import 'package:best_flutter_ui_templates/fitness_app/my_diary/policy.dart';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/web.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'chatbot.dart';

class MyCustomizationPolicyScreen extends StatefulWidget {
  const MyCustomizationPolicyScreen({super.key});

  @override
  State<MyCustomizationPolicyScreen> createState() => _MyCustomizationPolicyScreenState();
}

class _MyCustomizationPolicyScreenState extends State<MyCustomizationPolicyScreen> {

  // JWT 토큰 - 실제 앱에서는 안전하게 저장하고 관리해야 합니다.
  final String _jwtToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJtZW1iZXJJZFwiOlwiMmM5MTgwODI4YzMwYWYxMDAxOGMzMjY4MzM5NTAwMDJcIn0iLCJpYXQiOjE3MDE2NTI3MzgsImV4cCI6OTAwMDE3MDE2NTI3Mzh9.O-Rnu6H3u9VtBZZI9UcirI-IW0Bc5jqyL6qy7WHjoS0';

  Future<List<Policy>> fetchData() async {
    final response = await http.get(
      Uri.parse(uurl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> dataList = jsonData['data']['content'];

      return dataList.map((item) => Policy.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('G - welcome 정책 상세보기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildTopSection(), // 상단 섹션
          _buildMiddleSection(), // 중간 섹션
          _buildBottomSection(), // 하단 섹션
          // 추가적인 위젯들이 필요한 경우 여기에 추가할 수 있습니다.
        ],
      ),
        bottomNavigationBar: CommentInputField(),
    );
  }

  Widget _buildTopSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    // 상단 섹션의 위젯을 구성
    return Container(
      width: screenWidth, // 화면의 가로 너비에 맞게 조정
      height: screenWidth / 1.1, // 이미지의 가로세로 비율을 유지하고자 할 때
      child: Image.asset(
        'assets/fitness_app/청년도약계좌.png',
        fit: BoxFit.cover, // 이미지가 너비에 맞게 꽉 차도록 조정
      ),
    );
  }

  Widget _buildMiddleSection() {
    return FutureBuilder<List<Policy>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Column(
            children: snapshot.data!.map((policy) => ListTile(
              title: Text(policy.title),
              subtitle: Text(policy.intro),
              // 여기에 다른 UI 요소를 추가할 수 있습니다.
            )).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }



  Widget _buildBottomSection() {
    // 하단 섹션의 위젯을 구성
    return Container(
      padding: EdgeInsets.all(16),
      child: Row( // Row 위젯을 사용하여 버튼들을 가로로 배열합니다.
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼들이 동일한 간격을 유지하도록 합니다.
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse('https://www.kinfa.or.kr/product/youthJump.do');
              if (await launchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('연결할 수 없습니다!')),
                );
              }
            },
            child: Text('사이트 바로가기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
              // '챗봇 상담' 버튼의 동작을 정의합니다.
              // 예를 들어, 챗봇과의 대화를 시작할 수 있습니다.
            },
            child: Text('챗봇 상담'),
          ),
        ],
      ),
    );
  }
}

class CommentInputField extends StatefulWidget {
  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                // 댓글 아이콘 버튼 액션 (옵션)
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // '보내기' 버튼 액션: 입력한 댓글 처리
                final commentText = _controller.text;
                _controller.clear();
                // 여기에서 댓글 텍스트를 사용하여 처리, 예: 서버에 보내기
                print(commentText); // 콘솔에 출력, 실제로는 서버에 전송 등의 액션을 취해야 함
              },
            ),
          ],
        ),
      ),
    );
  }

}