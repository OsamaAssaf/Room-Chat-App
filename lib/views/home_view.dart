import 'package:chat_app/res/styles/colors.dart';
import 'package:chat_app/view_models/auth_view_model.dart';
import 'package:chat_app/view_models/chat_room_view_model.dart';
import 'package:chat_app/views/chats/chat_room_view.dart';
import 'package:chat_app/views/edit_profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List allUsers = [];
  bool _isLoading = true;

  Future<void> getData() async {
    // QuerySnapshot querySnapshot = await users.get();
    // allUsers = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print("allUsers: $allUsers");

    final ref = FirebaseDatabase.instance.ref();
    final DataSnapshot snapshot = await ref.child('users').get();
    Map data = snapshot.value as Map;
    data.forEach((key, value) {
      allUsers.add(value);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await getData();
    setState(() {
      _isLoading = false;
    });
  }

  void openChatRoom(
      String desUserId, String desUserName, String? desUserPhotoURL) {
    Provider.of<ChatRoomViewModel>(context, listen: false)
        .setValuesOpenChat(desUserId, desUserName, desUserPhotoURL);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ChatRoomView()));
  }

  @override
  void initState() {
    getData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthViewModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  if (allUsers[index]['userId'] != user!.uid) {
                    return ListTile(
                      onTap: () {
                        openChatRoom(
                            allUsers[index]['userId'],
                            allUsers[index]['full_name'],
                            allUsers[index]['photoURL']);
                      },
                      title: Text(allUsers[index]['full_name']),
                      leading: allUsers[index]['photoURL'] == null
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/man_profile.png'),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage(allUsers[index]['photoURL']),
                            ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.darkBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Osama Chat',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (user!.photoURL != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                          radius: 32.0,
                        ),
                      if (user.photoURL == null)
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/man_profile.png'),
                          radius: 32.0,
                        ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        user.displayName != null ? user.displayName! : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const EditProfileView()));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () {
                Provider.of<AuthViewModel>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
