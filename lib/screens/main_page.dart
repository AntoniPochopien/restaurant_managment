import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/table_element.dart';
import '../widgets/table_options_widget.dart';
import '../models/product_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedCard = -1;
  String? selectedCardId;
  int? guestNumber;
  Timestamp? lastCheck;
  List<dynamic> mealsId = [];
  late Stream<QuerySnapshot<Map<String, dynamic>>?> tableStream;
  List<ProductModel> listOfProducts = [];

  Future<void> getProducts() async {
    final CollectionReference products =
        FirebaseFirestore.instance.collection('/menu');

    DocumentSnapshot snapshot = await products.doc('products').get();
    var data = snapshot.data() as Map;
    List helpList = [];

    data.forEach((key, value) {
      helpList = value;
      helpList.forEach(
        (element) {
          Map map = Map<String, dynamic>.from(element);

          listOfProducts.add(ProductModel(
              id: map['id'], name: map['Name'], price: map['Price']));
        },
      );
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tableStream = FirebaseFirestore.instance.collection('/tables').snapshots();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final userId = routeArgs['userId'];

    return Scaffold(
      appBar: AppBar(title: Text(userId.toString())),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: TableOptionsWidget(
              listOfProducts: listOfProducts,
              selectedIndex: selectedCard,
              guestsNumber: guestNumber ?? 0,
              selectedTableId: selectedCardId,
              mealsId: mealsId,
              lastCheck: lastCheck,
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => setState(() {
                selectedCard = -1;
              }),
              child: Container(
                color: Color.fromARGB(255, 3, 68, 73),
                child: StreamBuilder(
                  stream: tableStream,
                  builder: (ctx, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final tablesDocs = streamSnapshot.data!.docs;
                    return GridView.builder(
                      itemCount: tablesDocs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCard = index;
                            selectedCardId = tablesDocs[index].id;
                            mealsId = tablesDocs[index]['orderedMealsList'];
                            guestNumber = tablesDocs[index]['guestsNumber'];
                            lastCheck = tablesDocs[index]['lastCheck'];
                            // .toDate()
                            // .millisecondsSinceEpoch;
                          });
                        },
                        child: TableElement(
                          selectedCard: selectedCard,
                          selectedItemIndex: index,
                          guestsNumber: tablesDocs[index]['guestsNumber'],
                          lastCheck: tablesDocs[index]['lastCheck'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
