import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> changeLikeCount({
  required bool increment,
  required String userId,
  required DocumentReference<Object?> postReference,
}) async {
  try {
    FirebaseFirestore.instance.runTransaction<int>((transaction) async {
      var transRes = await transaction.get(postReference);
      Map _map = transRes.data() as Map;
      if (increment) {
        int updatedLikes = _map['likes'] + 1;
        transaction.update(postReference, {'likes': updatedLikes});
        postReference.collection('likes').doc(userId).set({
          "createdAt": DateTime.now(),
        });
        return updatedLikes;
      } else {
        int updatedLikes = _map['likes'] - 1;
        transaction.update(postReference, {'likes': updatedLikes});
        postReference.collection('likes').doc(userId).delete();
        return updatedLikes;
      }
    });
  } catch (e, s) {
    print(s);
    print('Failed to update likes for document! $e');
  }
}

Future<void> changeCommentCount({required reference}) async {
  try {
    FirebaseFirestore.instance.runTransaction<int>((transaction) async {
      var transRes = await transaction.get(reference);
      Map _map = transRes.data() as Map;
      int updatedComments = _map['commentCount'] + 1;
      transaction.update(reference, {'commentCount': updatedComments});
      return updatedComments;
    });
  } catch (e, s) {
    print(s);
    print('Failed to update likes for document! $e');
  }
}
