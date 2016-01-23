part of project_builder.exceptions;

class MissingBuilderException implements Exception {
  final String msg;
  const MissingBuilderException(this.msg);
  String toString() => 'Missing builder.json exception: $msg';
}
