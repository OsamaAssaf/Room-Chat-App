import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword({required String email,required String password, required String fullName})async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      await sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        rethrow;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        rethrow;
      }
    } catch (e) {
      print(e);
      rethrow;
    }


  }

  Future<void> loginWithEmailAndPassword({required String email,required String password})async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      await sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.message);
        print('No user found for that email.');
        rethrow;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        rethrow;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> signInWithGoogle()async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> sendEmailVerification()async{

    User? user = FirebaseAuth.instance.currentUser;
    if(user != null && !user.emailVerified){
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut()async{
    await FirebaseAuth.instance.signOut();
  }

}