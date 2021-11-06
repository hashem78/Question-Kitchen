import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/new_question_form_widget.dart';
import 'package:question_kitchen/widgets/qsidebar_widget.dart';
import 'package:question_kitchen/widgets/question_tile_widget.dart';
import 'package:http/http.dart' as http;

class QuestionsPage extends HookWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folder = useProvider(folderProvider);
    final questions = useProvider(questionsPovider(folder));

    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.f1,
        ): () async {
          await _showBottomSheet(context, context.read(folderProvider));
        },
      },
      child: Focus(
        autofocus: true,
        child: QSideBar(
          right: Scaffold(
            appBar: AppBar(
              title: Text(folder.title),
              actions: [
                PopupMenuButton<int>(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text('Import'),
                        onTap: () async {
                          final pickerResults =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: true,
                            withData: true,
                            allowedExtensions: ['json'],
                          );
                          if (pickerResults != null) {
                            folder.importQuestions(pickerResults.files).then(
                              (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value)),
                                );
                              },
                              onError: (err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(err.toString())),
                                );
                              },
                            );
                          }
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Export'),
                        onTap: () => exportToJson(context),
                      ),
                    ];
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await _showBottomSheet(context, context.read(folderProvider));
              },
            ),
            body: SafeArea(
              child: questions.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(child: Text("There are no questions"));
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return QuestionTileWidget(question: data[index]);
                    },
                    itemCount: data.length,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(error.toString()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, QuestionFolder folder) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ProviderScope(
          child: NewQuestionFormWidget(
            folder: folder,
          ),
        );
      },
    );
  }

  Future<void> exportToJson(BuildContext context) async {
    final folder = context.read(folderProvider);
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
}
