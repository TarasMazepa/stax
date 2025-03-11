import 'package:stax/rebase/rebase_step.dart';

class RebaseData {
  final bool hasTheirsFlag;
  final bool hasOursFlag;
  final String rebaseOnto;
  final List<RebaseStep> steps;
  final int currentIndex;

  RebaseData(
    this.hasTheirsFlag,
    this.hasOursFlag,
    this.rebaseOnto,
    this.steps,
    this.currentIndex,
  );

  Map<String, dynamic> toJson() => {
    'hasTheirsFlag': hasTheirsFlag,
    'hasOursFlag': hasOursFlag,
    'rebaseOnto': rebaseOnto,
    'branches': steps.map((step) => step.toJson()).toList(),
    'currentIndex': currentIndex,
  };

  factory RebaseData.fromJson(Map<String, dynamic> json) {
    return RebaseData(
      json['hasTheirsFlag'] as bool,
      json['hasOursFlag'] as bool,
      json['rebaseOnto'] as String,
      (json['branches'] as List).map((e) => RebaseStep.fromJson(e)).toList(),
      json['currentIndex'] as int,
    );
  }
}
