import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/friend.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class UserFirebaseDAO {
  static Future<String?> insertUser(HedieatyUser user) async {
    Map<String, dynamic> userMap = user.toMap();
    userMap['friends'] = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .set(userMap)
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future<List<PledgedGiftModel>> getPledgedGifts(String userId) async {
    var gifts = await FirebaseFirestore.instance
        .collectionGroup('gifts')
        .where('buyer_id', isEqualTo: userId)
        .get();

    List<PledgedGiftModel> pledgedGifts = [];
    for (var giftDoc in gifts.docs) {
      Gift gift = Gift.fromMap(giftDoc.data());

      final eventDoc = await giftDoc.reference.parent.parent!.get();
      Event event = Event.fromMap(eventDoc.data()!);

      final userDoc = await eventDoc.reference.parent.parent!.get();
      HedieatyUser user = HedieatyUser.fromMap(userDoc.data()!);

      pledgedGifts.add(PledgedGiftModel(
        friend: user,
        event: event,
        gift: gift,
      ));
    }
    return pledgedGifts;
  }

  static Future<HedieatyUser?> getUserByPhone(String phone) async {
    var usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();
    if (usersSnapshot.size != 0) {
      return HedieatyUser.fromMap(usersSnapshot.docs.first.data());
    }
    return null;
  }

  static Future<String?> updateUser(HedieatyUser user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}

class FriendFirebaseDAO {
  static Future<String?> addFriend(String userId1, String userId2) async {
    await FirebaseFirestore.instance.collection('users').doc(userId1).update({
      'friends': FieldValue.arrayUnion([userId2])
    }).catchError((e) {
      return e.message;
    });

    await FirebaseFirestore.instance.collection('users').doc(userId2).update({
      'friends': FieldValue.arrayUnion([userId1])
    }).catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future<String?> removeFriend(String userId1, String userId2) async {
    await FirebaseFirestore.instance.collection('users').doc(userId1).update({
      'friends': FieldValue.arrayRemove([userId2])
    }).catchError((e) {
      return e.message;
    });

    await FirebaseFirestore.instance.collection('users').doc(userId2).update({
      'friends': FieldValue.arrayRemove([userId1])
    }).catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future<List<HomePageFriendModel>> getUserFriends(String userId) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .catchError((e) {
      return e.message;
    });
    List<String> friendIds = List.from(userDoc.data()!['friends']);
    if (friendIds.isEmpty) {
      return <HomePageFriendModel>[];
    }
    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('id', whereIn: friendIds)
        .get();

    List<HomePageFriendModel> friends = [];
    for (var doc in users.docs) {
      var friend = HedieatyUser.fromMap(doc.data());
      int? eventCount = (await FirebaseFirestore.instance
              .collection('users')
              .doc(friend.id)
              .collection('events')
              .where('date',
                  isGreaterThan: DateTime.now().millisecondsSinceEpoch)
              .count()
              .get())
          .count;

      friends.add(HomePageFriendModel(
        friend: friend,
        eventCount: eventCount ?? 0,
      ));
    }
    return friends;
  }
}

class EventFirebaseDAO {
  static Future<String?> insertEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(event.userId)
        .collection('events')
        .doc(event.id.toString())
        .set(event.toMap())
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future<List<Event>> getUserEvents(String userId) async {
    var events = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .get();
    return events.docs.map((doc) => Event.fromMap(doc.data())).toList();
  }

  static Future<String?> updateEvent(String userId, Event event) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(event.id.toString())
        .update(event.toMap())
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future deleteEvent(String userId, String eventId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }
}

class GiftFirebaseDAO {
  static Future<String?> insertGift(String userId, Gift gift) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(gift.eventId)
        .collection('gifts')
        .doc(gift.id.toString())
        .set(gift.toMap())
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future<List<Gift>> getEventGifts(String userId, String eventId) async {
    var gifts = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .get();
    return gifts.docs.map((doc) => Gift.fromMap(doc.data())).toList();
  }

  static Future<String?> updateGift(String userId, Gift gift) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(gift.eventId)
        .collection('gifts')
        .doc(gift.id.toString())
        .update(gift.toMap())
        .catchError((e) {
      return e.message;
    });
    return null;
  }

  static Future deleteGift(String userId, Gift gift) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(gift.eventId)
        .collection('gifts')
        .doc(gift.id)
        .delete();
  }
}
