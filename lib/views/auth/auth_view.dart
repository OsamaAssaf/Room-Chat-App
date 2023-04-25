import 'package:chat_app/view_models/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

import '../../res/styles/colors.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map authVariables = {
    'fullName': '',
    'email': '',
    'password': '',
  };


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    AuthViewModel _authViewModelProviderVar =
    Provider.of<AuthViewModel>(context);
    AuthViewModel _authViewModelProviderFun =
    Provider.of<AuthViewModel>(context, listen: false);
    AuthMode _authMode = _authViewModelProviderVar.authMode;
    Future<void> _submit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        _authViewModelProviderFun.setIsLoading(true);
        try {
          await _authViewModelProviderFun.submit(fullName: authVariables['fullName'],email: authVariables['email'],
              password: authVariables['password'],
              isLogin: _authMode == AuthMode.login ? true : false);
        }on FirebaseAuthException catch (e){
          showErrorDialog(e.message!);
        }
        catch(e){
          rethrow;
          showErrorDialog(e.toString());
        }
        _authViewModelProviderFun.setIsLoading(false);
      }
    }

    bool _isLoading = _authViewModelProviderVar.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            child: Container(
              width: width,
              height: height * 0.30,
              decoration: BoxDecoration(
                color: CustomColors.lightBlue,
              ),
            ),
            clipper: WaveClipperTwo(),
          ),
          ClipPath(
            child: Container(
              width: width,
              height: height * 0.25,
              decoration: BoxDecoration(
                color: CustomColors.darkBlue,
              ),
            ),
            clipper: WaveClipperTwo(),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ClipPath(
              child: Container(
                width: width,
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: CustomColors.darkBlue,
                ),
              ),
              clipper: WaveClipperTwo(reverse: true, flip: true),
            ),
          ),
          changeAuthModeText(_authMode, context),
          submitButton(_authMode, _submit,_isLoading),
          signInView(height, width, _authMode, _authViewModelProviderFun),
        ],
      ),
    );
  }

  Positioned changeAuthModeText(AuthMode _authMode, BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: RichText(
        text: TextSpan(
          text: _authMode == AuthMode.login ? 'New Here? ' : 'Already Member? ',
          children: <TextSpan>[
            TextSpan(
              text: _authMode == AuthMode.login ? 'Register' : 'Login',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Provider.of<AuthViewModel>(context, listen: false)
                      .changeAuthMode();
                  authVariables.clear();
                },
            ),
          ],
        ),
      ),
    );
  }

  Positioned signInView(double height, double width, AuthMode _authMode,
      AuthViewModel provider) {
    return Positioned(
      left: 16.0,
      top: height * 0.30,
      child: SizedBox(
        width: width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _authMode == AuthMode.login ? 'Login' : 'Register',
                style: TextStyle(
                  color: CustomColors.darkBlue,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              if (_authMode == AuthMode.register)
                textFormFieldWidget(
                  title: 'Full Name',
                ),
              if (_authMode == AuthMode.register)
                const SizedBox(
                  height: 24.0,
                ),
              textFormFieldWidget(
                title: 'Email',
              ),
              const SizedBox(
                height: 24.0,
              ),
              textFormFieldWidget(
                title: 'Password',
              ),
              if (_authMode == AuthMode.login)
                const SizedBox(
                  height: 8.0,
                ),
              if (_authMode == AuthMode.login)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async{

                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.darkBlue),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 16.0,
              ),
              GestureDetector(
                child: signInButton('assets/images/google_logo.png'),
                onTap: provider.googleSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned submitButton(AuthMode _authMode, Function() _submit,bool _isLoading) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: InkWell(
        child: Container(
          width: 120.0,
          height: 60.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child:!_isLoading? Text(
              _authMode == AuthMode.login ? 'Login' : 'Register',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ):const CircularProgressIndicator(),
          ),
        ),
        onTap: _submit,
      ),
    );
  }

  SizedBox signInButton(String imagePath) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }

  Column textFormFieldWidget({required String title}) {
    String? emptyFieldErrorText;

    switch (title) {
      case 'Full Name':
        emptyFieldErrorText = 'name';
        break;
      case 'Email':
        emptyFieldErrorText = 'email';
        break;
      case 'Password':
        emptyFieldErrorText = 'Password';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: CustomColors.darkBlue),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextFormField(
          key: Key(title),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.darkBlue,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.darkBlue),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.errorColor!,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.errorColor!,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $emptyFieldErrorText';
            }
            if (title == 'Email') {
              if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            if (title == 'Password') {
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
            }
            return null;
          },
          onSaved: (String? value) {
            if (title == 'Full Name') {
              authVariables['fullName'] = value!.trim();
            }
            else if (title == 'Email') {
              authVariables['email'] = value!.trim();
            }
            else if (title == 'Password') {
              authVariables['password'] = value!.trim();
            }
          },
        ),
      ],
    );
  }

  void showErrorDialog(String errorMessage){
    showDialog(context: context, builder: (ctx) =>  AlertDialog(
      title:const Text('Error occurred'),
      content: Text(errorMessage),
    ));
  }

}
