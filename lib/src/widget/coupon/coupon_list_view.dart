
import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/coupon_model.dart';
import 'package:sixcomputer/src/repo/coupon_repo.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_add_view.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_item.dart';

class CouponListView extends StatefulWidget {
  const CouponListView({super.key});

  static const String routeName = '/coupon-list';

  @override
  State<CouponListView> createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> {
  final List<CouponModel> coupons = [];

  final CouponClient couponClient = CouponClient();
  final TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  final List<CouponModel> searchCoupons = [];

  @override
  void initState() {
    super.initState();

    // fetchCoupons();
    fetchCoupons2();
  }
  fetchCoupons2() async {
    final coupons = await couponClient.fetchCoupons2();

    this.coupons.clear();
    this.coupons.addAll(coupons);
    setState(() {
    });
  }

  search(String query) async {

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
      });
      return;
    }

   final coupons = this.coupons.where((element) {
     return element.couponName!.toLowerCase().contains(query.toLowerCase());
   }).toList();
    isSearching = true;
    setState(() {
      searchCoupons.clear();
      searchCoupons.addAll(coupons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Coupons'),
            IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'add',
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, CouponAddView.routeName);
              },
            ),
          ]
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchCoupons2();
        },
        child: coupons.isEmpty
          ? const Center(
            child: Image(
              width: 100,
              height: 100,
              image: AssetImage('assets/images/empty_box.png')
            ),
          )
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white
                        ),
                        shadowColor: MaterialStateProperty.all(
                          Colors.transparent
                        ),
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16)
                        ),
                        leading: const Icon(Icons.search),
                        controller: searchController,
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              isSearching = false;
                              searchController.clear();
                            }
                          )
                        ],
                        hintText: 'Search coupon',
                        onSubmitted: (value) {
                          search(value);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ),
            isSearching
                ? SliverToBoxAdapter(
                  child : Padding(
                    padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        'Search result: ${searchCoupons.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
            )
                : const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
          isSearching
            ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final coupon = searchCoupons[index];
                  return CouponItem(couponModel: coupon);
                },
              childCount: searchCoupons.length,
            ),
            )
            : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final coupon = coupons[index];
                  return CouponItem(couponModel: coupon);
                },
                childCount: coupons.length,
              ),
            ),
          ]
        )
      ),
    );
  }
}
