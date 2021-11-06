import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
    }
  }

  Future<void> load() async {
    state = await loadSettingsState();
    await establishNotifications();
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

  void setState(SettingsState newState) {
    state = newState;
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (_) {
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
