import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/common/error_text.dart';
import 'package:reddit_clone_two/core/common/loader.dart';
import 'package:reddit_clone_two/core/utils.dart';
import 'package:reddit_clone_two/features/community/controller/community_controller.dart';
import 'package:reddit_clone_two/features/post/controller/post_controller.dart';
import 'package:reddit_clone_two/models/community_model.dart';
import 'package:reddit_clone_two/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  File? bannerFile;
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<CommunityModel> communities = [];
  CommunityModel? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        file: bannerFile,
      );
    } else if (widget.type == 'text' &&
        titleController.text
            .isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        description: descriptionController.text.trim(),
      );
    } else if (widget.type == 'link' &&
        titleController.text
            .isNotEmpty &&
        linkController.text
            .trim()
            .isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        link: linkController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: () {
              sharePost();
            },
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title here',
                filled: true,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeImage)
              GestureDetector(
                onTap: () {
                  selectBannerImage();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(9),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: currentTheme.textTheme.bodyMedium!.color!,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: bannerFile != null
                        ? Image.file(bannerFile!)
                        : Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: currentTheme
                            .textTheme.bodyMedium!.color!,
                      ),
                    ),
                  ),
                ),
              ),
            if (isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter description here',
                  filled: true,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 6,
              ),
            if (isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter link here',
                  filled: true,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Select Community'),
            ),
            ref.watch(getUserCommunitiesProvider).when(
              data: (data) {
                communities = data;
                if (data.isEmpty) {
                  return const SizedBox();
                }
                return DropdownButton(
                  value: selectedCommunity ?? data[0],
                  items: data.map(
                        (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value;
                    });
                  },
                );
              },
              error: (error, stackTrace) =>
                  ErrorText(
                    error: error.toString(),
                  ),
              loading: () => const Loader(),
            )
          ],
        ),
      ),
    );
  }
}
