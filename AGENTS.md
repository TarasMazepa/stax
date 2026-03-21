# Agents

- In dart files prefer optional named arguments over optional arguments
- If there is a function toJson() I prefer its return type to be dynamic
- I prefer each class to be in a separate file, if possible
- Do not remove UniqueKeys from anywhere.
- We do not need `interface` used on classes, it doesn't add any value.
- Do not refactor functions that return Future<void> to return void
- In GitHub workflow files, skip name if action is named action or a one line run command
- GitHub workflow files naming: filename, and name of workflow should be the same. Example: `dart-format.yml` (filename) `name: dart-format.yml` first line in the file, and job name should be the same but without extention: `dart-format`
