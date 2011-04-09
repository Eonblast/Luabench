-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

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

print()
print("And this shows both results in one graph. Note that this curves " ..
      "show time per table element.")