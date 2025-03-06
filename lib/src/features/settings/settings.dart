import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/login.dart';
import 'package:miracle/src/features/collection/favorite_quotes.dart';
import 'package:miracle/src/features/collection/own_quotes.dart';
import 'package:miracle/src/features/settings/collection.dart';
import 'package:miracle/src/features/settings/account_info.dart';
import 'package:miracle/src/features/settings/contact_screen.dart';
import 'package:miracle/src/features/settings/manage_reminder.dart';
import 'package:miracle/src/features/settings/theme_setting.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends HookWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final deleteAccount = useState<Map<String, dynamic>>({});
    final profile = useState<Map<String, dynamic>>({});
    final isLoading = useState<bool>(true);
    final isLogin = useState<bool>(false);

    void refresh() async{
      isLoading.value = true;
      try {
        DioClient().getProfile().then((response) {
          profile.value = response['data'];
          isLogin.value=true;
        });
      } on DioError catch (e) {
        print('error code= ${e.response?.statusCode}');
        if (e.response?.statusCode == 401) {
         isLogin.value=false;
        }
      }
    }

    useEffect(() {
      refresh();
      return;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Settings',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        actions: [
          isLogin.value?
          TextButton(
            onPressed: () {
              DioClient().logout().then((value) {
                GetStorage().remove(kAccessToken);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false,
                );
              });
            },
            child: const Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.white),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
          :Container()
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          isLogin.value?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Your Quotes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CollectionSetting(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.library_books_outlined,
                ),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(
                  'Collections',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 0.05,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OwnQuotes(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.edit_outlined,
                ),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(
                  'Add Your Own',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 0.05,
                ),
              ),
              /* ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PastQuotes(),
                ),
              );
            },
            leading: const Icon(
              Icons.history,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: Text(
              'Past Quotes',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ), */
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavoriteQuotes(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.favorite_border_outlined,
                ),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(
                  'Favorites',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  height: 7,
                ),
              ),
            ],
          ):
          Container(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => isLogin.value?const AccountInfo():const Login(),
                ),
              );
            },
            leading: const Icon(
              Icons.account_circle_outlined,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: Text(
              isLogin.value?'Account Info':'Login',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ManageReminder(),
                ),
              );
            },
            leading: const Icon(
              Icons.notifications_outlined,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: Text(
              'Reminder',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ThemeSetting(),
                ),
              );
            },
            leading: const Icon(
              Icons.brightness_6_outlined,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              Share.share(
                'Hey there! Check out this app for inspiring, motivating quotes and sayings: https://play.google.com/store/apps/details?id=com.manifestmiracle.app',
              );
            },
            leading: const Icon(
              Icons.share_outlined,
            ),
            title: Text(
              'Share Manifest Miracle',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.manifestmiracle.app"));
            },
            leading: const Icon(
              Icons.thumb_up_outlined,
            ),
            title: Container(
              color: Colors.transparent,
              child: Text(
                'Leave us Feedback',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ContactUs()));
            },
            leading: const Icon(
              Icons.call,
            ),
            title: Container(
              color: Colors.transparent,
              child: Text(
                'Contact Us',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),

          /* ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Widgets(),
                ),
              );
            },
            leading: const Icon(
              Icons.widgets_outlined,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: Text(
              'Widget',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ), */

          ListTile(
            onTap: () {
              launchUrl(Uri.parse(kUrlPrivacyPolicy));
            },
            leading: const Icon(Icons.privacy_tip),
            title: Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse(kUrlTnC));
              // launchUrl(Uri.parse(kUrlTnC));
            },
            leading: const Icon(Icons.file_copy_outlined),
            title: Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse(kUrlRefundPolicy));
            },
            leading: const FaIcon(FontAwesomeIcons.handHoldingDollar),
            title: Text(
              'Refund Policy',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          isLogin.value?
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete Account"),
                    content: const Text("Are you sure to delete your account permanently?"),
                    actions:<Widget> [

                         Padding(
                           padding: const EdgeInsets.only(right: 10, bottom: 10),
                           child: Container(
                             color: Colors.transparent,
                             width: 100,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 GestureDetector(
                                   onDoubleTap: (){},
                                     onTap: (){
                                      Navigator.pop(context);
                                     },
                                     child: const Text('No',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.w500
                                     ),)
                                 ),

                                 GestureDetector(
                                     onDoubleTap: (){},
                                     onTap: (){
                                       DioClient().deleteAccount().then((response) {
                                         // deleteAccount.value = response['data'];
                                         GetStorage().remove(kProfileData);
                                         // print("${response['data']}");
                                         ScaffoldMessenger.of(context).showSnackBar(
                                           const SnackBar(
                                             content: Text('Account Deleted Successfully'),
                                             duration: Duration(seconds: 3),
                                           ),
                                         );
                                         Navigator.of(context).pushAndRemoveUntil(
                                           MaterialPageRoute(
                                             builder: (context) => const Login(),
                                           ),
                                               (route) => false,
                                         );
                                       });
                                     },
                                     child: const Text('Yes',
                                       style: TextStyle(
                                           color: Colors.black,
                                           fontSize: 20,
                                           fontWeight: FontWeight.w500
                                       ),)
                                 ),
                               ],
                             ),
                           ),
                         ),


                    ],
                  );
                },
              );
            },
            leading: const FaIcon(FontAwesomeIcons.userSlash, color: Colors.red,size: 20,),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
          ):
          Container(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 0.05,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    launchUrlString(
                        'https://www.facebook.com/profile.php?id=100089043415393&mibextid=ZbWKwL');
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.indigo,
                  )),
              IconButton(
                onPressed: () {          launchUrlString(
                    'https://instagram.com/miracle.manifest1?igshid=ZDdkNTZiNTM=');},
                icon: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Colors.pink,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.twitter,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
