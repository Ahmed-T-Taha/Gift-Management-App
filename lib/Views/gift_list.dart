import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/gift_details_controller.dart';
import 'package:gift_management_app/Controllers/gift_list_controller.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:intl/intl.dart';

class GiftListPage extends StatefulWidget {
  const GiftListPage({super.key});
  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late GiftListController _controller;

  void _editGift(Gift gift) {
    Navigator.pushNamed(
      context,
      '/gift-details',
      arguments: UpdateGiftController(gift: gift),
    ).then((_) => setState(() {}));
  }

  void _addNewGift() {
    Navigator.pushNamed(
      context,
      '/gift-details',
      arguments: AddGiftController(_controller.event.id),
    ).then((_) => setState(() {}));
  }

  Future _deleteGift(Gift gift) async {
    _controller.deleteGift(gift).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _controller =
        ModalRoute.of(context)!.settings.arguments as GiftListController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Event\'s Gifts'),
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
                          trailing: gift.status == 'available'
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _editGift(gift),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteGift(gift),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
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
        onPressed: _addNewGift,
        child: Icon(Icons.add),
      ),
    );
  }
}
