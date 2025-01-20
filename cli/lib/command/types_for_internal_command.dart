enum InternalCommandType { public, hidden }

extension InternalCommandTypeIs on InternalCommandType {
  bool get isPublic => this == InternalCommandType.public;

  bool get isHidden => this == InternalCommandType.hidden;
}
