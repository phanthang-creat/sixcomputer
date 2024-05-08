import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_item_repo.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  int totalComplete = 0;
  int totalWaiting = 0;
  int totalOngoing = 0;
  int totalCancel = 0;
  final double width = 7;

  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;
  String valueExport = '';
  //Order
  List<OrderModel> _orders = [];

  List<OrderModel> ordersExport = [];

  List<OrderModel> orders0 = [];
  List<OrderModel> ordersWaiting = [];
  List<OrderModel> ordersOngoing = [];
  List<OrderModel> ordersCancel = [];
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

    orders0 = orders.where((element) => element.status == 'Complete' ).toList();
    ordersWaiting = orders.where((element) => element.status == 'Waiting' ).toList();
    ordersOngoing = orders.where((element) => element.status == 'Ongoing' ).toList();
    ordersCancel = orders.where((element) => element.status == 'Cancel' ).toList();
    for (var order in orders0) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
      revenue += order.total ?? 0;
    }
    for (var order in ordersWaiting) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
      totalWaiting += order.total ?? 0;
    }
    for (var order in ordersOngoing) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
      totalOngoing += order.total ?? 0;
    }
    for (var order in ordersCancel) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
      totalCancel += order.total ?? 0;
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
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dropDown(),
                exportComplete(),
              ]
            ),
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

  Widget exportComplete() {

    return IconButton(
      icon: const Icon(Icons.print),
      onPressed: () async {
        var myTheme = pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-VariableFont_wdth,wght.ttf')),
        );
        final pdf = pw.Document(
          theme: myTheme,
        );
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              //return invoice();
              return pw.Column(
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                    ),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 30),
                        pw.Container(
                          // decoration: pw.BoxDecoration(
                          //   border: pw.Border.all(color: PdfColors.black, width: 2),
                          // ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Text(
                                'Six Computer',
                                style: const pw.TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                    fontSize: 26,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                              ),
                            ]
                          )
                        ),
                        pw.SizedBox(height: 30),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black, width: 2),
                          ),
                          child: pw.Column(
                            children: [
                              pw.SizedBox(height: 30),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                  children: [
                                    pw.Text(
                                      valueExport,
                                      style: const pw.TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    pw.Text(
                                      'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ]
                              ),
                              pw.SizedBox(height: 30),
                            ]
                          )
                        ),
                      ],
                    )
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                    ),
                    child: pw.Column(
                      children: [
                        pw.SizedBox(height: 30),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Container(
                              width: 40,
                              child:pw.Text(
                                'ID',
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            pw.Container(
                              width: 100,
                              child:pw.Text(
                                'Fullname',
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            pw.Container(
                              width: 100,
                              child:pw.Text(
                                'Total',
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            pw.Container(
                              width: 100,
                              child:pw.Text(
                                'Payment',
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 30),
                      ]
                    )
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                    ),
                    child: pw.Column(
                      children: [
                        pw.SizedBox(height: 30),
                        for (var order in ordersExport)
                          pw.Column(
                            children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                children: [
                                  pw.Container(
                                    width: 40,
                                    child: pw.Text(
                                      textAlign: pw.TextAlign.left,
                                      order.id.toString(),
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 100,
                                    child:pw.Text(
                                      textAlign: pw.TextAlign.left,
                                      order.fullname ?? '',
                                      style: const pw.TextStyle(
                                      fontSize: 12,
                                      ),
                                      ),
                                  ),
                                  pw.Container(
                                    width: 100,
                                    child: pw.Text(
                                      NumberFormat.currency(locale: 'vi').format(order.total),
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 100,
                                    child:pw.Text(
                                      order.paymentMethod ?? '',
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            pw.SizedBox(height: 30),
                            ]
                          ),
                      ]
                    )
                  ),
                  if(valueExport == 'Complete')
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                    ),
                    child: pw.Column(
                      children: [
                        pw.SizedBox(height: 30),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Text(
                              'Total Revenue',
                              style: const pw.TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            pw.Text(
                              NumberFormat.currency(locale: 'vi').format(revenue),
                              style: const pw.TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 30),
                      ]
                    ),
                  ),
                ],
              );
            },
          ),
        );
        Printing.layoutPdf(onLayout: (format) {
          return pdf.save();
        });
      },
    );
  }

  Widget dropDown() {
    return DropdownButton<String>(
      hint: const Text('Select status'),
      value: 'Complete',
      items: <String>['Complete', 'Ongoing'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        if(value == 'Complete') {
          ordersExport = orders0;
          value = 'Complete';
        }
        else if(value == 'Ongoing') {
          ordersExport = ordersOngoing;
          value = 'Ongoing';
        }
        setState(() {
          valueExport = value!;
          value = valueExport;
        });
      },
    );
  }
}