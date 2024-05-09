import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/coupon_model.dart';
import 'package:sixcomputer/src/repo/coupon_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';

class CouponEditView extends StatefulWidget {
  final String id;
  const CouponEditView({super.key, required this.id});

  static const routeName = '/edit-coupon';

  @override
  State<CouponEditView> createState() => _CouponEditViewState();
}

class _CouponEditViewState extends State<CouponEditView> {
  final _formKey = GlobalKey<FormState>();

  final CouponClient couponClient = CouponClient();
  late CouponModel coupon;

  @override
  void initState() {
    super.initState();

    fetchData();
  }
  fetchCouponById() async {
    final coupon = await couponClient.getCouponById(widget.id);

    couponIdController.text = coupon.couponId ?? '';
    nameController.text = coupon.couponName ?? '';
    percentController.text = coupon.percentageNum.toString() ?? '';
    productIdController.text = coupon.productId ?? '';

    this.coupon = coupon;

    setState(() {});
  }

  void fetchData() {
    fetchCouponById();
  }
  TextEditingController couponIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController percentController = TextEditingController();
  TextEditingController productIdController = TextEditingController();

  updateCoupon() async {
    final coupon = this.coupon;

    coupon.couponId = couponIdController.text;

    coupon.couponName = nameController.text;

    coupon.percentageNum = int.parse(percentController.text);

    coupon.productId = productIdController.text;

    await couponClient.updateCoupon(coupon).then((value) => Message.showToast(context, 'update success'));
  }
  deleteCoupon() async {
    await couponClient.deleteCoupon(widget.id).then((value) => Message.showToast(context, 'delete success'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: couponIdController,
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter coupon id' : null,
                decoration: const InputDecoration(
                  labelText: 'Coupon Id',
                  hintText: 'Enter coupon id',
                  fillColor: Color.fromARGB(255, 126, 126, 126),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  )
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: nameController,
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter coupon name' : null,
                decoration: const InputDecoration(
                  labelText: 'Coupon Name',
                  hintText: 'Enter coupon name',
                  fillColor: Color.fromARGB(255, 126, 126, 126),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  )
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: percentController,
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter percentage' : null,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                  labelText: 'Percentage',
                  hintText: 'Enter percentage',
                  fillColor: Color.fromARGB(255, 126, 126, 126),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  )
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: productIdController,
                validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter product id' : null,
                decoration: const InputDecoration(
                  labelText: 'Product Id',
                  hintText: 'Enter product id',
                  fillColor: Color.fromARGB(255, 126, 126, 126),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  )
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateCoupon();
                      }
                    },
                    child: const Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteCoupon();
                    },
                    child: const Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ]
          )
        ),
      ),
    );
  }
}