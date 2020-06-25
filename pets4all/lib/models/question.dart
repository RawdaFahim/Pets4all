import 'package:cloud_firestore/cloud_firestore.dart';

class Questions {
  String uid, type, content;

  Questions._({
    this.uid,
    this.type,
    this.content,
  });
  // factory Questions.fromDocumentData(Map<String, dynamic> data) {
  //   return Questions._(
  //     uid: data['uid'],
  //     type: data['type'],
  //     content: data["content"],
  //   );
  // }
  factory Questions.fromDocument(DocumentSnapshot snap) {
    if (snap == null) {
      return null;
    } else {
      Map<String, dynamic> data = snap.data;
      return Questions._(
        uid: snap.documentID,
        type: data['type'],
        content: data["content"],
      );
    }
  }
}
