class Result<T> {
  String tilte;
  String message;
  T? data;

  Result({required this.tilte, required this.message, this.data});

  static const success = 'SUCCESS';
  static const failure = 'FAILED';
}
