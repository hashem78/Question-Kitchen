import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:uuid/uuid.dart';

class NewFolderForm extends HookWidget {
  const NewFolderForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        right: 32.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'New Folder',
            style: TextStyle(
              fontSize: 50.sp,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: name,
              decoration: const InputDecoration(
                hintText: "Science",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                QuestionFolder.createFolder(
                  QuestionFolder(
                    uid: const Uuid().v4(),
                    title: name.text,
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}
