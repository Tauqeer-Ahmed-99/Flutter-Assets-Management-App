import 'package:asset_managment_app/models/account.dart';
import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddTransactionModal extends StatefulWidget {
  final String payment;
  final Account account;
  final BuildContext context;

  const AddTransactionModal(
      {Key? key,
      required this.payment,
      required this.account,
      required this.context})
      : super(key: key);

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  var amountController = TextEditingController();
  var reasonController = TextEditingController();
  var dateController = TextEditingController();
  var selectedDate = "";

  void datePicker() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        dateController.value =
            TextEditingValue(text: formatter.format(pickedDate));
        selectedDate = pickedDate.toIso8601String();
      });
    });
  }

  showLoaderDialog(BuildContext context, String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Consumer<Accounts>(
      builder: ((context, accounts, child) {
        void handleMakeTxn() async {
          if (double.tryParse(amountController.text) == null) {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Please enter a valid amount.",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
            ));
          } else {
            Navigator.of(context).pop();

            var txnDate = selectedDate == ""
                ? DateTime.now().toIso8601String()
                : selectedDate;

            var transaction = {
              "amount": double.parse(amountController.text),
              "payment": widget.payment,
              "date": txnDate,
              "reason": reasonController.text
            };

            showLoaderDialog(widget.context, "Creating transaction...");

            await accounts.addTransaction(
                widget.context, widget.account.id, transaction);

            Navigator.of(widget.context).pop();
          }
        }

        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Make a Transaction:",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Payment mode: ",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.normal),
                      ),
                      Text(widget.payment == "sent" ? "Sending" : " Recieving",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: widget.payment == "sent"
                                  ? Colors.orange
                                  : Colors.green))
                    ],
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        "Amount",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      label: Text(
                        "Reason",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      label: Text(
                        "Date",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: datePicker,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: widget.payment == "sent"
                                  ? MaterialStateProperty.all(Colors.orange)
                                  : MaterialStateProperty.all(Colors.green)),
                          onPressed: handleMakeTxn,
                          child: Text(
                            widget.payment == "sent" ? "Send" : "Recieve",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ],
        );
      }),
    );
  }
}
