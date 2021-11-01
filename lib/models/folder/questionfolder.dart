import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<List<Question>> fetchQuestions() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    return firestore
        .collection(user.uid)
        .doc(uid)
        .collection('questions')
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
    await firestore
        .collection(user.uid)
        .doc(uid)
        .collection('questions')
        .add(question.toJson());
  }

  Future<void> removeQuestion(String questionText) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    final query = await firestore
        .collection(user.uid)
        .doc(uid)
        .collection('questions')
        .where('text', isEqualTo: questionText)
        .get();
    for (final element in query.docs) {
      await element.reference.delete();
    }
  }

  factory QuestionFolder.fromJson(Map<String, dynamic> json) =>
      _$QuestionFolderFromJson(json);
}
