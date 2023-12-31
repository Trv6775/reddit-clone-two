import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone_two/core/utils.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/features/post/repository/post_repository.dart';
import 'package:reddit_clone_two/models/community_model.dart';
import 'package:reddit_clone_two/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final fetchUserPostsProvider =
    StreamProvider.family((ref, List<CommunityModel> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    state = true;//loading has started
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: '/posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );
    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final PostModel post = PostModel(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );
        final res = await _postRepository.addPost(post);
        state = false;
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, 'Post created successfully!');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]); //is an empty list
  }
}
