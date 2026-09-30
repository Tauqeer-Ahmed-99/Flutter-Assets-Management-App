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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.deleteSelection.contains(widget.account.id)
            ? Colors.red.withValues(alpha: 0.4)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        selected: widget.deleteSelection.contains(widget.account.id),
        selectedTileColor: Colors.transparent,
        leading: const Icon(
          Icons.account_circle_sharp,
          color: Colors.white70,
          size: 40,
        ),
        title: Text(widget.account.accountName,
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
        subtitle: Row(
          children: [
            Flexible(
              child: Text(
                "Started: ",
                style: GoogleFonts.poppins(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                widget.account.accountStartingDate,
                style: GoogleFonts.poppins(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
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
                  Text("Avl.Bal:", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text("₹ ${widget.getBalance().toString()}", style: GoogleFonts.poppins(color: Colors.green[200], fontWeight: FontWeight.bold))
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
      ),
    );
  }
}
