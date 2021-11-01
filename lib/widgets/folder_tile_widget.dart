import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/pages/questions_page.dart';
import 'package:question_kitchen/providers.dart';

class FolderTileWidget extends HookWidget {
  const FolderTileWidget({
    Key? key,
    required this.folder,
  }) : super(key: key);
  final QuestionFolder folder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(folder.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProviderScope(
                overrides: [
                  folderProvider.overrideWithValue(folder),
                ],
                child: const QuestionsPage(),
              );
            },
          ),
        );
      },
    );
  }
}
