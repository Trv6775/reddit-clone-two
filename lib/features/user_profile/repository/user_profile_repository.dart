import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_two/core/constants/firebase_constants.dart';
import 'package:reddit_clone_two/core/failure.dart';
import 'package:reddit_clone_two/core/providers/firebase_providers.dart';
import 'package:reddit_clone_two/core/type_defs.dart';
import 'package:reddit_clone_two/models/user_model.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firebaseFirestore: ref.watch(firebaseFirestoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(
              user.toMap(),
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
}
