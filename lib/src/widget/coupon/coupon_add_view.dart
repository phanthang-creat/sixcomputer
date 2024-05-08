import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/coupon_model.dart';
import 'package:sixcomputer/src/repo/coupon_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';
import 'package:uuid/uuid.dart';


class CouponAddView extends StatefulWidget {
  const CouponAddView({super.key});

  static const String routeName = '/add-coupon';

  @override
  State<CouponAddView> createState() => _CouponAddViewState();
}

class _CouponAddViewState extends State<CouponAddView>{
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController percentController = TextEditingController();
  TextEditingController productIdController = TextEditingController();

  addCoupon() async {
    final coupon = CouponModel(
      couponId: const Uuid().v4(),
      couponName: nameController.text,
      precentageNum: int.parse(percentController.text),
      productId: productIdController.text,
    );

    final couponClient = CouponClient();
    couponClient.addCoupon(coupon).then((value) {
      Message.showToast(context, 'Add Coupon Success');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              controller: nameController,
              validator: (value) => value == null || value.isEmpty
                ? 'Please enter coupon name'
                : null,
              decoration: InputDecoration(
                labelText: 'Coupon Name',
                hintText: 'Enter coupon name',
                fillColor: const Color.fromARGB(255, 126, 126, 126),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: percentController,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty
                ? 'Please enter precentage number'
                : null,
              decoration: InputDecoration(
                labelText: 'Precentage Number',
                hintText: 'Enter precentage number',
                fillColor: const Color.fromARGB(255, 126, 126, 126),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productIdController,
              validator: (value) => value == null || value.isEmpty
                ? 'Please enter product id'
                : null,
              decoration: InputDecoration(
                labelText: 'Product Id',
                hintText: 'Enter product id',
                fillColor: const Color.fromARGB(255, 126, 126, 126),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  addCoupon();
                }
              },
              child: const Text('Add Coupon'),
            ),
          ]
        ),
      ),
    );
  }

}