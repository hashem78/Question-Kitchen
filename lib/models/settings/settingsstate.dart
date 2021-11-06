import 'package:freezed_annotation/freezed_annotation.dart';

part 'settingsstate.freezed.dart';
part 'settingsstate.g.dart';

enum NotificationsState { enabled, disabled }

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(NotificationsState.disabled) NotificationsState notificationsState,
  }) = _SettingsState;
  const factory SettingsState.loading({@Default(NotificationsState.disabled) NotificationsState notificationsState}) = _SettingsStateLoading;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}
