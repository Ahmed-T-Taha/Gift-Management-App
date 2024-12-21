import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class FriendEventListController {
  HedieatyUser friend;
  FriendEventListController({required this.friend});

  Future<List<Event>> get events async {
    return await EventFirebaseDAO.getUserEvents(friend.id);
  }
}
