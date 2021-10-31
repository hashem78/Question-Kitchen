// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_QuestionData _$$_QuestionDataFromJson(Map<String, dynamic> json) =>
    _$_QuestionData(
      text: json['text'] as String,
      answer: Answer.fromJson(json['answer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_QuestionDataToJson(_$_QuestionData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'answer': instance.answer.toJson(),
    };

_$_QuestionError _$$_QuestionErrorFromJson(Map<String, dynamic> json) =>
    _$_QuestionError(
      json['error'] as String?,
    );

Map<String, dynamic> _$$_QuestionErrorToJson(_$_QuestionError instance) =>
    <String, dynamic>{
      'error': instance.error,
    };
