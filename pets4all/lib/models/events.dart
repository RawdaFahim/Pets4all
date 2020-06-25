import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String uid, type, content;

  Events._({
    this.uid,
    this.type,
    this.content,
  });
  // factory Events.fromDocumentData(Map<String, dynamic> data) {
  //   return Events._(
  //     uid: data['uid'],
  //     type: data['type'],
  //     content: data["content"],
  //   );
  // }
  factory Events.fromDocument(DocumentSnapshot snap) {
    if (snap == null) {
      return null;
    } else {
      Map<String, dynamic> data = snap.data;
      return Events._(
        uid: snap.documentID,
        type: data['type'],
        content: data["content"],
      );
    }
  }
}
