# Agents

- Also check MORE-AGENTS.md if present
- In dart files prefer optional named arguments over optional arguments
- If there is a function toJson() I prefer its return type to be dynamic
- I prefer each class to be in a separate file, if possible
- Do not remove UniqueKeys from anywhere.
- We do not need `interface` used on classes, it doesn't add any value.
- Do not refactor functions that return Future<void> to return void
- In GitHub workflow files, skip name if action is named action or a one line run command
- GitHub workflow files naming: filename, and name of workflow should be the same. Example: `dart-format.yml` (filename) `name: dart-format.yml` first line in the file, and job name should be the same but without extention: `dart-format`
- I prefer conrete types over `var`. So define mutable variables using concrete type. final or const values we can have type skipped, as I think that final and const look nice on their own.
- when writing scripts make sure that they could be invoked from any location and if they provide any commands - output those commands in a separate line
- when naming dart extentions I prefer name of the extention to read same or similar to the type, so if extention is "on String" I would name it "OnString", this also applies to nested types like "OnListOfLists" or "OnNullableListOfStreamControllers"
- `stdin.readLineSync()` doesn't have good async substitution and shouldn't be refactored to async API
