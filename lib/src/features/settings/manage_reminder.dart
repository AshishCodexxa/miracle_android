import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/reminder.dart';
import 'package:miracle/src/features/settings/edit_reminder.dart';
import 'package:miracle/src/service/notification_service.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:miracle/src/widget/input_card.dart';

class ManageReminder extends ConsumerWidget {
  const ManageReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int howMany = GetStorage().read<int>(kNotificationHowMany) ?? 10;
    String startAt = GetStorage().read(kNotificationStartAt) ?? '10:30';
    String endAt = GetStorage().read(kNotificationEndAt) ?? '21:30';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back,
              color: Colors.white,),
          ),
        title: const Text('Reminders',
          style: TextStyle(
            color: Colors.white
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Set Up Your Daily Routine To Make Motivation Fit Your Habits',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Roboto_Medium'),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                // boxShadow: <BoxShadow>[
              /*    BoxShadow(
                      color: Colors.black54.withOpacity(0.16),
                      blurRadius: 3,
                      offset: const Offset(4, 7))
                ],*/
                borderRadius: BorderRadius.circular(20),),
              child: InputCard(
                heading: 'How Many',
                options: kNotificationFrequency,
                initialValue: '$howMany X',
                onValueChanged: (index, value) {
                  howMany = index + 1;
                },
              ),
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
            const Spacer(),
            GradientButton(
                label: 'Save',
                onPressed: () {
                  DateTime startTime = DateFormat.Hm().parse(startAt);
                  DateTime endTime = DateFormat.Hm().parse(endAt);
                  bool isValidStartEndTime = true;
                  String errorMessage = '';

                  if (startTime.isAfter(endTime)) {
                    isValidStartEndTime = false;
                    errorMessage = 'End at must be After Start at';
                  }

                  if (startTime.isAtSameMomentAs(endTime)) {
                    isValidStartEndTime = false;
                    errorMessage = 'End at and Start at must not be same';
                  }
                  GetStorage().write(kNotificationHowMany, howMany);
                  GetStorage().write(kNotificationStartAt, startAt);
                  GetStorage().write(kNotificationEndAt, endAt).then((value) {
                    scheduleNotifications();
                  });

                  if (!isValidStartEndTime) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(errorMessage),
                      duration: const Duration(seconds: 3),
                    ));
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminder Saved Successfully'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    Key? key,
    this.reminder,
  }) : super(key: key);

  final Reminder? reminder;

  @override
  Widget build(BuildContext context) {
    if (reminder == null) return Container();

    String time = '${reminder!.startAt} - ${reminder!.endAt}';
    String howMany = reminder!.howMany;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditReminder(
              reminder: reminder!,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Every Weekday',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black38,
                  ),
                  child: Center(
                    child: Text(
                      '$howMany X',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  Switch(
                    value: false,
                    onChanged: (value) {},
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
