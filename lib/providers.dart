import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/models/question/question.dart';

final authProvider = StreamProvider(
  (_ref) {
    return FirebaseAuth.instance.userChanges();
  },
);

final foldersProvider = StreamProvider<List<QuestionFolder>>(
  (_) {
    return QuestionFolder.fetchFolders();
  },
);
final folderProvider = ScopedProvider<QuestionFolder>(
  (_) {
    throw UnimplementedError();
  },
);
final questionsPovider = StreamProvider.family<List<Question>, QuestionFolder>(
  (_, folder) {
    return folder.fetchQuestions();
  },
);
