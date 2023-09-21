import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/data/model/category.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:miracle/src/widget/tag.dart';

import '../auth/login.dart';

class Mine extends HookWidget {
  const Mine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final motivations = useState<List<Category>>([]);
    final affirmations = useState<List<Category>>([]);
    final selectedCategory = GetStorage().read<String>(kSelectedCategories);
    final selected = useState<List<int>>(selectedCategory?.split(',').map((e) => int.parse(e)).toList() ?? []);

    refresh() async {
      isLoading.value = true;
      final response = await DioClient().getCategories();
      final categories = response.data;
      motivations.value =
          categories.where((element) => element.type == 'motivation').toList();
      affirmations.value =
          categories.where((element) => element.type == 'affirmation').toList();

      isLoading.value = false;
    }

    toggle(int id) {
      if (selected.value.contains(id)) {
        selected.value =
            selected.value.where((element) => element != id).toList();
      } else {
        selected.value = [...selected.value, id];
      }
    }

    useEffect(() {
      if(selectedCategory!=null){
        refresh();
      }
      return;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Mine'),
        centerTitle: true,
      ),
      body:selectedCategory!=null?
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            if (isLoading.value)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (!isLoading.value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Affirmation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8 / .30,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: affirmations.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            toggle(affirmations.value[index].id);
                          },
                          child: Tag(
                            tag: affirmations.value[index].name,
                            isSelected: selected.value.contains(
                              affirmations.value[index].id,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Motivation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                            childAspectRatio: 0.8 / .30,
                            crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: motivations.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            toggle(motivations.value[index].id);
                          },
                          child: Tag(
                            tag: motivations.value[index].name,
                            isSelected: selected.value.contains(
                              motivations.value[index].id,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GradientButton(
                        onPressed: () {
                          if (selected.value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Select At least one'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                          final data = {
                            'preferences': selected.value.join(',')
                          };

                          DioClient().updatePreference(data).then((value) {
                            GetStorage().write(
                              kSelectedCategories,
                              selected.value.join(','),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Updated successfully'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          });
                        },
                        label: 'Save',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ):
      Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 25),
              child:Text(
                'Please login for Affirmation and customization',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),
              ) ,),
            const SizedBox(
              height: 16,
            ),
            GradientButton(
              label: 'Continue',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
          ],
        ) ,
      ),
    );
  }
}
