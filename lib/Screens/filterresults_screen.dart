import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random/componenets/api_calls.dart';
import 'package:random/componenets/db_helper.dart';
import 'package:random/model/cart.dart';
import 'package:random/model/item_model.dart';
import 'package:random/providers/cart_provider.dart';

class FilterResultsScreen extends StatefulWidget {
  //const FilterResultsScreen({Key? key}) : super(key: key);
  static const String id = 'filterresults_screen';
  List<String>? filterList;
  double minPrice, maxPrice;
  DateTime date;
  FilterResultsScreen(
      {this.filterList,
      required this.minPrice,
      required this.maxPrice,
      required this.date});

  @override
  State<FilterResultsScreen> createState() =>
      _FilterResultsScreenState(filterList, minPrice, maxPrice, date);
}

class _FilterResultsScreenState extends State<FilterResultsScreen> {
  List<Product> semiFinalFilterList = [];
  List<String>? filterList;
  List<Product> categoryFilterList = [];
  List<Product> priceFilterList = [];
  List<Product> finalFilterList = [];
  List<Product> firstFilterList = [];
  List<Product> secondFilterList = [];
  List<Product> timeFilterList = [];
  DateTime? date;
  double minPrice, maxPrice;
  final df = DateFormat('dd-MM-yyyy');
  _FilterResultsScreenState(
      this.filterList, this.minPrice, this.maxPrice, this.date);
  late Future<ProductItems> items;
  int count = 0;
  @override
  void initState() {
    items = getItemList();
    setState(() {});
    super.initState();
  }

  getFilterItems(AsyncSnapshot snapshot) {
    if (count == 0) {
      for (var item in snapshot.data!.item!.product!) {
        for (var filter in filterList!) {
          if (item.category!.contains(filter)) {
            if (!categoryFilterList.contains(item)) {
              categoryFilterList.add(item);
            }
          }
        }
      }
      if (categoryFilterList.isNotEmpty) {
        firstFilterList = categoryFilterList;
      } else {
        for (var item in snapshot.data!.item!.product!) {
          if (!finalFilterList.contains(item)) {
            firstFilterList.add(item);
          }
        }
      }
      for (var item in firstFilterList) {
        print(item.price!.substring(1));
        if (int.parse(item.price!.substring(1)) >= minPrice &&
            int.parse(item.price!.substring(1)) <= maxPrice) {
          if (!priceFilterList.contains(item)) {
            priceFilterList.add(item);
          }
        }
      }
      print('.......');
      print(priceFilterList.length);
      if (priceFilterList.isNotEmpty) {
        secondFilterList = priceFilterList;
      } else {
        secondFilterList = firstFilterList;
      }
      for (var item in secondFilterList) {
        if (date!.isBefore(
            (DateTime.fromMillisecondsSinceEpoch(item.createDate!)))) {
          if (!timeFilterList.contains(item)) {
            timeFilterList.add(item);
          }
        }
      }
      if (timeFilterList.isNotEmpty) {
        finalFilterList = timeFilterList;
      } else {
        finalFilterList = secondFilterList;
      }
      count++;
    }
  }

  Widget build(BuildContext context) {
    DBHelper? dbHelper = DBHelper();
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int count = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Results'),
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
      body: FutureBuilder<ProductItems>(
          future: items,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              getFilterItems(snapshot);
              return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: height * 0.4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: finalFilterList.length,
                  itemBuilder: (context, index) {
                    return Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      SizedBox(
                        height: height / 6,
                        width: width / 2.5,
                        child: Image(
                            image: NetworkImage(
                                'https://electronic-ecommerce.herokuapp.com/${finalFilterList[index].image}')),
                      ),
                      Text(
                        finalFilterList[index].name!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Rs. ${(double.parse(finalFilterList[index].price!.substring(1))*127.21).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(df
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              finalFilterList[index].createDate!))
                          .toString()),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Stock:${finalFilterList[index].stock!}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('Categories:'),
                        const SizedBox(width: 2),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Text('${finalFilterList[index].category![0]},'),
                          const SizedBox(width: 4.0),
                          Text(finalFilterList[index].category![1]),
                        ]),
                      ]),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          dbHelper
                              .insert(Cart(
                                  id: index,
                                  productId:
                                      snapshot.data!.item!.product![index].id,
                                  productName:
                                      snapshot.data!.item!.product![index].name,
                                  productImage:
                                      'https://electronic-ecommerce.herokuapp.com/${snapshot.data!.item!.product![index].image!}',
                                  initialPrice: (int.parse(snapshot
                                          .data!.item!.product![index].price!
                                          .replaceAll(RegExp('[^0-9]'), '')))
                                      .toString(),
                                  productPrice: (int.parse(snapshot
                                          .data!.item!.product![index].price!
                                          .replaceAll(RegExp('[^0-9]'), '')))
                                      .toString(),
                                  stock: snapshot
                                      .data!.item!.product![index].stock!,
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
                          child: const Text('Add to Cart',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ]);
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }
}
