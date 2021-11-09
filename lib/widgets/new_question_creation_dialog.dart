import 'package:enum_to_string/enum_to_string.dart';
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
    final priorityValue = useValueNotifier(QuestionPriority.none);

    final folder = useProvider(folderProvider);
    return AlertDialog(
      title: const Text('New Question'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Question'),
                    TextFormField(
                      controller: questionController,
                      autofocus: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText:
                            'What is the weather when the climate is tropic ?',
                      ),
                      validator: validateNewQuestionFields,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Answer'),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Priority'),
                    NewQuestionPrioritySlider(
                      onPriorityChanged: (priority) {
                        priorityValue.value = priority;
                      },
                    ),
                  ],
                ),
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
            final canSubmit = _formKey.currentState!.validate();
            if (canSubmit) {
              await Question.create(
                folderId: folder.uid,
                uuid: const Uuid().v4(),
                text: questionController.text,
                priority: priorityValue.value,
                answer: Answer.data(
                  text: answerController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class NewQuestionPrioritySlider extends HookWidget {
  const NewQuestionPrioritySlider({
    Key? key,
    required this.onPriorityChanged,
  }) : super(key: key);

  final void Function(QuestionPriority priority) onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    final sliderValue = useValueNotifier(0.0);
    final sliderColor = useValueNotifier<Color?>(null);
    final priorityValue =
        useValueNotifier(QuestionPriority.none);
    return Slider(
      value: useValueListenable(sliderValue),
      onChanged: (value) {
        sliderValue.value = value;
        switch (value.toInt()) {
          case 0:
            priorityValue.value = QuestionPriority.none;
            onPriorityChanged(QuestionPriority.none);
            sliderColor.value = null;
            break;
          case 1:
            priorityValue.value = QuestionPriority.low;
            onPriorityChanged(QuestionPriority.low);
            sliderColor.value = Colors.grey;
            break;
          case 2:
            priorityValue.value = QuestionPriority.medium;
            onPriorityChanged(QuestionPriority.medium);
            sliderColor.value = Colors.amber;
            break;
          case 3:
            priorityValue.value = QuestionPriority.high;
            onPriorityChanged(QuestionPriority.high);
            sliderColor.value = Colors.red;
            break;
          default:
        }
      },
      label: EnumToString.convertToString(
        useValueListenable(priorityValue),
      ),
      activeColor: useValueListenable(sliderColor),
      thumbColor: useValueListenable(sliderColor),
      min: 0,
      max: 3,
      divisions: 3,
    );
  }
}
