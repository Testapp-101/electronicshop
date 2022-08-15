// ignore_for_file: prefer_const_constructors
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random/Screens/filter_screen.dart';
import 'package:random/componenets/api_calls.dart';
import 'package:random/componenets/db_helper.dart';
import 'package:random/model/cart.dart';
import 'package:random/model/item_model.dart';
import 'package:random/providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper = DBHelper();
  final df = DateFormat('dd-MM-yyyy');
  late Future<ProductItems> items;
  int currentIndex = 0;
  @override
  void initState() {
    items = getItemList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //http://electronic-ecommerce.herekuapp.com/fantechHeadset.jpg
    return Scaffold(
      appBar: AppBar(
        title: Text('Electronic Shop'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    items: items,
                  ),
                ));
              });
            },
          ),
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
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(children: [
        Container(
          color: Colors.tealAccent,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<ProductItems>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: height * 0.4,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.item!.product!.length,
                    itemBuilder: (context, index) {
                      return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: height / 6,
                              width: width / 2.5,
                              child: Image(
                                  image: NetworkImage(
                                      'https://electronic-ecommerce.herokuapp.com/${snapshot.data!.item!.product![index].image!}')),
                            ),
                            Text(
                              snapshot.data!.item!.product![index].name!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Rs. ${(double.parse(snapshot.data!.item!.product![index].price!.substring(1))*127.21).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(df
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data!.item!.product![index]
                                        .createDate!))
                                .toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Stock:${snapshot.data!.item!.product![index].stock!}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Text('Categories:'),
                              SizedBox(width: 2),
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        '${snapshot.data!.item!.product![index].category![0]},'),
                                    SizedBox(width: 4.0),
                                    Text(snapshot.data!.item!.product![index]
                                        .category![1]),
                                  ]),
                            ]),
                            SizedBox(height: 8),
                            Visibility(
                              visible: (snapshot.data!.item!.product![index].stock!>0)?true:false,
                              child: InkWell(
                                onTap: () {
                                  dbHelper!
                                      .insert(Cart(
                                          id: index,
                                          productId: snapshot
                                              .data!.item!.product![index].id,
                                          productName: snapshot
                                              .data!.item!.product![index].name,
                                          productImage:
                                              'https://electronic-ecommerce.herokuapp.com/${snapshot.data!.item!.product![index].image!}',
                                          initialPrice: (int.parse(snapshot.data!
                                                  .item!.product![index].price!
                                                  .replaceAll(
                                                      RegExp('[^0-9]'), '')))
                                              .toString(),
                                          productPrice: (int.parse(snapshot.data!
                                                  .item!.product![index].price!
                                                  .replaceAll(
                                                      RegExp('[^0-9]'), '')))
                                              .toString(),
                                          stock: snapshot.data!.item!.product![index].stock!,
                                          quantity: 1))
                                      .then((value) {
                                    print('Added to Cart Successfully');
                                    cart.addTotalPrice(double.parse(snapshot
                                        .data!.item!.product![index].price!
                                        .replaceAll(RegExp('[^0-9]'), '')));
                                    Fluttertoast.showToast(
                                        msg: "Item added to Cart Successfully",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    cart.addCounter();
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: width * 0.4,
                                  color: Colors.blue,
                                  child: Text('Add to Cart',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ]);
                    });
              } else {
                return Center(
                  child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ]),
      
    );
  }
}
