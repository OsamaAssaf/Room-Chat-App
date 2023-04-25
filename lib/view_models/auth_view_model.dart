import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AuthViewModel with ChangeNotifier {
  AuthMode _authMode = AuthMode.login;
  AuthMode get authMode => _authMode;
  void changeAuthMode() {
    if (_authMode == AuthMode.login) {
      _authMode = AuthMode.register;
    } else {
      _authMode = AuthMode.login;
    }
    notifyListeners();
  }

  User? user;
  String? userId;
  void changeUserState(User? newUser) {
    user = newUser;
    notifyListeners();
  }

  bool? isEmailVerified;
  void setIsEmailVerified(bool newValue){
    isEmailVerified = newValue;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }


  Future<void> submit({required String? fullName,required String email,required String password ,required bool isLogin}) async {
    try{
      if(isLogin){
        await AuthService().loginWithEmailAndPassword(email: email, password: password);
      }else{
        await AuthService().registerWithEmailAndPassword(email: email, password: password,fullName: fullName!);
        addUserToDatabase(fullName: fullName,email: email);
        user!.updateDisplayName(fullName);
      }


    }on FirebaseAuthException catch (_){
      rethrow;
    }
    catch(e){
      rethrow;
    }

  }

  Future<void> sendEmailVerification()async{
    await AuthService().sendEmailVerification();
  }

  Future<void> googleSignIn() async {
    await AuthService().signInWithGoogle();
    addUserToDatabase(fullName: user!.displayName!,email: user!.email!,photoURL: user!.photoURL);
  }

  Future<void> addUserToDatabase({required String? fullName,required String email , String? gender,String? photoURL})async{
    await FirebaseDatabase.instance.ref('users/${user!.uid}').set({
      'full_name':fullName,
      'email':email,
      'gender':gender,
      'photoURL':photoURL,
      'userId':user!.uid,
    });
  }

  Future<void> signOut()async{
    await AuthService().signOut();
    changeUserState(FirebaseAuth.instance.currentUser);
  }



}

enum AuthMode { login, register }
