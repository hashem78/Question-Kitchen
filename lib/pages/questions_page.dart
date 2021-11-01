import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/new_question_form_widget.dart';
import 'package:question_kitchen/widgets/question_tile_widget.dart';

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
        child: Scaffold(
          appBar: AppBar(
            title: Text(folder.title),
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Export'),
                      onTap: () => exportToTxt(context),
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
                  reverse: true,
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

  void exportToTxt(BuildContext context) {
    final folder = context.read(folderProvider);
    context.read(questionsPovider(folder)).whenData(
      (questions) async {
        var ans = "";
        for (final question in questions) {
          ans += "Q: ${question.text}\nA: ${question.answer.text}\n";
        }
        await FileSaver.instance.saveFile(
          'test.txt',
          Uint8List.fromList(
            utf8.encode(ans),
          ),
          'txt',
          mimeType: MimeType.TEXT,
        );
      },
    );
  }
}
