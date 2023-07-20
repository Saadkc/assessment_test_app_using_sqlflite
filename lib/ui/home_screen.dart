import 'package:assessment_app/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../services/database.dart';
import 'items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Item>>? items;
  final db = SqlDatabaseService();

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  void fetchItems() {
    items = db.fetchItem();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemScreen(
                          db: db,
                          isEdit: false,
                        )));
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Item>>(
          future: items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(!snapshot.hasData) {
              return const Center(child: Text('No Items Added'));
            } else {
              final itemData = snapshot.data!;

              return itemData.isEmpty
                  ? const Center(
                      child: Text('No Items Added'),
                    )
                  : ListView.builder(
                      itemCount: itemData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16, right: 16),
                          child: Card(
                            color: Colors.grey[200],
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                    itemData[index].itemName[0].toUpperCase()),
                              ),
                              title: Text(itemData[index].itemName),
                              subtitle: Text("Rs ${itemData[index].itemPrice}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ItemScreen(
                                                    db: db,
                                                    item: itemData[index],
                                                    isEdit: true,
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      db
                                          .deleteItem(itemData[index].id!)
                                          .then((value) => showTopSnackBar(
                                                Overlay.of(context),
                                                const CustomSnackBar.success(
                                                  message: 'Item Deleted',
                                                ),
                                              ));
                                      fetchItems();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }
          }),
    );
  }
}
