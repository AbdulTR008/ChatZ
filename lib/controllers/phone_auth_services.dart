import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verfyID = '';

  ///adb connect 192.168.43.89

  Future<void>? sentOTP(
      {required String phNumber,
      required Function onError,
      required Function nextMove}) {
    _auth
        .verifyPhoneNumber(
            phoneNumber: '+91$phNumber',
            timeout: const Duration(seconds: 30),
            verificationCompleted: (phoneAuthCom) {
              return;
            },
            verificationFailed: (error) async {
              return;
            },
            codeSent: (verficationID, va) async {
              verfyID = verficationID;
              nextMove();
            },
            codeAutoRetrievalTimeout: (vID) async {
              return;
            })
        .onError((error, stackTrace) => onError(''));
  }

  Future? loginWithOTP({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verfyID, smsCode: otp);

    try {
      final user = await _auth.signInWithCredential(cred);
      if (user.user != null) {
        return 'Success';
      } else {
        return "Error in OTP login";
      }
    } on FirebaseAuthException catch (e) {
      return print('AuthService FirebaseAuthException ${e.message.toString()}');
    } catch (e) {
      return print('AuthService loginWithOTP ${e.toString()}');
    }
  }

  Future logout() async {
    await _auth.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    final user = await _auth.currentUser;

    return user != null;
  }
}
