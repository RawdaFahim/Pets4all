import 'package:cloud_firestore/cloud_firestore.dart';

class Forums {
  String uid, type, content, title, authorName;
  List<Map<dynamic, dynamic>> comments;
  num participants;

  Forums._(
      {this.uid,
      this.type,
      this.content,
      this.comments,
      this.participants,
      this.title,
      this.authorName});
  // factory Forums.fromDocumentData(Map<String, dynamic> data) {
  //   return Forums._(
  //     uid: data['uid'],
  //     type: data['type'],
  //     content: data["content"],
  //   );
  // }

  factory Forums.fromDocument(DocumentSnapshot snap) {
    if (snap == null) {
      return null;
    } else {
      Map<String, dynamic> data = snap.data;
      return Forums._(
        uid: snap.documentID,
        type: data['type'],
        content: data["content"],
        participants: data["participants"],
        comments: List.from(data["comments"]),
        authorName: data["authorName"],
        title: data["title"],
      );
    }
  }
}
