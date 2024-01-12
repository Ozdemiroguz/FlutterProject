import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/services/consts.dart';
import 'package:untitled5/models/color.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 10,
      ),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'User', lastName: 'Name');

  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'SmartHome');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:softBack ,
        title: const Text(
          'Smart Home Chat Bot',
          style: TextStyle(
            color: Colors.white,

          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: DashChat(
          currentUser: _currentUser,
          typingUsers: _typingUsers,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.deepPurple,
            containerColor:Colors.deepPurpleAccent,
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      String content = m.text;
      //m.text +=" Sen bir ev uygulamasındaki chat botsun ev sahibinin ismi ali ev sahibiyle bir evmişsin gibi konuş";

      if (m.user == _currentUser) {
        return Messages(role: Role.user, content:content+"Sen bir ev uygulamasındaki chat botsun ev sahibinin ismi Oğuzhan ev sahibiyle bir evmişsin gibi konuşman gerekiyor");
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 500,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}
