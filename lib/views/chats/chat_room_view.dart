import 'package:chat_app/res/styles/colors.dart';
import 'package:chat_app/view_models/chat_room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {

  late TextEditingController _messageController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _messageController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }


  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage()async{
    _focusNode.unfocus();
    await ChatRoomViewModel().sendTextMessage("Hello");

  }

  @override
  Widget build(BuildContext context) {
    ChatRoomViewModel provider = Provider.of<ChatRoomViewModel>(context);
    String? desUserId = provider.desUserId;
    String? desUserName = provider.desUserName;
    String? desUserPhotoURL = provider.desUserPhotoURL;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Row(
          children: [
            desUserPhotoURL == null
                ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/man_profile.png'),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(desUserPhotoURL),
              ),
            ),
            const SizedBox(width: 8.0,),
            Text(desUserName!),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx,index){
                    return Container(color: Colors.red,height: 20.0,);
                  },
              ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(width: 2.0,color: CustomColors.darkBlue)
                      ),
                    ),
                    focusNode: _focusNode,

                  ),
                ),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon:  Icon(Icons.send,color: CustomColors.darkBlue,size: 32.0,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
