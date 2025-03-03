class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Failed to connect to the server'});
}

class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Failed to connect to the server'});
}

class ParsingException implements Exception {
  final String message;
  ParsingException({this.message = 'Failed to parse data'});
}
