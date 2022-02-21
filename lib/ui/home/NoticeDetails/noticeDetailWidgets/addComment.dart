import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/comment.dart';
import 'package:durkhawpui/utils/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCommentUI extends StatelessWidget {
  final Function(String) onSend;
  final String postId;
  AddCommentUI({Key? key, required this.onSend, required this.postId})
      : super(key: key);
  final TextEditingController _textCtrl = TextEditingController();
  final _fire = FirebaseFirestore.instance.collection('posts');
  final _userCtrl = Get.find<UserController>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Theme.of(context).dialogBackgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Add a comment',
                  border: InputBorder.none,
                ),
                autofocus: false,
                maxLines: null,
                controller: _textCtrl,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  if (_userCtrl.user.value.name.toLowerCase() == "guest") {
                    _userCtrl.promptLogin();
                    return;
                  }
                  if (_textCtrl.text.isNotEmpty) {
                    Comment _temp = Comment(
                      docId: '',
                      text: _textCtrl.text,
                      userName: _userCtrl.user.value.name,
                      userAvatar: _userCtrl.user.value.avatarUrl,
                      userId: _userCtrl.user.value.userId,
                      createdAt: DateTime.now(),
                      updatedAt: null,
                    );
                    _fire
                        .doc(postId)
                        .collection('comments')
                        .add(_temp.toJson());
                    _textCtrl.text = "";
                    onSend(_textCtrl.text);
                    changeCommentCount(
                        reference: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId));
                    _focusNode.unfocus();
                  }
                },
                icon: Icon(
                  Icons.send,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
