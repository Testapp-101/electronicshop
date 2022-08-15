import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random/Screens/checkout_screen.dart';
import 'package:random/componenets/db_helper.dart';
import 'package:random/model/cart.dart';
import 'package:random/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const String id = 'cart_screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Electronic Shop'),
        actions: [
          Center(
              child: Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ));
              },
            ),
          )),
          SizedBox(
            width: 10,
          ),
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return  Visibility(
              visible:(value.getCounter()>0)?true:false,
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CheckoutScreen(),
                  ));
                },
              ),
            );
              },
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: ((context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return (Center(
                        child: Text(
                      'Cart is Empty',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    )));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                            height: height * 0.14,
                                            width: width * 0.3,
                                            image: NetworkImage(snapshot
                                                .data![index].productImage!)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.5,
                                              child: Text(
                                                snapshot
                                                    .data![index].productName!,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: width * 0.5,
                                              child: Text(
                                                ((double.parse(snapshot
                                                            .data![index]
                                                            .productPrice!)) *
                                                        127.21)
                                                    .toStringAsFixed(2),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(children: [
                                              InkWell(
                                                  onTap: () {
                                                    int quantity = snapshot
                                                        .data![index].quantity!;
                                                    int price = int.parse(
                                                        snapshot.data![index]
                                                            .initialPrice!);
                                                    quantity--;
                                                    int? newPrice =
                                                        quantity * price;

                                                    if (quantity > 0) {
                                                      dbHelper!
                                                          .updateQuantity(Cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              productId: snapshot
                                                                  .data![index]
                                                                  .productId,
                                                              productName: snapshot
                                                                  .data![index]
                                                                  .productName,
                                                              productImage: snapshot
                                                                  .data![index]
                                                                  .productImage,
                                                              initialPrice: snapshot
                                                                  .data![index]
                                                                  .initialPrice,
                                                              productPrice:
                                                                  newPrice
                                                                      .toString(),
                                                              stock: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              quantity:
                                                                  quantity))
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .initialPrice!));
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print(error.toString());
                                                      });
                                                    }
                                                  },
                                                  child: Icon(Icons.remove)),
                                              Container(
                                                height: height * 0.04,
                                                width: width * 0.2,
                                                color: Colors.blue,
                                                child: Text(
                                                    snapshot
                                                        .data![index].quantity
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    int quantity = snapshot
                                                        .data![index].quantity!;
                                                    int price = int.parse(
                                                        snapshot.data![index]
                                                            .initialPrice!);
                                                    quantity++;
                                                    int? newPrice =
                                                        quantity * price;
                                                    dbHelper!
                                                        .updateQuantity(Cart(
                                                            id: snapshot
                                                                .data![index]
                                                                .id,
                                                            productId: snapshot
                                                                .data![index]
                                                                .productId,
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName,
                                                            productImage: snapshot
                                                                .data![index]
                                                                .productImage,
                                                            initialPrice: snapshot
                                                                .data![index]
                                                                .initialPrice,
                                                            productPrice:
                                                                newPrice
                                                                    .toString(),
                                                            stock: snapshot
                                                                .data![index]
                                                                .id,
                                                            quantity: quantity))
                                                        .then((value) {
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.addTotalPrice(
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .initialPrice!));
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print(error.toString());
                                                    });
                                                  },
                                                  child: Icon(Icons.add))
                                            ]),
                                          ],
                                        ),
                                        InkWell(
                                            onTap: () {
                                              int quantity = snapshot
                                                  .data![index].quantity!;
                                              dbHelper!
                                                  .delete(
                                                      snapshot.data![index].id!)
                                                  .then((value) {
                                                cart.removeCounter();
                                                cart.removeTotalPrice(
                                                    double.parse(snapshot
                                                        .data![index]
                                                        .productPrice!
                                                        .replaceAll(
                                                            RegExp('[^0-9]'),
                                                            '')));
                                                quantity = 0;
                                                setState(() {});
                                              }).onError((error, stackTrace) {
                                                print(error.toString());
                                              });
                                            },
                                            child: const Icon(Icons.delete))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                } else {
                  return const Text('');
                }
              })),
          Consumer<CartProvider>(
            builder: ((context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(children: <Widget>[
                  ReusableWidget(
                      title: 'Sub Total',
                      value:
                          (value.getTotalPrice() * 127.21).toStringAsFixed(2))
                ]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(width: 100),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    );
  }
}
