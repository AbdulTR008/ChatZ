import 'package:chatz/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_title.dart';
import '../widgets/input_field.dart';
import '../controllers/phone_auth_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();
  final _userPhoneNumber = TextEditingController();
  final _userOTP = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool isUserHasAccount = true;
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  final _authService = AuthService();
  final Telephony telephony = Telephony.instance;
  String readOTPSms = '';

/////****************** Variable **********************************************************/

  void readOTPMessage() {
    telephony.listenIncomingSms(
      listenInBackground: false,
      onNewMessage: (SmsMessage messages) {
        setState(() {
          if (messages.body!.contains('chatz-15cc0')) {
            readOTPSms = messages.body!.substring(0, 6);

            setState(() {
              _userOTP.text = readOTPSms;

              Future.delayed(const Duration(seconds: 2), () {
                otpSubmit();
              });
            });
          }
        });
      },
    );
  }

  void authPhoneSubmit() async {
    // setState(() {
    //   isLoading = true;
    // });

    _authService.sentOTP(
      phNumber: _userPhoneNumber.text,
      onError: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text('Error In Sending OTP'),
        ),
      ),
      nextMove: () {
        readOTPMessage();
        setState(() {
          isLoading = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Expanded(
            child: AlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: otpSubmit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  child: const Text('Submit'),
                )
              ],
              title: const Text('Enter OTP'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinCodeTextField(
                        onCompleted: (value) {
                          otpSubmit();
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 30,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.blue,
                        ),
                        appContext: context,
                        length: 6,
                        onChanged: (enteredInput) {},
                        controller: _userOTP,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _userPhoneNumber.clear();
  }

  Future<void> otpSubmit() async {
    final authRes = await _authService.loginWithOTP(otp: _userOTP.text);

    if (authRes == 'Success') {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text('Invalid OTP'),
          ),
        );
      }
    }
  }

  void authEmailSubmit() async {
    try {
      bool isValid = _formKey.currentState!.validate();
      // setState(() {
      //   isLoading = true;
      // });

      if (!isValid) {
        return;
      }
      return await _auth
          .sendSignInLinkToEmail(
            actionCodeSettings: ActionCodeSettings(
                androidInstallApp: true,
                androidMinimumVersion: '12',
                androidPackageName: 'com.example.chatz',
                url: 'https://chatzredirect.page.link/}',
                handleCodeInApp: true),
            email: _userEmail.text,
          )
          .catchError(
            (onError) => print('Error sending email verification $onError'),
          )
          .then((value) => print('sendSignInLinkToEmail @value'));
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userEmail.dispose();
    _userPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          AppTitle(screenHeight: screenHeight),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xff9AD0C2),
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InputField(
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !emailRegex.hasMatch(value)) {
                                    return 'Enter Valid UserEmail';
                                  }
                                  return null;
                                },
                                obscureText: false,
                                keyBoardType: TextInputType.emailAddress,
                                icon: Icons.mail,
                                input: _userEmail,
                                inputLabel: AppLocalizations.of(context)!.email,
                              ),
                              InputField(
                                  prefixText: '+91 ',
                                  keyBoardType: TextInputType.phone,
                                  input: _userPhoneNumber,
                                  inputLabel:
                                      AppLocalizations.of(context)!.phoneNumber,
                                  icon: Icons.phone,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value!.length > 10) {
                                      return 'Enter Valid Number';
                                    }
                                    return null;
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                  onPressed: () {
                                    authPhoneSubmit();
                                    authEmailSubmit();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            backgroundColor: Colors.red,
                                          )
                                        : Text(
                                            isUserHasAccount
                                                ? AppLocalizations.of(context)!
                                                    .login
                                                : AppLocalizations.of(context)!
                                                    .signUp,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isUserHasAccount = !isUserHasAccount;
                                  });
                                },
                                child: Text(
                                  isUserHasAccount
                                      ? AppLocalizations.of(context)!
                                          .createAccount
                                      : AppLocalizations.of(context)!
                                          .iAlreadyHaveAnAccount,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// if (!isUserHasAccount) {
//   await _auth.createUserWithEmailAndPassword(
//       email: _userEmail.text, password: _userPassword.text);
//   if (mounted) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => const ChatScreen()));
//   }
// } else {
//   await _auth.signInWithEmailAndPassword(
//       email: _userEmail.text, password: _userPassword.text);
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => const ChatScreen()));
// }

///////////********Email */
//  InputField(
//                             validator: (value) {
//                               if (value == null ||
//                                   value.trim().isEmpty ||
//                                   !_emailRegex.hasMatch(value)) {
//                                 return 'Enter Valid UserEmail';
//                               }
//                               return null;
//                             },
//                             obscureText: false,
//                             keyBoardType: TextInputType.emailAddress,
//                             icon: Icons.mail,
//                             input: _userEmail,
//                             inputLabel: "Email",
//                           ),

/////password//////
// InputField(
//                           validator: (value) {
//                             if (value == null ||
//                                 value.trim().isEmpty ||
//                                 value.length <= 6) {
//                               return 'Enter Valid Password';
//                             }
//                             return null;
//                           },
//                           icon: Icons.lock,
//                           obscureText: true,
//                           input: _userPassword,
//                           inputLabel: "Password",
//                         ),



  ///password//////
                                // InputField(
                                //   validator: (value) {
                                //     if (value == null ||
                                //         value.trim().isEmpty ||
                                //         value.length <= 6) {
                                //       return 'Enter Valid Password';
                                //     }
                                //     return null;
                                //   },
                                //   icon: Icons.lock,
                                //   obscureText: true,
                                //   input: _userPassword,
                                //   inputLabel:
                                //       AppLocalizations.of(context)!.password,
                                // ),



//                                     if (!isUserHasAccount) {
//   await _auth.createUserWithEmailAndPassword(
//       email: _userEmail.text, password: _userPassword.text);
//   if (mounted) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => const ChatScreen()));
//   }
// } else {
//   await _auth.signInWithEmailAndPassword(
//       email: _userEmail.text, password: _userPassword.text);
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => const ChatScreen()));
// }