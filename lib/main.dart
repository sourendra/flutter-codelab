import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

final ThemeData iOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData defaultTheme = ThemeData(
  primaryColor: Colors.purple,
  accentColor: Colors.orange[400],
);

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendly Chat',
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : defaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMessage> _messageList = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String message) {
    _textController.clear();
    ChatMessage chatMessage = ChatMessage(
      text: message,
      animationController: AnimationController(
          duration: const Duration(milliseconds: 300), vsync: this),
    );
    setState(() {
      _messageList.insert(0, chatMessage);
      _isComposing = false;
    });
    _focusNode.requestFocus();
    chatMessage.animationController.forward();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _isComposing ? _handleSubmitted : null,
                onChanged: (value) {
                  setState(() {
                    _isComposing = value.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _isComposing
                    ? _handleSubmitted(_textController.text)
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendly Chat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0: 0.4,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messageList[index],
              itemCount: _messageList.length,
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messageList) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final _name = 'Sourendra Gantait';
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      // opacity: CurvedAnimation(
      //     parent: animationController,
      //     curve: Curves.easeIn,
      //   ),
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        )),
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  child: Text(_name[0]),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(text),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
