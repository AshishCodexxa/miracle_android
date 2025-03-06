import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/reminder.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/widget/input_card.dart';

class EditReminder extends ConsumerStatefulWidget {
  const EditReminder({Key? key, required this.reminder}) : super(key: key);

  final Reminder reminder;

  @override
  ConsumerState<EditReminder> createState() => _EditReminderState();
}

class _EditReminderState extends ConsumerState<EditReminder> {
  List<int> selectedDays = [];
  String startAt = '';
  String endAt = '';
  int howMany = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
          leading: const Icon(Icons.arrow_back,
            color: Colors.white,),
          title: const Text('Reminders',
        style: TextStyle(
          color: Colors.white
        ),),
          actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        )
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Type of quote'),
                const Spacer(),
                Row(
                  children: const [
                    Text('Type of quote'),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            InputCard(
              heading: 'How Many',
              options: kNotificationFrequency,
              initialValue: '$howMany X',
              onValueChanged: (index, value) {
                howMany = index + 1;
              },
            ),
            InputCard(
              heading: 'Start At',
              options: kNotificationReminderOptions,
              initialValue: startAt,
              onValueChanged: (index, value) {
                startAt = value;
              },
            ),
            InputCard(
              heading: 'End At',
              options: kNotificationReminderOptions,
              initialValue: endAt,
              onValueChanged: (index, value) {
                endAt = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var day in kWeekDays.entries)
                  GestureDetector(
                    onTap: () {
                      selectedDays.contains(day.value)
                          ? selectedDays.remove(day.value)
                          : selectedDays.add(day.value);

                      setState(() {});
                    },
                    child: ReminderDay(
                      day: day.key,
                      isSelected: selectedDays.contains(day.value),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Sound'),
                const Spacer(),
                Row(
                  children: const [
                    Text('Type of quote'),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderDay extends StatelessWidget {
  const ReminderDay({Key? key, required this.day, required this.isSelected})
      : super(key: key);

  final String day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.tertiaryContainer;
    final selectedTextColor = Theme.of(context).colorScheme.onTertiaryContainer;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? selectedColor : null,
          border: Border.all(color: selectedColor, width: 2)),
      child: Center(
        child: Text(
          day,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: isSelected ? selectedTextColor : null),
        ),
      ),
    );
  }
}
