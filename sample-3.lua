-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.SHOW_ONE = false -- setting false often increases resolution
luabench.SLICE    = 0.01  -- minimal time slice for cycles. Safe default: 0.2.
luabench.BEST_OF  = 1     -- number of repeat runs, fastest used. Safe deflt: 3.

luabench.plot(

        -- title
        "-=xXx=- Sample 3: Right & Wrong Concatenation ",

        -- preparation (prompt and code)
        "t[i] = 'abc'",
        function(x) t={}; for i=1,x do t[i]='abc' end; return t; end,

        -- bench line #1: (prompt and code)
		"WRONG WAY TO DO IT: s=''; for i=1,#t do s=s..t[i] end",
        function(t) local s=""; for i=1,#t do s=s..t[i] end return s end,

        -- bench line #2: (prompt and code)
		"RIGHT WAY TO DO IT: return table.concat(t) end",
        function(t) return table.concat(t) end
		)

print()
print("This shows two results in one graph. Note that these curves " ..
      "show time per table element.")