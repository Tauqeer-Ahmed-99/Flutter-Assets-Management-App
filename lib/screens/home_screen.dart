import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:asset_managment_app/providers/auth_provider.dart';
import 'package:asset_managment_app/widgets/account_tile.dart';
import 'package:asset_managment_app/widgets/add_account_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/homescreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> menuItems = [
    {
      "name": 'Profile',
      "icon": Icons.account_circle_sharp,
      "action": (auth, context) {}
    },
    {
      "name": 'Logout',
      "icon": Icons.logout,
      "action": (auth, context) async {
        await FirebaseAuth.instance.signOut();
      }
    }
  ];

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

  void handleConfirmDelete(BuildContext context, Accounts accounts) async {
    Navigator.of(context).pop();

    showLoaderDialog(context, "Deleting account(s)...");
    await accounts.deleteAccount(context, deleteSelection);

    setState(() {
      isDeleteSelectionActive = false;
      deleteSelection = [];
    });

    Navigator.of(context).pop();
  }

  showDeleteDialog(BuildContext _context, Accounts accounts) {
    return showDialog(
      barrierDismissible: true,
      context: _context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text(
            "Are you sure?",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Row(
            children: [
              Text(
                "Do you really want to delete selected\naccounts?",
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(_context).pop();
              },
              child: Text(
                "CANCEL",
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () => handleConfirmDelete(context, accounts),
              child: Text(
                "DELETE ACCOUNTS",
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleDeleteButtonTap(Accounts accounts) {
    showDeleteDialog(context, accounts);
  }

  void _showAddAccountForm(Accounts accounts) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return AddAccountModal(
            scaffoldKey: _scaffoldKey,
            accounts: accounts,
          );
        });
  }

  final skeletonsCount = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: ((context, auth, child) =>
          Consumer<Accounts>(builder: (context, accounts, child) {
            var mediaQuery = MediaQuery.of(context);
            var auth = FirebaseAuth.instance;
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor:
                    isDeleteSelectionActive ? Colors.blue[700] : Colors.blue,
                title: Text(
                  "Assets",
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  if (isDeleteSelectionActive)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => handleDeleteButtonTap(accounts),
                      tooltip: "Delete selected",
                    ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    itemBuilder: (BuildContext context) {
                      return menuItems
                          .map(
                            (item) => PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    item["icon"],
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    item["name"],
                                    style: GoogleFonts.poppins(),
                                  )
                                ],
                              ),
                              onTap: () => item["action"](auth, context),
                            ),
                          )
                          .toList();
                    },
                  )
                ],
              ),
              body: accounts.isLoading
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
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[400]),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    )
                  : accounts.getAccounts.isEmpty
                      ? Center(
                          child: Text(
                          "No accounts available,\nAdd a new account by tapping button below.",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey),
                        ))
                      : SizedBox(
                          height: mediaQuery.size.height,
                          width: mediaQuery.size.width,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20.0),
                                margin: const EdgeInsets.all(10.0),
                                // height: 100,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Hi ${auth.currentUser?.displayName}! ",
                                          style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Current assets value: ",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "₹${accounts.getTotalAssets().toString()}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[900]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: accounts.getAccounts.length,
                                  itemBuilder: (context, index) => AccountTile(
                                    isDeleteSelectionActive:
                                        isDeleteSelectionActive,
                                    account: accounts.getAccounts[index],
                                    accounts: accounts,
                                    userIndex: index,
                                    setDeleteSelectionActive:
                                        setDeleteSelectionActive,
                                    toggleDeleteSelection:
                                        toggleDeleteSelection,
                                    deleteSelection: deleteSelection,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              floatingActionButton: SizedBox(
                height: 50,
                width: 150,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text("New Account")
                      ],
                    ),
                  ),
                  onPressed: () => _showAddAccountForm(accounts),
                ),
              ),
            );
          })),
    );
  }
}
