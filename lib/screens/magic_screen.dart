// import 'package:chatz/screens/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // import 'package:magic_sdk/magic_sdk.dart';

// import '../widgets/app_title.dart';
// import '../widgets/input_field.dart';

// class EmailAuth extends StatefulWidget {
//   const EmailAuth({super.key});

//   @override
//   State<EmailAuth> createState() => _EmailAthState();
// }

// class _EmailAthState extends State<EmailAuth> {
//   final _userEmail = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   Magic magic = Magic.instance;

//   final myController = TextEditingController();

//   void verifyEmailByLink() async {
//     bool isValid = _formKey.currentState!.validate();

//     if (isValid) {
//       var token =
//           await Magic.instance.auth.loginWithEmailOTP(email: _userEmail.text);

//       if (token.isNotEmpty) {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const ChatScreen()));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: const Text('Chat Z'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                   child: TextFormField(
//                     controller: myController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter your email',
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     foregroundColor:
//                         MaterialStateProperty.all<Color>(Colors.blue),
//                   ),
//                   onPressed: () async {
//                     var token = await magic.auth
//                         .loginWithSMS(phoneNumber: myController.text);
//                     debugPrint(
//                         'tokssssssssssssssssssssssssssssssssssssen, $token');

//                     if (token.isNotEmpty) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const ChatScreen()));
//                     }
//                   },
//                   child: const Text('Login'),
//                 ),
//               ],
//             ),
//           ),
//           Magic.instance.relayer
//         ],
//       ),
//     );
//   }
// }




// // Stack(
// //         children: [
// //           // const AppTitle(screenHeight: 10),
// //           Center(
// //             child: Card(
// //               color: Colors.white,
// //               child: Form(
// //                 key: _formKey,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: SizedBox(
// //                     height: 300,
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       crossAxisAlignment: CrossAxisAlignment.stretch,
// //                       children: [
// //                         InputField(
// //                           validator: (value) {
// //                             if (value == null ||
// //                                 value.trim().isEmpty ||
// //                                 !emailRegex.hasMatch(value)) {
// //                               return 'Enter Valid UserEmail';
// //                             }
// //                             return null;
// //                           },
// //                           obscureText: false,
// //                           keyBoardType: TextInputType.emailAddress,
// //                           icon: Icons.mail,
// //                           input: _userEmail,
// //                           inputLabel: AppLocalizations.of(context)!.email,
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: ElevatedButton(
// //                             style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.teal),
// //                             onPressed: verifyEmailByLink,
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: isLoading
// //                                   ? const CircularProgressIndicator(
// //                                       backgroundColor: Colors.red,
// //                                     )
// //                                   : const Text(
// //                                       'Submit',
// //                                       style: TextStyle(
// //                                           fontSize: 20, color: Colors.black),
// //                                     ),
// //                             ),
// //                           ),
// //                         ),
// //                         Magic.instance.relayer
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
