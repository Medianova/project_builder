part of project_builder.exceptions;

class NotLoadedException implements Exception {
  final String msg;
  const NotLoadedException(this.msg);
  String toString() => 'Template not loaded exception: $msg';
}
