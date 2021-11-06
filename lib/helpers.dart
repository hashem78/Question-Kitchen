import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:question_kitchen/models/settings/settingsstate.dart';

Future<SettingsState> loadSettingsState() async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  final firestore = FirebaseFirestore.instance;
  final query = await firestore.collection(user!.uid).doc('settings').get();
  final state = SettingsState.fromJson(query.data()!);

  return state;
}

Future<void> saveSettingsState(SettingsState state) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  final firestore = FirebaseFirestore.instance;
  await firestore
      .collection(user!.uid)
      .doc('settings')
      .set({'runtimeType': 'default', ...state.toJson()});
}
