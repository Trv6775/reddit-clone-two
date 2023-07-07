import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_two/core/constants/constants.dart';
import 'package:reddit_clone_two/core/utils.dart';
import 'package:reddit_clone_two/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_two/features/community/repository/community_repository.dart';
import 'package:reddit_clone_two/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =StateNotifierProvider<CommunityController,bool>((ref) {
  final communityRepository=  ref.watch(communityRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});

final getUserCommunitiesProvider=StreamProvider((ref) {
  final communityController=ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider=StreamProvider.family((ref,String name) {
  final communityController=ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
        super(false); //loading not true

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    CommunityModel community = CommunityModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
    state = false; //loading finished
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }
  Stream<List<CommunityModel>>getUserCommunities(){
    final uid=_ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}
