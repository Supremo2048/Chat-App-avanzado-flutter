import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWrite = false;

  final List<ChatMessage> _message = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.blue,
              maxRadius: 14,
              child: Text(
                'Jo',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Jose Cardozo',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            )
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _message.length,
              itemBuilder: (_, i) => _message[i],
              reverse: true,
            )),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textEditingController,
            onSubmitted: _handleSubmit,
            onChanged: (text) {
              setState(() {
                if (text.trim().isNotEmpty) {
                  _isWrite = true;
                } else {
                  _isWrite = false;
                }
              });
            },
            decoration: const InputDecoration.collapsed(hintText: 'Enviar msn'),
            focusNode: _focusNode,
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWrite
                        ? () =>
                            _handleSubmit(_textEditingController.text.trim())
                        : null,
                    child: const Text('Enviar'))
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(
                            Icons.send,
                          ),
                          onPressed: _isWrite
                              ? () => _handleSubmit(
                                  _textEditingController.text.trim())
                              : null),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textEditingController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      text: texto,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    _message.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWrite = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _message) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
