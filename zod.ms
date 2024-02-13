// basic zod implementation on miniscript
__scope__ = function()
    Validator = {}
    Validator.validators = []
    Validator._optional = false
    Validator._nullable = false
    Validator._coerce = false
    Validator._default = null
    Validator.parse = function(value)
        if value == null and self._default != null then return {"valid": true, "value": self._default}
        if value == null and self._nullable == false then return {"valid": false, "error": "Value is null"}
        if value == null and self._nullable == true then return {"valid": true, "value": null}
        if self._coerce == true then 
            value = self.handleCoerce(value)
            if typeof(value) == "map" and value.valid == false then return value
        end if
        for validater in self.validators
            result = validater(value)
            if result != true and self._optional == false then
                return {"valid": false, "error": result}
            end if
        end for
        return {"valid": true, "value": value}
    end function
    Validator.handleCoerce = function(value)
        return value
    end function
    Validator.addValidator = function(validater)
        self.validators.push(@validater)
        return self
    end function
    Validator.optional = function()
        self._optional = true
        return self
    end function
    Validator.nullable = function()
        self._nullable = true
        return self
    end function
    Validator.coerce = function()
        self._coerce = true
        return self
    end function
    Validator.default = function(value)
        self._default = value
        return self
    end function
    
    StringValidator = new Validator
    StringValidator.max = function(max, options)
        if options == null then options = {}
        checkIfStringMax = function(value)
            if value.len > max then
                if options.hasIndex("message") then return options.message
                return "String is too long"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringMax)
    end function
    StringValidator.min = function(min, options)
        if options == null then options = {}
        checkIfStringMin = function(value)
            if value.len < min then
                if options.hasIndex("message") then return options.message
                return "String is too short"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringMin)
    end function
    StringValidator.length = function(length, options)
        if options == null then options = {}
        checkIfStringLength = function(value)
            if value.len != length then
                if options.hasIndex("message") then return options.message
                return "String is not the correct length"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringLength)
    end function
    StringValidator.regex = function(regex, options)
        if options == null then options = {}
        checkIfStringRegex = function(value)
            if value.is_match(regex) == false then
                if options.hasIndex("message") then return options.message
                return "String does not match regex"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringRegex)
    end function
    StringValidator.includes = function(includes, options)
        if options == null then options = {}
        checkIfStringIncludes = function(value)
            if value.indexOf(includes) == null then
                if options.hasIndex("message") then return options.message
                return "String does not include value"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringIncludes)
    end function
    StringValidator.startsWith = function(startsWith, options)
        if options == null then options = {}
        checkIfStringStartsWith = function(value)
            if value.indexOf(startsWith) != 0 then
                if options.hasIndex("message") then return options.message
                return "String does not start with value"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringStartsWith)
    end function
    StringValidator.endsWith = function(endsWith, options)
        if options == null then options = {}
        checkIfStringEndsWith = function(value)
            if value.indexOf(endsWith) != value.len - endsWith.len then
                if options.hasIndex("message") then return options.message
                return "String does not end with value"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringEndsWith)
    end function
    StringValidator.ip = function(options)
        if options == null then options = {}
        checkIfStringIp = function(value)
            if is_valid_ip(value) == false then
                if options.hasIndex("message") then return options.message
                return "String is not a valid IP address"
            end if
            return true
        end function
        return self.addValidator(@checkIfStringIp)
    end function
    StringValidator.handleCoerce = function(value)
        newValue = str(value)
        if typeof(newValue) != "string" then return {"valid": false, "error": "Value is not a string"}
        return newValue
    end function
    StringValidator.New = function()
        checkIfString = function(value)
            if typeof(value) != "string" then
                return "Value is not a string"
            end if
            return true
        end function
        result = new StringValidator
        result.validators = []
        return result.addValidator(@checkIfString)
    end function
    
    NumberValidator = new Validator
    NumberValidator.gt = function(gt, options)
        if options == null then options = {}
        checkIfNumberGt = function(value)
            if value <= gt then
                if options.hasIndex("message") then return options.message
                return "Number is not greater than " + gt
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberGt)
    end function
    NumberValidator.gte = function(gte, options)
        if options == null then options = {}
        checkIfNumberGte = function(value)
            if value < gte then
                if options.hasIndex("message") then return options.message
                return "Number is not greater than or equal to " + gte
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberGte)
    end function
    NumberValidator.lt = function(lt, options)
        if options == null then options = {}
        checkIfNumberLt = function(value)
            if value >= lt then
                if options.hasIndex("message") then return options.message
                return "Number is not less than " + lt
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberLt)
    end function
    NumberValidator.lte = function(lte, options)
        if options == null then options = {}
        checkIfNumberLte = function(value)
            if value > lte then
                if options.hasIndex("message") then return options.message
                return "Number is not less than or equal to " + lte
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberLte)
    end function
    NumberValidator.integer = function(options)
        if options == null then options = {}
        checkIfNumberInteger = function(value)
            if value % 1 != 0 then
                if options.hasIndex("message") then return options.message
                return "Number is not an integer"
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberInteger)
    end function
    NumberValidator.positive = function(options)
        if options == null then options = {}
        checkIfNumberPositive = function(value)
            if value <= 0 then
                if options.hasIndex("message") then return options.message
                return "Number is not positive"
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberPositive)
    end function
    NumberValidator.nonnegative = function(options)
        if options == null then options = {}
        checkIfNumberNonnegative = function(value)
            if value < 0 then
                if options.hasIndex("message") then return options.message
                return "Number is negative"
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberNonnegative)
    end function
    NumberValidator.negative = function(options)
        if options == null then options = {}
        checkIfNumberNegative = function(value)
            if value >= 0 then
                if options.hasIndex("message") then return options.message
                return "Number is not negative"
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberNegative)
    end function
    NumberValidator.nonpositive = function(options)
        if options == null then options = {}
        checkIfNumberNonpositive = function(value)
            if value > 0 then
                if options.hasIndex("message") then return options.message
                return "Number is positive"
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberNonpositive)
    end function
    NumberValidator.multipleOf = function(multipleOf, options)
        if options == null then options = {}
        checkIfNumberMultipleOf = function(value)
            if value % multipleOf != 0 then
                if options.hasIndex("message") then return options.message
                return "Number is not a multiple of " + multipleOf
            end if
            return true
        end function
        return self.addValidator(@checkIfNumberMultipleOf)
    end function
    NumberValidator.handleCoerce = function(value)
        newValue = value.val
        if typeof(newValue) != "number" then return {"valid": false, "error": "Value is not a number"}
        return newValue
    end function
    NumberValidator.New = function()
        checkIfNumber = function(value)
            if typeof(value) != "number" then
                return "Value is not a number"
            end if
            return true
        end function
        result = new NumberValidator
        result.validators = []
        return result.addValidator(@checkIfNumber)
    end function
    
    BooleanValidator = new Validator
    BooleanValidator.truthy = function(options)
        if options == null then options = {}
        checkIfBooleanTruthy = function(value)
            if value != true then
                if options.hasIndex("message") then return options.message
                return "Value is not truthy"
            end if
            return true
        end function
        return self.addValidator(@checkIfBooleanTruthy)
    end function
    BooleanValidator.falsy = function(options)
        if options == null then options = {}
        checkIfBooleanFalsy = function(value)
            if value != false then
                if options.hasIndex("message") then return options.message
                return "Value is not falsy"
            end if
            return true
        end function
        return self.addValidator(@checkIfBooleanFalsy)
    end function
    BooleanValidator.handleCoerce = function(value)
        if value == "true" or value == true then return true
        if value == "false" or value == false then return false
        return {"valid": false, "error": "Value is not a boolean"}
    end function
    BooleanValidator.New = function()
        checkIfBoolean = function(value)
            if value != true and value != false then
                return "Value is not a boolean"
            end if
            return true
        end function
        result = new BooleanValidator
        result.validators = []
        return result.addValidator(@checkIfBoolean)
    end function
    
    ObjectValidator = new Validator
    ObjectValidator.schema = {}
    ObjectValidator.parse = function(table)
        resultTable = {}
        for value in self.schema
            key = value.key
            validator = value.value
            if table.hasIndex(key) then result = validator.parse(table[key])
            if not table.hasIndex(key) and validator._nullable == true then result = {"valid": true, "value": null}
            if not table.hasIndex(key) and validator._optional == false and validator._nullable == false then return {"valid": false, "error": "Value is missing"}
            if not table.hasIndex(key) and validator._optional == true then result = {"valid": true, "value": null}
            if result.valid == false then return result
            resultTable[key] = result.value
        end for
        return {"valid": true, "value": resultTable}
    end function
    ObjectValidator.shape = function(key)
        return self.schema[key]
    end function
    ObjectValidator.extend = function(schema)
        return ObjectValidator.New(self.schema + schema)    
    end function
    ObjectValidator.merge = function(otherObjectValidator)
        return ObjectValidator.New(self.schema + otherObjectValidator.schema)
    end function
    ObjectValidator.pick = function(keys)
        newSchema = {}
        for v in self.schema
            if keys.hasIndex(v.key) and keys[v.key] == true then newSchema[v.key] = v.value
        end for
        return ObjectValidator.New(newSchema)
    end function
    ObjectValidator.omit = function(keys)
        newSchema = {}
        for v in self.schema
            if not keys.hasIndex(v.key) then newSchema[v.key] = v.value
        end for
        return ObjectValidator.New(newSchema)
    end function
    ObjectValidator.New = function(schema)
        result = new ObjectValidator
        result.schema = schema
        return result
    end function
    
    globals.z = {}
    z.string = function()
        return new StringValidator.New()
    end function
    z.number = function()
        return new NumberValidator.New()
    end function
    z.boolean = function()
        return new BooleanValidator.New()
    end function
    z.object = function(schema)
        return new ObjectValidator.New(schema)
    end function
    z.optional = function(validator)
        return validator.optional()
    end function
    z.nullable = function(validator)
        return validator.nullable()
    end function
    z.coerce = function(validator)
        return validator.coerce()
    end function
end function
__scope__
globals.remove("__scope__")