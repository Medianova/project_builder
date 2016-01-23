part of project_builder.exceptions;

class MissingDirectoryException implements Exception {
  final String msg;
  const MissingDirectoryException(this.msg);
  String toString() => 'Missing directory exception: $msg';
}
