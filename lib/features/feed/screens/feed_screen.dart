import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/common/error_text.dart';
import 'package:reddit_clone_two/core/common/loader.dart';
import 'package:reddit_clone_two/core/common/post_card.dart';
import 'package:reddit_clone_two/features/community/controller/community_controller.dart';
import 'package:reddit_clone_two/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUserCommunitiesProvider).when(
          data: (communities) {
            return ref
                .watch(
                  fetchUserPostsProvider(communities),
                )
                .when(
                  data: (posts) {
                    //designing the posts
                    return ListView.builder(itemCount: posts.length,itemBuilder: (context, index) {
                      final post=posts[index];
                      return PostCard(post: post);
                    },);
                  },
                  error: (error, stackTrace) {
                    // print(error);
                       return ErrorText(
                          error: error.toString(),
                        );
                  },
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
