import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/helpers.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:question_kitchen/providers.dart';
import 'package:question_kitchen/widgets/new_question_priority_slider.dart';
import 'package:question_kitchen/widgets/qsidebar_widget.dart';

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
    return QSideBar(
      right: Scaffold(
        appBar: AppBar(
          title: const Text('New question'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
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
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            color: Colors.pink,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 0.4.sw,
                          child: ListView(
                            children: [
                              Container(
                                height: 100,
                                width: 200,
                                color: Colors.red,
                              )
                            ],
                          ),
                        )
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
        ),
      ),
    );
  }
}
        // TextButton(
        //   onPressed: () async {
        //     Navigator.pop(context);
        //   },
        //   child: const Text('Cancel'),
        // ),
        // TextButton(
        //   onPressed: () async {
        //     final canSubmit = _formKey.currentState!.validate();
        //     if (canSubmit) {
        //       await Question.create(
        //         folderId: folder.uid,
        //         uuid: const Uuid().v4(),
        //         text: questionController.text,
        //         priority: priorityValue.value,
        //         answer: Answer.data(
        //           text: answerController.text,
        //         ),
        //       );
        //       Navigator.pop(context);
        //     }
        //   },
        //   child: const Text('Save'),
        // ),