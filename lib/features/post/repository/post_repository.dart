import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_two/core/constants/firebase_constants.dart';
import 'package:reddit_clone_two/core/failure.dart';
import 'package:reddit_clone_two/core/providers/firebase_providers.dart';
import 'package:reddit_clone_two/core/type_defs.dart';
import 'package:reddit_clone_two/models/community_model.dart';
import 'package:reddit_clone_two/models/post_model.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firebaseFirestore: ref.watch(firebaseFirestoreProvider),
  ),
);

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(PostModel post) async {
    try {
      return right(
        _posts.doc(post.id).set(
              post.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    return _posts
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
