-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

-- drawing multiple graphs from one call, with different Xmax.

-- settings depending on VM
if(jit == nil) then VM = "PUC"; vers = _VERSION; S1 = "*"
               else VM = "JIT"; vers = jit.version; S1 = "x" end

-- headline
print("Sample 6 - plotset function - running " .. vers)

-- include luabench ascii bench graph & configure it
luabench = require("luabench")

-- settings
luabench.VERSION_TAG    = "Sample 6 / " .. VM
luabench.NAME1          = "Multiplication " .. VM   -- name to + interval bracket right of plot
luabench.NAME2          = "Division " .. VM -- name to x interval bracket right of plot

luabench.SYMBOL1        = S1  
luabench.SYMBOL2        = ":"  
luabench.SYMBOL_OVERLAP = "#"  

luabench.MAX_HEIGHT     = 50     -- max height of graph area, in terminal lines
luabench.WIDTH          = 50     -- width of graph area, in terminal columns
luabench.VERBOSITY      = 1      -- debugging: 0 = quiet, 1, 2 = verbose
luabench.SLICE          = 0.01    -- minimal time slice per measure, in seconds 
luabench.SHOW_ONE       = false  -- setting false often increases resolution
luabench.SHOW_TWO       = false  -- setting false sometimes increases resolution
luabench.CUTOFF         = true   -- don't show the area from y0 to ymin
luabench.FIX_CYCLES     = false  -- for all x take cycles of x0
luabench.RECYCLE_TABLE  = true   -- allow for tables to be re-used for next x

explain = [[

This is a comparison between arithmetical operations: multiplication and division.
	
]]

print(explain)

luabench.plotset(
	 
	 -- added to headline
	 "ArithBench ("..VM..")",     
     
	 -- explanation of source table
 	 "t[i] = rand(1,i)",

     -- preparation of source table (not measured), 
     -- with re-use of previously generated contents for speed up.
     function(x,lastx,lastt)
        if lastx == nil then t={}; lastx = 0 else t = lastt end -- sic 0
        for i=lastx+1,x do t[i] = math.random(1,i) end
        return t
     end,

	 -- graphs to paint, Xmax
     {100,1000,10000},

	 -- prompt and function 1st line
     "Multiplication ("..VM..")",
     function(t) 
	    local p = 1000
	    for k,v in ipairs(t) do
	        p = p * v
        end
     end,

	 -- prompt and function 2nd line
     "Division ("..VM..")",
	 function(t) 
	    local d = 1000
	    for k,v in ipairs(t) do
	        d = d / v
        end
	 end            
)
