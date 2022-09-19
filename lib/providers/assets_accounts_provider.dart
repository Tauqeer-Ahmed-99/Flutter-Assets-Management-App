import 'package:asset_managment_app/models/account.dart';
import 'package:asset_managment_app/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class Accounts extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Account> _accounts = [];
  var isLoading = false;

  Accounts() {
    fetchAndSetAccounts();
  }

  List<Account> get getAccounts {
    return [..._accounts];
  }

  double getBalance(int userIndex) {
    var txns = _accounts[userIndex].transactions;

    var balance = 0.0;

    for (var txn in txns) {
      if (txn.payment == "sent") {
        balance -= txn.amount;
      } else {
        balance += txn.amount;
      }
    }

    return balance;
  }

  Future<void> fetchAndSetAccounts() async {
    isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();
    final url = Uri.parse(
        "https://assets-management-1afc6-default-rtdb.firebaseio.com/accounts/${user.uid}.json?auth=$authToken");
    final response = await http.get(url);
    final parsedResponse = await json.decode(response.body);

    if (response.statusCode == 200) {
      if (parsedResponse != null) {
        var accounts = parsedResponse.entries
            .map((account) => {...account.value, "id": account.key})
            .toList();
        List<Account> newAccounts = [];

        for (var account in accounts) {
          var txns = account["transactions"] != null
              ? account["transactions"]
                  .entries
                  .map((txn) => {...txn.value, "id": txn.key})
              : [];
          List<Transaction> newTxns = [];

          for (var txn in txns) {
            newTxns.add(Transaction(
                id: txn["id"],
                amount: txn["amount"],
                payment: txn["payment"],
                date: txn["date"],
                reason: txn["reason"]));
          }

          newAccounts.add(
            Account(
              id: account["id"],
              accountName: account["accountName"],
              accountDescripton: account["accountDescripton"],
              accountStartingDate: account["accountStartingDate"],
              transactions: newTxns,
            ),
          );
        }
        _accounts = newAccounts;
      } else {
        _accounts = [];
      }
    } else {
      print(response.statusCode);
      print(response.body);
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> addAccount(BuildContext context, account) async {
    final user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();
    final url = Uri.parse(
        "https://assets-management-1afc6-default-rtdb.firebaseio.com/accounts/${user.uid}.json?auth=$authToken");

    final body = account;
    final response = await http.post(
      url,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Account added Successfully.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Account add failed.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    isLoading = true;
    notifyListeners();

    await fetchAndSetAccounts();

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount(
      BuildContext context, List<String> deleteSelection) async {
    final user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();

    List<bool> deletingErrors = [];

    for (var id in deleteSelection) {
      final url = Uri.parse(
          "https://assets-management-1afc6-default-rtdb.firebaseio.com/accounts/${user.uid}/$id.json?auth=$authToken");

      final response = await http.delete(url);

      deletingErrors.add(response.statusCode == 200);
    }

    if (deletingErrors.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Account(s) delete failed.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Account(s) deleted Successfully.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    isLoading = true;
    notifyListeners();

    await fetchAndSetAccounts();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(BuildContext context, String id, txn) async {
    final user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();
    final url = Uri.parse(
        "https://assets-management-1afc6-default-rtdb.firebaseio.com/accounts/${user.uid}/$id/transactions.json?auth=$authToken");

    final response = await http.post(url, body: json.encode(txn));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Transaction successful.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Transaction failed.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    isLoading = true;
    notifyListeners();

    await fetchAndSetAccounts();

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(BuildContext context,
      List<String> deleteSelection, String accountId) async {
    final user = FirebaseAuth.instance.currentUser;
    final authToken = await user!.getIdToken();

    List<bool> responseErrors = [];

    for (var txnId in deleteSelection) {
      final url = Uri.parse(
          "https://assets-management-1afc6-default-rtdb.firebaseio.com/accounts/${user.uid}/$accountId/transactions/$txnId.json?auth=$authToken");

      final response = await http.delete(url);

      responseErrors.add(response.statusCode == 200);
    }

    if (responseErrors.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Transaction(s) delete failed.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Transaction(s) deleted successfully.",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    isLoading = true;
    notifyListeners();

    await fetchAndSetAccounts();

    isLoading = false;
    notifyListeners();
  }

  double getTotalAssets() {
    var balance = 0.0;

    for (var account in _accounts) {
      for (var txn in account.transactions) {
        if (txn.payment == "sent") {
          balance -= txn.amount;
        } else {
          balance += txn.amount;
        }
      }
    }

    return balance;
  }
}
