import 'package:social_app/components/chat_bubble.dart';
import 'package:social_app/components/my_text_field.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:social_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail; // chat with whom
  const ConversationPage({
    super.key,
    required this.receiverId,
    required this.receiverEmail
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController  = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  // for text field focus
  FocusNode myFocusNode = FocusNode();
  void sendMessage()async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear(); // clear after sending message
    }
    scrollDown();
  }
  @override
  void initState() {
    super.initState();
    // add listener to focus node
    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        // cause a delay so that the keyboard has time to show up
        // then the amount of remaining space will be calculated,
        // then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
            ()=> scrollDown(),
        );
      }
    });
    // wait a bit for listview to be built, then scroll to bottom'
    Future.delayed(
      const Duration(milliseconds: 500),
        ()=> scrollDown(),
    );
  }
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
    );
  }
  @override
  void dispose() {
    _messageController.dispose();
    myFocusNode.dispose(); // <---
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("conversation page"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey), // drawer color
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text("chat with ${widget.receiverEmail}"),
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }
  Widget _buildMessageList(){
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Text("Error");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text("Loading...");
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc)=>_buildMessageItem(doc)).toList(),
          );
        });
  }
  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data["senderId"] == _authService.getCurrentUser()!.uid;
    return ChatBubble(message: data["message"], isCurrentUser: isCurrentUser);
  }
  //build message input
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              maxLines: 3,
              focusNode: myFocusNode,
              hintText: "Type a message",
            ),
          ),
          // send button
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade500,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.arrow_upward, ), // color: Colors.white // not given, auto for light/dark
            ),
          ),
        ],
      ),
    );
  }
}
/*
The following ProviderNotFoundException was thrown building ChatBubble(dirty):
Error: Could not find the correct Provider<ThemeProvider> above this ChatBubble Widget

This happens because you used a `BuildContext` that does not include the provider
of your choice. There are a few common scenarios:

 */