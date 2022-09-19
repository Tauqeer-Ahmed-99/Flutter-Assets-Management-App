import 'package:asset_managment_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function(bool) setFormLoading;

  const LoginForm({Key? key, required this.setFormLoading}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormState>();
  final _passwordFieldKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  var email = "";
  var password = "";

  var _isLoading = false;

  bool validateEmail(String email) {
    return email.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  handleEmailChange(_email) {
    email = _email;
  }

  handlePasswordChange(_password) {
    password = _password;
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

  String? validateFormPassword(String? password) {
    if (password != null && password.length < 8) {
      return "Password must be 8 characters long.";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    handleLoginTap(auth) async {
      var _isFormValid = _formKey.currentState!.validate();

      if (_isFormValid) {
        widget.setFormLoading(true);
        setState(() {
          _isLoading = true;
        });
        await auth.signIn(context, email, password);
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
          child: Column(
            children: [
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
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onChanged: handleEmailChange,
                validator: validateFormEmail,
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
                  FocusScope.of(context).unfocus();
                },
                onChanged: handlePasswordChange,
                validator: validateFormPassword,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        handleLoginTap(auth);
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Login",
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
