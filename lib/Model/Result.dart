class Result<T> {
  String tilte;
  String message;
  T? data;

  Result({required this.tilte, required this.message, this.data});

  factory Result.completed(String message) => Result(tilte: success, message: message);

  static const success = 'SUCCESS';
  static const failure = 'FAILED';
}
