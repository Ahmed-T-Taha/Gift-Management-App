import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/friend.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class HomeController {
  late final String _userId;
  HomeController() {
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<HomePageFriendModel>> get friends async {
    return await FriendFirebaseDAO.getUserFriends(_userId);
  }

  Future<String?> addUserByPhone(String phone) async {
    HedieatyUser? friend = await UserFirebaseDAO.getUserByPhone(phone);
    if (friend == null) {
      return 'No user was found with this phone number';
    }
    return await addFriend(friend.id);
  }

  Future<String?> addFriend(String friendId) async {
    return await FriendFirebaseDAO.addFriend(_userId, friendId);
  }
}
