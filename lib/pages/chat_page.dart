import 'package:get/get.dart';
import 'package:social_app/components/user_tile.dart';
import 'package:social_app/pages/conversation_page.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:social_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("${_authService.getCurrentUser()!.displayName}"),
        leading: IconButton(
            onPressed: ()=> Get.to(()=> const HomePage()),
            icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey), // drawer color
      ),
      //endDrawer: const MyDrawer(), // drawer vs endDrawer
      body: Column(
        children: [
          const Text("Select an user to chat: ", style: TextStyle(fontSize: 18)),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }
  // build a list of users except current user
  Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("Error: ${snapshot.error}"); // error code
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text("Loading...");
          }
          return ListView( // <--- not builder
            children: snapshot.data!.map<Widget>(
                    (userData)=>_buildUserListItem(userData,context)
            ).toList(),
          );
        }
    );
  }
  // build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
    // display all users except current user
    if(userData["uid"] != _authService.getCurrentUser()!.uid){
      return UserTile(
        text: userData["email"], // ----------------------------------------------- handle
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=>ConversationPage(
                receiverId: userData["uid"],
                receiverEmail: userData["email"],
              ),
            ),
          );
        },
      );
    }else{
      return const SizedBox();
    }
  }
}
