-------------------------------------------------------------------------------
--- Package     : Luabench - ASCII plotter for Lua performance over i       ---
--- File        : luabench.lua                                              ---
--- Description : Main and only module file                                 ---
--- Version     : 0.4.1/ alpha                                              ---
--- Requirement : Lua 5.1 or JIT 2 but may run anything lower than that     ---
--- Copyright   : 2011 Henning Diedrich, Eonblast Corporation               ---
--- Author      : H. Diedrich <hd2010@eonblast.com>                         ---
--- License     : MIT see end of file                                       ---
--- Created     : 08 Apr 2011                                               ---
--- Changed     : 14 Apr 2011  0.4.0                                        ---
--- Changed     : 12 Sep 2011                                               ---
-------------------------------------------------------------------------------
---                                                                         ---
---  ASCII plotted graph showing performance relative to element count.     ---
---                                                                         ---
---  Use: luabench=require("luabench")                                      ---
---       luabench.plot("caption", "text", prepfunc, "legend", benchfunc)   ---
---                                                                         ---
---  See: sample.lua                                                        ---
---                                                                         ---
-------------------------------------------------------------------------------

module("luabench", package.seeall)

-----------------------------------------------------------------------
-- settings: defaults
-----------------------------------------------------------------------

-- change these values in your main script, see samples

VERSION_TAG    = "Luabench 0.4.1" -- version number to appear at the top
NAME1          = ""               -- name to + interval bracket right of plot
NAME2          = ""               -- name to x interval bracket right of plot
SYMBOL1        = '+'
SYMBOL2        = 'x'
SYMBOL_OVERLAP = '*'
BACKGROUND     = ' '              
X_AXIS         = '_'              

MAX_HEIGHT    = 30             -- max height of graph area in terminal lines
WIDTH         = 50             -- width of graph are in terminal columns
MAX_CYCLES    = 100000         -- max number of times the test functions run 
MAX_ELEMENTS  = 1000           -- upper limit of number of elements (x)
SLICE         = 0.05           -- minimal time slice to use for cycles
BESTOF        = 3              -- number of repeat runs, fastest is used
VERBOSITY     = 1              -- debugging: 0 = quiet, 1, 2 = verbose
SHOW_ONE      = false          -- setting false often increases resolution
SHOW_TWO      = false          -- setting false sometimes increases resolution
CUTOFF        = true           -- don't show the area from y0 to ymin
ALWAYS_CUTOFF = false          -- cutoff even if < 25% space is saved by it
FIX_CYCLES    = false           -- for all x take cycles of x0
RECYCLE_TABLE = true           -- allow for tables to be re-used for next x

PLOTTER_BANNER = 
    "-=xXx=- "..VERSION_TAG.." - http://www.eonblast.com/luabench"
TITLE = "-=xXx=- Luabench"
MARGIN = "\t"

-- ymax is calculated automatically. 
-- y0 is fix 1 but its drawing can be controlled by SHOW_ONE and SHOW_TWO.

sep =   "---------------------------------------" ..
        "-------------------------------------o-"
subsep= "......................................." ..
        "......................................."

EXPLAIN = [[
	
	1. a table of a given size X (element count) is prepared (filled)
	2. it is given to a function and execution times are measured,
	   several times (cycles). The average execution time is Y.
	3. X is increased and the preparation and measurement are repeated,
	   several times (graph width) until y = span.
	4. an ascii graph is drawn showing all y(x).
	5. SPAN (=XMAX) is increased, the next measurements are made,
	   the next graph is drawn.
	
	The cycles are controlled by setting SLICE: as many cycles are
	done as necessary to reach a total time of SLICE. For short f
	this can result in millions of cycles. If SLICE is too small, 
	results will be blurry as the clock tick is never precise.

]]

-----------------------------------------------------------------------
-- main function
-----------------------------------------------------------------------

function plot(title, prepP, prepare, prompt1, action1, prompt2, action2)

    if prompt2 == nil or action2 == nil then
        plot1(title, prepP, prepare, prompt1, action1)
    else
        plot2(title, prepP, prepare, prompt1, action1, prompt2, action2)
    end
end

-----------------------------------------------------------------------
-- output formatting and math (except graph)
-----------------------------------------------------------------------

function plothead()
    margin()
    if(jit ~= nil) then io.write(jit.version)
    elseif(_PATCH) then io.write(_PATCH) 
    else io.write(_VERSION .. ' official') 
    end
    if(VERSION_TAG ~= nil) then
        io.write(" - " .. VERSION_TAG)
    end
    print()
end

-- percent value with no decimals >= 2, but one decimal < 2. ----------
function prcstr(part, base)
    if secnd == 0 then return 0 end
    x = math.floor(part / base * 100)
    if(x <= 2) then
        x = math.floor(part / base * 1000) / 10
    end
    return x
end

printcol = 0
function printf(...)
	s = string.format(...)
	if(s:find("\n")) then printcol = 0 else printcol = printcol + s:len() end
    io.write(s)
end

-- verbosity controlled conditional printing --------------------------
function printfv(vl,...)
    if vl <= VERBOSITY then printf(...) end
end

function tab(x)
	while(printcol < x) do io.write(" "); printcol = printcol + 1 end
end

function tabv(vl,x)
    if vl <= VERBOSITY then tab(x) end
end

waitdots_count = 0
waitdots_info_len = 0
mincycles = nil
maxcycles = nil
fixcycles = nil
function waitdots(items)
    if waitdots_count == 0 then margin() end
    for i = 1,waitdots_info_len do
        io.write("\b \b"); 
    end
    io.write('.');
    if mincycles ~= nil then
        if mincycles == maxcycles then
            info = " x=" .. number_format(items) .. ": " .. number_format(mincycles) .. " cycles"
        else
            info = " x=" .. number_format(items) .. ": " .. number_format(mincycles) .. " & " .. number_format(maxcycles) .. " cycles"
        end
        waitdots_info_len = info:len()
        io.write(info)
    end
    io.flush() 
    waitdots_count = waitdots_count + 1
    mincycles = nil
    maxcycles = nil
end

function delete_waitdots()
    for i = 1,waitdots_count + waitdots_info_len + MARGIN:len() do
        io.write("\b \b"); io.flush()
    end
    
    -- io.write("\b\b\b\b\b\b\b\b\b\b\b\b\b")
    waitdots_count = 0
    waitdots_info_len = 0
end

-- helps blaming crashes
function activedot(char)
    io.write("  " .. char)
    io.flush()
end

function delete_activedot()
    io.write("\b\b\b   \b\b\b")
    io.flush()
end    

function nanosecs_per(time, per)
	return time * 1000000000 / per
end

function microsecs_per(time, per)
	return time * 1000000 / per
end

function margin(vl)
    if vl == nil or vl <= VERBOSITY then io.write(MARGIN) end
end

function min(a,b)
    if a == nil then return b end
    if b == nil then return a end
    return math.min(a,b)
end

function max(a,b)
    if a == nil then return b end
    if b == nil then return a end
    return math.max(a,b)
end

function str(s)
    if s == nil then return "" end
    return s
end
-- decimal point ------------------------------------------------------
-- by Richard Warburton http://lua-users.org/wiki/FormattingNumbers ---
function number_format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-----------------------------------------------------------------------
-- mini json stringify for output
-----------------------------------------------------------------------
-- from http://lua-users.org/wiki/TableUtils

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

-----------------------------------------------------------------------
-- ASCII plotter
-----------------------------------------------------------------------

function tlimits(t)
    if #t == 0 then return nil,nil end
    vmin = nil 
    vmax = nil
    for _,v in next, t do 
        vmin = min(vmin,v)
        vmax = max(vmax,v)
    end
    return vmin,vmax
end

function plot_graph2(title, p1, p2, name1, name2)

    -- take #1 out -- often gains much resolution for the graph
    if not SHOW_ONE then
        suppressed = "x=1 "..SYMBOL1..": " .. p1[1] .. "; "..SYMBOL2..": " .. p2[1]
        p1[1] = nil
        p2[1] = nil
    end
    
    if not SHOW_TWO then
        suppressed = suppressed .. "\n        " ..
        "x=#2 "..SYMBOL1..": " .. p1[2] .. "; "..SYMBOL2..": " .. p2[2]
        p1[2] = nil
        p2[2] = nil
    end
    
    imax = math.max(#p1,#p2)
    vmin1,vmax1 = tlimits(p1)
    vmin2,vmax2 = tlimits(p2)
    
    if vmax1 == nil and vmax2 == nil then
        print("Can't plot ", vmin1, vmax1, vmin2, vax2)
        return
    end

    vmin = min(vmin1,vmin2)
    vmax = max(vmax1,vmax2)
    bar  = 10 ^ (math.ceil(math.log10(vmax / 100))) 
    ymax = math.max(10,math.ceil( vmax / bar ) * bar)
    ymin = math.max( 0,math.floor( vmin / bar - 1) * bar)
    if CUTOFF and (ALWAYS_CUTOFF or ymin / ymax > 0.25) then do_cutoff = true 
    else do_cutoff = false end
    if not do_cutoff then ymin = 0 end
    yspan = ymax - ymin
    
    step = math.ceil(yspan / MAX_HEIGHT / 10) * 10

    if step == 10 then
        altstep = math.ceil(yspan / MAX_HEIGHT / 5) * 5
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    if step == 5 then
        altstep = math.ceil(yspan / MAX_HEIGHT / 2) * 2
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    if step == 2 then
        altstep = math.ceil(yspan / MAX_HEIGHT)
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    -- start output    
    margin()
    print("nsec/element  " .. title)
    
    -- print(#p1, #p2, vmin, vmax, MAX_HEIGHT, step)
    
    ylast = ymax * step  -- guaranteed over

    for y = ymax,ymin,-step do
    
        plotrow2(y, ylast, p1, p2, name1, name2)

        ylast = y

    end

    -- cut off, dotted x axis
    if do_cutoff and ylast > 0 then
        margin()
        io.write(string.format("%10s |", "..."))
        for x = 1,imax,1 do io.write(".") end
        print()
    -- zero level x axis
    elseif ylast ~= 0 then
        plotrow2(0, ylast, p1, p2, name1, name2)
    end

    -- x axis legend
    ----------------
    xl = {}
    for items  = 0,MAX_ELEMENTS,math.ceil(MAX_ELEMENTS / WIDTH) do
        if items == 0 then items = 1 end
    -- clone of this loop head at (*) !!
        xl[#xl+1] = items
    end

    margin()
    io.write(string.format("%10.10s  ", "elements:"))

    for x = 1,imax,10 do
        leg = "^" .. number_format(xl[x])
        io.write(leg)
        for li = 1,10-leg:len()-1 do io.write(' ') end
    end
    print()

    if not SHOW_ONE then
        margin()
        print(suppressed)
    end 
end


function plot_graph1(title, p1, name1)

    -- take #1 out -- often gains much resolution for the graph
    if not SHOW_ONE then
        suppressed = "x=1 "..SYMBOL1..": " .. p1[1]
        p1[1] = nil
    end
    
    if not SHOW_TWO then
        suppressed = suppressed .. 
        "; x= "..SYMBOL1..": " .. p1[2]
        p1[2] = nil
    end
    
    imax = #p1
    vmin1,vmax1 = tlimits(p1)
    
    if vmax1 == nil then
        print("Can't plot ", vmin1, vmax1)
        return
    end

    vmin = vmin1
    vmax = vmax1
    bar  = 10 ^ (math.ceil(math.log10(vmax / 100))) 
    ymax = math.max(10,math.ceil( vmax / bar ) * bar)
    ymin = math.max( 0,math.floor( vmin / bar - 1) * bar)
    if CUTOFF and (ALWAYS_CUTOFF or ymin / ymax > 0.25) then do_cutoff = true 
    else do_cutoff = false end
    if not do_cutoff then ymin = 0 end
    yspan = ymax - ymin
    
    step = math.ceil(yspan / MAX_HEIGHT / 10) * 10

    if step == 10 then
        altstep = math.ceil(yspan / MAX_HEIGHT / 5) * 5
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    if step == 5 then
        altstep = math.ceil(yspan / MAX_HEIGHT / 2) * 2
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    if step == 2 then
        altstep = math.ceil(yspan / MAX_HEIGHT)
        if yspan / altstep < MAX_HEIGHT then
            step = altstep
        end
    end

    -- start output    
    margin()
    print("nsec/element  " .. title)
    
    -- print(#p1, #p2, vmin, vmax, MAX_HEIGHT, step)
    
    ylast = ymax * step  -- guaranteed over

    for y = ymax,ymin,-step do
    
        plotrow1(y, ylast, p1, name1)

        ylast = y

    end

    -- cut off, dotted x axis
    if do_cutoff and ylast > 0 then
        margin()
        io.write(string.format("%10s |", "..."))
        for x = 1,imax,1 do io.write(".") end
        print()
    -- zero level x axis
    elseif ylast ~= 0 then
        plotrow1(0, ylast, p1, name1)
    end

    -- x axis legend
    ----------------
    xl = {}
    for items  = 0,MAX_ELEMENTS,math.ceil(MAX_ELEMENTS / WIDTH) do
        if items == 0 then items = 1 end
    -- clone of this loop head at (*) !!
        xl[#xl+1] = items
    end

    margin()
    io.write(string.format("%10.10s  ", "elements:"))

    for x = 1,imax,10 do
        leg = "^" .. xl[x]
        io.write(leg)
        for li = 1,10-leg:len()-1 do io.write(' ') end
    end
    print()

    if not SHOW_ONE then
        margin()
        print(suppressed)
    end 
end

function plotrow1(y, ylast, p1, name1)

        margin()        
        io.write(string.format("%10d |", y))
        local s = {}
        local u1

        for x = 1,imax,1 do
            local y1 = p1[x]

            -- x=1 taken out
            if not SHOW_ONE and x == 1 then
                io.write(':')
            elseif not SHOW_TWO and x == 2 then
                io.write(':')
            else
                -- hit?
                if y1 == nil then y1 = 0 end
                if y1 ~= nil and y1 >= y and y1 < ylast then 
                    u1 = true
                else
                    u1 = false
                end
                
                -- plot
                if y == 0 and y1==0 then io.write(':')
                elseif u1 then io.write(SYMBOL1)
                elseif y == 0 then io.write(X_AXIS) 
                else io.write(BACKGROUND)
                end
            end
        end
        
        if u1 then 
            min1,max1 = tlimits(p1)
            io.write(string.format(" [%d..%d] %s  ", min1, max1, name1))
        end

        print()
end

function plotrow2(y, ylast, p1, p2, name1, name2)

        margin()        
        io.write(string.format("%10d |", y))
        local s = {}
        local u1, u2

        for x = 1,imax,1 do
            local y1 = p1[x]
            local y2 = p2[x]

            -- x=1 taken out
            if not SHOW_ONE and x == 1 then
                io.write(':')
            elseif not SHOW_TWO and x == 2 then
                io.write(':')
            else
                -- hit?
                if y1 == nil then y1 = 0 end
                if y2 == nil then y2 = 0 end
                if y1 ~= nil and y1 >= y and y1 < ylast then 
                    u1 = true
                else
                    u1 = false
                end
                if y2 ~= nil and y2 >= y and y2 < ylast then 
                    u2 = true
                else
                    u2 = false
                end
                
                -- plot
                if y == 0 and (y1==0 or y2==0) then io.write(':')
                elseif u1 == true and u2 == true then io.write(SYMBOL_OVERLAP)
                elseif u1 then io.write(SYMBOL1)
                elseif u2 then io.write(SYMBOL2)
                elseif y == 0 then io.write(X_AXIS) 
                else io.write(BACKGROUND)
                end
            end
        end
        
        if u1 then 
            min1,max1 = tlimits(p1)
            if u2 then io.write("  "..SYMBOL1..": ") end -- sic if u2
            io.write(string.format(" [%d..%d] %s  ", min1, max1, name1))
        end

        if u2 then 
            if u1 then io.write("  "..SYMBOL2..": ") end -- sic if u1
            min2,max2 = tlimits(p2)
            io.write(string.format(" [%d..%d] %s", min2, max2, name2))
        end

        print()
end

-----------------------------------------------------------------------
-- random contents creation
-----------------------------------------------------------------------

math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) ) 
-- random seed more friendly to lower digit integers - credit: ferrix


local abc = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

local speaklike = {'a', 'a', 'a', 'b', 'b', 'c', 'c', 'c', 'c', 'd', 'd', 'd', 'e', 'e', 'e', 'e', 'e', 'f', 'f', 'g', 'g', 'h', 'h', 'i', 'i', 'i', 'i', 'j', 'j', 'k', 'l', 'l', 'l', 'm', 'm', 'm', 'n', 'n', 'n', 'n', 'o','o','o','o', 'p', 'p', 'p', 'q', 'q', 'r', 'r', 'r', 's', 's', 's', 's', 's', 't', 't', 't', 't', 'u', 'u', 'u', 'v', 'v', 'w', 'w', 'x', 'y', 'y', 'y', 'z', 'z', 'z', ' ',
'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ' ', ' ', ' ', '.', '.', '!', '?', ',', ',', ',', '-', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

local keylike = {'a', 'a', 'a', 'b', 'b', 'c', 'c', 'c', 'c', 'd', 'd', 'd', 'e', 'e', 'e', 'e', 'e', 'f', 'f', 'g', 'g', 'h', 'h', 'i', 'i', 'i', 'i', 'j', 'j', 'k', 'l', 'l', 'l', 'm', 'm', 'm', 'n', 'n', 'n', 'n', 'o','o','o','o', 'p', 'p', 'p', 'q', 'q', 'r', 'r', 'r', 's', 's', 's', 's', 's', 't', 't', 't', 't', 'u', 'u', 'u', 'v', 'v', 'w', 'w', 'x', 'y', 'y', 'y', 'z', 'z', 'z', '_', '_', '_',  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

function randstr(min,max,set)
    if  max == nil then 
        max = min
        min = 1
    end       
    if  set == nil then
        set = speaklike
    end

    local r = {}
    local length = math.random(min,max)
    local i
    for i = 1, length do
        r[i] = set[math.random(1, #set)]
    end
    return table.concat(r)
end

function someval()
    y = math.random(2,11)
    if y == 1 then return nil end
    if y == 2 then return false end 
    if y == 3 then return true end 
    if y == 4 then return math.random(1,10000000) end 
    if y == 5 then return math.random(-10000000,-10000000) end 
    if y == 6 then return math.random(-1000000000,-1000000000) / 1000000 end 
    if y == 7 then return abc[math.random(1,26)] end 
    if y == 8 then return randstr(5) end 
    if y == 9 then return randstr(15) end 
    if y == 10 then return randstr(100) end 
    if y == 11 then return randstr(1000) end 
end

function someval_no_bools()
    y = math.random(4,10)
    if y == 4 then return math.random(1,10000000) end 
    if y == 5 then return math.random(-10000000,-10000000) end 
    if y == 6 then return math.random(-1000000000,-1000000000) / 1000000 end 
    if y == 7 then return abc[math.random(1,26)] end 
    if y == 8 then return randstr(5) end 
    if y == 9 then return randstr(15) end 
    if y == 10 then return randstr(100) end 
    if y == 11 then return randstr(1000) end 
end

function stringify(t) table.val_to_str( t ) end

function jingle()
    local jingles = { "breath!", ":-)", ":-o", "+1", "... and the sun?", "take a break now, you deserve it", "have fun!", "not too bad _", "there's more ...", "good.", "do something good now", "birthdays?", "you have mail", "can we talk?", "what movie is today?", "this is the best day of my live, too", "music!?", "l.o.v.e", "wow!", "nice", "...!?", "books are cool", "Call me Ishmael ...", "rake to the see", "42", "43", "er?", "hello?", "hello world?", "Like that tool? Let me know: hd@2010@eonblast.com", "follow the wite rabbit ...", "an apple a day keeps the doctor away. seriously now" }
    if math.random(1,1000) == 1 then
        margin()
        print(jingles[math.random(1,#jingles)])
    end
end
-----------------------------------------------------------------------
-- measure one formula, CYCLE times, including test data preparation
-----------------------------------------------------------------------

local t = {}

local function prepare(items, prepP, prep, lastx, lastt)

  printfv(2, "%-12s ", actionP)

    ---ooo--- Prepare the table ---ooo---
  if prep ~= nil then
    t = prep(items, lastx, lastt)
  end
  
  return t
end

local function measure(items, actionP, action)

  local clock  = os.clock
  local local_format = table.format
  local local_concat = table.concat

    collectgarbage()

    ---ooo--- Clock Call Cost ---ooo---
    local lap = clock() + SLICE
    local tclocks = 0
    while(clock() < lap) do tclocks = tclocks + 1 end
    assert(tclocks ~= 0)
    local clock_cost = SLICE / tclocks
    -- print("Clock cost: " .. clock_cost)

    ---ooo--- Cycles Required ---ooo---
    local lap = clock() + SLICE
    local cycles = 0
    local prelap
    local tm = clock()
    if(not FIX_CYCLES or fixcycles==nil) then
        while(clock() < lap and cycles < MAX_CYCLES) do
            action(t)
            cycles = cycles + 1
        end
        fixcycles = cycles -- ///
    else
        cycles = fixcycles
    end
    prelap = clock() - tm - clock_cost * cycles
    assert(cycles ~= 0)
    bar = 10 ^ (math.ceil(math.log10(cycles / 100)))
    cycles = math.max(1,math.ceil( cycles / bar ) * bar)
    mincycles = min(cycles, mincycles)
    maxcycles = max(cycles, maxcycles)

    local last = nil
    local best = nil
    local tsum = 0

    -- actually USE the test measurement, if 1 cycle already took > than SLICE
    if cycles == 1 then 
        best = prelap;
        tsum = prelap;
        start = 2 
    else
        start = 1 
    end

    ---ooo--- The Measurement ---ooo---
    local i, t0, t1, t2, t3, tm0, tm1, tt, tticks, tloop, dtick, lap, itm, idf, gop, gop2, c, disc
    local nix = function() end
    local disc = 0.01
    local dummy = 0
    
    for k = start, BESTOF do

        collectgarbage()

        -- measure 1 clock tick in 'loops'
        tticks = 0
        t0 = clock()
        t1 = t0 + disc
        t2 = t1 + disc
        -- wait for clock tick
        while clock() < t1 do end
        -- count loops in one second, with penalty of clock() call
        while clock() < t2 do tticks = tticks + 1 end

        collectgarbage()

        c = 0
        t0 = clock()
        t1 = t0 + disc
        -- wait for clock tick
        while clock() < t1 do dummy = dummy + 1 end

        -- measure loop
        for i = 1, cycles do last = action(t) end
        t2 = clock()
        
        -- wait for clock tick
        t3 = t2 + disc
        while clock() < t3 do c = c + 1 end
        over = math.min(c,tticks) / tticks * disc
        tm = t3 - t1 - over - clock_cost
        -- print("Measure tm: " .. tm .. " (over: " .. over ..") c, tticks: " .. c .. "," .. tticks)
        -- print("Diff " .. (t2 - t1) .. " --> " .. tm)

        best = min(best, tm)
    end
    tm = best
    -- print("Take .. " .. tm)
    -- if DYN and tm == 0 then MAX_CYCLES = math.ceil(MAX_CYCLES * 4) end 
    -- if DYN and tm > 1 then MAX_CYCLES = math.ceil(MAX_CYCLES / 2) end 

    if tm ~= 0 then
  	    mspc= nanosecs_per(tm, cycles * items)
        tabv(2,27)
        printfv(2, "%10.0fns/element ", mspc)
    else
	    mspc = nil
        printfv(2, "%dx %-12s ** sample too small, could not measure, increase MAX_CYCLES ** ", cycles, actionP)
    end
  
    return mspc, last 

end

-----------------------------------------------------------------------
-- main function
-----------------------------------------------------------------------

function plot1(title, prepP, prep, prompt1, action1)

    plothead()

    margin()
    print(sep)
    margin()
    printf("x=[%d..%s] elements in a table %-25s\n", 1, number_format(MAX_ELEMENTS), prepP)
    margin()
    print("y=time/x needed for " .. prompt1)
    margin()
    print(sep)

    collectgarbage()

    local t2 = {}
    local lastitems
    local lastt

    for items  = 0,MAX_ELEMENTS,math.ceil(MAX_ELEMENTS / WIDTH) do
        if items == 0 then items = 1 end
    -- clone of this loop head at (*) !
        
        if(VERBOSITY < 2) then waitdots(items) end
        
        t = prepare(items, prepP, prep, lastitems, lastt)

        -- safe for next iteration, this shortens table creation time
        lastitems = items
        lastt = t

        if anyprev then margin(2); printfv(2, subsep .. "\n") end
        margin(2)
        printfv(2, "%d elements in %-25s\n", items, prepP)
        margin(2)
        printfv(2, subsep .. "\n")

        ok, secnd, r2 = pcall(measure, items, prompt1, action1)
        if ok == false then
            secnd = nil
            r2 = "[error]"
        end
        
        if secnd == nil then secnd = 0 end
        t2[#t2+1] = secnd        
        printfv(2, "     %.20s.. \n", r2)

        margin(2)
        printfv(2, "     %.20s.. \n", r3)
       
        anyprev = true
    end
    
    if(VERBOSITY < 2) then delete_waitdots() end
    
    plot_graph1(title, t2, NAME1)

    margin()
    print(PLOTTER_BANNER)
    pcall(jingle)

end

function plot2(title, prepP, prep, prompt1, action1, prompt2, action2)

    plothead()

    margin()
    print(sep)
    margin()
    printf("x=[%d..%s] elements in %-25s\n", 1, number_format(MAX_ELEMENTS), prepP)
    margin()
    print(SYMBOL1..": " .. prompt1)
    margin()
    print(SYMBOL2..": " .. prompt2)
    margin()
    print(sep)

    collectgarbage()

    local t2 = {}
    local t3 = {}
    local lastitems
    local lastt
    
    for items  = 0,MAX_ELEMENTS,math.ceil(MAX_ELEMENTS / WIDTH) do
        if items == 0 then items = 1 end
    -- clone of this loop head at (*) !
        
        if(VERBOSITY < 2) then waitdots(items) end
        
        t = prepare(items, prepP, prep, lastitems, lastt)

        -- safe for next iteration, this shortens table creation time
        lastitems = items
        lastt = t

        if anyprev then margin(2); printfv(2, subsep .. "\n") end
        margin(2)
        printfv(2, "%d elements in %-25s\n", items, prepP)
        margin(2)
        printfv(2, subsep .. "\n")

        activedot(SYMBOL1)
        ok, secnd, r2 = pcall(measure, items, prompt1, action1)
        if ok == false then
            print(secnd)
            secnd = nil
            r2 = "[error]"
        end
        if secnd == nil then secnd = 0 end
        t2[#t2+1] = secnd        
        printfv(2, "     %.20s.. \n", r2)
        delete_activedot()

        activedot(SYMBOL2)
        ok, third, r3 = pcall(measure, items, prompt2, action2)
        if ok == false then
            print(third)
            third = nil
            r3 = "[error]"
        end
        if third == nil then third = 0 end
        t3[#t3+1] = third
        delete_activedot()
        
        if(secnd and third) then prc = prcstr(third, secnd)
            margin(2)
            printfv(2, "%3g%% %.20s.. \n", prc, r3)
        else 
            prc = "-"
            margin(2)
            printfv(2, "     %.20s.. \n", r3)
        end
       
        anyprev = true
    end
    
    if(VERBOSITY < 2) then delete_waitdots() end
    
    plot_graph2(title, t2, t3, NAME1, NAME2)

    margin()
    print(PLOTTER_BANNER)
    pcall(jingle)
    
end

function plotset(title, prompt, prepfunc, spans, prompt1, func1, prompt2, func2)

    -- print headline
    print()
    print(title)
    for i=1,#title do io.write("=") end
    print()
    print()

    -- loop over different element counts
    if spans == nil then 
        spans = {100,1000,10000,100000,1000000,10000000} 
    end

    for i = 1, #spans do
    
        luabench.MAX_ELEMENTS= spans[i] -- upper limit of number of elements (x)
        luabench.MAX_CYCLES  = 10000000  -- max number of times the test functions run 
	
        luabench.plot(title,

               -- preparation
               prompt,
               prepfunc,
               prompt1,
               func1,
               prompt2,
               func2
               )
               
       print()
       print()
    end
end


-- History
--
-- 0.4.1
-- major speed up by allowing for recycling target tables
-- added FIX_CYCLES to allow for fixed number of cycles for all x
-- added plotset() to render with multiple Xmax
-- minor clean up of locals and parameters t2 and t3
-- fixed single curve prepare call
-- added explain text
--
-- 0.4
-- added exception catch pcall() around measure function
-- added lower limit of string sizes for randstr()
-- added speak like and key like random string pattern sets
-- added some decimal point formatting for number displays
-- attempt at higher precision for small count of elements 
-- fixed x sequence from 1,3,5.. v 1,11,21.. to 1,2,4.. v 1,10,20..
--
-- 0.3
-- fixed wait dots margin
-- added dynamic cycle adjustment from get go
-- added display of elements and cycles to wait dots
-- refactored use of math.min/max on nil
-- fixed adjustment and deletion of wait dots
-- fixed Lua/LuaJIT version display
-- added VERSION_TAG for subject name & version
--
-- 0.2
-- added test feed function someval_no_bools()
-- added 1K string to someval()
-- added suppressing of CUTOFF when < 25% space gain
-- added ALWAYS_CUTOFF
-- added definable x axis character
-- added colon on x axis as signifyer for actual 0s 
-- fixed one too high lower cutoff row

-- TODO: single line plot function lags behind plot2()

