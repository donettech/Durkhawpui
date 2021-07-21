import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String description = "";
  String eas = "test";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            MarkdownTextInput(
              (String value) {
                setState(() {
                  description = value;
                });
              },
              description,
              label: 'Description',
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MarkdownBody(
                data: description,
                shrinkWrap: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  eas =
                      description.replaceAll(new RegExp(r'(?:_|[^\w\s])+'), '');
                });
              },
              child: Text("Done"),
            ),
            Text(eas),
          ],
        ),
      ),
    );
  }
}
