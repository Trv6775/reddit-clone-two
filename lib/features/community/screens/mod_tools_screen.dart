import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;

  const ModToolsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddModsScreen(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderators'),
            onTap: () {
              navigateToAddModsScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit community'),
            onTap: () {
              navigateToEditCommunityScreen(context);
            },
          ),
        ],
      ),
    );
  }
}
