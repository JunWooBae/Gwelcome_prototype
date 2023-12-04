import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController textEditingController = TextEditingController();

  // OpenAI API를 호출하는 함수
  Future<void> callGptApi(String text) async {
    const String apiKey = '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'; // 여기에 OpenAI API 키를 입력하세요.
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // 사용하려는 모델을 지정합니다.
          'messages': [
            {
              'role': 'user',
              'content': text,
            },
          ],
          //'session_id': sessionId,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        if (responseBody['choices'] != null && responseBody['choices'].isNotEmpty) {
          final botMessage = responseBody['choices'][0]['message']['content'];
          setState(() {
            messages.add({"type": "bot", "text": botMessage});
          });
        } else {
          setState(() {
            messages.add({"type": "bot", "text": "I didn't get that, can you say it again?"});
          });
        }
      } else {
        setState(() {
          messages.add({
            "type": "bot",
            "text": "Error: ${response.statusCode} - ${json.decode(response.body)['message']}"
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"type": "bot", "text": "Error: Exception - ${e.toString()}"});
      });
    }
  }



  void sendMessage() {
    final text = textEditingController.text;
    if (text.trim().isNotEmpty) {
      setState(() {
        messages.add({"type": "user", "text": text});
      });
      callGptApi(text);
      textEditingController.clear();
    }
  }

  Widget buildMessage(Map<String, String> message) {
    bool isUserMessage = message["type"] == "user";

    return Row(
      mainAxisAlignment:
      isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isUserMessage)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(child: Text('봇')),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8, // 최대 너비를 화면의 80%로 설정
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue[300] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message["text"] ?? "",
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black,
              ),
              softWrap: true, // 자동 줄바꿈 활성화
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챗봇 상담'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(messages[index]),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "여기에 메시지를 입력하세요...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}