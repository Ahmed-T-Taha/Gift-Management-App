import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/friend.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class Gift {
  String id;
  String name;
  String description;
  String category;
  double price;
  String imageUrl;
  String status;
  String? buyerId;
  String eventId;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.status,
    this.buyerId,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'status': status,
      'buyer_id': buyerId,
      'event_id': eventId,
    };
  }

  static Gift fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      price: map['price'] as double,
      imageUrl: map['image_url'] as String,
      status: map['status'] as String,
      buyerId: map['buyer_id'] as String?,
      eventId: map['event_id'] as String,
    );
  }
}

class PledgedGiftModel {
  HedieatyUser friend;
  Event event;
  Gift gift;

  PledgedGiftModel({
    required this.friend,
    required this.event,
    required this.gift,
  });
}
