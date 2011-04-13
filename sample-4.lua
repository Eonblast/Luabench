-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.MAX_ELEMENTS = 100000

luabench.plot(

        -- title
        "-=xXx=- Sample 4: concat() and a large table ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"return table.concat(t) end",
        function(t) return table.concat(t) end
		)

print()
print("But concat() gets slower, too, when strings get longer. xmax is now set to 100,000. Before, we looked at x in 1 - 1,000. Now at 1 - 100,000 [<- this all is an unrelated test comment].")