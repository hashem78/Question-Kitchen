import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/answer/answer.dart';
import 'package:question_kitchen/models/questionmedia/questionmedia.dart';

part 'question.freezed.dart';
part 'question.g.dart';

enum QuestionPriority {
  high,
  low,
  medium,
  none,
}

@freezed
class Question with _$Question {
  const Question._();
  const factory Question.data({
    String? folderId,
    required String uuid,
    required String text,
    QuestionMedia? media,
    required QuestionPriority priority,
    required Answer answer,
  }) = _QuestionData;

  static Future<void> create({
    required String folderId,
    required String uuid,
    required String text,
    QuestionMedia? media,
    required QuestionPriority priority,
    required Answer answer,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    EasyDebounce.debounce(
      'submit-question',
      const Duration(seconds: 1),
      () async {
        await firestore
            .collection(user.uid)
            .doc('folders')
            .collection('folders')
            .doc(folderId)
            .collection('questions')
            .doc(uuid)
            .set(
          {
            'createdAt': FieldValue.serverTimestamp(),
            ...Question.data(
              uuid: uuid,
              text: text,
              priority: priority,
              answer: answer,
            ).toJson(),
          },
        );
      },
    );
  }

  Future<void> delete() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(folderId!)
        .collection('questions')
        .doc(uuid)
        .delete();
  }

  Future<void> update({
    required String newText,
    required String newAnswer,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(folderId!)
        .collection('questions')
        .doc(uuid)
        .update(
          copyWith(
            text: newText,
            answer: answer.copyWith(
              text: newAnswer,
            ),
          ).toJson(),
        );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
