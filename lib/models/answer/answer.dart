
import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer with _$Answer {
  const factory Answer.data({required String text}) = _AnswerData;
	
  factory Answer.fromJson(Map<String, dynamic> json) =>
			_$AnswerFromJson(json);
}
