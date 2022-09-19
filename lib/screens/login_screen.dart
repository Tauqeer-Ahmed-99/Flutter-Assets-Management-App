import 'package:asset_managment_app/widgets/login_form.dart';
import 'package:asset_managment_app/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/loginscreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isSigningUp = false;
  var isFormLoading = false;

  void setFormLoading(bool isLoading) {
    setState(() {
      isFormLoading = isLoading;
    });
  }

  void toggleForm() {
    setState(() {
      isSigningUp = !isSigningUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Assets Management",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 120,
                          width: 120,
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.asset("assets/assets-logo.jpg")),
                      Text(
                        "Assets",
                        style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Card(
                  elevation: 5.0,
                  child: Column(
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.8,
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Text(
                          isSigningUp ? "Sign up" : "Login",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!isSigningUp)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: LoginForm(setFormLoading: setFormLoading),
                        ),
                      if (isSigningUp)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SignUpForm(setFormLoading: setFormLoading),
                        ),
                      // if (!isFormLoading)
                      TextButton(
                        child: Text(
                          isSigningUp
                              ? "Already have an account? Login instead."
                              : "Dont have an account? Signup instead.",
                        ),
                        onPressed: isFormLoading ? null : toggleForm,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "version 1.0",
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 10),
                ),
                Text(
                  "Copyright Zero Friction(TM)",
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 10),
                )
              ],
            )),
      ),
    );
  }
}
