-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.MAX_ELEMENTS = 1000000

luabench.plot(

        -- title
        "-=xXx=- Sample 4a: concat() and a very large table ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"return table.concat(t) end",
        function(t) return table.concat(t) end
		)

print()
print("Concat() problems are getting more pronounced. xmax is now set to 1.000,000.")