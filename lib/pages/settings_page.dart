import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/helpers.dart';
import 'package:question_kitchen/models/settings/settingsstate.dart';

import 'package:question_kitchen/widgets/qsidebar_widget.dart';

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController({SettingsState? st})
      : super(const SettingsState.loading()) {
    load();
  }

  @override
  void dispose() async {
    await FirebaseMessaging.instance.deleteToken();
    _notificationsSubscription?.cancel();
    _userEventSubscriptions?.cancel();
    super.dispose();
  }

  Future<void> establishNotifications() async {
    if (state.notificationsState == NotificationsState.enabled) {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      final token = await messaging.getToken(
        vapidKey:
            "BPIjzv-Q3r9FfpS_cyNpOH02edDlMlBFnD9bOWXuifh4YL0z9-N0eVn0L0NWkB-NugKBaKf-s99NtBdU83EiYBg",
      );
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.doc('${user.uid}/settings').update(
        {
          'notificationTokens': FieldValue.arrayUnion(
            [token],
          ),
        },
      );
      _notificationsSubscription = FirebaseMessaging.onMessage.listen(
        (message) {},
      );
    } else {
      await FirebaseMessaging.instance.deleteToken();
      _notificationsSubscription?.cancel();
    }
  }

  StreamSubscription<User?>? _userEventSubscriptions;
  Future<void> load() async {
    _userEventSubscriptions ??= FirebaseAuth.instance.userChanges().listen(
      (event) async {
        if (event != null) {
          state = await loadSettingsState();
          await establishNotifications();
        }
      },
    );
  }

  StreamSubscription<RemoteMessage>? _notificationsSubscription;
  Future<void> setNotificationsState(NotificationsState newState) async {
    if (newState == NotificationsState.enabled) {
      await establishNotifications();
    } else {
      FirebaseMessaging.instance.deleteToken();
      _notificationsSubscription?.cancel();
    }

    state = state.copyWith(notificationsState: newState);
    await saveSettingsState(state);
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = state.copyWith(
      userThemeMode: theme,
      userBrightness: (theme == ThemeMode.system)
          ? (SchedulerBinding.instance!.window.platformBrightness)
          : (theme == ThemeMode.dark)
              ? Brightness.dark
              : Brightness.light,
    );
    await saveSettingsState(state);
  }

  void setState(SettingsState newState) {
    state = newState;
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (ref) {
    return SettingsController();
  },
);

class SettingsPage extends HookWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState = useProvider(settingsControllerProvider);
    return QSideBar(
      right: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Notifications'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const NotificationSettingsAlertDialog();
                      },
                    );
                  },
                  subtitle: Text(
                    settingsState.notificationsState ==
                            NotificationsState.enabled
                        ? 'Enabled'
                        : 'Disabled',
                  ),
                ),
                ListTile(
                  title: const Text('Theme'),
                  subtitle: Text(
                    EnumToString.convertToString(settingsState.userThemeMode),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return HookBuilder(
                          builder: (context) {
                            final currentSettingsState = useProvider(
                              settingsControllerProvider,
                            );
                            final themeMode = useValueNotifier(
                              currentSettingsState.userThemeMode,
                            );

                            return AlertDialog(
                              title: const Text('Theme'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile<ThemeMode>(
                                    title: const Text('System'),
                                    value: ThemeMode.system,
                                    groupValue: useValueListenable(themeMode),
                                    onChanged: (value) {
                                      final settingsNotifier = context.read(
                                        settingsControllerProvider.notifier,
                                      );
                                      themeMode.value = value!;
                                      settingsNotifier.setTheme(value);
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: const Text('Dark'),
                                    value: ThemeMode.dark,
                                    groupValue: useValueListenable(themeMode),
                                    onChanged: (value) {
                                      final settingsNotifier = context.read(
                                        settingsControllerProvider.notifier,
                                      );
                                      themeMode.value = value!;
                                      settingsNotifier.setTheme(value);
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: const Text('Light'),
                                    value: ThemeMode.light,
                                    groupValue: useValueListenable(themeMode),
                                    onChanged: (value) {
                                      final settingsNotifier = context.read(
                                        settingsControllerProvider.notifier,
                                      );
                                      themeMode.value = value!;
                                      settingsNotifier.setTheme(value);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationSettingsAlertDialog extends HookWidget {
  const NotificationSettingsAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState = useProvider(settingsControllerProvider);
    return AlertDialog(
      title: const Text('Notifications'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<NotificationsState>(
            title: const Text('Enabled'),
            value: NotificationsState.enabled,
            groupValue: settingsState.notificationsState,
            onChanged: (value) {
              final notifier =
                  context.read(settingsControllerProvider.notifier);
              notifier.setNotificationsState(value!);
            },
          ),
          RadioListTile<NotificationsState>(
            title: const Text('Disabled'),
            value: NotificationsState.disabled,
            groupValue: settingsState.notificationsState,
            onChanged: (value) {
              final notifier =
                  context.read(settingsControllerProvider.notifier);
              notifier.setNotificationsState(value!);
            },
          ),
        ],
      ),
      actions: const [],
    );
  }
}
