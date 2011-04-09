-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.plot(

        -- title
        "-=xXx=- Sample 2: using concat() ",

        -- preparation (prompt and code)
        "t[i] = 'abc'",
        function(x) t={}; for i=1,x do t[i]='abc' end; return t; end,

        -- bench line #1: (prompt and code)
		"return table.concat(t) end",
        function(t) return table.concat(t) end

		)
print()
print("Using concat() is the recommended way to do this. ")
