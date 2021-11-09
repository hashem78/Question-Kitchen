import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/helpers.dart';
import 'package:question_kitchen/models/answer/answer.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:question_kitchen/providers.dart';
import 'package:uuid/uuid.dart';
final GlobalKey<FormState> _formKey = GlobalKey();

class NewQuestionCreationDialog extends HookWidget {
  const NewQuestionCreationDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionController = useTextEditingController();
    final answerController = useTextEditingController();
    final folder = useProvider(folderProvider);
    return AlertDialog(
      title: Text('New Question'),
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
            children: [
              TextFormField(
                controller: questionController,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'What is the weather when the climate is tropic ?',
                ),
                validator: validateNewQuestionFields,
              ),
              TextFormField(
                maxLines: null,
                controller: answerController,
                decoration: const InputDecoration(
                  hintText: 'It should be hotter than 50c',
                ),
                validator: validateNewQuestionFields,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel),
          label: Text('Cancel'),
        ),
        TextButton.icon(
          onPressed: () async {
            final canSubmit = _formKey.currentState!.validate();
            if (canSubmit) {
              await Question.create(
                folderId: folder.uid,
                uuid: const Uuid().v4(),
                text: questionController.text,
                priority: QuestionPriority.low,
                answer: Answer.data(
                  text: answerController.text,
                ),
              );
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
      ],
    );
  }
}
