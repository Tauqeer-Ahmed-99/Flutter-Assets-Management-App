class Transaction {
  String id;
  double amount;
  String payment;
  String date;
  String reason;

  Transaction(
      {required this.id,
      required this.amount,
      required this.payment,
      required this.date,
      required this.reason});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "payment": payment,
      "date": date,
      "reason": reason
    };
  }
}
