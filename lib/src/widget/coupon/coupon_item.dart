import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/coupon_model.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/repo/coupon_repo.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_edit_view.dart';

import '../product/product_edit_view.dart';

class CouponItem extends StatefulWidget {
  final CouponModel couponModel;
  const CouponItem({super.key, required this.couponModel});

  @override
  State<CouponItem> createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem>{
  @override
  void initState() {
    super.initState();
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Coupon'),
            content: const Text('Are you sure you want to delete this coupon?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    deleteCoupon();
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'))
            ],
          );
        });
  }

  deleteCoupon() {
    try {
      final couponClient = CouponClient();

      couponClient.deleteCoupon(widget.couponModel.couponId!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon deleted successfully'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ]),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.couponModel.couponName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text(NumberFormat.currency(
                                      locale: 'vi', symbol: '%')
                                      .format(widget.couponModel.percentageNum)),
                                  const SizedBox(height: 5),
                                  Text('Product discount: ${widget.couponModel.productId!}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ]),
                          ),
                          //Edit and delete
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, CouponEditView.routeName,
                                        arguments: {'id': widget.couponModel.couponId!});
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue,
                                  )
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                  onTap: () {
                                    showAlert();
                                  },
                                  child: const Icon(
                                    Icons.delete_outlined,
                                    color: Colors.red,
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                    ]))
              ]),
        ),
        const SizedBox(height: 16),
      ]
    );
  }
}
