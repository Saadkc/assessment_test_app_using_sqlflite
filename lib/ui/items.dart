import 'package:assessment_app/services/database.dart';
import 'package:assessment_app/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/item_model.dart';

class ItemScreen extends StatefulWidget {
  final SqlDatabaseService db;
  final Item? item;
  final bool isEdit;
  const ItemScreen(
      {super.key, this.item, required this.db, required this.isEdit});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  @override
  void initState() {
    if (widget.item != null) {
      itemNameController.text = widget.item!.itemName;
      itemPriceController.text = widget.item!.itemPrice.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
            child: TextFormField(
              controller: itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
            child: TextFormField(
              controller: itemPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Item Price',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 32, right: 32),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (itemNameController.text.isNotEmpty &&
                      itemPriceController.text.isNotEmpty) {
                    if (!widget.isEdit) {
                      widget.db
                          .insertItem(
                              itemName: itemNameController.text,
                              itemPrice: int.parse(itemPriceController.text))
                          .then((value) => showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.success(
                                  message: 'Item Added Successfully',
                                ),
                              ));

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else {
                      widget.db
                          .updateItem(
                              id: widget.item!.id!,
                              itemName: itemNameController.text,
                              itemPrice: int.parse(itemPriceController.text))
                          .then((value) => showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.success(
                                  message: 'Item Updated Successfully',
                                ),
                              ));

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.info(
                        message: 'Please fill all the fields',
                      ),
                    );
                  }
                },
                child: Text(
                  widget.isEdit ? "Update" : "Save",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
