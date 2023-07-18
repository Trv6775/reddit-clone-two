import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/common/error_text.dart';
import 'package:reddit_clone_two/core/common/loader.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/features/community/controller/community_controller.dart';


class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  int counter = 0;

  void saveMods() {
    final communityController = ref.read(communityControllerProvider.notifier);
    communityController.addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              saveMods();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (context, index) {
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                        data: (user) {
                          if (community.mods.contains(member) && counter == 0) {
                            uids.add(member);
                          }
                          counter++;
                          return CheckboxListTile(
                            value: uids.contains(member),
                            onChanged: (value) {
                              if (value!) {
                                addUid(member);
                              } else {
                                removeUid(member);
                              }
                            },
                            title: Text(user.name),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
