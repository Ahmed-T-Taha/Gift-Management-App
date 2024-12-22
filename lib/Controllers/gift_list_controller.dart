import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:gift_management_app/Models/local_db.dart';

class GiftListController {
  late final String _userId;
  Event event;

  GiftListController({required this.event}) {
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<Gift>> get gifts async {
    return await GiftFirebaseDAO.getEventGifts(_userId, event.id);
  }

  Future deleteGift(Gift gift) async {
    GiftLocalDAO.deleteGift(gift.id);
    await GiftFirebaseDAO.deleteGift(_userId, gift);
  }
}
