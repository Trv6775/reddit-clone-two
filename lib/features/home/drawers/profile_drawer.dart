import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  void logOut(WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    authController.logOut();
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
              onTap: () {},
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
              value: true,
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
  }
}
