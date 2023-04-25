import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomViewModel with ChangeNotifier {
  String? desUserId;
  String? desUserName;
  String? desUserPhotoURL;

  void setValuesOpenChat(String? newDesUserId,
      String? newDesUserName, String? newDesUserPhotoURL) {
    desUserId = newDesUserId;
    desUserName = newDesUserName;
    desUserPhotoURL = newDesUserPhotoURL;
    notifyListeners();
  }


  Future<void> sendTextMessage(String message)async{
    
  }
}
