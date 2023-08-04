class BaseException implements Exception {
  BaseException({this.message = 'Unknown Error'});
  final String message;
}