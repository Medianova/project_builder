part of project_builder.exceptions;

class ExistsException implements Exception {
  final String msg;
  const ExistsException(this.msg);
  String toString() => 'Resource exists exception: $msg';
}
