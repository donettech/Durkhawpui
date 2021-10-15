import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> changeLikeCount(
    {required String postId,
    required bool increment,
    required reference}) async {
  try {
    FirebaseFirestore.instance.runTransaction<int>((transaction) async {
      DocumentSnapshot notice = await transaction.get(reference);
      if (!notice.exists) {
        throw Exception('Document does not exist!');
      }
      int updatedLikes =
          increment ? notice.data()!['likes'] + 1 : notice.data()!['likes'] - 1;
      transaction.update(reference, {'likes': updatedLikes});
      return updatedLikes;
    });
  } catch (e, s) {
    print(s);
    print('Failed to update likes for document! $e');
  }
}

Future<void> changeCommentCount(
    {required String postId,
    required bool increment,
    required reference}) async {
  try {
    FirebaseFirestore.instance.runTransaction<int>((transaction) async {
      DocumentSnapshot notice = await transaction.get(reference);
      if (!notice.exists) {
        throw Exception('Document does not exist!');
      }
      int updatedLikes = increment
          ? notice.data()!['viewCount'] + 1
          : notice.data()!['viewCount'] - 1;
      transaction.update(reference, {'viewCount': updatedLikes});
      return updatedLikes;
    });
  } catch (e, s) {
    print(s);
    print('Failed to update likes for document! $e');
  }
}
