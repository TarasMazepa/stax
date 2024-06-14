import 'dart:convert';
import 'dart:io';

final defaultEncoding = Platform.isWindows ? Utf8Codec() : systemEncoding;
