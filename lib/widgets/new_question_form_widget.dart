import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/models/answer/answer.dart';
import 'package:question_kitchen/models/folder/questionfolder.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class NewQuestionFormWidget extends HookWidget {
  NewQuestionFormWidget({
    Key? key,
    required this.folder,
  }) : super(key: key);
  final QuestionFolder folder;

  final GlobalKey<FormState> formKey = GlobalKey();
  Future<void> _submit(
    BuildContext context,
    String questionText,
    String answerText,
  ) async {
    final valid = formKey.currentState!.validate();
    if (valid) {
      folder.addQuestion(
        Question.data(
          text: questionText,
          uuid: const Uuid().v4(),
          answer: Answer.data(
            text: answerText,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionController = useTextEditingController();
    final answerController = useTextEditingController();
    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.f2,
        ): () => _submit(
              context,
              questionController.text,
              answerController.text,
            )
      },
      child: Form(
        key: formKey,
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
              Text(
                'New Question',
                style: TextStyle(
                  fontSize: 50.sp,
                ),
              ),
              TextFormField(
                controller: questionController,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'What is the weather when the climate is tropic ?',
                ),
                validator: _validateField,
              ),
              TextFormField(
                maxLines: null,
                controller: answerController,
                decoration: const InputDecoration(
                  hintText: 'It should be hotter than 50c',
                ),
                validator: _validateField,
              ),
              SizedBox(
                height: 0.01.sh,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _submit(
                      context,
                      questionController.text,
                      answerController.text,
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateField(value) {
    if (value == null || value == '') {
      return "This field can't be empty";
    }
    if (value.length < 10) {
      return "Field needs to be more than 10 characters";
    }
    return null;
  }
}
