import 'package:flutter/material.dart';
import 'package:gift_management_app/Controllers/pledged_gifts_controller.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:intl/intl.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  const MyPledgedGiftsPage({super.key});
  @override
  State<MyPledgedGiftsPage> createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final PledgedGiftsController _controller = PledgedGiftsController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Pledged Gifts'),
      ),
      body: FutureBuilder<List<PledgedGiftModel>>(
        future: _controller.pledgedGifts,
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
              final giftModel = gifts[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: getStatusColor(giftModel.gift.status),
                  child: ListTile(
                    title: Row(
                      children: [
                        Image.network(
                          giftModel.gift.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Text(giftModel.gift.name),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Friend Name: ${giftModel.friend.name}'),
                              Text('Event Name: ${giftModel.event.name}'),
                              Text(
                                  'Event Date: ${DateFormat.yMd().format(giftModel.event.date)}'),
                              Text('Status: ${giftModel.gift.status}'),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: giftModel.gift.status == 'pledged'
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      child: Text('Unpledge Gift'),
                                      onPressed: () =>
                                          _controller.unpledgeGift(giftModel),
                                    ),
                                    ElevatedButton(
                                      child: Text('Purchase Gift'),
                                      onPressed: () =>
                                          _controller.purchaseGift(giftModel),
                                    ),
                                  ],
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
