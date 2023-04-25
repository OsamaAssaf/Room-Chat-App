import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/auth_view_model.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthViewModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Edit Profile'),
      ),
      body: Column(
        children: [
          CircleAvatar(

          ),
        ],
      ),
    );
  }
}
