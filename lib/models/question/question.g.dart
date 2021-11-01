// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_QuestionData _$$_QuestionDataFromJson(Map<String, dynamic> json) =>
    _$_QuestionData(
      uuid: json['uuid'] as String,
      text: json['text'] as String,
      answer: Answer.fromJson(json['answer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_QuestionDataToJson(_$_QuestionData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'text': instance.text,
      'answer': instance.answer.toJson(),
    };
