import 'package:asset_managment_app/models/account.dart';
import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:asset_managment_app/widgets/add_transaction_modal.dart';
import 'package:asset_managment_app/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class AccountDetails extends StatefulWidget {
  static const route = "/account-details";

  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  var _selectedIndex = 0;
  var payment = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isDeleteSelectionActive = false;
  List<String> deleteSelection = [];

  void setDeleteSelectionActive(String id) {
    setState(() {
      isDeleteSelectionActive = true;
      deleteSelection.add(id);
    });
  }

  void toggleDeleteSelection(String id) {
    setState(() {
      if (deleteSelection.contains(id)) {
        deleteSelection.removeWhere((element) => element == id);
        if (deleteSelection.isEmpty) {
          isDeleteSelectionActive = false;
        }
      } else {
        deleteSelection.add(id);
      }
    });
  }

  void handleNavigationBarTap(
      int index, Account account, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      payment = "recieved";
    } else {
      payment = "sent";
    }

    _showTransactionForm(context, account);
  }

  void _showTransactionForm(BuildContext _context, Account account) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return AddTransactionModal(
              payment: payment, account: account, context: _context);
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

  void handleConfirmDelete(
      BuildContext context, Accounts accounts, String accountId) async {
    Navigator.of(context).pop();

    showLoaderDialog(context, "Deleting transaction(s)...");

    await accounts.deleteTransaction(context, deleteSelection, accountId);

    setState(() {
      isDeleteSelectionActive = false;
      deleteSelection = [];
    });
    Navigator.of(context).pop();
  }

  showDeleteDialog(BuildContext _context, BuildContext context,
      Accounts accounts, String accountId) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure?",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Row(
            children: [
              Text(
                "Do you really want to delete selected\ntransactions?",
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "CANCEL",
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () =>
                  handleConfirmDelete(_context, accounts, accountId),
              child: Text(
                "DELETE TRANSACTIONS",
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleDeleteButtonTap(
      BuildContext _context, Accounts accounts, String accountId) {
    showDeleteDialog(_context, context, accounts, accountId);
  }

  final skeletonsCount = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final account = arguments["account"] as Account;
    final accounts = arguments["accounts"] as Accounts;
    final __userIndex = arguments["userIndex"] as int;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor:
              isDeleteSelectionActive ? Colors.blue[700] : Colors.blue,
          title: Text(
            account.accountName,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            if (isDeleteSelectionActive)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => handleDeleteButtonTap(
                    _scaffoldKey.currentContext as BuildContext,
                    accounts,
                    account.id),
                tooltip: "Delete selected",
              ),
          ]),
      body: Consumer<Accounts>(
        builder: ((context, accounts, child) {
          var activeAccount = accounts.getAccounts
              .firstWhere((element) => element.id == account.id);
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[800] as Color,
                            Colors.blue[300] as Color
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${activeAccount.accountName}'s Balance : ",
                              style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "₹${accounts.getBalance(__userIndex)}",
                              style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Transaction History",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (activeAccount.transactions.isEmpty)
                    Text(
                      "Transaction History not available.",
                      style: GoogleFonts.poppins(),
                    ),
                  if (activeAccount.transactions.isEmpty == false)
                    SizedBox(
                      height: mediaQuery.size.height * 0.7,
                      child: accounts.isLoading
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ...skeletonsCount
                                      .map(
                                        (_) => SkeletonLoader(
                                          builder: Container(
                                            height: 100,
                                            width: double.infinity,
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey[400]),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: activeAccount.transactions.length,
                              itemBuilder: ((context, index) => TransactionTile(
                                    index: index,
                                    userIndex: __userIndex,
                                    transaction: activeAccount
                                        .transactions.reversed
                                        .toList()[index],
                                    isDeleteSelectionActive:
                                        isDeleteSelectionActive,
                                    setDeleteSelectionActive:
                                        setDeleteSelectionActive,
                                    toggleDeleteSelection:
                                        toggleDeleteSelection,
                                    deleteSelection: deleteSelection,
                                  )),
                            ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => handleNavigationBarTap(
            index, account, _scaffoldKey.currentContext as BuildContext),
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_downward_rounded),
              label: "Receive",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward_rounded),
              label: "Send",
              backgroundColor: Colors.orange),
        ],
      ),
    );
  }
}
