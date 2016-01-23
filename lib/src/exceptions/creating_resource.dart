part of project_builder.exceptions;

class CreateResourceException implements Exception {
  final String msg;
  const CreateResourceException(this.msg);
  String toString() => 'Can\'t create resource exception: $msg';
}
