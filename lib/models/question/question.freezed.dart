// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _QuestionData.fromJson(json);
}

/// @nodoc
class _$QuestionTearOff {
  const _$QuestionTearOff();

  _QuestionData data(
      {required String uuid, required String text, required Answer answer}) {
    return _QuestionData(
      uuid: uuid,
      text: text,
      answer: answer,
    );
  }

  Question fromJson(Map<String, Object> json) {
    return Question.fromJson(json);
  }
}

/// @nodoc
const $Question = _$QuestionTearOff();

/// @nodoc
mixin _$Question {
  String get uuid => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  Answer get answer => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String uuid, String text, Answer answer) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String uuid, String text, Answer answer)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String uuid, String text, Answer answer)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_QuestionData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res>;
  $Res call({String uuid, String text, Answer answer});

  $AnswerCopyWith<$Res> get answer;
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  final Question _value;
  // ignore: unused_field
  final $Res Function(Question) _then;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? text = freezed,
    Object? answer = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      answer: answer == freezed
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as Answer,
    ));
  }

  @override
  $AnswerCopyWith<$Res> get answer {
    return $AnswerCopyWith<$Res>(_value.answer, (value) {
      return _then(_value.copyWith(answer: value));
    });
  }
}

/// @nodoc
abstract class _$QuestionDataCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionDataCopyWith(
          _QuestionData value, $Res Function(_QuestionData) then) =
      __$QuestionDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid, String text, Answer answer});

  @override
  $AnswerCopyWith<$Res> get answer;
}

/// @nodoc
class __$QuestionDataCopyWithImpl<$Res> extends _$QuestionCopyWithImpl<$Res>
    implements _$QuestionDataCopyWith<$Res> {
  __$QuestionDataCopyWithImpl(
      _QuestionData _value, $Res Function(_QuestionData) _then)
      : super(_value, (v) => _then(v as _QuestionData));

  @override
  _QuestionData get _value => super._value as _QuestionData;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? text = freezed,
    Object? answer = freezed,
  }) {
    return _then(_QuestionData(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      answer: answer == freezed
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as Answer,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_QuestionData implements _QuestionData {
  const _$_QuestionData(
      {required this.uuid, required this.text, required this.answer});

  factory _$_QuestionData.fromJson(Map<String, dynamic> json) =>
      _$$_QuestionDataFromJson(json);

  @override
  final String uuid;
  @override
  final String text;
  @override
  final Answer answer;

  @override
  String toString() {
    return 'Question.data(uuid: $uuid, text: $text, answer: $answer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _QuestionData &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.answer, answer) ||
                const DeepCollectionEquality().equals(other.answer, answer)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(answer);

  @JsonKey(ignore: true)
  @override
  _$QuestionDataCopyWith<_QuestionData> get copyWith =>
      __$QuestionDataCopyWithImpl<_QuestionData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String uuid, String text, Answer answer) data,
  }) {
    return data(uuid, text, answer);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String uuid, String text, Answer answer)? data,
  }) {
    return data?.call(uuid, text, answer);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String uuid, String text, Answer answer)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(uuid, text, answer);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_QuestionData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestionDataToJson(this);
  }
}

abstract class _QuestionData implements Question {
  const factory _QuestionData(
      {required String uuid,
      required String text,
      required Answer answer}) = _$_QuestionData;

  factory _QuestionData.fromJson(Map<String, dynamic> json) =
      _$_QuestionData.fromJson;

  @override
  String get uuid => throw _privateConstructorUsedError;
  @override
  String get text => throw _privateConstructorUsedError;
  @override
  Answer get answer => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$QuestionDataCopyWith<_QuestionData> get copyWith =>
      throw _privateConstructorUsedError;
}
