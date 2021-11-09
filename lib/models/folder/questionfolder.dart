import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_kitchen/models/question/question.dart';
part 'questionfolder.freezed.dart';
part 'questionfolder.g.dart';

@freezed
abstract class QuestionFolder with _$QuestionFolder {
  const QuestionFolder._(); // Added constructor
  const factory QuestionFolder({
    required String uid,
    required String title,
  }) = _QuestionFolderData;
  static Future<void> createFolder(QuestionFolder folder) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(folder.uid)
        .set(folder.toJson());
  }

  static Stream<List<QuestionFolder>> fetchFolders() {
    final firestore = FirebaseFirestore.instance;

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;

    return firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final folders = <QuestionFolder>[];
          for (final element in data.docs) {
            folders.add(
              QuestionFolder.fromJson(
                element.data(),
              ),
            );
          }
          sink.add(folders);
        },
      ),
    );
  }

  Future<void> update(String newFolderName) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(uid)
        .update(copyWith(
          title: newFolderName,
        ).toJson());
  }

  Future<String> importQuestions(List<PlatformFile> files) async {
    var counter = 0;
    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser!;
      final batch = firestore.batch();
      for (final file in files) {
        try {
          final decodedQuestions = jsonDecode(
            utf8.decode(
              file.bytes!.toList(),
            ),
          );
          for (final question in decodedQuestions) {
            counter++;
            batch.set(
              firestore
                  .collection(user.uid)
                  .doc('folders')
                  .collection('folders')
                  .doc(question['uuid']),
              question,
            );
          }
        } catch (e) {
          throw Exception('Failed to parse ${file.name}');
        }
        batch.commit();
      }
    } on FirebaseException {
      rethrow;
    }
    return "Imported $counter questions from ${files.length} files";
  }

  Future<void> removeFolder() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    await firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(uid)
        .delete();
  }

  Stream<List<Question>> fetchQuestions() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    return firestore
        .collection(user.uid)
        .doc('folders')
        .collection('folders')
        .doc(uid)
        .collection('questions')
        .orderBy('createdAt')
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final questions = <Question>[];
          for (final element in data.docs) {
            questions.add(
              Question.fromJson(
                element.data(),
              ),
            );
          }
          sink.add(questions);
        },
      ),
    );
  }

  
  factory QuestionFolder.fromJson(Map<String, dynamic> json) =>
      _$QuestionFolderFromJson(json);
}
