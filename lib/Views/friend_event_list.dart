import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/friend_event_list_controller.dart';
import 'package:gift_management_app/Controllers/friend_gift_list_controller.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:intl/intl.dart';

class FriendEventListPage extends StatefulWidget {
  const FriendEventListPage({super.key});
  @override
  State<FriendEventListPage> createState() => _FriendEventListPageState();
}

class _FriendEventListPageState extends State<FriendEventListPage> {
  late FriendEventListController _controller;

  void _goToEvent(Event event) {
    Navigator.pushNamed(
      context,
      '/friend-gifts',
      arguments:
          FriendGiftListController(friend: _controller.friend, event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller =
        ModalRoute.of(context)!.settings.arguments as FriendEventListController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Friend\'s Event List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Friend Info:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('Name: ${_controller.friend.name}'),
                Text('Email: ${_controller.friend.email}'),
                Text('Phone: ${_controller.friend.phone}'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Event>>(
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
                              Text('Date: ${DateFormat().format(event.date)}'),
                              Text('Location: ${event.location}'),
                              Text('Description: ${event.description}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
