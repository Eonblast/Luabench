-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.SLICE    = 0.01  -- minimal time slice for cycles. Safe default: 0.2.
luabench.BEST_OF  = 1     -- number of repeat runs, fastest used. Safe deflt: 3.

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
