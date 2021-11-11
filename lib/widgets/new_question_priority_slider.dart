import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:question_kitchen/models/question/question.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final priorityValue = useValueNotifier(QuestionPriority.none);
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
