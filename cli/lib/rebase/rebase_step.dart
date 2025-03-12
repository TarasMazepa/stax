class RebaseStep {
  final String node;
  final String? parent;

  RebaseStep(this.node, this.parent);

  Map<String, dynamic> toJson() => {
    'node': node,
    if (parent != null) 'parent': parent,
  };

  factory RebaseStep.fromJson(Map<String, dynamic> json) {
    return RebaseStep(json['node'] as String, json['parent'] as String?);
  }
}
