import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text("messages",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        centerTitle:false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
            onPressed: () {  },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(5),
            child:ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentContact('berry',context)

              ],
            ) ,
          )
        ],
      ),
    );
  }
}

Widget _buildRecentContact(String name,BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Use backgroundImage for NetworkImage
        ),
        const SizedBox(height: 5), // Added const here as SizedBox doesn't depend on any variables
        Text(
          "test",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}