import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionmedia.freezed.dart';
part 'questionmedia.g.dart';

@freezed
class QuestionMedia with _$QuestionMedia {
  const factory QuestionMedia.data(
    List<String>? files,
    List<String>? voiceRecordings,
    List<String>? images,
    List<String>? videos,
  ) = _QuestionMedia;

  factory QuestionMedia.fromJson(Map<String, dynamic> json) =>
      _$QuestionMediaFromJson(json);
}
