import 'package:chatz/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:telephony/telephony.dart';


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
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF075E54),
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'We sent a code to your phone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PinCodeTextField(
                      onCompleted: (value) {
                        otpSubmit();
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: const Color(0xFFE8F5E9),
                        inactiveFillColor: Colors.grey[100]!,
                        activeColor: const Color(0xFF25D366),
                        selectedColor: const Color(0xFF25D366),
                        inactiveColor: Colors.grey[300]!,
                      ),
                      enableActiveFill: true,
                      appContext: context,
                      length: 6,
                      onChanged: (enteredInput) {},
                      controller: _userOTP,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: otpSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'VERIFY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
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
            builder: (context) => const ChatListScreen(),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // WhatsApp-style title
              const Text(
                'ChatZ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF075E54),
                ),
              ),
              const SizedBox(height: 40),
              // Description
              Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'ChatZ will send an SMS message to verify your phone number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Phone number input
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF25D366), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _userPhoneNumber,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter phone number';
                            }
                            if (value.length != 10) {
                              return 'Enter valid 10-digit number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      authPhoneSubmit();
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'NEXT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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