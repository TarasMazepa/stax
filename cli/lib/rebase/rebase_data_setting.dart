import 'dart:convert';
import 'package:stax/settings/base_settings.dart';
import 'package:stax/settings/setting.dart';

class RebaseStep {
  final String node;
  final String parent;

  RebaseStep({required this.node, this.parent = ''});

  Map<String, dynamic> toJson() => {'node': node, 'parent': parent};

  factory RebaseStep.fromJson(Map<String, dynamic> json) {
    return RebaseStep(
      node: json['node'] as String,
      parent: (json['parent'] as String?) ?? '',
    );
  }
}

class RebaseData {
  final bool hasTheirsFlag;
  final bool hasOursFlag;
  final String rebaseOnto;
  final List<RebaseStep> steps;
  final int currentIndex;

  RebaseData({
    required this.hasTheirsFlag,
    required this.hasOursFlag,
    required this.rebaseOnto,
    required this.steps,
    this.currentIndex = 0,
  });

  Map<String, dynamic> toJson() => {
    'hasTheirsFlag': hasTheirsFlag,
    'hasOursFlag': hasOursFlag,
    'rebaseOnto': rebaseOnto,
    'branches': steps.map((step) => step.toJson()).toList(),
    'currentIndex': currentIndex,
  };

  factory RebaseData.fromJson(Map<String, dynamic> json) {
    return RebaseData(
      hasTheirsFlag: json['hasTheirsFlag'] as bool,
      hasOursFlag: json['hasOursFlag'] as bool,
      rebaseOnto: json['rebaseOnto'] as String,
      steps:
          (json['branches'] as List)
              .map(
                (e) => RebaseStep.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList(),
      currentIndex: json['currentIndex'] as int? ?? 0,
    );
  }
}

class RebaseDataSetting extends Setting<RebaseData?> {
  RebaseDataSetting(
    String name,
    RebaseData? defaultValue,
    BaseSettings settings,
    String description,
  ) : super(
        name,
        defaultValue,
        settings,
        (s) => s.isEmpty ? null : RebaseData.fromJson(jsonDecode(s)),
        (data) => data == null ? '' : jsonEncode(data.toJson()),
        description,
      );
}
