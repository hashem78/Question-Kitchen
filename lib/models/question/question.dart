import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/answer/answer.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const factory Question.data({
    required String uuid,
    required String text,
    required Answer answer,
  }) = _QuestionData;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
