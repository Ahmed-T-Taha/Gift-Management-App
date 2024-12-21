import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class FriendGiftListController {
  HedieatyUser friend;
  Event event;
  FriendGiftListController({required this.friend, required this.event});

  Future<List<Gift>> get gifts async {
    return await GiftFirebaseDAO.getEventGifts(friend.id, event.id);
  }

  Future<String?> pledgeGift(Gift gift) async {
    gift.status = 'pledged';
    gift.buyerId = FirebaseAuth.instance.currentUser!.uid;
    return GiftFirebaseDAO.updateGift(friend.id, gift);
  }
}
