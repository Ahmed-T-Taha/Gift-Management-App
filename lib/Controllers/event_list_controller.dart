import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/local_db.dart';

class EventListController {
  late final String _userId;
  EventListController() {
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }
  Future<List<Event>> get events async {
    return await EventFirebaseDAO.getUserEvents(_userId);
  }

  Future deleteEvent(String eventId) async {
    await EventLocalDAO.deleteEvent(eventId);
    await EventFirebaseDAO.deleteEvent(_userId, eventId);
  }
}
