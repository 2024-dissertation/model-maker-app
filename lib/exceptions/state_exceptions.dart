class StateException implements Exception {
  final String message;
  StateException({this.message = 'Something went wrong'});
}
