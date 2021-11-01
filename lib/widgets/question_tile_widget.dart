import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/providers.dart';

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
      subtitle: useValueListenable(shown) ? Text(question.answer.text) : null,
      trailing: IconButton(
        onPressed: () async =>
            await context.read(folderProvider).removeQuestion(question.text),
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }
}
