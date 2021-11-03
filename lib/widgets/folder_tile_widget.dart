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
      trailing: IconButton(
        onPressed: () async {
          final shouldRemove = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Are you sure you want to remove this folder?',
                ),
                content: const Text(
                  'Please be aware that this action is irreversiable',
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Remove'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
          if (shouldRemove != null && shouldRemove) {
            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Removed Folder'),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              ),
            );
            final closeReason = await controller.closed;
            if (closeReason != SnackBarClosedReason.action) {
              await folder.removeFolder();
            }
          }
        },
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
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
