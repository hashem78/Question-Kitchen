import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/answer/answer.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const factory Question.data({
    required String text,
    required Answer answer,
  }) = _QuestionData;
  const factory Question.error([String? error]) = _QuestionError;

  static Stream<List<Question>> fetchQuestions() {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection('questions').snapshots().transform(
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

  static Future<void> addQuestion(Question question) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('questions').add(question.toJson());
  }

  static Future<void> removeQuestion(String questionText) async {
    final firestore = FirebaseFirestore.instance;
    final query = await firestore
        .collection('questions')
        .where('text', isEqualTo: questionText)
        .get();
    for (final element in query.docs) {
      await element.reference.delete();
    }
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
