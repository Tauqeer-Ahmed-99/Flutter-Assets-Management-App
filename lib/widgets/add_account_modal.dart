import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAccountModal extends StatefulWidget {
  final Accounts accounts;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AddAccountModal(
      {Key? key, required this.accounts, required this.scaffoldKey})
      : super(key: key);

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  var accountNameController = TextEditingController();
  var accountDescriptionController = TextEditingController();
  var accountStartDateController = TextEditingController();

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
        accountStartDateController.value =
            TextEditingValue(text: formatter.format(pickedDate));
      });
    });
  }

  showLoaderDialog(BuildContext context) {
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
                  "Creating acount, Please wait...",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleCreateAccountTap() async {
    showLoaderDialog(context);
    var newAccount = {
      "accountName": accountNameController.text,
      "accountDescripton": accountDescriptionController.text,
      "accountStartingDate": accountStartDateController.text,
    };
    await widget.accounts.addAccount(
        widget.scaffoldKey.currentContext as BuildContext, newAccount);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
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
                "Create a new account:",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: accountNameController,
                decoration: InputDecoration(
                  label: Text(
                    "Account Name",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: accountDescriptionController,
                decoration: InputDecoration(
                  label: Text(
                    "Account Description",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: accountStartDateController,
                decoration: InputDecoration(
                  label: Text(
                    "Account Starting Date",
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
                      onPressed: handleCreateAccountTap,
                      child: Text(
                        "Create Account",
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        ),
      ],
    );
  }
}
