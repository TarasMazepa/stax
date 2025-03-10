import 'package:stax/rebase/rebase_step.dart';

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
