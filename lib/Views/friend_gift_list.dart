import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/friend_gift_list_controller.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:intl/intl.dart';

class FriendGiftListPage extends StatefulWidget {
  const FriendGiftListPage({super.key});
  @override
  State<FriendGiftListPage> createState() => _FriendGiftListPageState();
}

class _FriendGiftListPageState extends State<FriendGiftListPage> {
  late FriendGiftListController _controller;

  Future _pledgeGift(Gift gift) async {
    String? result = await _controller.pledgeGift(gift);
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      return;
    }
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    _controller =
        ModalRoute.of(context)!.settings.arguments as FriendGiftListController;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Friend\'s Gift List'),
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
                  _controller.event.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                    'Date: ${DateFormat.yMd().format(_controller.event.date)}'),
                Text('Location: ${_controller.event.location}'),
                Text('Description: ${_controller.event.description}'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Gift>>(
              future: _controller.gifts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No gifts found'));
                }
                final gifts = snapshot.data!;
                Color getStatusColor(String status) {
                  switch (status) {
                    case 'pledged':
                      return Colors.greenAccent;
                    case 'purchased':
                      return Colors.redAccent;
                    case 'available':
                    default:
                      return Colors.lightBlueAccent;
                  }
                }

                return ListView.builder(
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: getStatusColor(gift.status),
                        child: ListTile(
                          leading: Image.network(
                            gift.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(gift.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: ${gift.description}'),
                              Text('Category: ${gift.category}'),
                              Text(
                                  'Price: EGP${gift.price.toStringAsFixed(2)}'),
                              Text('Status: ${gift.status}'),
                            ],
                          ),
                          trailing: gift.status == "available"
                              ? ElevatedButton(
                                  onPressed: () => _pledgeGift(gift),
                                  child: Text('Pledge'),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
