import 'package:flutter/material.dart';

import '../constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  static const String id = 'checkout_screen';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  void _submitForm() async {
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  maxLength: 20,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Name', hintText: 'Enter your name'),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Billing Address',
                      hintText: 'Enter billing Address'),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your delivery address';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Deliver Address',
                      hintText: 'Enter delivery Address'),
                ),
                const Text('Telephone:'),
                TextFormField(
                  maxLength: 10,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number'),
                ),
                const Text('Date:'),
                TextFormField(
                  maxLength: 10,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter date';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Date', hintText: 'DD/MM/YY'),
                ),
                ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
