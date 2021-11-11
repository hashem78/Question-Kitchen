import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/helpers.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/new_question_creation_dialog.dart';
import 'package:question_kitchen/widgets/qsidebar_widget.dart';
import 'package:question_kitchen/widgets/question_tile_widget.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

class QuestionsPage extends HookWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folder = useProvider(folderProvider);
    final questions = useProvider(questionsPovider(folder));

    return QSideBar(
      right: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(folder.title),
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) {
                  return [
                    _ImportPopupItem(folder),
                    _ExportPopupItem(folder),
                  ];
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProviderScope(
                      overrides: [
                        folderProvider.overrideWithValue(folder),
                      ],
                      child: const NewQuestionCreationDialog(),
                    );
                  },
                ),
              );
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
    );
  }
}

class _ExportPopupItem extends PopupMenuItem<int> {
  const _ExportPopupItem(
    this.folder, {
    Key? key,
  }) : super(key: key, child: const Text('Export'));
  final QuestionFolder folder;
  @override
  VoidCallback? get onTap => () async => await exportToJson(folder);
}

class _ImportPopupItem extends PopupMenuItem<int> {
  const _ImportPopupItem(
    this.folder, {
    Key? key,
  }) : super(key: key, child: const Text('Import'));
  final QuestionFolder folder;
  @override
  VoidCallback? get onTap => () async {
        final pickerResults = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: true,
          withData: true,
          allowedExtensions: ['json'],
        );
        if (pickerResults != null) {
          folder.importQuestions(pickerResults.files).then(
            (value) {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(content: Text(value)),
              );
            },
            onError: (err) {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(content: Text(err.toString())),
              );
            },
          );
        }
      };
}
