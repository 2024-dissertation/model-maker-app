class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class ParsingException implements Exception {
  final String message;
  ParsingException({this.message = 'Failed to parse data'});
}
