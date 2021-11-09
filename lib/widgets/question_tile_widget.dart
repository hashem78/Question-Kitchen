import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/models/question/question.dart';

class QuestionTileWidget extends HookWidget {
  const QuestionTileWidget({
    Key? key,
    required this.question,
  }) : super(key: key);
  final Question question;

  @override
  Widget build(BuildContext context) {
    final shown = useValueNotifier(false);
    return ListTile(
      title: Text(question.text),
      onTap: () => shown.value = !shown.value,
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return HookBuilder(builder: (context) {
              final questionController = useTextEditingController(
                text: question.text,
              );
              final answerController = useTextEditingController(
                text: question.answer.text,
              );
              return AlertDialog(
                title: const Text('Edit Question'),
                content: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Question'),
                          TextField(
                            controller: questionController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Answer'),
                          TextField(
                            controller: answerController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await question.update(
                        newText: questionController.text,
                        newAnswer: answerController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            });
          },
        );
      },
      subtitle: useValueListenable(shown) ? Text(question.answer.text) : null,
      trailing: IconButton(
        onPressed: () async {
          final shouldRemove = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                    'Are you sure you want to remove this question?'),
                content: const Text(
                    'Please be aware that this action is irreversiable'),
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
                content: const Text('Removed Question'),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              ),
            );
            final closeReason = await controller.closed;
            if (closeReason != SnackBarClosedReason.action) {
              question.delete();
            }
          }
        },
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }
}
