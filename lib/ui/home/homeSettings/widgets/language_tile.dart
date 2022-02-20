import 'package:durkhawpui/controllers/languageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageTile extends StatefulWidget {
  const LanguageTile({Key? key}) : super(key: key);

  @override
  _LanguageTileState createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  final LanguageController language = Get.find();

  List<String> options = ["English", "Mizo"];
  String selected = "English";

  @override
  void initState() {
    super.initState();
    var _language = language.getLocaleString();
    if (_language == "es") {
      selected = "Mizo";
    } else {
      selected = "English";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.language),
      title: Text("Language"),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("Select Language"),
          isExpanded: false,
          isDense: true,
          value: selected,
          onChanged: (newValue) {
            if (newValue == null) {
            } else if (newValue == "Mizo") {
              language.setLocale(Locale('es', "ES"));
              selected = newValue;
            } else if (newValue == "English") {
              language.setLocale(Locale('en', "US"));
              selected = newValue;
            }
            setState(() {});
          },
          items: options
              .map(
                (item) => DropdownMenuItem<String>(
                  child: Text(item),
                  value: item,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
