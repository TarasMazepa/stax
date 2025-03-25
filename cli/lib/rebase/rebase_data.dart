import 'package:stax/rebase/rebase_step.dart';

class RebaseData {
  final bool hasTheirsFlag;
  final bool hasOursFlag;
  final String rebaseOnto;
  final List<RebaseStep> steps;
  int index;

  RebaseStep get currentStep => steps[index];

  RebaseData(
    this.hasTheirsFlag,
    this.hasOursFlag,
    this.rebaseOnto,
    this.steps,
    this.index,
  );

  Map<String, dynamic> toJson() => {
    'hasTheirsFlag': hasTheirsFlag,
    'hasOursFlag': hasOursFlag,
    'rebaseOnto': rebaseOnto,
    'steps': steps.map((step) => step.toJson()).toList(),
    'index': index,
  };

  factory RebaseData.fromJson(Map<String, dynamic> json) {
    return RebaseData(
      json['hasTheirsFlag'] as bool,
      json['hasOursFlag'] as bool,
      json['rebaseOnto'] as String,
      (json['steps'] as List).map((e) => RebaseStep.fromJson(e)).toList(),
      json['index'] as int,
    );
  }
}
