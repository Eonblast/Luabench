# luabench 0.1.0

This ASCII plotter draws a benchmark as a graph.

It shows how the benchmark behaves (y time axis) while a table increases in size (the x axis) that it uses as feed. 

It can also compare two Lua benchmarks. The size of the plot area of the graph can be adapted to your needs, the ranges shown are automatically adjusted to sensible values. The drawing x=1 is suppressed by default as it often skews the scale of the shown area for no gain. The time is shown relative to elements in the table. 

Status: mostly runs. Beware of possible dumb mistakes in the time measurement. Please double check.

Have fund

## Sample

Let's assume we wanted to compare two implementations

	1		local s="" 
			for i=1,#t do
				s=s..t[i] 
			end
and

	2		 table.concat(t)

And we would like to see how those implementations hold up for different tables sizes. While for each table element the table should simply have 

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

This is the result of the sample files 

	sample.lua
	sample2.lua
	sample3.lua
	sample4.lua

Simply call 'make' with arguments to see them being produced.

**lua sample.lua**
	Lua 5.1 official
	----------------------------------------------------------------------------o-
	x=[1..1000] elements in a table t[i] = 'abc'			 
	y=time/x needed for s=''; for i=1,#t do s=s..t[i] end
	----------------------------------------------------------------------------o-
		nsec/element  -=xXx=- Sample: Wrong Concatenation 
		  1700 |:												  
		  1650 |:											   +++ [325..1691]	 
		  1600 |:										   ++++	  
		  1550 |:										+++		  
		  1500 |:									  ++		  
		  1450 |:								  ++++			  
		  1400 |:								++				  
		  1350 |:							 +++				  
		  1300 |:						 ++++					  
		  1250 |:					   ++						  
		  1200 |:					+++							  
		  1150 |:				  ++							  
		  1100 |:				++								  
		  1050 |:			  ++								  
		  1000 |:			++									  
		   950 |:												  
		   900 |:												  
		   850 |:												  
		   800 |:												  
		   750 |:												  
		   700 |:												  
		   650 |:												  
		   600 |:												  
		   550 |:												  
		   500 |:												  
		   450 |:												  
		   400 |:	   +++++									  
		   350 |:  ++++											  
		   300 |:++												  
		   ... |..................................................
	 elements:	^1		 ^200	  ^400	   ^600		^800	 
	 x=1: 374 not shown
	-=xXx=- Luabench Plotter 0.1.0 - http://eonblast.com/luabench

Note that this curve doesn't even show total time but time per element. So what you are seeing is only one part of a geometric growth. [And this is a sample comment.]

**lua sample-2.lua**

	Lua 5.1 official
	----------------------------------------------------------------------------o-
	x=[1..1000] elements in a table t[i] = 'abc'			 
	y=time/x needed for return table.concat(t) end
	----------------------------------------------------------------------------o-
		nsec/element  -=xXx=- Sample 2: using concat() 
		   130 |:												  
		   128 |:												  
		   126 |:												  
		   124 |:+												  
		   122 |:												  
		   120 |:												  
		   118 |:												  
		   116 |:												  
		   114 |:												  
		   112 |:												  
		   110 |:												  
		   108 |: +												  
		   106 |:												  
		   104 |:  +											  
		   102 |:												  
		   100 |:	+											  
			98 |:												  
			96 |:	 ++											  
			94 |:	   +++		  ++++++   +		 + +		  
			92 |:		  ++++++ +		+++ +++++++++ + ++++++++ + [91..125]   
			90 |:				+								+ 
		   ... |..................................................
	 elements:	^1		 ^200	  ^400	   ^600		^800	 
	 x=1: 591.4 not shown
	-=xXx=- Luabench Plotter 0.1.0 - http://eonblast.com/luabench

Using concat() is the recommended way to do this. 

**lua sample-3.lua**
	Lua 5.1 official
	----------------------------------------------------------------------------o-
	1 - 1000 elements in t[i] = 'abc'			  
	+: WRONG: s=''; for i=1,#t do s=s..t[i] end
	x: RIGHT: return table.concat(t) end
	----------------------------------------------------------------------------o-
		nsec/element  -=xXx=- Sample 3: Right & Wrong Concatenation 
		  1700 |:												  
		  1640 |:											   +++ [329..1689]	 
		  1580 |:										  +++++	  
		  1520 |:									   +++		  
		  1460 |:								   ++++			  
		  1400 |:								+++				  
		  1340 |:							++++				  
		  1280 |:						++++					  
		  1220 |:					 +++						  
		  1160 |:				   ++							  
		  1100 |:				 ++								  
		  1040 |:			  +++								  
		   980 |:			++									  
		   920 |:												  
		   860 |:												  
		   800 |:												  
		   740 |:												  
		   680 |:												  
		   620 |:												  
		   560 |:												  
		   500 |:												  
		   440 |:												  
		   380 |:	 +++++++									  
		   320 |:++++											  
		   260 |:												  
		   200 |:												  
		   140 |:												  
			80 |:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx [91..124] 
			20 |:												  
		   ... |..................................................
	 elements:	^1		 ^200	  ^400	   ^600		^800	 
	x=1 +: 373.7; x: 592.3
	-=xXx=- Luabench Plotter 0.1.0 - http://eonblast.com/luabench

And this shows both results in one graph. Note that this curves show time per table element.

**lua sample-4.lua**
	Lua 5.1 official
	----------------------------------------------------------------------------o-
	x=[1..100000] elements in a table t[i] = 'abc' .. i		   
	y=time/x needed for return table.concat(t) end
	----------------------------------------------------------------------------o-
		nsec/element  -=xXx=- Sample 4: concat() and a large table 
		   190 |:												  
		   186 |:												  
		   182 |:								  +				  
		   178 |:												  
		   174 |:												  
		   170 |:												  
		   166 |:												  
		   162 |:									  +			  
		   158 |:												  
		   154 |:						+						  
		   150 |:					  +					+		  
		   146 |:												  
		   142 |:							+		+	  +		  
		   138 |:											+ + + 
		   134 |:								 + +			  
		   130 |:									 + +	 +	  
		   126 |:				+				+		 + +   + + [101..184]	
		   122 |:					 + + +++ +++				  
		   118 |:				 ++++							  
		   114 |:	   +	 +++								  
		   110 |:		+  ++									  
		   106 |:	+	 ++										  
		   102 |:+ + ++											  
		   ... |..................................................
	 elements:	^1		 ^20000	  ^40000   ^60000	^80000	 
	 x=1: 589.8 not shown
	-=xXx=- Luabench Plotter 0.1.0 - http://eonblast.com/luabench

But concat() has its problems, too, when we get into deep waters. [xmax is now set to 100,000. Before, we looked at x in 1 - 1,000. Now at 1 - 100,000].

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
	 print("Not that this curve doesn't even show total time but time per " ..
		   "element. So what you are seeing is only one part of a geometric " ..
		   "growth. [And this is a sample comment.]")
