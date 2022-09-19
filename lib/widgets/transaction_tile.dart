import 'package:asset_managment_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final int index;
  final int userIndex;
  final bool isDeleteSelectionActive;
  final void Function(String) setDeleteSelectionActive;
  final void Function(String) toggleDeleteSelection;
  final List<String> deleteSelection;
  const TransactionTile(
      {Key? key,
      required this.transaction,
      required this.index,
      required this.userIndex,
      required this.isDeleteSelectionActive,
      required this.setDeleteSelectionActive,
      required this.toggleDeleteSelection,
      required this.deleteSelection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: deleteSelection.contains(transaction.id),
      selectedTileColor: Colors.grey[300],
      title: Text(
        transaction.reason,
        style: GoogleFonts.poppins(),
      ),
      subtitle: Text(
          DateFormat.yMMMd().add_jm().format(DateTime.parse(transaction.date))),
      trailing: SizedBox(
        width: 150,
        height: double.infinity,
        child: Center(
          child: Text(
            "${transaction.payment == "sent" ? "-" : "+"} ₹${transaction.amount}",
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: transaction.payment == "sent"
                    ? Colors.orange
                    : Colors.green),
          ),
        ),
      ),
      onTap: () {
        if (isDeleteSelectionActive) {
          toggleDeleteSelection(transaction.id);
        }
      },
      onLongPress: () => setDeleteSelectionActive(transaction.id),
    );
  }
}
