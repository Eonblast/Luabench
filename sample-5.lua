-----------------------------------------------------------------------
-- luabench plotter sample
-----------------------------------------------------------------------

package.path="./?.lua"
luabench=require("luabench")

luabench.MAX_ELEMENTS = 100

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = randstr 1 - 200 chars",
        function(x) t={}; for i=1,x do t[i]=luabench.randstr(200) end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)

luabench.MAX_ELEMENTS = 1000

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)

luabench.MAX_ELEMENTS = 10000

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)


luabench.MAX_ELEMENTS = 100

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)

luabench.MAX_ELEMENTS = 1000

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)

luabench.MAX_ELEMENTS = 10000

luabench.plot(

        -- title
        "-=xXx=- '..' and string.format() ",

        -- preparation (prompt and code)
        "t[i] = 'abc' .. i",
        function(x) t={}; for i=1,x do t[i]='abc'..i end; return t; end,

        -- bench line #1: (prompt and code)
		"'[' .. table.concat(t) .. ']'",
        function(t) return '[' .. table.concat(t) .. ']' end,

        -- bench line #2: (prompt and code)
		"string.format('[%s]', table.concat(t))",
        function(t) return string.format('[%s]', table.concat(t)) end
		)

