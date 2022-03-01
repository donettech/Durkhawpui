class PageModel {
  late String docId;
  late String text;
  PageModel({required this.docId, required this.text});
  PageModel.fromJson(Map<String, dynamic> json, {required String id}) {
    docId = id;
    text = json['text'];
  }

  toJson() {
    return {
      'text': text,
    };
  }
}
