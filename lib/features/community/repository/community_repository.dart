import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_two/core/constants/firebase_constants.dart';
import 'package:reddit_clone_two/core/failure.dart';
import 'package:reddit_clone_two/core/providers/firebase_providers.dart';
import 'package:reddit_clone_two/core/type_defs.dart';
import 'package:reddit_clone_two/models/community_model.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
  ),
);

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _communities =>
      _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(CommunityModel community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();

      ///this gets the
      ///name of the community
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(
        _communities.doc(community.name).set(
              community.toMap(),
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

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayUnion([userId]),
          },
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

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayRemove([userId]),
          },
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

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities.add(
          CommunityModel.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) =>
              CommunityModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var community in event.docs) {
        communities.add(
          CommunityModel.fromMap(community.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {'mods': uids},///Here we don't use FieldValue.addArray as it is
          ///to have totally new list
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
