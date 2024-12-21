import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:uuid/uuid.dart';

abstract class EventDetailsController {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late final String pageTitle;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? pickedDate;

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? locationValidator(String? location) {
    if (location == null || location.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? descriptionValidator(String? description) {
    if (description == null || description.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  Future<String?> publishEvent();
}

class AddEventController extends EventDetailsController {
  AddEventController() {
    pageTitle = 'Add new event';
  }
  @override
  Future<String?> publishEvent() async {
    if (!formKey.currentState!.validate()) {
      return 'FormValidationError';
    }
    if (pickedDate == null) {
      return 'Date is required';
    }

    Event event = Event(
      id: Uuid().v4(),
      name: nameController.text,
      date: pickedDate!,
      location: locationController.text,
      description: descriptionController.text,
      userId: userId,
    );
    return EventFirebaseDAO.insertEvent(event);
  }
}

class UpdateEventController extends EventDetailsController {
  Event event;
  UpdateEventController({required this.event}) {
    pageTitle = 'Edit this event';
    nameController.text = event.name;
    locationController.text = event.location;
    descriptionController.text = event.description;
    pickedDate = event.date;
  }

  @override
  Future<String?> publishEvent() async {
    if (!formKey.currentState!.validate()) {
      return 'FormValidationError';
    }
    if (pickedDate == null) {
      return 'Date is required';
    }

    event.name = nameController.text;
    event.date = pickedDate!;
    event.location = locationController.text;
    event.description = descriptionController.text;
    return EventFirebaseDAO.updateEvent(userId, event);
  }
}
