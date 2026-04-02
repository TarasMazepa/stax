import 'dart:io';
import 'package:cli_util/cli_util.dart';
import 'package:monolib_dart/stream.dart';

void main() async {
  print(await sharedStdIn.readLine());
}
