import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/friend_event_list_controller.dart';
import 'package:gift_management_app/Controllers/home_controller.dart';
import 'package:gift_management_app/Models/friend.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  void _signOut() async {
    _controller.signOut().then((_) => Navigator.pushReplacementNamed(
          context,
          '/login',
        ));
  }

  void _goToFriendEvents(HedieatyUser friend) async {
    Navigator.pushNamed(
      context,
      '/friend-events',
      arguments: FriendEventListController(friend: friend),
    ).then((_) => setState(() {}));
  }

  void _addNewFriend() async {
    showDialog(
      context: context,
      builder: (context) {
        final phoneController = TextEditingController();
        return AlertDialog(
          title: Text('Add New Friend'),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String? result =
                    await _controller.addUserByPhone(phoneController.text);
                if (result != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                } else {
                  setState(() {});
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Hedieaty'),
        actions: [ElevatedButton(onPressed: _signOut, child: Text('Sign out'))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/pledged-gifts')
                    .then((_) => setState(() {}));
              },
              child: Text('Manage Your Pledged Gifts'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/events')
                    .then((_) => setState(() {}));
              },
              child: Text('Go to Your Events'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<HomePageFriendModel>>(
              future: _controller.friends,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No friends found'));
                }
                final friends = snapshot.data!;
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friendModel = friends[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: ListTile(
                          onTap: () => _goToFriendEvents(friendModel.friend),
                          title: Text(friendModel.friend.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone: ${friendModel.friend.phone}'),
                              Text(
                                  'Upcoming Events: ${friendModel.eventCount}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFriend,
        child: Icon(Icons.add),
      ),
    );
  }
}
