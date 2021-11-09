import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/models/settings/settingsstate.dart';
import 'package:http/http.dart' as http;

String? validateNewQuestionFields(String? value) {
  if (value == null || value == '') {
    return "This field can't be empty";
  }
  if (value.length < 10) {
    return "Field needs to be more than 10 characters";
  }
  return null;
}

Future<void> exportToJson(QuestionFolder folder) async {
    final user = FirebaseAuth.instance.currentUser!;
    final req = await http.post(
      Uri.parse(
        'https://us-central1-question-kitchen.cloudfunctions.net/exportQuestions',
      ),
      body: {
        'user': user.uid,
        'folder': folder.uid,
      },
    );
    await FileSaver.instance.saveFile(
      folder.title,
      req.bodyBytes,
      'json',
      mimeType: MimeType.JSON,
    );
  }

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
