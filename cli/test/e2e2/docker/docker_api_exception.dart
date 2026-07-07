class DockerApiException implements Exception {
  final String message;

  DockerApiException(this.message);

  @override
  String toString() => 'DockerApiException: $message';
}
