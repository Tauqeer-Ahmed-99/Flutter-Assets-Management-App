import 'package:asset_managment_app/models/transaction.dart';

class Account {
  String id;
  String accountName;
  String accountDescripton;
  String accountStartingDate;
  List<Transaction> transactions;

  Account(
      {required this.id,
      required this.accountName,
      required this.accountDescripton,
      required this.accountStartingDate,
      required this.transactions});

  Map<String, dynamic> toMap() {
    return {
      "accountName": accountName,
      "accountDescripton": accountDescripton,
      "accountStartingDate": accountStartingDate,
      "transactions": transactions.isEmpty
          ? [].asMap()
          : transactions.map((txn) => txn.toMap()).toList().asMap(),
    };
  }
}
