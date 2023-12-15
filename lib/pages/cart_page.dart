import 'package:flutter/material.dart';
import 'package:food_delivery_apps/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_apps/pages/transaksi_done.dart';
import '../model/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    //   return PopScope(
    //       canPop: false,
    //       onPopInvoked: (bool doPop) {
    //         if (doPop) {
    //           Navigator.pop(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const HomePage(
    //                 uid: '',
    //               ),
    //             ),
    //           );
    //         }
    //       },
    // child:

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Consumer<CartModel>(
          builder: (context, value, child) {
            return const Text(
              "Shopping Cart",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/order_history');
            },
          ),
        ],
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          if (value.cartItems.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 211.0,
                  height: 70.63,
                  child: Image.asset(
                    'assets/design/images/mantap.png',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Center(
                  child: Text(
                    'Kosong nihh, pilih menu dulu yukk...',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "My Cart (${value.cartItems.length} items)",
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: value.cartItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      List<String> itemDetails = value.cartItems[index];

                      List<List<String>> identicalItems = value.cartItems
                          .where((item) => item == itemDetails)
                          .toList();

                      int quantity = identicalItems.length;

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 206, 140, 19),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              identicalItems[0][2],
                              height: 36,
                            ),
                            title: Text(
                              '${itemDetails[0]} x$quantity',
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              'Rp. ${itemDetails[1]} each',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize:
                                        12, // Adjust the font size as needed
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                  ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                Provider.of<CartModel>(context, listen: false)
                                    .removeItemFromCartByDetails(itemDetails);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 190, 129, 15),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(color: Colors.green[200]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp. ${value.calculateTotal()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Konfirmasi Pesanan",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Anda akan menyelesaikan pesanan dengan total:",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp. ${value.calculateTotal()}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Apakah Anda yakin ingin melanjutkan?",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Tidak"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Provider.of<CartModel>(context,
                                                      listen: false)
                                                  .recordOrder();
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TransaksiBerhasil(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text("Ya"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Pay Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
