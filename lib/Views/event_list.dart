import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/event_list_controller.dart';
import 'package:gift_management_app/Controllers/event_details_controller.dart';
import 'package:gift_management_app/Controllers/gift_list_controller.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:intl/intl.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});
  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventListController _controller = EventListController();

  void _goToEvent(Event event) {
    Navigator.pushNamed(
      context,
      '/gifts',
      arguments: GiftListController(event: event),
    ).then((_) => setState(() {}));
  }

  void _addNewEvent() async {
    Navigator.pushNamed(
      context,
      '/event-details',
      arguments: AddEventController(),
    ).then((_) => setState(() {}));
  }

  Future _editEvent(Event event) async {
    Navigator.pushNamed(
      context,
      '/event-details',
      arguments: UpdateEventController(event: event),
    ).then((_) => setState(() {}));
  }

  Future _deleteEvent(String eventId) async {
    _controller.deleteEvent(eventId).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _controller.events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          }
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: ListTile(
                    onTap: () => _goToEvent(event),
                    title: Text(event.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat.yMd().format(event.date)}'),
                        Text('Location: ${event.location}'),
                        Text('Description: ${event.description}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(event.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        child: Icon(Icons.add),
      ),
    );
  }
}
