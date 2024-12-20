import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/event_details_controller.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});
  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late EventDetailsController _controller;

  Future _publish() async {
    String? result = await _controller.publishEvent();
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event published successfully')));
      Navigator.pop(context);
    } else if (result == 'FormValidationError') {
      return;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Future _setDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _controller.pickedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _controller.pickedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EventDetailsController?;
    _controller = args ?? AddEventController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _controller.pageTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _controller.nameController,
                      validator: _controller.nameValidator,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _controller.locationController,
                      validator: _controller.locationValidator,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _controller.descriptionController,
                      validator: _controller.descriptionValidator,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _setDate,
                      child: Text(
                        _controller.pickedDate == null
                            ? 'Pick a date'
                            : 'Selected date: ${DateFormat.yMd().format(_controller.pickedDate!)}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _publish,
                      child: Text('Save & Publish'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
