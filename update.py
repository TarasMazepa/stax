import re

with open('cli/lib/command/internal_command_doctor.dart', 'r') as f:
    content = f.read()

# Add import
import_monolib = "import 'package:monolib_dart/monolib_dart.dart';\n"
if "package:monolib_dart/monolib_dart.dart" not in content:
    content = content.replace("import 'package:stax/string_empty_to_null.dart';", "import 'package:monolib_dart/monolib_dart.dart';\nimport 'package:stax/string_empty_to_null.dart';")

# Add flag definition
flag_def = "  static final flagJson = Flag(short: '-j', long: '--json', description: 'output in json format');\n"
if "static final flagJson" not in content:
    content = content.replace("class InternalCommandDoctor extends InternalCommand {", "class InternalCommandDoctor extends InternalCommand {\n" + flag_def)

# Add flag to super constructor
if "flags: [flagJson]" not in content:
    content = content.replace("type: InternalCommandType.hidden,", "type: InternalCommandType.hidden,\n        flags: [flagJson],")

# Add flag check
if "final isJson = flagJson.hasFlag(args);" not in content:
    content = content.replace("String boolToCheckmark(bool value) => value ? 'V' : 'X';", "final isJson = flagJson.hasFlag(args);\n\n    String boolToCheckmark(bool value) => value ? 'V' : 'X';")

with open('cli/lib/command/internal_command_doctor.dart', 'w') as f:
    f.write(content)
