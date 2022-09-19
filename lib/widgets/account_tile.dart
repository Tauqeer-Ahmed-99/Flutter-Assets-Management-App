import 'package:asset_managment_app/models/account.dart';
import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:asset_managment_app/screens/account_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountTile extends StatefulWidget {
  final Account account;
  final Accounts accounts;
  final int userIndex;
  final bool isDeleteSelectionActive;
  final void Function(String) setDeleteSelectionActive;
  final void Function(String) toggleDeleteSelection;
  final List<String> deleteSelection;

  const AccountTile(
      {Key? key,
      required this.account,
      required this.accounts,
      required this.userIndex,
      required this.isDeleteSelectionActive,
      required this.setDeleteSelectionActive,
      required this.toggleDeleteSelection,
      required this.deleteSelection})
      : super(key: key);

  double getBalance() {
    double balance = 0.0;

    for (var txn in account.transactions) {
      if (txn.payment == "sent") {
        balance -= txn.amount;
      } else {
        balance += txn.amount;
      }
    }

    return balance;
  }

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  @override
  Widget build(BuildContext context) {
    void handleTileTap() {
      Navigator.of(context).pushNamed(AccountDetails.route, arguments: {
        "accounts": widget.accounts,
        "account": widget.account,
        "balance": widget.getBalance(),
        "userIndex": widget.userIndex,
      });
    }

    return ListTile(
      selected: widget.deleteSelection.contains(widget.account.id),
      selectedTileColor: Colors.grey[300],
      leading: const Icon(
        Icons.account_circle_sharp,
        color: Colors.grey,
        size: 40,
      ),
      title: Text(widget.account.accountName,
          style: GoogleFonts.poppins(fontSize: 20)),
      subtitle: Row(
        children: [
          Text(
            "Account started from : ",
            style: GoogleFonts.poppins(),
          ),
          Text(
            widget.account.accountStartingDate,
            style: GoogleFonts.poppins(),
          )
        ],
      ),
      trailing: SizedBox(
        width: 80,
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Avl.Bal:"),
                Text("₹ ${widget.getBalance().toString()}")
              ]),
        ),
      ),
      onTap: () {
        if (widget.isDeleteSelectionActive) {
          widget.toggleDeleteSelection(widget.account.id);
        } else {
          handleTileTap();
        }
      },
      onLongPress: () => widget.setDeleteSelectionActive(widget.account.id),
    );
  }
}
