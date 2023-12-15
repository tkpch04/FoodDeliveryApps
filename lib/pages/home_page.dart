import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/grocery_item_tile.dart';
import '../model/cart_model.dart';
import 'cart_page.dart';
// ignore: unused_import
import 'package:food_delivery_apps/utils/utils.dart';
import 'package:food_delivery_apps/model/user_model.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserModel.getUserFromFirestore(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(
                    uid: '',
                  ),
                ));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Food Delivery Apps",
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.w500,
                backgroundColor: Colors.transparent,
              ),
            ),
            backgroundColor:
                Colors.transparent, // Set the background color of the app bar
            elevation: 0.0, // Remove the shadow under the app bar
            automaticallyImplyLeading: false, // Remove the back button
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 204, 58, 0),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CartPage();
                },
              ),
            ),
            child: const Icon(Icons.shopping_bag),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 17,
                      height: 20,
                      child: Image.asset(
                        'assets/design/images/iconly-bold-location.png',
                      ),
                    ),
                    FutureBuilder<UserModel?>(
                      future: _userFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text(
                              "Lokasi Tidak Diketahui",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 1),
                                Text(
                                  snapshot.data!.lokasi ?? "N/A",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize:
                                            17, // Adjust the font size as needed
                                      ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      width: 14,
                      height: 15,
                      child: Image.asset(
                        'assets/design/images/iconly-light-arrow-down-2-pcZ.png',
                      ),
                    ),
                  ],
                ),
              ),
              // ...

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4.69, 4.69, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 204,
                        ),
                        child: Text(
                          'Order your food  Fast and Free',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 27, // Adjust the font size as needed
                                fontWeight: FontWeight.w500,
                                height: 1.1725,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: SizedBox(
                        width: 211.0,
                        height: 70.63,
                        child: Image.asset(
                          'assets/design/images/delivery-1.png',
                          width: 10,
                          height: 2,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20), // Adjust the spacing here

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 18, // Adjust the font size as needed
                        fontWeight: FontWeight.w500,
                        height: 1.1725,
                        color: const Color.fromARGB(255, 255, 153, 0),
                      ),
                ),
              ),

              Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 180, 112, 47),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '🍔 Burger',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1725,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(),
              ),
              Expanded(
                child: Consumer<CartModel>(
                  builder: (context, value, child) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      physics: const ScrollPhysics(),
                      itemCount: value.shopItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return GroceryItemTile(
                          itemName: value.shopItems[index][0],
                          itemPrice: value.shopItems[index][1],
                          imagePath: value.shopItems[index][2],
                          color: value.shopItems[index][3],
                          description: value.shopItems[index][4],
                          onPressed: () => Provider.of<CartModel>(
                            context,
                            listen: false,
                          ).addItemToCart(index),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
