import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/common/error_text.dart';
import 'package:reddit_clone_two/core/common/loader.dart';
import 'package:reddit_clone_two/core/constants/constants.dart';
import 'package:reddit_clone_two/core/utils.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  // void save(CommunityModel community) {
  //   ref.read(communityControllerProvider.notifier).editCommunity(
  //         profileFile: profileFile,
  //         bannerFile: bannerFile,
  //         context: context,
  //         community: community,
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (community) => Scaffold(
            backgroundColor:
                Pallete.darkModeAppTheme.appBarTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit community'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(9),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: Pallete
                                .darkModeAppTheme.textTheme.bodyMedium!.color!,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : community.banner.isEmpty ||
                                          community.banner ==
                                              Constants.bannerDefault
                                      ? const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          ),
                                        )
                                      : Image.network(community.banner),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileFile != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 30,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(community.profilePic),
                                    radius: 30,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}