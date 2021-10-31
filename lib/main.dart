// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/models/answer/answer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.montserratTextTheme(),
          ),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> _submit(String questionText, String answerText) async {
    final valid = formKey.currentState!.validate();
    if (valid) {
      Question.addQuestion(
        Question.data(
          text: questionText,
          answer: Answer.data(
            text: answerText,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyC,
        ): () async {
          await _showBottomSheet(context);
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await _showBottomSheet(context);
            },
          ),
          body: SafeArea(
            child: StreamBuilder<List<Question>>(
              stream: Question.fetchQuestions(),
              initialData: const [],
              builder: (BuildContext context,
                  AsyncSnapshot<List<Question>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final questions = snapshot.requireData;
                if (questions.isEmpty) {
                  return Center(child: Text("There are no questions"));
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return questions[index].when(
                      data: (text, answer) {
                        return ListTile(
                          title: Text(text),
                          subtitle: Text(answer.text),
                          trailing: IconButton(
                            onPressed: () async {
                              await Question.removeQuestion(text);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                      error: (error) {
                        return Text(error.toString());
                      },
                    );
                  },
                  itemCount: questions.length,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return HookBuilder(
          builder: (context) {
            final questionController = useTextEditingController();
            final answerController = useTextEditingController();
            return CallbackShortcuts(
              bindings: {
                LogicalKeySet(
                  LogicalKeyboardKey.control,
                  LogicalKeyboardKey.keyS,
                ): () => _submit(
                      questionController.text,
                      answerController.text,
                    )
              },
              child: Focus(
                autofocus: true,
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
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText:
                                'What is the weather when the climate is tropic ?',
                          ),
                          validator: _validateField,
                        ),
                        TextFormField(
                          controller: answerController,
                          decoration: InputDecoration(
                            hintText: 'It should be hotter than 50c',
                          ),
                          validator: _validateField,
                        ),
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        ElevatedButton(
                          onPressed: () => _submit(
                            questionController.text,
                            answerController.text,
                          ),
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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
