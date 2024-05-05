import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_item_repo.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const String routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Color leftBarColor = Colors.blue;
  final Color rightBarColor = Colors.red;
  final Color middleBarColor = Colors.green;

  final double width = 7;

  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;

  //Order
  List<OrderModel> _orders = [];

  int touchedGroupIndex = -1;

  int revenue = 0;

  int orderCount = 0;

  @override
  void initState() {
    super.initState();
    init();
    fetchAllOrders();
  }

  fetchAllOrders() async {
    OrderClient ref = OrderClient();
    List<OrderModel> orders = await ref.getAllOrders();

    List<OrderItemModel> orderItems = await OrderItemClient().getAllOrderItems();

    List<OrderModel> orders0 = orders.where((element) => element.status == 'Complete' ).toList();

    for (var order in orders0) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
      revenue += order.total ?? 0;
    }

    orderCount = orders.where((element) => element.status == 'Waiting').length;

    _orders = orders.where((element) => element.status == 'Complete' || element.status == 'Waiting' || element.status == 'Ongoing').toList();

    setState(() {});
  }

  init() {
    final items = [
      makeGroupData(0, 5, 12),
      makeGroupData(1, 16, 12),
      makeGroupData(2, 18, 5),
      makeGroupData(3, 20, 16),
      makeGroupData(4, 17, 6),
      makeGroupData(5, 19, 1.5),
      makeGroupData(6, 10, 1.5),
    ];

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;

    touchedGroupIndex = -1;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Revenue', style: TextStyle(color: Colors.black54, fontSize: 12),),
                    Text(
                      NumberFormat.decimalPattern().format(revenue),
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Orders', style: TextStyle(color: Colors.black54, fontSize: 12),),
                    Text(
                      NumberFormat.decimalPattern().format(orderCount),
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: 40,
                          title: '40%',
                          showTitle: false
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: 30,
                          title: '30%',
                          showTitle: false

                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: 15,
                          title: '15%',
                          showTitle: false

                        ),
                        PieChartSectionData(
                          color: Colors.yellow,
                          value: 15,
                          title: '15%',
                          showTitle: false

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  maxY: 20,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: ((group) {
                          return Colors.grey;
                        }),
                        getTooltipItem: (a, b, c, d) => null,
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups!);
                          });
                          return;
                        }
              
                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;
              
                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups!);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups!);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (final rod
                                in showingBarGroups![touchedGroupIndex].barRods) {
                              sum += rod.toY;
                            }
                            final avg = sum /
                                showingBarGroups![touchedGroupIndex]
                                    .barRods
                                    .length;
              
                            showingBarGroups![touchedGroupIndex] =
                                showingBarGroups![touchedGroupIndex].copyWith(
                              barRods: showingBarGroups![touchedGroupIndex]
                                  .barRods
                                  .map((rod) {
                                return rod.copyWith(
                                    toY: avg, color: middleBarColor);
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: const FlGridData(show: false),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}