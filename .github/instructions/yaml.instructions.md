# YAML Instructions

When working with YAML files in this dotfiles repository:

## Syntax Guidelines
- Use 2-space indentation consistently
- Avoid tabs - use spaces only
- Quote strings when they contain special characters
- Use lowercase for boolean values (true/false)

## Structure
- Group related settings together
- Use meaningful key names
- Keep nesting levels reasonable (prefer flat structures)
- Add comments for complex configurations

## Ansible YAML
- Include descriptive task names
- Use proper module parameters
- Organize tasks in logical order
- Use variables for repeated values

## Configuration YAML
- Validate syntax before committing
- Use consistent naming conventions
- Document any non-obvious settings
- Include examples in comments when helpful

## Best Practices
- Keep files focused on single purposes
- Use anchors and aliases for repeated structures
- Validate YAML syntax with tools
- Format consistently across all files

## Error Prevention
- Quote strings that might be interpreted as other types
- Be explicit about data types when ambiguity exists
- Use proper escaping for special characters
- Test configurations after changes
