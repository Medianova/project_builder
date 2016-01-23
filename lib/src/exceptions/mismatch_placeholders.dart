part of project_builder.exceptions;

class MismatchPlaceholdersException implements Exception {
  final String msg;
  const MismatchPlaceholdersException(this.msg);
  String toString() => 'Mismatch placeholder exception: $msg';
}
