import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/answer/answer.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const Question._();
  const factory Question.data({
    required String uuid,
    required String text,
    required Answer answer,
  }) = _QuestionData;

  Future<void> update({
    required String folderId,
    required String newText,
    required String newAnswer,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(folderId)
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
