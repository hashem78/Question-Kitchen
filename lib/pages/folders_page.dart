import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/folder_tile_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/widgets/qsidebar_widget.dart';
import 'package:uuid/uuid.dart';

final _formKey = GlobalKey<FormState>();

class FoldersPage extends HookWidget {
  const FoldersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foldersStream = useProvider(foldersProvider);
    return QSideBar(
      right: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Folders'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await _showBottomSheet(context);
          },
        ),
        body: SafeArea(
          child: foldersStream.when(
            data: (folders) {
              if (folders.isEmpty) {
                return const Center(child: Text("There are no folders"));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return FolderTileWidget(
                    folder: folders[index],
                  );
                },
                itemCount: folders.length,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Text(error.toString());
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return HookBuilder(
          builder: (context) {
            final name = useTextEditingController();
            return AlertDialog(
              title: const Text('New Folder'),
              content: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Builder(
                              builder: (context) {
                                return const Text('Folder name');
                              },
                            ),
                          ),
                          TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'A folder\'s name can\'t be empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Science",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ), 
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    EasyDebounce.debounce(
                      'add-folder',
                      const Duration(seconds: 1),
                      () {
                        final valid = _formKey.currentState!.validate();
                        if (valid) {
                          QuestionFolder.createFolder(
                            QuestionFolder(
                              uid: const Uuid().v4(),
                              title: name.text,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
