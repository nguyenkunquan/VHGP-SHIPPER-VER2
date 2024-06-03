import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Colors/color.dart';
import '../Json/constrain.dart';
import '../apis/apiServices.dart';
import '../models/EdgeModel.dart';
import '../models/MessageEdgeModelHistory.dart';
import '../provider/appProvider.dart';
import '../widgets/order_accept_modal.dart';
import '../widgets/order_done_modal.dart';
import '../widgets/order_shipping_modal.dart';
import 'order_detail_page.dart';
import '../ojt/apis/apiServices.dart';
import '../ojt/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = true;
  bool isLoading = true;
  bool isLoadingFilter = false;
  var filterActive = 1;
  int dayActive = 0;
  int subtractFilter = 0;
  // MessageEdgeModelHistory messageEdgeModel = MessageEdgeModelHistory();
  EdgeModel _edgeModel = EdgeModel();

  void _ModalAccept(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc) {
          return OrderAcceptModal(function: (func) {});
        });
  }

  void _ModalShipping(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc) {
          return OrderShippingModal(
              storeId: "", menuId: '', function: (func) {});
        });
  }

  void _ModalDone(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc) {
          return OrderDoneModal(storeId: "", menuId: '', function: (func) {});
        });
  }

  getTimeNow(dayActive, subtract) {
    DateTime now = DateTime.now();
    var formatterMonth = DateFormat('MM');
    if (dayActive == 3) {
      String actualMonth = formatterMonth.format(now);
      return "Tháng ${actualMonth}";
    } else {
      if (dayActive == 1) {
        now = DateTime.now();
      } else if (dayActive == 2) {
        now = DateTime.now().subtract(Duration(days: subtract));
      }
      var formatterDate = DateFormat('dd');

      String actualDate = formatterDate.format(now);
      String actualMonth = formatterMonth.format(now);
      print(actualDate + " Tháng " + actualMonth);
      return actualDate + " Tháng " + actualMonth;
    }
  }

  statistical_order() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      // padding: EdgeInsets.all(15),
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
              Icons.today,
              color: MaterialColors.primary,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            TextButton(
              child: Text(
                getTimeNow(dayActive, subtractFilter),
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: "SF Bold",
                    fontSize: 15),
              ),
              onPressed: () {
                _modalBottomSheetMenu();
              },
            ),
          ]),
          Container(
            child: Row(children: [
              SizedBox(
                width: 5,
              ),
              InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    var shipperId = context.read<AppProvider>().getUserId;

                    dayActive = 2;
                    DateTime now = DateTime.now();
                    print(now);
                    now = DateTime.now()
                        .subtract(Duration(days: subtractFilter + 1));
                    subtractFilter = subtractFilter + 1;
                    print(now);
                    var formatterDate = DateFormat('dd');
                    var formatterMonth = DateFormat("MM");
                    var formatterYear = DateFormat("yyyy");
                    String actualDate = formatterDate.format(now);
                    String actualMonth = formatterMonth.format(now);
                    String actualYear = formatterYear.format(now);
                    String dayFilter =
                        "${actualMonth}/${actualDate}/${actualYear}";
                    globals.dateOnly =
                        "${actualYear}-${actualMonth}-${actualDate}";
                    print(dayFilter);
                    hanldeFilter(shipperId, dayFilter, "", "");
                  });
                },
              ),
              SizedBox(
                width: 3,
              ),
              InkWell(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    var shipperId = context.read<AppProvider>().getUserId;

                    dayActive = 2;
                    DateTime now = DateTime.now();
                    now = DateTime.now()
                        .subtract(Duration(days: subtractFilter - 1));
                    subtractFilter = subtractFilter - 1;
                    var formatterDate = DateFormat('dd');
                    var formatterMonth = DateFormat("MM");
                    var formatterYear = DateFormat("yyyy");
                    String actualDate = formatterDate.format(now);
                    String actualMonth = formatterMonth.format(now);
                    String actualYear = formatterYear.format(now);
                    String dayFilter =
                        "${actualMonth}/${actualDate}/${actualYear}";
                    globals.dateOnly =
                        '${actualYear}-${actualMonth}-${actualDate}';
                    print(dayFilter);
                    hanldeFilter(shipperId, dayFilter, "", "");
                  });
                },
              ),
              // Icon(Icons.arrow_forward_ios, size: 18, color: Color.fromARGB(120, 120, 120, 1)),
            ]),
          )
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: 220.0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chọn Khoảng Thời Gian",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: "SF Bold",
                                fontSize: 15),
                          ),
                        ]),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(240, 240, 240, 1)))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                print("1");
                                filterActive = 1;
                                dayActive = 1;
                                Navigator.pop(context);
                                var shipperId =
                                    context.read<AppProvider>().getUserId;
                                DateTime now = DateTime.now();
                                var formatterDate = DateFormat('dd');
                                var formatterMonth = DateFormat("MM");
                                var formatterYear = DateFormat("yyyy");
                                String actualDate = formatterDate.format(now);
                                String actualMonth = formatterMonth.format(now);
                                String actualYear = formatterYear.format(now);
                                String dayFilter =
                                    "${actualMonth}/${actualDate}/${actualYear}";
                                globals.dateOnly =
                                    '${actualYear}-${actualMonth}-${actualDate}';
                                hanldeFilter(shipperId, dayFilter, "", "");
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Hôm nay",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(120, 120, 120, 1),
                                          fontFamily: "SF Medium",
                                          fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 1
                                        ? Icon(Icons.radio_button_checked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                print("2");
                                filterActive = 2;
                                dayActive = 2;
                                Navigator.pop(context);
                                var shipperId =
                                    context.read<AppProvider>().getUserId;
                                DateTime now =
                                    DateTime.now().subtract(Duration(days: 1));
                                var formatterDate = DateFormat('dd');
                                var formatterMonth = DateFormat("MMM");
                                var formatterYear = DateFormat("yyyy");
                                String actualDate = formatterDate.format(now);
                                String actualMonth = formatterMonth.format(now);
                                String actualYear = formatterYear.format(now);
                                String dayFilter =
                                    "${actualMonth} ${actualDate} ${actualYear}";
                                globals.dateOnly =
                                    '${actualYear}-${actualMonth}-${actualDate}';
                                subtractFilter = subtractFilter + 1;
                                hanldeFilter(shipperId, dayFilter, "", "");
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Hôm qua",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(120, 120, 120, 1),
                                          fontFamily: "SF Medium",
                                          fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 2
                                        ? Icon(Icons.radio_button_checked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                print("3");
                                filterActive = 3;
                                dayActive = 3;
                                Navigator.pop(context);
                                var shipperId =
                                    context.read<AppProvider>().getUserId;
                                DateTime now = DateTime.now();
                                var formatterMonth = DateFormat("MM");
                                var formatterYear = DateFormat("yyyy");
                                String actualMonth = formatterMonth.format(now);
                                String actualYear = formatterYear.format(now);
                                subtractFilter = subtractFilter + 1;
                                hanldeFilter(
                                    shipperId, "", actualMonth, actualYear);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Tháng này",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(120, 120, 120, 1),
                                          fontFamily: "SF Medium",
                                          fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 3
                                        ? Icon(Icons.radio_button_checked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),

                          // InkWell(
                          //   onTap: () {
                          //     mystate(() {
                          //       filterActive = 4;
                          //       dayActive = 4;
                          //       Navigator.pop(context);
                          //       var storeId = context.read<AppProvider>().getUserId;

                          //       // getOrderReport(storeId, "");
                          //     });
                          //   },
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Container(
                          //         child: Row(children: [
                          //           Text(
                          //             "Từ trước tới nay",
                          //             style: TextStyle(color: Color.fromRGBO(120, 120, 120, 1), fontFamily: "SF Medium", fontSize: 16),
                          //           ),
                          //         ]),
                          //       ),
                          //       Container(
                          //         child: Row(children: [
                          //           filterActive == 4
                          //               ? Icon(Icons.radio_button_checked, size: 20, color: Color.fromRGBO(120, 120, 120, 1))
                          //               : Icon(Icons.radio_button_unchecked, size: 20, color: Color.fromRGBO(120, 120, 120, 1)),
                          //         ]),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                        ],
                      ))
                ],
              ),
            );
          });
        });
  }

  revenue() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Tổng quan đơn hàng  ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "SF Bold",
                            fontSize: 18),
                      ),
                      Icon(Icons.info,
                          size: 15, color: Color.fromARGB(255, 170, 165, 165)),
                    ],
                  ),
                ),
                Container(
                  child: Column(children: [
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '$totalOrder',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'Tổng Đơn',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: 8,
                              width: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '$totalSuccess',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Thành Công',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '$totalFail',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'Đơn hủy',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: 8,
                              width: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '$totalCusFail',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Khách hủy',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 30),
                  child: Row(
                    children: [
                      Text(
                        "Tổng quan thu tiền",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "SF Bold",
                            fontSize: 18),
                      ),
                      Icon(Icons.info,
                          size: 15, color: Color.fromARGB(255, 170, 165, 165)),
                    ],
                  ),
                ),
                Container(
                  child: Column(children: [
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '${totalOrderCost} đ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'Tổng phí đơn',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   // height: 8,
                            //   width: 15,
                            // ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Container(
                            //     height: 80.0,
                            //     padding: EdgeInsets.only(left: 15, right: 15),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       color: Color.fromRGBO(240, 240, 240, 1),
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Container(
                            //           child: Text(
                            //             '8',
                            //             style: TextStyle(fontSize: 18, fontFamily: "SF Bold", color: MaterialColors.primary),
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           height: 10,
                            //         ),
                            //         Container(
                            //           padding: EdgeInsets.only(
                            //             bottom: 8,
                            //           ),
                            //           child: Text(
                            //             'Khách hủy',
                            //             style: TextStyle(fontSize: 14, fontFamily: "SF SemiBold", color: Colors.black),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '${(totalDistanceByDate * 1000).truncate()} m',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        'Quảng đường',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: 8,
                              width: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 80.0,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        '${totalShipCost} đ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Bold",
                                            color: MaterialColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Tổng phí ship',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF SemiBold",
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  order_doing(segment) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#0123456",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "SF SemiBold",
                    fontSize: 16,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image(
                          // color:70olors.red,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          image: NetworkImage(segment == 0
                              ? "https://cdn-icons-png.flaticon.com/512/4521/4521931.png"
                              : "https://cdn-icons-png.flaticon.com/512/7541/7541900.png")),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          (segment == 0 ? "Lấy Hàng" : "Giao hàng"),
                          style: TextStyle(
                            fontFamily: "SF Medium",
                            color: MaterialColors.primary,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.room,
                    color: Colors.red,
                  ),
                ),
                Container(
                  child: Text(
                    " From ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "S1.07, Vinhomes Grand Park",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    "   |",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.room,
                    color: Colors.green,
                  ),
                ),
                Container(
                  child: Text(
                    " To ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "S1.07, Vinhomes Grand Park",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "Tiền mặt: ",
                        style: TextStyle(
                            color: Color.fromRGBO(80, 80, 80, 1), fontSize: 16),
                      ),
                      Text(
                        "50.000 VND",
                        style: TextStyle(
                            color: Color.fromRGBO(80, 80, 80, 1), fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            MaterialColors.primary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _ModalShipping(context);
                      },
                      child: Text('Chi tiết',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontFamily: "SF SemiBold")),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  trip_doing(EdgeModel _edgeModel) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MaterialColors.primary.withOpacity(0.15),
        // border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    // color:70olors.red,
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/1946/1946770.png")),
                SizedBox(
                  width: kSpacingUnit * 1,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tòa ${_edgeModel.buildingName}",
                      style: TextStyle(
                          fontSize: 15, fontFamily: "SF Bold", height: 1.3),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${_edgeModel.buildingName}",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF Regular",
                        height: 1.3,
                        color: Color.fromRGBO(120, 120, 120, 1),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        // "Tiền mặt",
                        "Tổng đơn hàng: ",
                        style: TextStyle(
                            color: Color.fromRGBO(80, 80, 80, 1), fontSize: 15),
                      ),
                      Text(
                        "${_edgeModel.orderNum}",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                            fontFamily: "SF Bold"),
                      ),
                    ],
                  ),
                ],
              ),
              // Container(
              //   child: Row(
              //     children: [
              //       Image(
              //           // color:70olors.red,
              //           height: 20,
              //           width: 20,
              //           fit: BoxFit.cover,
              //           image: NetworkImage(segment == 0
              //               ? "https://cdn-icons-png.flaticon.com/512/4521/4521931.png"
              //               : "https://cdn-icons-png.flaticon.com/512/7541/7541900.png")),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Container(
              //         padding: EdgeInsets.only(top: 5),
              //         child: Text(
              //           (segment == 0 ? "Lấy Hàng" : "Giao hàng"),
              //           style: TextStyle(
              //             fontFamily: "SF Medium",
              //             color: MaterialColors.primary,
              //             fontSize: 15,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
              Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  // padding: const EdgeInsets.only(
                  //   left: 0,
                  //   right: 15,
                  // ),
                  width: 120,
                  child: SizedBox(
                    height: 36,
                    child: InkWell(
                      onTap: () => {
                        if (_edgeModel.id != null)
                          {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetailPage(
                                            edgeId: _edgeModel.id!,
                                            building: _edgeModel.buildingName!,
                                            alphabet: alphabet[
                                                ((_edgeModel.priority ?? 1) - 1)
                                                    .toInt()],
                                            statusEdge: _edgeModel.status!)))
                                .then((value) => {onReload()})
                          }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  MaterialColors.primary,
                                  MaterialColors.primary2,
                                ])),
                        child: const Text(
                          'Xem chi tiết',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            height: 1,
                            fontFamily: "SF SemiBold",
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         // width: 100,
          //         child: OutlinedButton(
          //           style: ButtonStyle(
          //             backgroundColor: MaterialStatePropertyAll<Color>(
          //                 MaterialColors.primary),
          //             shape: MaterialStateProperty.all(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10.0),
          //               ),
          //             ),
          //           ),
          //           onPressed: () {
          //             _ModalShipping(context);
          //           },
          //           child: Text('Chi tiết',
          //               style: TextStyle(
          //                   color: Color.fromARGB(255, 255, 255, 255),
          //                   fontSize: 16,
          //                   fontFamily: "SF SemiBold")),
          //         ),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }

  handleToggle(val) {
    setState(() {
      status = val;
    });
  }

  MessageEdgeModelHistory messageEdgeModel = MessageEdgeModelHistory();
  int totalOrder = 0;
  int totalSuccess = 0;
  int totalFail = 0;
  int totalCusFail = 0;
  int totalOrderCost = 0;
  int totalShipCost = 0;
  double totalDistanceByDate = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("load");
    String shipperId = context.read<AppProvider>().getUserId;
    DateTime now = DateTime.now();
    var formatterDate = DateFormat('dd');
    var formatterMonth = DateFormat("MM");
    var formatterYear = DateFormat("yyyy");
    String actualDate = formatterDate.format(now);
    String actualMonth = formatterMonth.format(now);
    String actualYear = formatterYear.format(now);
    String dayFilter = "${actualYear}-${actualMonth}-${actualDate}";
    ApiServices.getCurrentJob(shipperId)
        .then((value) => {
              if (value != null)
                {
                  setState(() => {
                        // isLoading = false,
                        _edgeModel = value,
                      })
                }
              else
                {
                  {
                    setState(() => {isLoading = false})
                  }
                }
            })
        .then((value) => {
              print("shipperId: " + shipperId),
              print("dayFilter: " + dayFilter),
              ApiServices.getReportOrder(shipperId, dayFilter, "", "")
                  .then((value2) => {
                        if (value2 != null)
                          {
                            messageEdgeModel = value2,
                            print(messageEdgeModel.data),
                            setState(() => {
                                  totalOrder = messageEdgeModel.data["total"],
                                  totalSuccess =
                                      messageEdgeModel.data["success"],
                                  totalFail = messageEdgeModel.data["canceled"],
                                  totalCusFail =
                                      messageEdgeModel.data["customerFail"],
                                  isLoading = false,
                                  isLoadingFilter = false,
                                  totalOrderCost =
                                      messageEdgeModel.data["totalOrderCost"],
                                  totalShipCost =
                                      messageEdgeModel.data["totalShipCost"],
                                })
                          }
                        else
                          {
                            {
                              setState(() => {isLoading = false})
                            }
                          }
                      })
            })
        .then((value) => {
              globals.dateOnly = '${actualYear}-${actualMonth}-${actualDate}',
            //   ApiServices2.getTotalDistanceByDate(
            //           shipperId, DateTime.parse(globals.dateOnly))
            //       .then((value) {
            //     if (value != null) {
            //       setState(() {
            //         totalDistanceByDate = value;
            //         isLoading = false;
            //       });
            //     } else {
            //       setState(() {
            //         isLoading = false;
            //       });
            //     }
            //   })
            })
        .catchError((onError) => {
              print("onError: " + onError.toString()),
              setState(() {
                isLoading = false;
              })
            });
  }

  void onReload() {
    String shipperId = context.read<AppProvider>().getUserId;
    DateTime now = DateTime.now();
    var formatterDate = DateFormat('dd');
    var formatterMonth = DateFormat("MM");
    var formatterYear = DateFormat("yyyy");
    String actualDate = formatterDate.format(now);
    String actualMonth = formatterMonth.format(now);
    String actualYear = formatterYear.format(now);
    String dayFilter = "${actualMonth}/${actualDate}/${actualYear}";
    ApiServices.getCurrentJob(shipperId)
        .then((value) => {
              if (value != null)
                {
                  setState(() => {
                        // isLoading = false,
                        _edgeModel = value,
                      })
                }
              else
                {
                  {
                    setState(() => {isLoading = false})
                  }
                }
            })
        .then((value) => {
              ApiServices.getReportOrder(shipperId, dayFilter, "", "")
                  .then((value2) => {
                        if (value2 != null)
                          {
                            messageEdgeModel = value2,
                            print(messageEdgeModel.data),
                            setState(() => {
                                  totalOrder = messageEdgeModel.data["total"],
                                  totalSuccess =
                                      messageEdgeModel.data["success"],
                                  totalFail = messageEdgeModel.data["canceled"],
                                  totalCusFail =
                                      messageEdgeModel.data["customerFail"],
                                  isLoading = false,
                                  isLoadingFilter = false,
                                  totalOrderCost =
                                      messageEdgeModel.data["totalOrderCost"],
                                  totalShipCost =
                                      messageEdgeModel.data["totalShipCost"],
                                })
                          }
                        else
                          {
                            {
                              setState(() => {isLoading = false})
                            }
                          }
                      })
            })
        .then((value) => {
              // ApiServices2.getTotalDistanceByDate(
              //         shipperId, DateTime.parse(globals.dateOnly))
              //     .then((value) {
              //   if (value != null) {
              //     setState(() {
              //       totalDistanceByDate = value;
              //       isLoading = false;
              //     });
              //   } else {
              //     setState(() {
              //       isLoading = false;
              //     });
              //   }
              // })
            })
        .catchError((onError) => {
              print("onError: " + onError.toString()),
              setState(() {
                isLoading = false;
              })
            });
  }

  void hanldeFilter(String shipperId, String day, String month, String year) {
    setState(() {
      isLoadingFilter = true;
    });
    ApiServices.getReportOrder(shipperId, day, month, year).then((value2) {
      if (value2 != null) {
        messageEdgeModel = value2;
        setState(() {
          totalOrder = messageEdgeModel.data["total"];
          totalSuccess = messageEdgeModel.data["success"];
          totalFail = messageEdgeModel.data["canceled"];
          totalCusFail = messageEdgeModel.data["customerFail"];
          totalOrderCost = messageEdgeModel.data["totalOrderCost"];
          totalShipCost = messageEdgeModel.data["totalShipCost"];
          isLoadingFilter = false;
        });
      } else {
        setState(() {
          isLoadingFilter = false;
        });
      }
    }).then((value) {
      String dayFilter = "${year}-${month}-${day}";
      // ApiServices2.getTotalDistanceByDate(
      //         shipperId, DateTime.parse(globals.dateOnly))
      //     .then((value) {
      //   if (value != null) {
      //     setState(() {
      //       totalDistanceByDate = value;
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       isLoading = false;
      //     });
        // }
      // });
    }).catchError((onError) {
      print("onError: " + onError.toString());
      setState(() {
        isLoadingFilter = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromARGB(243, 255, 85, 76),
                                Color.fromARGB(255, 249, 136, 36)
                              ]),
                        ),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.read<AppProvider>().getName,
                                    style: TextStyle(
                                        color: MaterialColors.white,
                                        fontFamily: "SF Bold",
                                        fontSize: 18),
                                  ),
                                  Padding(padding: EdgeInsets.all(3)),
                                  Text(
                                    context.read<AppProvider>().getUserId,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "SF Regular",
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(''),
                                Text(
                                  "Bật/Tắt trạng thái",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "SF Bold",
                                    fontSize: 12,
                                  ),
                                ),
                                Switch(
                                  value:
                                      context.watch<AppProvider>().isSwitched,
                                  onChanged: (bool newValue) {
                                    if (globals.shippingOrderCounter == 0) {
                                      context
                                          .read<AppProvider>()
                                          .toogleSwitch(newValue);
                                    } else {
                                      Flushbar(
                                        messageText: const Center(
                                          child: Text(
                                            "Vẫn còn đơn hàng chưa giao xong!",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 15),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.info_outline,
                                          color: Colors.orange,
                                        ),
                                        duration: Duration(seconds: 2),
                                        flushbarPosition: FlushbarPosition.TOP,
                                        backgroundColor: Colors.white,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        margin: EdgeInsets.all(8),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadows: [
                                          const BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(3, 3),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ).show(context);
                                    }
                                  },
                                  activeTrackColor: Colors.white30,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.white30,
                                )
                              ],
                            )
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       context.read<AppProvider>().getStatus
                            //           ? "Sẵn sàng"
                            //           : "Đang bận",
                            //       style: const TextStyle(
                            //           color: Colors.white,
                            //           fontFamily: "SF Bold",
                            //           fontSize: 18),
                            //     ),
                            //     Padding(padding: EdgeInsets.all(4)),
                            //     FlutterSwitch(
                            //       width: 60.0,
                            //       height: 30.0,
                            //       valueFontSize: 15.0,
                            //       toggleSize: 25.0,
                            //       value: status,
                            //       borderRadius: 30.0,
                            //       padding: 3.5,
                            //       activeColor: Colors.white,
                            //       toggleColor: Colors.orange,
                            //       // showOnOff: true,
                            //       onToggle: (val) {
                            //         handleToggle(val);
                            //         // setState(() {
                            //         //   status = val;
                            //         // });
                            //       },
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      // order_doing(0),
                      if (_edgeModel.id != null) ...[
                        Container(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Đang thực hiện",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: "SF Bold",
                                      fontSize: 18),
                                ),
                              ],
                            )),
                        trip_doing(_edgeModel)
                      ],
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              "Thống kê",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: "SF Bold",
                                  fontSize: 18),
                            ),
                          )
                        ],
                      )),
                      statistical_order(),
                      revenue(),

                      // Center(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       TextButton(
                      //         child: Text("Show Order accept"),
                      //         onPressed: () {
                      //           _ModalAccept(context);
                      //         },
                      //       ),
                      //       TextButton(
                      //         child: Text("Show Order Shipping"),
                      //         onPressed: () {
                      //           _ModalShipping(context);
                      //         },
                      //       ),
                      //       TextButton(
                      //         child: Text("Show Order Done"),
                      //         onPressed: () {
                      //           _ModalDone(context);
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                margin: EdgeInsets.only(top: 110),
                color: Colors.white,
                height: MediaQuery.of(context).size.height - 110,
                width: MediaQuery.of(context).size.width,
                child: SpinKitDualRing(
                  color: MaterialColors.primary,
                  size: 40.0,
                ),
              ),
            if (isLoadingFilter)
              Container(
                // margin: EdgeInsets.only(top: 110),
                color: Colors.white.withOpacity(0.7),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SpinKitDualRing(
                  color: MaterialColors.primary,
                  size: 40.0,
                ),
              ),
          ],
        );
      },
    );
  }
}
