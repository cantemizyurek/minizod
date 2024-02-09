# MiniScript Validation Library

A lightweight, Zod-inspired validation library for MiniScript, designed to provide a simple and intuitive API for data validation. This library allows you to validate strings, numbers, booleans, and complex objects with ease, supporting optional, nullable, and coercion features for robust data handling.

## Features

- **Type Validation**: Support for basic types such as `string`, `number`, and `boolean`.
- **Object Validation**: Validate complex objects using a schema-based approach.
- **Modifiers**: Includes `.optional()`, `.nullable()`, and `.coerce()` modifiers for flexible validation rules.
- **String Validations**: Methods like `.min()`, `.max()`, `.length()`, `.regex()`, `.includes()`, `.startsWith()`, and `.endsWith()`.
- **Number Validations**: Includes `.gt()`, `.gte()`, `.lt()`, `.lte()`, `.integer()`, `.positive()`, `.nonnegative()`, `.negative()`, and `.nonpositive()`.
- **Boolean Validations**: Supports `.truthy()` and `.falsy()` checks.
- **Custom Coercion**: Ability to coerce values to the expected type before validation.

## Installation

Since MiniScript is domain-specific scripting language, the installation process would depend on the environment where MiniScript runs. Ensure you have the MiniScript environment set up, then integrate this validation library script into your project.

## Usage

### Basic Validation

```miniscript
// Validate a string
nameValidator = z.string().min(3).max(20)
result = nameValidator.parse("John Doe")
```

### Object Validation

```miniscript
// Define a user schema
userSchema = {
  "name": z.string().min(3),
  "age": z.number().positive().optional()
}

// Validate a user object
userValidator = z.object(userSchema)
user = {"name": "Jane Doe", "age": 25}
result = userValidator.parse(user)
```

### Modifiers

```miniscript
// Optional string validation
optionalEmail = z.string().email().optional()

// Nullable number validation
nullableAge = z.number().nullable()
```

## Examples

### Validating an IP Address

```miniscript
ipValidator = z.string().ip()
result = ipValidator.parse("192.168.1.1")
```

### Combining Validators

```miniscript
// Combine validators for complex validation rules
complexValidator = z.object({
  "username": z.string().min(3).max(15),
  "password": z.string().min(8).regex("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$") // Simple regex for demonstration
})
```

## Contributing

Contributions to improve the library or extend its functionalities are welcome.

## License

This library is licensed under the MIT License. See the LICENSE file for more details.
