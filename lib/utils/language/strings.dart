import 'package:get/get.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'post_title': 'Notification',
          "new_post_creation": "Create new post",
          'title': "Title",
          "description": "Description",
          "authority": "Authority",
          "opt_map": "Use Map",
          "attachments": "Attachments",
          "check_preview": "Check Preview",
          "add_post_hint": "Brief healine",
          "pin_point_hint":
              "Place the pin on the map where event will take place/took place",
        },
        'es_ES': {
          'post_title': 'Thuchhuah',
          "new_post_creation": "Thuchhuah thar siamna",
          'title': "Thupui",
          "description": "A chipchiar",
          "authority": "Chhuahtu",
          "opt_map": "Map a tarlan",
          "attachments": "Thiltel-te",
          "check_preview": "Landan enchhinna",
          "add_post_hint": "A thupui tawi fel takin",
          "pin_point_hint": "Hmun tihlan i duhna lai ah Pin hi dah rawh le"
        },
      };
}
