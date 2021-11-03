import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/pages/login_page.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/folder_tile_widget.dart';
import 'package:question_kitchen/widgets/new_folder_form_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FoldersPage extends HookWidget {
  const FoldersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foldersStream = useProvider(foldersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Log out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ];
            },
          ),
        ],
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
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const NewFolderForm();
      },
    );
  }
}
