# luabench 0.4.1

**This ASCII plotter draws a benchmark as a graph.**

It shows how a benchmark behaves (y = time) while a table increases in size (x = number of elements) that is used as a feed for the benchmark. 

It can also compare two Lua benchmarks. The size of the plot area of the graph can be adapted to your needs, the ranges shown are automatically adjusted to sensible values. The drawing x=1 is suppressed by default as it often skews the scale of the shown area for no gain. The time is shown relative to elements in the table. 

Luabench runs with Lua 5.1 and LuaJIT 2.0.

**Status:** quite reliable. Beware of possible dumb mistakes in the time measurement. Please double check & let me know if things fail or cause artifacts in the measurements. Tests on different platforms could be more complete.

**Have fun**

## Quick

    lua sample-3.lua

This draws a self-explanatory sample benchmark graph exploring the beauty of concat().

## Sample

Let's assume we wanted to compare two implementations of string concatenation in Lua:

	1		local s="" 
			for i=1,#t do
				s=s..t[i] 
			end
and

	2		 table.concat(t)

And we would like to see how those implementations hold up for different tables sizes. For each table element the table should simply have:

	t[i] = 'abc'
	
The test program for this may look like this:

## Program

**sample-3.lua**

	package.path="./?.lua"
	luabench=require("luabench")
	
	luabench.plot(
	
			-- title
			"-=xXx=- Sample 3: Right & Wrong Concatenation ",
	
			-- preparation (prompt and code)
			"t[i] = 'abc'",
			function(x) t={}; for i=1,x do t[i]='abc' end; return t; end,
	
			-- bench line #1: (prompt and code)
			"WRONG: s=''; for i=1,#t do s=s..t[i] end",
			function(t) local s=""; for i=1,#t do s=s..t[i] end return s end,
	
			-- bench line #2: (prompt and code)
			"RIGHT: return table.concat(t) end",
			function(t) return table.concat(t) end
			)

## Result

And this is what you get. You can try it yourself by running 

    $ lua sample-3.lua

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in t[i] = 'abc'             
	+: WRONG WAY TO DO IT: s=''; for i=1,#t do s=s..t[i] end
	x: RIGHT WAY TO DO IT: return table.concat(t) end
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- Sample 3: Right & Wrong Concatenation                       
	      1700 |:                                                  
	      1640 |:                                                ++ [331..1659]   
	      1580 |:                                            ++++  
	      1520 |:                                         +++      
	      1460 |:                                      +++         
	      1400 |:                                 +++++            
	      1340 |:                              +++                 
	      1280 |:                          ++++                    
	      1220 |:                      ++++                        
	      1160 |:                   +++                            
	      1100 |:                 ++                               
	      1040 |:              +++                                 
	       980 |:             +                                    
	       920 |:                                                  
	       860 |:                                                  
	       800 |:                                                  
	       740 |:                                                  
	       680 |:                                                  
	       620 |:                                                  
	       560 |:                                                  
	       500 |:                                                  
	       440 |:           ++                                     
	       380 |:    +++++++                                       
	       320 |:++++                                              
	       260 |:                                                  
	       200 |:                                                  
	       140 |:                                                  
	        80 |:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx [94..127] 
	        20 |:                                                  
	         0 |:__________________________________________________
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1,000   
	x=1 +: 373.49551774906; x: 591.89477075895
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench

This shows two results in one graph. Note that these curves show time per table element.

# All Samples

This is the result of these sample files, run one after the other:

	lua sample.lua
	lua sample-2.lua
	lua sample-3.lua
	lua sample-4.lua
	lua sample-4a.lua
	lua sample-5.lua
	lua sample-6.lua

Simply call 'make' with no arguments to see them being produced.

**lua sample-2.lua**

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in a table t[i] = 'abc'             
	y=time/x needed for return table.concat(t) end
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- Sample 2: using concat()                         
	       120 |::                                                 
	       118 |::                                                 
	       116 |::                                                 
	       114 |::                                                 
	       112 |::                                                 
	       110 |::+                                                
	       108 |::                                                 
	       106 |::                                                 
	       104 |:: +                                               
	       102 |::  +                                              
	       100 |::                                                 
	        98 |::   +++                                           
	        96 |::      ++++      +++++++++++++                    
	        94 |::          ++++++             ++++++++++++++++++++ [94..110]   
	        92 |::                                                 
	        90 |::                                                 
	        88 |::                                                 
	        86 |::                                                 
	        84 |::                                                 
	        82 |::                                                 
	        80 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1000    
	x=1 +: 601.74663158848; x= +: 129.5907714002
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench

    Using concat() is the recommended way to do this. 

**lua sample-3.lua**

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in t[i] = 'abc'             
	+: WRONG WAY TO DO IT: s=''; for i=1,#t do s=s..t[i] end
	x: RIGHT WAY TO DO IT: return table.concat(t) end
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- Sample 3: Right & Wrong Concatenation                    
	      1700 |::                                                 
	      1640 |::                                              +++ [342..1668]   
	      1580 |::                                           +++   
	      1520 |::                                        +++      
	      1460 |::                                   +++++         
	      1400 |::                                +++              
	      1340 |::                            ++++                 
	      1280 |::                         +++                     
	      1220 |::                     ++++                        
	      1160 |::                  +++                            
	      1100 |::                ++                               
	      1040 |::             +++                                 
	       980 |::            +                                    
	       920 |::                                                 
	       860 |::                                                 
	       800 |::                                                 
	       740 |::                                                 
	       680 |::                                                 
	       620 |::                                                 
	       560 |::                                                 
	       500 |::                                                 
	       440 |::          ++                                     
	       380 |::    ++++++                                       
	       320 |::++++                                             
	       260 |::                                                 
	       200 |::                                                 
	       140 |::                                                 
	        80 |::xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx [93..109] 
	        20 |::                                                 
	         0 |::_________________________________________________
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1,000   
	x=1 +: 370.4983078425; x: 587.27532943597
    x=#2 +: 322.16520161742; x: 126.39980575457
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench

    This shows two results in one graph. Note that these curves show time per table element.

**lua sample-4.lua**

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..100,000] elements in a table t[i] = 'abc' .. i        
	y=time/x needed for return table.concat(t) end
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- Sample 4: concat() and a large table             
	       160 |::                                                 
	       156 |::                                            +++++ [102..157]   
	       152 |::                                   + +++++++     
	       148 |::                               ++++ +            
	       144 |::                                                 
	       140 |::                             ++                  
	       136 |::                        +++++                    
	       132 |::                  ++++++                         
	       128 |::                 +                               
	       124 |::               ++                                
	       120 |::              +                                  
	       116 |::            ++                                   
	       112 |::         +++                                     
	       108 |::        +                                        
	       104 |:: +++++++                                         
	       100 |::+                                                
	        96 |::                                                 
	        92 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^20000   ^40000   ^60000   ^80000   ^100000  
	x=1 +: 591.44214446758; x= +: 102.10193611574
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench

    But concat() gets slower, too, when strings get longer. xmax is now set to 100,000. Before, we looked at x in 1 - 1,000. Now at 1 - 100,000 [And all this is an example comment].

**lua sample-4a.lua**

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000,000] elements in a table t[i] = 'abc' .. i        
	y=time/x needed for return table.concat(t) end
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- Sample 4a: concat() and a very large table         
	       310 |::                                                 
	       300 |::                                                + [118..300]   
	       290 |::                                              +  
	       280 |::                                           +++ + 
	       270 |::                                       +  +      
	       260 |::                        +               ++       
	       250 |::                                                 
	       240 |::                                     ++          
	       230 |::                                                 
	       220 |::                                                 
	       210 |::                         ++  ++                  
	       200 |::                           ++  ++++++            
	       190 |::              +++ ++++++                         
	       180 |::          ++++   +                               
	       170 |::                                                 
	       160 |::        ++                                       
	       150 |::    + ++                                         
	       140 |::     +                                           
	       130 |::  ++                                             
	       120 |:: +                                               
	       110 |::+                                                
	       100 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200000  ^400000  ^600000  ^800000  ^1000000 
	x=1 +: 588.83116285814; x= +: 106.6885434493
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench

    Concat() problems are getting more pronounced. xmax is now set to 1.000,000.

**lua sample-5.lua**

	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..100] elements in t[i] = randstr 1 - 200 chars
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                    
	       520 |::                                                 
	       510 |::x                                                
	       500 |::                                                 
	       490 |::                                                 
	       480 |::                                                 
	       470 |::                                                 
	       460 |::                                                 
	       450 |::                                                 
	       440 |::                                                 
	       430 |::    x                                            
	       420 |::+                                                
	       410 |::                                                 
	       400 |:: x                                               
	       390 |::      x                                          
	       380 |::                                                 
	       370 |::       x   x                                     
	       360 |::        xxx                                      
	       350 |:: +                        xx                     
	       340 |::  x +        x                                   
	       330 |::               xxx  x       x                    
	       320 |::   x                 xx      x xx       x  x   xx [266..512] 
	       310 |::      +    +x     x    xx ++  x  x xx    xx xxx  
	       300 |::       ++ +   x             +     x   xx         
	       290 |::  ++     +       +           +  +    x  +       + [242..428]   
	       280 |::             + ++  x+++  x    ++ + ++    + +++++ 
	       270 |::                  +    ++             ++  +      
	       260 |::     x      + +                   +  +           
	       250 |::                         +                       
	       240 |::     +             +                             
	       230 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^20      ^40      ^60      ^80      ^100     
	x=1 +: 1135.6627297561; x: 1867.260224274
    x=#2 +: 739.80396922075; x: 889.41469440122
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench
	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in t[i] = 'abc' .. i        
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                  
	       130 |::                                                 
	       128 |::x                                                
	       126 |::                                                 
	       124 |::                                                 
	       122 |::                                                 
	       120 |::+                                                
	       118 |::                                                 
	       116 |::                                                 
	       114 |:: x                                               
	       112 |::                                                 
	       110 |:: +x                                              
	       108 |::        xxx                                      
	       106 |::  +x       xxx  x                                
	       104 |::    xx        xx xxxxxxxxxxxx             xxx   x [102..128] 
	       102 |::   ++ xx++++++   +++         xxxxxxxxxxxxx   xxx 
	       100 |::     ++       +++   ++++++++++++++++++ + ++++++++ [99..121]   
	        98 |::       +                              + +        
	        96 |::                                                 
	        94 |::                                                 
	        92 |::                                                 
	        90 |::                                                 
	        88 |::                                                 
	        86 |::                                                 
	        84 |::                                                 
	        82 |::                                                 
	        80 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1,000   
	x=1 +: 802.58094695976; x: 1262.7657185299
    x=#2 +: 147.03670691737; x: 185.17844563118
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench
	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..10,000] elements in t[i] = 'abc' .. i        
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                 
	       120 |::                                                 
	       118 |::                                                 
	       116 |::                                                 
	       114 |::                                                 
	       112 |::                                    xx           
	       110 |::                          x  x  xxx      xxxx*xxx [101..112] 
	       108 |::                         x xx xx   x  xxx     +  
	       106 |::             xxxxxxxxxxxx +++++++++++++++++++  ++ [99..110]   
	       104 |::x      xxxxxx +   +   +                          
	       102 |:: x xxxx++ ++++ +++ +++ +++                       
	       100 |::+ *++++  +                                       
	        98 |:: +                                               
	        96 |::                                                 
	        94 |::                                                 
	        92 |::                                                 
	        90 |::                                                 
	        88 |::                                                 
	        86 |::                                                 
	        84 |::                                                 
	        82 |::                                                 
	        80 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^2,000   ^4,000   ^6,000   ^8,000   ^10,000  
	x=1 +: 804.33201028618; x: 1253.9346057468
    x=#2 +: 103.1594348353; x: 108.59276015945
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench
	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..100] elements in t[i] = 'abc' .. i        
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                    
	       440 |::                                                 
	       420 |::x                                                
	       400 |::                                                 
	       380 |::                                                 
	       360 |::                                                 
	       340 |:: x                                               
	       320 |::                                                 
	       300 |::+                                                
	       280 |::                                                 
	       260 |::  x                                              
	       240 |:: + x                                             
	       220 |::    x                                            
	       200 |::     x                                           
	       180 |::  ++  xxx                                        
	       160 |::    ++                                           
	       140 |::      +++xxx                                     
	       120 |::         +++*****x*xxxxx                         
	       100 |::                 + +++++*************************  +:  [102..318]     x:  [106..439] 
	        80 |::                                                 
	        60 |::                                                 
	        40 |::                                                 
	        20 |::                                                 
	         0 |::_________________________________________________
	 elements:  ^1       ^20      ^40      ^60      ^80      ^100     
	x=1 +: 805.51137292982; x: 1247.3574395573
    x=#2 +: 490.62392947217; x: 710.17626583063
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench
	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in t[i] = 'abc' .. i        
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                  
	       130 |::                                                 
	       128 |::                                                 
	       126 |::x                                                
	       124 |::                                                 
	       122 |::                                                 
	       120 |::+                                                
	       118 |::                                                 
	       116 |::                                                 
	       114 |:: x                                               
	       112 |::                                                 
	       110 |::         x                                       
	       108 |:: +x     x x                                      
	       106 |::   x       xx                                  x 
	       104 |::  + x     +  xxxxxxxxx x xx               xxxxx  
	       102 |::   + xx ++ +     + +  x x  xxxxxxxxxxxxxxx++   +x [101..127] 
	       100 |::    ++ x    +++++ + ++++++++++++ +++++++++  +++ + [99..120]   
	        98 |::      ++                        +                
	        96 |::                                                 
	        94 |::                                                 
	        92 |::                                                 
	        90 |::                                                 
	        88 |::                                                 
	        86 |::                                                 
	        84 |::                                                 
	        82 |::                                                 
	        80 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1,000   
	x=1 +: 803.95203970133; x: 1248.9970011233
    x=#2 +: 145.35261450247; x: 183.57026664402
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench
	Lua 5.1 official - Luabench 0.4.1
	----------------------------------------------------------------------------o-
	x=[1..10,000] elements in t[i] = 'abc' .. i        
	+: '[' .. table.concat(t) .. ']'
	x: string.format('[%s]', table.concat(t))
	----------------------------------------------------------------------------o-
        nsec/element  -=xXx=- '..' and string.format()                                 
	       120 |::                                                 
	       118 |::                                                 
	       116 |::                                                 
	       114 |::                                                 
	       112 |::                                                 
	       110 |::                          xx       x         xxxx [101..111] 
	       108 |::                            xxxxxxx xxxxxxxxx    
	       106 |::            xxxxxxxxxxxxxx+++++++++++++++++++++++ [99..107]   
	       104 |::x    x xxx*x    +                                
	       102 |:: x xx x+++ +++++ +++++++++                       
	       100 |::+ x++++                                          
	        98 |:: ++                                              
	        96 |::                                                 
	        94 |::                                                 
	        92 |::                                                 
	        90 |::                                                 
	        88 |::                                                 
	        86 |::                                                 
	        84 |::                                                 
	        82 |::                                                 
	        80 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^2,000   ^4,000   ^6,000   ^8,000   ^10,000  
	x=1 +: 796.37225083733; x: 1256.3044820767
    x=#2 +: 103.28399207874; x: 108.85942682612
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


ArithBench (PUC)
================

**lua sample-6.lua**

Sample 6 - plotset function - running Lua 5.1

This is a comparison between arithmetical operations: multiplication and division.


	Lua 5.1 official - Sample 6 / PUC
	----------------------------------------------------------------------------o-
	x=[1..100] elements in t[i] = rand(1,i)         
	*: Multiplication (PUC)
	:: Division (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                                
	       340 |::                                                 
	       336 |::                                                 
	       332 |::                                                 
	       328 |::#                                                
	       324 |::                                                 
	       320 |::                                                 
	       316 |::                                                 
	       312 |::                                                 
	       308 |::                                                 
	       304 |::                                                 
	       300 |::                                                 
	       296 |::                                                 
	       292 |::                                                 
	       288 |::                                                 
	       284 |::                                                 
	       280 |:: #                                               
	       276 |::                                                 
	       272 |::                                                 
	       268 |::                                                 
	       264 |::                                                 
	       260 |::  *                                              
	       256 |::  :                                              
	       252 |::                                                 
	       248 |::                                                 
	       244 |::   #                                             
	       240 |::                                                 
	       236 |::                                                 
	       232 |::    #                                            
	       228 |::                                                 
	       224 |::     #                                           
	       220 |::      #                                          
	       216 |::       #:                                        
	       212 |::        *#:                                      
	       208 |::          *::                                    
	       204 |::           **##:                                 
	       200 |::               *#:::::                           
	       196 |::                 *****###:::#::#::::::::: :      
	       192 |::                         *** ** ****** * # :::::: [194..329] Division PUC
	       188 |::                                      * * ******* [189..330] Multiplication PUC  
	       184 |::                                                 
	       180 |::                                                 
	       176 |::                                                 
	       172 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^20      ^40      ^60      ^80      ^100     
	x=1 *: 747.33983186405; :: 742.04718599657
        x=#2 *: 467.80677189409; :: 469.23747188354
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


	Lua 5.1 official - Sample 6 / PUC
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in t[i] = rand(1,i)         
	*: Multiplication (PUC)
	:: Division (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                             
	       210 |::                                                 
	       209 |::                                                 
	       208 |::                                                 
	       207 |::                                                 
	       206 |::                                                 
	       205 |::                                                 
	       204 |::                                                 
	       203 |:::                                                
	       202 |::                                                 
	       201 |::                                                 
	       200 |::                                                 
	       199 |:: :                                               
	       198 |::*                                                
	       197 |::  :                                              
	       196 |::                                                 
	       195 |::   :                                             
	       194 |:: *  :    :                                       
	       193 |::     :    :                                      
	       192 |::      : :  :                               ::    
	       191 |::  *    :    :::                                 : [185..203] Division PUC
	       190 |::               :                     :           
	       189 |::   **           :                 :     :      : 
	       188 |::     *  *        :::::         :                 
	       187 |::      **              ::::::::  :: ::  : :       
	       186 |::         * *                  :          *:  ::  
	       185 |::          *   **   *               * *:          
	       184 |::            **  * * *  *  *  *  * *     *    * ** [181..198] Multiplication PUC  
	       183 |::                     ** ** **  * *  * *   *      
	       182 |::                 *            *        *      *  
	       181 |::                                           **    
	       180 |::                                                 
	       179 |::                                                 
	       178 |::                                                 
	       177 |::                                                 
	       176 |::                                                 
	       175 |::                                                 
	       174 |::                                                 
	       173 |::                                                 
	       172 |::                                                 
	       171 |::                                                 
	       170 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1,000   
	x=1 *: 748.55988573771; :: 739.98558832947
        x=#2 *: 213.49864630157; :: 216.69358913349
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


	Lua 5.1 official - Sample 6 / PUC
	----------------------------------------------------------------------------o-
	x=[1..10,000] elements in t[i] = rand(1,i)         
	*: Multiplication (PUC)
	:: Division (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                           
	       200 |::                                                 
	       199 |::                                                 
	       198 |::                                                 
	       197 |::                                                 
	       196 |::                                                 
	       195 |::                                                 
	       194 |::                                                 
	       193 |::                                                 
	       192 |::                                                 
	       191 |::     :  :                                        
	       190 |::  :                                        *     
	       189 |:: *                         :                     
	       188 |::::  :    :      :     :                  ::      
	       187 |::    *                    :                   :  : [184..191] Division PUC
	       186 |::   :  :  *::::    :    :    *   : ::    :   :  : 
	       185 |::       :      :: : :::  * :  ::: :  ::::   :  #  
	       184 |::*                       :   :             *      
	       183 |::  **      *      *                               
	       182 |::     **     ****  *  **    * *   *      **  *  ** [180..190] Multiplication PUC  
	       181 |::       *   *    *  **  * *    *** *** **     *   
	       180 |::        *                 *          *           
	       179 |::                                                 
	       178 |::                                                 
	       177 |::                                                 
	       176 |::                                                 
	       175 |::                                                 
	       174 |::                                                 
	       173 |::                                                 
	       172 |::                                                 
	       171 |::                                                 
	       170 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^2,000   ^4,000   ^6,000   ^8,000   ^10,000  
	x=1 *: 747.32881409928; :: 741.16311527592
        x=#2 *: 185.11882231832; :: 196.39520407189
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


ArithBench (PUC)
================

**lua sample-7.lua**

## Sample 7 - plotset function - running Lua 5.1

This shows the speed of multiplication.

	Lua 5.1 official - Sample 7 / PUC
	----------------------------------------------------------------------------o-
	x=[1..100] elements in a table t[i] = rand(1,i)         
	y=time/x needed for Multiplication (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                       
	       340 |::                                                 
	       336 |::*                                                
	       332 |::                                                 
	       328 |::                                                 
	       324 |::                                                 
	       320 |::                                                 
	       316 |::                                                 
	       312 |::                                                 
	       308 |::                                                 
	       304 |::                                                 
	       300 |::                                                 
	       296 |::                                                 
	       292 |:: *                                               
	       288 |::                                                 
	       284 |::                                                 
	       280 |::                                                 
	       276 |::                                                 
	       272 |::                                                 
	       268 |::  *                                              
	       264 |::                                                 
	       260 |::                                                 
	       256 |::                                                 
	       252 |::   *                                             
	       248 |::                                                 
	       244 |::    *                                            
	       240 |::                                                 
	       236 |::     **                                          
	       232 |::                                                 
	       228 |::       *                                         
	       224 |::        **                                       
	       220 |::          *                                      
	       216 |::           ****                                  
	       212 |::               *****                             
	       208 |::                    **********                   
	       204 |::                              ************* ** * 
	       200 |::                                           *  * * [203..339] Multiplication PUC  
	       196 |::                                                 
	       192 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^20      ^40      ^60      ^80      ^100     
	x=1 *: 765.28235774114; x= *: 487.0246119281
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


	Lua 5.1 official - Sample 7 / PUC
	----------------------------------------------------------------------------o-
	x=[1..1,000] elements in a table t[i] = rand(1,i)         
	y=time/x needed for Multiplication (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                        
	       220 |::                                                 
	       219 |::                                                 
	       218 |::                                                 
	       217 |::                                                 
	       216 |::                                                 
	       215 |::                                                 
	       214 |::                                                 
	       213 |::                                                 
	       212 |::                                                 
	       211 |::                                                 
	       210 |::*                                                
	       209 |::                                                 
	       208 |::                                                 
	       207 |::                                                 
	       206 |:: *                                               
	       205 |::                                                 
	       204 |::  *                                              
	       203 |::   **                                            
	       202 |::     ** *                                        
	       201 |::             *                                   
	       200 |::       * **** * *  **                            
	       199 |::               * **  ****     *  *       *       
	       198 |::                         ** **  * **  *    ** ** 
	       197 |::                           *            *    *   
	       196 |::                               *     * *  *     * [195..210] Multiplication PUC  
	       195 |::                                    *            
	       194 |::                                                 
	       193 |::                                                 
	       192 |::                                                 
	       191 |::                                                 
	       190 |::                                                 
	       189 |::                                                 
	       188 |::                                                 
	       187 |::                                                 
	       186 |::                                                 
	       185 |::                                                 
	       184 |::                                                 
	       183 |::                                                 
	       182 |::                                                 
	       181 |::                                                 
	       180 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^200     ^400     ^600     ^800     ^1000    
	x=1 *: 757.93233980576; x= *: 225.09255248671
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


	Lua 5.1 official - Sample 7 / PUC
	----------------------------------------------------------------------------o-
	x=[1..10,000] elements in a table t[i] = rand(1,i)         
	y=time/x needed for Multiplication (PUC)
	----------------------------------------------------------------------------o-
        nsec/element  ArithBench (PUC)                                        
	       200 |::                                                 
	       199 |::                                                 
	       198 |::                                                 
	       197 |::               **                                
	       196 |::                                                 
	       195 |::                                                 
	       194 |::         * *  *  * *                             
	       193 |::*    *       *    *  ** *  **  *      *   *      
	       192 |::  *    **           *    **  *  **  *         * * [188..197] Multiplication PUC  
	       191 |::      *   *                       ** *  **  ** * 
	       190 |:: * **       *                          *   *     
	       189 |::                              *                  
	       188 |::                       *                         
	       187 |::                                                 
	       186 |::                                                 
	       185 |::                                                 
	       184 |::                                                 
	       183 |::                                                 
	       182 |::                                                 
	       181 |::                                                 
	       180 |::                                                 
	       179 |::                                                 
	       178 |::                                                 
	       177 |::                                                 
	       176 |::                                                 
	       175 |::                                                 
	       174 |::                                                 
	       173 |::                                                 
	       172 |::                                                 
	       171 |::                                                 
	       170 |::                                                 
	       ... |...................................................
	 elements:  ^1       ^2000    ^4000    ^6000    ^8000    ^10000   
	x=1 *: 758.22095279409; x= *: 197.11464768414
	-=xXx=- Luabench 0.4.1 - http://www.eonblast.com/luabench


**cat sample.lua**

        -----------------------------------------------------------------------
        -- luabench plotter sample
        -----------------------------------------------------------------------
        
        package.path="./?.lua"
        luabench=require("luabench")
        
        luabench.plot(
        
                -- title
                "-=xXx=- Sample: Wrong Concatenation ",
        
                -- preparation (prompt and code)
                "t[i] = 'abc'",
                function(x) t={}; for i=1,x do t[i]='abc' end; return t; end,
        
                -- bench line #1: (prompt and code)
                "s=''; for i=1,#t do s=s..t[i] end",
                function(t) local s=""; for i=1,#t do s=s..t[i] end return s end
        
                )
        print()
        print("Note that this curve doesn't even show total time but time per " ..
              "element. So what you are seeing is only one part of a geometric " ..
              "growth. [And also note that this is but a sample comment.]")


**Und das war: samples 1 to 7 in a row plus the source of sample.lua**


# History

## 0.4.1
* major speed up by allowing for recycling target tables
* added FIX_CYCLES to allow for fixed number of cycles for all x
* added plotset() to render with multiple Xmax
* minor clean up of locals and parameters t2 and t3
* fixed single curve prepare call
* added explain text

## 0.4
* added exception catch pcall() around measure function
* added lower limit of string sizes for randstr()
* added speak like and key like random string pattern sets
* added some decimal point formatting for number displays
* attempt at higher precision for small count of elements 
* fixed x sequence from 1,3,5.. v 1,11,21.. to 1,2,4.. v 1,10,20..

## 0.3
* fixed wait dots margin
* added dynamic cycle adjustment from get go
* added display of elements and cycles to wait dots
* refactored use of math.min/max on nil
* fixed adjustment and deletion of wait dots
* fixed Lua/LuaJIT version display
* added VERSION_TAG for subject name & version

## 0.2
* added test feed function someval_no_bools()
* added 1K string to someval()
* added suppressing of CUTOFF when < 25% space gain
* added ALWAYS_CUTOFF
* added definable x axis character
* added colon on x axis as signifyer for actual 0s 
* fixed one too high lower cutoff row

* TODO: single line plot function lags behind plot2()
