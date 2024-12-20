import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/gift.dart';

class PledgedGiftsController {
  late final String _userId;
  PledgedGiftsController() {
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<PledgedGiftModel>> get pledgedGifts async {
    return await UserFirebaseDAO.getPledgedGifts(_userId);
  }

  Future<String?> unpledgeGift(PledgedGiftModel giftModel) async {
    giftModel.gift.status = 'available';
    giftModel.gift.buyerId = null;
    return GiftFirebaseDAO.updateGift(giftModel.friend.id, giftModel.gift);
  }

  Future<String?> purchaseGift(PledgedGiftModel giftModel) async {
    giftModel.gift.status = 'purchased';
    return GiftFirebaseDAO.updateGift(giftModel.friend.id, giftModel.gift);
  }
}
