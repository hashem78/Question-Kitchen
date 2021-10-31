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
  switch (json['runtimeType'] as String?) {
    case 'data':
      return _QuestionData.fromJson(json);
    case 'error':
      return _QuestionError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Question',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$QuestionTearOff {
  const _$QuestionTearOff();

  _QuestionData data({required String text, required Answer answer}) {
    return _QuestionData(
      text: text,
      answer: answer,
    );
  }

  _QuestionError error([String? error]) {
    return _QuestionError(
      error,
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
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text, Answer answer) data,
    required TResult Function(String? error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_QuestionData value) data,
    required TResult Function(_QuestionError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res>;
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  final Question _value;
  // ignore: unused_field
  final $Res Function(Question) _then;
}

/// @nodoc
abstract class _$QuestionDataCopyWith<$Res> {
  factory _$QuestionDataCopyWith(
          _QuestionData value, $Res Function(_QuestionData) then) =
      __$QuestionDataCopyWithImpl<$Res>;
  $Res call({String text, Answer answer});

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
    Object? text = freezed,
    Object? answer = freezed,
  }) {
    return _then(_QuestionData(
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
@JsonSerializable()
class _$_QuestionData implements _QuestionData {
  const _$_QuestionData({required this.text, required this.answer});

  factory _$_QuestionData.fromJson(Map<String, dynamic> json) =>
      _$$_QuestionDataFromJson(json);

  @override
  final String text;
  @override
  final Answer answer;

  @override
  String toString() {
    return 'Question.data(text: $text, answer: $answer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _QuestionData &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.answer, answer) ||
                const DeepCollectionEquality().equals(other.answer, answer)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(answer);

  @JsonKey(ignore: true)
  @override
  _$QuestionDataCopyWith<_QuestionData> get copyWith =>
      __$QuestionDataCopyWithImpl<_QuestionData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text, Answer answer) data,
    required TResult Function(String? error) error,
  }) {
    return data(text, answer);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
  }) {
    return data?.call(text, answer);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(text, answer);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_QuestionData value) data,
    required TResult Function(_QuestionError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestionDataToJson(this)..['runtimeType'] = 'data';
  }
}

abstract class _QuestionData implements Question {
  const factory _QuestionData({required String text, required Answer answer}) =
      _$_QuestionData;

  factory _QuestionData.fromJson(Map<String, dynamic> json) =
      _$_QuestionData.fromJson;

  String get text => throw _privateConstructorUsedError;
  Answer get answer => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$QuestionDataCopyWith<_QuestionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$QuestionErrorCopyWith<$Res> {
  factory _$QuestionErrorCopyWith(
          _QuestionError value, $Res Function(_QuestionError) then) =
      __$QuestionErrorCopyWithImpl<$Res>;
  $Res call({String? error});
}

/// @nodoc
class __$QuestionErrorCopyWithImpl<$Res> extends _$QuestionCopyWithImpl<$Res>
    implements _$QuestionErrorCopyWith<$Res> {
  __$QuestionErrorCopyWithImpl(
      _QuestionError _value, $Res Function(_QuestionError) _then)
      : super(_value, (v) => _then(v as _QuestionError));

  @override
  _QuestionError get _value => super._value as _QuestionError;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_QuestionError(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_QuestionError implements _QuestionError {
  const _$_QuestionError([this.error]);

  factory _$_QuestionError.fromJson(Map<String, dynamic> json) =>
      _$$_QuestionErrorFromJson(json);

  @override
  final String? error;

  @override
  String toString() {
    return 'Question.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _QuestionError &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$QuestionErrorCopyWith<_QuestionError> get copyWith =>
      __$QuestionErrorCopyWithImpl<_QuestionError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text, Answer answer) data,
    required TResult Function(String? error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text, Answer answer)? data,
    TResult Function(String? error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_QuestionData value) data,
    required TResult Function(_QuestionError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_QuestionData value)? data,
    TResult Function(_QuestionError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestionErrorToJson(this)..['runtimeType'] = 'error';
  }
}

abstract class _QuestionError implements Question {
  const factory _QuestionError([String? error]) = _$_QuestionError;

  factory _QuestionError.fromJson(Map<String, dynamic> json) =
      _$_QuestionError.fromJson;

  String? get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$QuestionErrorCopyWith<_QuestionError> get copyWith =>
      throw _privateConstructorUsedError;
}
