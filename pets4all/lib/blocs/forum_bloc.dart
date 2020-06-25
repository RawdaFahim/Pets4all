import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pets4all/models/question.dart';
import 'package:pets4all/models/events.dart';
import 'package:pets4all/models/forums.dart';
import 'dart:collection';

class ForumServices {
  final _firestore = Firestore.instance;
  String _formId;

  BehaviorSubject<num> _participants$;
  Stream<num> get participants => _participants$.stream;

//* added part
// # this is made to pass id of fourm which I clicked on its comments to be bring it and be my stream
  void setformId(formId) {
    _formId = formId;
    specificforums$;
  }

  Stream<Forums> get specificforums$ {
    return _firestore
        .collection("forums")
        .document(
        _formId) //this is the id I got form line 22 where I pass it in home when I click on comments in line472
        .snapshots()
        .map((snap) {
      final forums = Forums.fromDocument(snap);
      print(forums.toString());
      return forums;
    });
  }
//* end of addded part

  void addparticipant(Forums form) {
    num numbe = form.participants;
    numbe++;
    Firestore.instance.collection('forums').document(form.uid).updateData(
      {
        'participants': numbe,
      },
    );
  }

  void addComment(Forums form, dynamic comments) {
    Firestore.instance.collection('forums').document(form.uid).updateData(
      {
        'comments': comments,
      },
    );
  }

  void removeComment(Forums form, dynamic comments) {
    Firestore.instance.collection('forums').document(form.uid).updateData(
      {
        'comments': comments,
      },
    );
  }

  void minusparticipant(Forums form) {
    num numbe = form.participants;
    numbe--;
    Firestore.instance.collection('forums').document(form.uid).updateData(
      {
        'participants': numbe,
      },
    );
  }

  BehaviorSubject<Map<String, Color>> _color$ =
  BehaviorSubject<Map<String, Color>>(seedValue: {});
  Stream<Map<String, Color>> get color => _color$.stream;
  void addColor(Color selectedcolor, String uid) {
    Map<String, Color> selectedColors = _color$.value;
    selectedColors[uid] = selectedcolor;
    _color$.sink.add(selectedColors);
  }

  // BehaviorSubject<Events> _events$;

  Stream<List<Forums>> get forums$ {
    return _firestore.collection("forums").snapshots().map((snap) {
      final docs = snap.documents;
      final forums = docs.map((doc) => Forums.fromDocument(doc)).toList();
      return forums;
    });
  }

  Stream<UnmodifiableListView<String>> get forumsTypes$ {
    Set<String> types = Set<String>();
    return forums$.map((List<Forums> fo) {
      fo.forEach((f) {
        types.add(f.type);
      });
      return UnmodifiableListView<String>(types);
    });
  }

  void addpart() {}

  void dispose() {
    _color$.close();
    _participants$.close();
  }
}
