import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:miracle/src/widget/input_card.dart';

class Reminder extends ConsumerStatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  ConsumerState<Reminder> createState() => _ReminderState();
}

class _ReminderState extends ConsumerState<Reminder> {
  String startAt = '09:30';
  String endAt = '21:30';
  int howMany = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(
                  'assets/images/img-2.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Set Daily Motivation Reminder',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InputCard(
                  heading: 'How Many',
                  options: kNotificationFrequency,
                  initialValue: '$howMany X',
                  onValueChanged: (index, value) {
                    setState(() {
                      howMany = index + 1;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InputCard(
                  heading: 'Start At',
                  options: kNotificationReminderOptions,
                  initialValue: startAt,
                  onValueChanged: (index, value) {
                    startAt = value;
                  },
                ),
              ),
              Opacity(
                opacity: howMany > 1 ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InputCard(
                    heading: 'End At',
                    options: kNotificationReminderOptions,
                    initialValue: endAt,
                    onValueChanged: (index, value) {
                      endAt = value;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
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
                  GetStorage().write(kNotificationEndAt, endAt);

                  if (!isValidStartEndTime) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(errorMessage),
                    ));
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectCategory(),
                    ),
                  );
                },
                label: 'Continue',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
