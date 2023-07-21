import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  void logOut(WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    authController.logOut();
  }

  void navigateToUserProfileScreen(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.watch(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 70,
              ),
            ),
            Text(
              'u/${user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My profile'),
              onTap: () {
                navigateToUserProfileScreen(context, user.uid);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              title: const Text('Log out'),
              onTap: () {
                logOut(ref);
              },
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).thememode ==
                  ThemeMode.dark,
              /**this looks at the value of theme Mode from it's provider
               * by use of getter to access the private _themeMode*/
              onChanged: (value) {
                toggleTheme(ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
