import 'package:gift_management_app/Models/hedieaty_user.dart';

class Friend {
  String userId;
  String friendId;

  Friend({
    required this.userId,
    required this.friendId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
    };
  }

  static Friend fromMap(Map<String, dynamic> map) {
    return Friend(
      userId: map['user_id'] as String,
      friendId: map['friend_id'] as String,
    );
  }
}

class HomePageFriendModel {
  HedieatyUser friend;
  int eventCount;

  HomePageFriendModel({
    required this.friend,
    required this.eventCount,
  });
}
