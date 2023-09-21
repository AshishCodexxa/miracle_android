import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/data/model/category.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/home/main_screen.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:miracle/src/widget/tag.dart';

class SelectCategory extends HookWidget {
  const SelectCategory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final motivations = useState<List<Category>>([]);
    final affirmations = useState<List<Category>>([]);
    final selected = useState<List<int>>([]);

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
      refresh();
      return;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: SizeConfig.screenHeight,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 15),
          children: [
            const AspectRatio(
              aspectRatio: 3 / 2,
              child: Image(
                image: AssetImage('assets/images/img-4.png'),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'What areas of your life would you like to improve?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading.value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      'Affirmation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                        fontSize: SizeConfig.blockSizeHorizontal*5.5,
                        fontWeight: FontWeight.w600
                          ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 120,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .25 / 1.2,
                              crossAxisSpacing: 20,
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
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Motivation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          fontSize: SizeConfig.blockSizeHorizontal*5.5,
                          fontWeight: FontWeight.w600
                          ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 120,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: .25 / 1.2,
                              crossAxisSpacing: 20,
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
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GradientButton(
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
                              kSelectedCategories, selected.value.join(','));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        });
                      },
                      label: 'Continue',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
