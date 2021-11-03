import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/question/question.dart';
part 'questionfolder.freezed.dart';
part 'questionfolder.g.dart';

@freezed
abstract class QuestionFolder with _$QuestionFolder {
  const QuestionFolder._(); // Added constructor
  const factory QuestionFolder({
    required String uid,
    required String title,
  }) = _QuestionFolderData;
  static Future<void> createFolder(QuestionFolder folder) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore.collection(user.uid).doc(folder.uid).set(folder.toJson());
  }

  static Stream<List<QuestionFolder>> fetchFolders() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    return firestore.collection(user.uid).snapshots().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final folders = <QuestionFolder>[];
          for (final element in data.docs) {
            folders.add(
              QuestionFolder.fromJson(
                element.data(),
              ),
            );
          }
          sink.add(folders);
        },
      ),
    );
  }

  Future<void> removeFolder() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore.collection(user.uid).doc(uid).delete();
  }

  Stream<List<Question>> fetchQuestions() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    return firestore
        .collection(user.uid)
        .doc(uid)
        .collection('questions')
        .orderBy('createdAt')
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final questions = <Question>[];
          for (final element in data.docs) {
            questions.add(
              Question.fromJson(
                element.data(),
              ),
            );
          }
          sink.add(questions);
        },
      ),
    );
  }

  Future<void> addQuestion(Question question) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    EasyDebounce.debounce(
      'submit-question',
      const Duration(seconds: 1),
      () async {
        await firestore
            .collection(user.uid)
            .doc(uid)
            .collection('questions')
            .doc(question.uuid)
            .set(
          {
            'createdAt': FieldValue.serverTimestamp(),
            ...question.toJson(),
          },
        );
      },
    );
  }

  Future<void> removeQuestion(String uuid) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore
        .collection(user.uid)
        .doc(uid)
        .collection('questions')
        .doc(uuid)
        .delete();
  }

  factory QuestionFolder.fromJson(Map<String, dynamic> json) =>
      _$QuestionFolderFromJson(json);
}
