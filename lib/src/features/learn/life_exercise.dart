import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/exercise.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LifeExerciseScreen extends HookWidget {
  const LifeExerciseScreen({Key? key, required this.exercise})
      : super(key: key);
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        backgroundColor: primaryColor,
        title: Text(exercise.title,
        style: const TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SfPdfViewer.network('${kBaseUrl}pdf/life/${exercise.exercise}'),
      ),
    );
  }
}
