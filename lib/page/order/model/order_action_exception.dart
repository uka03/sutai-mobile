class OrderActionException implements Exception {
  const OrderActionException(this.message);

  final String message;

  @override
  String toString() => message;
}
