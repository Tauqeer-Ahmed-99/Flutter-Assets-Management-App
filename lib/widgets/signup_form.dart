import 'package:asset_managment_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  final Function(bool) setFormLoading;

  const SignUpForm({Key? key, required this.setFormLoading}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameFieldKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormState>();
  final _cnfEmailFieldKey = GlobalKey<FormState>();
  final _passwordFieldKey = GlobalKey<FormState>();
  final _cnfPasswordFieldKey = GlobalKey<FormState>();

  final _userNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _cnfEmailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _cnfPasswordFocusNode = FocusNode();

  var userName = "";
  var email = "";
  var cnfEmail = "";
  var password = "";
  var cnfPassword = "";

  var _isLoading = false;

  bool validateEmail(String email) {
    return email.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  handleUserNameChange(_userName) {
    userName = _userName;
  }

  handleEmailChange(_email) {
    email = _email;
  }

  handleCnfEmailChange(_email) {
    cnfEmail = _email;
  }

  handlePasswordChange(_password) {
    password = _password;
  }

  handleCnfPasswordChange(_password) {
    cnfPassword = _password;
  }

  String? validateUserName(String? userName) {
    if (userName == null || userName == "" || userName.length < 4) {
      return "Username must be 4 charcters long.";
    } else {
      return null;
    }
  }

  String? validateFormEmail(String? email) {
    if (email != null) {
      if (validateEmail(email)) {
        return null;
      } else {
        return "Please enter a valid email.";
      }
    } else {
      return null;
    }
  }

  String? validateCnfFormEmail(String? email) {
    if (email != cnfEmail || cnfEmail == "") {
      if (validateEmail(email as String)) {
        return null;
      } else {
        return "Emails does not match.";
      }
    } else {
      return null;
    }
  }

  String? validateFormPassword(String? password) {
    if (password != null && password.length < 8) {
      return "Password must be 8 characters long.";
    } else {
      return null;
    }
  }

  String? validateCnfFormPassword(String? password) {
    if (password != cnfPassword || cnfPassword == "") {
      return "Passwords does not match.";
    } else {
      return null;
    }
  }

  late BuildContext prevContext;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    handleSignupTap(auth) async {
      var _isFormValid = _formKey.currentState!.validate();

      if (_isFormValid) {
        widget.setFormLoading(true);
        setState(() {
          _isLoading = true;
        });
        await auth.signUp(context, email, password, userName);
        setState(() {
          _isLoading = false;
        });
        widget.setFormLoading(false);
      }
    }

    return Consumer<Auth>(
      builder: (context, auth, child) => SizedBox(
        width: mediaQuery.size.width * 0.8,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  key: _userNameFieldKey,
                  focusNode: _userNameFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  onChanged: handleUserNameChange,
                  validator: validateUserName,
                ),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  key: _emailFieldKey,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_cnfEmailFocusNode);
                  },
                  onChanged: handleEmailChange,
                  validator: validateFormEmail,
                ),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: "Confirm Email",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  key: _cnfEmailFieldKey,
                  focusNode: _cnfEmailFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  onChanged: handleCnfEmailChange,
                  validator: validateCnfFormEmail,
                ),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  key: _passwordFieldKey,
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_cnfPasswordFocusNode);
                  },
                  onChanged: handlePasswordChange,
                  validator: validateFormPassword,
                ),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  key: _cnfPasswordFieldKey,
                  focusNode: _cnfPasswordFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: handleCnfPasswordChange,
                  validator: validateCnfFormPassword,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          handleSignupTap(auth);
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 50),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            "Signup",
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
