import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:gift_management_app/Models/local_db.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

abstract class GiftDetailsController {
  late final String pageTitle;
  late final String eventId;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();

  GiftDetailsController({required this.eventId});

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? descriptionValidator(String? description) {
    if (description == null || description.isEmpty) {
      return "Description cannot be empty";
    }
    return null;
  }

  String? categoryValidator(String? category) {
    if (category == null || category.isEmpty) {
      return "Category cannot be empty";
    }
    return null;
  }

  String? priceValidator(String? priceString) {
    if (priceString == null || priceString.isEmpty) {
      return "Price cannot be empty";
    }
    double? price = double.tryParse(priceString);
    if (price == null) {
      return "Price must only contain digits and an optional decimal point";
    }
    if (price <= 0) {
      return "Price must best positive";
    }
    return null;
  }

  Future<bool> validImageUrl(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) {
      return true;
    }
    final response = await http.head(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<String?> publishGift();
}

class AddGiftController extends GiftDetailsController {
  AddGiftController(String eventId) : super(eventId: eventId) {
    pageTitle = 'Add new gift';
  }

  @override
  Future<String?> publishGift() async {
    if (!formKey.currentState!.validate()) {
      return 'FormValidationError';
    }
    if (!(await validImageUrl(imageUrlController.text))) {
      return 'Image url can not be accessed. Please enter valid url or leave field empty';
    }

    Gift gift = Gift(
      id: Uuid().v4(),
      name: nameController.text,
      description: descriptionController.text,
      category: categoryController.text,
      price: double.parse(priceController.text),
      imageUrl: imageUrlController.text.isEmpty
          ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuRAosUbmHVJSkVTPODO0duKzDc9_AlJWx0Q&s'
          : imageUrlController.text,
      status: 'available',
      buyerId: null,
      eventId: eventId,
    );
    final userId = FirebaseAuth.instance.currentUser!.uid;
    GiftLocalDAO.insertGift(gift);
    return await GiftFirebaseDAO.insertGift(userId, gift);
  }
}

class UpdateGiftController extends GiftDetailsController {
  Gift gift;
  UpdateGiftController({required this.gift}) : super(eventId: gift.eventId) {
    nameController.text = gift.name;
    descriptionController.text = gift.description;
    categoryController.text = gift.category;
    priceController.text = gift.price.toString();
    imageUrlController.text = gift.imageUrl;
    pageTitle = 'Edit this gift';
  }

  @override
  Future<String?> publishGift() async {
    if (!formKey.currentState!.validate()) {
      return 'FormValidationError';
    }

    gift.name = nameController.text;
    gift.description = descriptionController.text;
    gift.category = categoryController.text;
    gift.price = double.parse(priceController.text);
    gift.imageUrl = imageUrlController.text;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    GiftLocalDAO.updateGift(gift);
    return await GiftFirebaseDAO.updateGift(userId, gift);
  }
}
