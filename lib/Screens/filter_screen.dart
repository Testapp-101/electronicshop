import 'package:flutter/material.dart';
import 'package:random/Screens/filterresults_screen.dart';
import 'package:random/Screens/home_screen.dart';
import 'package:random/Screens/nav_screen.dart';
import 'package:random/model/item_model.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:date_time_picker/date_time_picker.dart';

class FilterScreen extends StatefulWidget {
  //const FilterScreen({Key? key}) : super(key: key);
  static const String id = 'filter_screen';
  late Future<ProductItems>? items;
  FilterScreen({this.items});

  @override
  State<FilterScreen> createState() => _FilterScreenState(items!);
}

class _FilterScreenState extends State<FilterScreen> {
  late Future<ProductItems>? items;
  _FilterScreenState(this.items);
  List<String> getcategories = [];
  List<String> categoriesFilterList = [];
  int count = 0;
  double minPrice = 0.00;
  double maxPrice = 0.00;
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  DateTime date = DateTime.now().add(Duration(days: 1));

  getCategories(AsyncSnapshot snapshot) {
    if (count == 0) {
      for (int i = 0; i < snapshot.data!.item!.product!.length; i++) {
        for (int j = 0;
            j < snapshot.data!.item!.product![i].category!.length;
            j++) {
          if (!getcategories
              .contains(snapshot.data!.item!.product![i].category![j])) {
            getcategories.add(snapshot.data!.item!.product![i].category![j]);
          }
        }
      }
      count++;
    }
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter Products'),
          actions: [
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                if (minPrice > 0 && maxPrice > 0) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => FilterResultsScreen(
                            filterList: categoriesFilterList,
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                            date: date,
                          )));
                } else if ((date == DateTime.now().add(Duration(days: 1))) ||
                    (categoriesFilterList.isNotEmpty)) {
                      if ((minPriceController.text.isEmpty &&
                      maxPriceController.text.isEmpty)) {
                         Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FilterResultsScreen(
                              filterList: categoriesFilterList,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                              date: date,
                            )));
                  }
                  else if ((minPriceController.text.isEmpty ||
                      maxPriceController.text.isEmpty)) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Enter both min max price or select a category'),
                    ));
                   
                  }  else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FilterResultsScreen(
                              filterList: categoriesFilterList,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                              date: date,
                            )));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Enter both min max price or select a category'),
                  ));
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: const Text(
                    'Price Range',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      const Text('Rs.'),
                      Container(
                        height: 25,
                        width: 100,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.rectangle,
                        //   border: Border.all(
                        //     color: Colors.black,
                        //     width: 1.0,
                        //   ),
                        // ),
                        child: TextField(
                          controller: minPriceController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Min',
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) {
                            minPrice = double.parse(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('Rs.'),
                      Container(
                        height: 25,
                        width: 100,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.rectangle,
                        //   border: Border.all(
                        //     color: Colors.black,
                        //     width: 1.0,
                        //   ),
                        // ),
                        child: TextField(
                          controller: maxPriceController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Max',
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) {
                            maxPrice = double.parse(value);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<ProductItems>(
                  future: items,
                  builder: ((context, snapshot) {
                    getCategories(snapshot);
                    return Column(
                      children: <Widget>[
                        Container(
                            height: 30,
                            width: double.infinity,
                            child: const Text(
                              'Categories',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            )),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: getcategories.length,
                            itemBuilder: ((context, indexx) {
                              return ListTile(
                                title:
                                    Text(getcategories[indexx].toUpperCase()),
                                trailing: ToggleSwitch(
                                  customWidths: [90.0, 50.0],
                                  cornerRadius: 20.0,
                                  activeBgColors: [
                                    [Colors.cyan],
                                    [Colors.redAccent]
                                  ],
                                  initialLabelIndex: 1,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  labels: const ['YES', 'No'],
                                  //icons: [null, FontAwesomeIcons.times],
                                  onToggle: (index) {
                                    if (index == 0) {
                                      if (!categoriesFilterList
                                          .contains(getcategories[indexx])) {
                                        categoriesFilterList
                                            .add(getcategories[indexx]);
                                      }
                                    } else {
                                      categoriesFilterList.removeWhere((item) =>
                                          item == getcategories[indexx]);
                                    }
                                    print('switched to: $index');
                                    print(categoriesFilterList.length);
                                  },
                                ),
                              );
                            }))
                      ],
                    );
                  })),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Date',
                  onChanged: (val) {
                    date = DateTime.parse(val);
                    print(date);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
