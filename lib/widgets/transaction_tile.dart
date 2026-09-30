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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: deleteSelection.contains(transaction.id)
            ? Colors.red.withValues(alpha: 0.4)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        selected: deleteSelection.contains(transaction.id),
        selectedTileColor: Colors.transparent,
        title: Text(
          transaction.reason,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        subtitle: Text(
            DateFormat.yMMMd().add_jm().format(DateTime.parse(transaction.date)),
            style: GoogleFonts.poppins(color: Colors.white70),
        ),
        trailing: SizedBox(
          width: 150,
          height: double.infinity,
          child: Center(
            child: Text(
              "${transaction.payment == "sent" ? "-" : "+"} ₹${transaction.amount}",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: transaction.payment == "sent"
                      ? Colors.orange[300]
                      : Colors.green[300]),
            ),
          ),
        ),
        onTap: () {
          if (isDeleteSelectionActive) {
            toggleDeleteSelection(transaction.id);
          }
        },
        onLongPress: () => setDeleteSelectionActive(transaction.id),
      ),
    );
  }
}
