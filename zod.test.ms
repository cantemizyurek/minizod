import_code("./libs/testing/mitest.ms")
import_code("./zod.ms")

vi.global()

test "zod", function()
    test "string", function()
        string = "hello"
        number = 123
        expect(z.string().parse(string).valid).toBe(true)
        expect(z.string().parse(number).valid).toBe(false)

        test "max", function()
            expect(z.string().max(3).parse("123").valid).toBe(true)
            expect(z.string().max(3).parse("1234").valid).toBe(false)
        end function

        test "min", function()
            expect(z.string().min(3).parse("123").valid).toBe(true)
            expect(z.string().min(3).parse("12").valid).toBe(false)
        end function

        test "length", function()
            expect(z.string().length(3).parse("123").valid).toBe(true)
            expect(z.string().length(3).parse("12").valid).toBe(false)
            expect(z.string().length(3).parse("1234").valid).toBe(false)
        end function

        test "regex", function()
            expect(z.string().regex("^hello$").parse("hello").valid).toBe(true)
            expect(z.string().regex("^hello$").parse("hello world").valid).toBe(false)
        end function

        test "includes", function()
            expect(z.string().includes("hello").parse("hello world").valid).toBe(true)
            expect(z.string().includes("hello").parse("world").valid).toBe(false)
        end function

        test "startsWith", function()
            expect(z.string().startsWith("hello").parse("hello world").valid).toBe(true)
            expect(z.string().startsWith("hello").parse("world").valid).toBe(false)
        end function

        test "endsWith", function()
            expect(z.string().endsWith("world").parse("hello world").valid).toBe(true)
            expect(z.string().endsWith("world").parse("hello").valid).toBe(false)
        end function

        test "ip", function()
            expect(z.string().ip().parse("1.1.1.1").valid).toBe(true)
            expect(z.string().ip().parse("1.1.1").valid).toBe(false)
        end function

        test "coerce", function()
            expect(z.string().coerce().parse(123).valid).toBe(true)
            expect(z.string().coerce().parse(123).value).toBe("123")
        end function
    end function

    test "number", function()
        string = "hello"
        number = 123
        expect(z.number().parse(number).valid).toBe(true)
        expect(z.number().parse(string).valid).toBe(false)

        test "gt", function()
            expect(z.number().gt(3).parse(4).valid).toBe(true)
            expect(z.number().gt(3).parse(3).valid).toBe(false)
        end function

        test "gte", function()
            expect(z.number().gte(3).parse(3).valid).toBe(true)
            expect(z.number().gte(3).parse(2).valid).toBe(false)
        end function

        test "lt", function()
            expect(z.number().lt(3).parse(2).valid).toBe(true)
            expect(z.number().lt(3).parse(3).valid).toBe(false)
        end function

        test "lte", function()
            expect(z.number().lte(3).parse(3).valid).toBe(true)
            expect(z.number().lte(3).parse(4).valid).toBe(false)
        end function

        test "integer", function()
            expect(z.number().integer().parse(3).valid).toBe(true)
            expect(z.number().integer().parse(3.5).valid).toBe(false)
        end function

        test "positive", function()
            expect(z.number().positive().parse(3).valid).toBe(true)
            expect(z.number().positive().parse(-3).valid).toBe(false)
        end function

        test "nonnegative", function()
            expect(z.number().nonnegative().parse(0).valid).toBe(true)
            expect(z.number().nonnegative().parse(-3).valid).toBe(false)
        end function

        test "negative", function()
            expect(z.number().negative().parse(-3).valid).toBe(true)
            expect(z.number().negative().parse(3).valid).toBe(false)
        end function

        test "nonpositive", function()
            expect(z.number().nonpositive().parse(0).valid).toBe(true)
            expect(z.number().nonpositive().parse(3).valid).toBe(false)
        end function

        test "multipleOf", function()
            expect(z.number().multipleOf(3).parse(6).valid).toBe(true)
            expect(z.number().multipleOf(3).parse(7).valid).toBe(false)
        end function

        test "coerce", function()
            expect(z.number().coerce().parse("123").valid).toBe(true)
            expect(z.number().coerce().parse("123").value).toBe(123)
        end function
    end function

    test "boolean", function()
        expect(z.boolean().parse(true).valid).toBe(true)
        expect(z.boolean().parse(false).valid).toBe(true)
        expect(z.boolean().parse("true").valid).toBe(false)
        expect(z.boolean().parse("false").valid).toBe(false)
    end function

    test "object", function()
        person = z.object({
            "name": z.string(),
            "age": z.number()
        })

        expect(person.parse({"name": "John", "age": 30}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": "30"}).valid).toBe(false)

        test "shape", function()
            person = z.object({
                "name": z.string(),
                "age": z.number()
            })

            expect(person.shape("name").parse("John").valid).toBe(true)
            expect(person.shape("name").parse("John").value).toBe("John")
        end function

        test "extend", function()
            person = z.object({
                "name": z.string(),
                "age": z.number()
            })

            employee = person.extend({
                "position": z.string()
            })

            expect(employee.parse({"name": "John", "age": 30, "position": "Developer"}).valid).toBe(true)
            expect(employee.parse({"name": "John", "age": 30}).valid).toBe(false)
        end function

        test "merge", function()
            person = z.object({
                "name": z.string(),
                "age": z.number()
            })

            employee = z.object({
                "position": z.string()
            })

            merged = person.merge(employee)

            expect(merged.parse({"name": "John", "age": 30, "position": "Developer"}).valid).toBe(true)
            expect(merged.parse({"name": "John", "age": 30}).valid).toBe(false)
        end function

        test "pick", function()
            person = z.object({
                "name": z.string(),
                "age": z.number()
            })

            picked = person.pick({"name": true})

            expect(picked.parse({"name": "John", "age": 30}).valid).toBe(true)
            expect(picked.parse({"name": "John", "age": 30}).value).toBe({"name": "John"})
        end function

        test "omit", function()
            person = z.object({
                "name": z.string(),
                "age": z.number()
            })

            omitted = person.omit({"age": true})

            expect(omitted.parse({"name": "John", "age": 30}).valid).toBe(true)
            expect(omitted.parse({"name": "John", "age": 30}).value).toBe({"name": "John"})
        end function
    end function

    test "optional", function()
        person = z.object({
            "name": z.string(),
            "age": z.optional(z.number())
        })

        expect(person.parse({"name": "John"}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": 30}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": "30"}).valid).toBe(true)
    end function

    test "nullable", function()
        person = z.object({
            "name": z.string(),
            "age": z.nullable(z.number())
        })

        expect(person.parse({"name": "John"}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": 30}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": "30"}).valid).toBe(false)
        expect(person.parse({"name": "John", "age": null}).valid).toBe(true)
    end function

    test "default", function()
        person = z.object({
            "name": z.string(),
            "age": z.default(z.number(), 30)
        })

        expect(person.parse({"name": "John"}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": 30}).valid).toBe(true)
        expect(person.parse({"name": "John", "age": "30"}).valid).toBe(false)
    end function

    test "any", function()
        expect(z.any().parse("hello").valid).toBe(true)
        expect(z.any().parse(123).valid).toBe(true)
        expect(z.any().parse(true).valid).toBe(true)
        expect(z.any().parse({}).valid).toBe(true)

        expect(z.any().parse(123).value).toBe(123)
        expect(z.any().parse("hello").value).toBe("hello")

        test "function", function()
            t = function()
            end function

            expect(@z.any().parse(@t).value).toBe(t)
        end function
    end function

    test "array", function()
        schema = z.array(z.string())

        expect(schema.parse(["hello", "world"]).valid).toBe(true)
        expect(schema.parse(["hello", 123]).valid).toBe(false)
    end function

    test "enum", function()
        schema = z.enum(["hello", "world"])

        expect(schema.parse("hello").valid).toBe(true)
        expect(schema.parse("world").valid).toBe(true)
        expect(schema.parse("hi").valid).toBe(false)
    end function
end function