import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:slide_to_act/slide_to_act.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Colors/color.dart';
import '../Json/constrain.dart';
import '../apis/apiServices.dart';
import '../models/EdgeModel.dart';
import '../models/MessageEdgeModel.dart';
import '../provider/appProvider.dart';
import 'order_detail_page.dart';

class RouteDetailPage extends StatefulWidget {
  num status;
  String routeId;
  num totalBill;
  num totalCod;
  String orderId;
  RouteDetailPage(
      {super.key,
      required this.status,
      required this.routeId,
      required this.totalBill,
      required this.totalCod,
      required this.orderId});

  @override
  State<RouteDetailPage> createState() => _RouteDetailPageState();
}

pointPickup(EdgeModel edge, index) {
  getStatusTrip(status) {
    if (status == StatusEdge.done) {
      return "Hoàn thành";
    } else if (status == StatusEdge.todo) {
      return "Đang thực hiện";
    } else {
      return "Chưa làm";
    }
  }

  List<Color> getColorStatusTrip(status) {
    if (status == StatusEdge.done) {
      return [
        MaterialColors.success,
        Colors.green,
      ];
    } else if (status == StatusEdge.todo) {
      return [
        MaterialColors.primary,
        MaterialColors.primary2,
      ];
    } else {
      return [
        Color.fromRGBO(200, 200, 200, 1),
        Color.fromRGBO(180, 180, 180, 1)
      ];
    }
  }

  return Container(
    margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(2, 4),
            blurRadius: 5,
            spreadRadius: 2)
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border:
                        Border.all(color: Color.fromRGBO(230, 230, 230, 1))),
                child: Text(alphabet[index],
                    style: TextStyle(fontSize: 14, fontFamily: "SF SemiBold")),
              ),
              SizedBox(width: 5),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  // color: getColorStatusTrip(edge.status),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: getColorStatusTrip(edge.status)),
                  // border: Border.all(color: getColorStatusTrip(edge.status)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.podcasts, size: 14, color: Colors.white),
                    SizedBox(width: 7),
                    Text(
                      getStatusTrip(edge.status),
                      style: TextStyle(
                          fontFamily: "SF Medium",
                          fontSize: 13,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "${edge.orderNum} đơn hàng",
            style: TextStyle(
                fontFamily: "SF Regular",
                fontSize: 15,
                color: Color.fromRGBO(150, 150, 150, 1)),
          ),
        ]),
        SizedBox(
          height: kSpacingUnit * 1,
        ),
        SizedBox(
          height: kSpacingUnit * .5,
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${edge.buildingName}",
                  style: TextStyle(fontFamily: "SF Medium", fontSize: 16),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: kSpacingUnit * .5,
        ),
      ],
    ),
  );
}

pointDelivery(index) {
  return Container(
    margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(2, 4),
            blurRadius: 5,
            spreadRadius: 2)
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Color.fromRGBO(230, 230, 230, 1))),
            child: Text(index,
                style: TextStyle(fontSize: 14, fontFamily: "SF SemiBold")),
          ),
          SizedBox(width: 5),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: MaterialColors.primary,
              border: Border.all(color: MaterialColors.primary),
            ),
            child: Row(
              children: [
                Icon(Icons.podcasts, size: 14, color: Colors.white),
                Text(
                  "  Điểm giao hàng",
                  style: TextStyle(
                      fontFamily: "SF Medium",
                      fontSize: 13,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ]),
        SizedBox(
          height: kSpacingUnit * 1,
        ),
        Container(
          child: Row(
            children: [
              Text(
                "Trà sữa 5 Ngon",
                style: TextStyle(fontFamily: "SF Medium", fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: kSpacingUnit * .5,
        ),
        Text(
          "S5.05, Vinhomes Grand Park, Phường Long Thạnh Mỹ, Quận 9",
          style: TextStyle(
              fontFamily: "SF Regular",
              fontSize: 15,
              color: Color.fromRGBO(150, 150, 150, 1)),
        ),
      ],
    ),
  );
}

total_order(totalBill, totalCod) {
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  return Container(
    padding: EdgeInsets.only(top: 30, bottom: 15, left: 15, right: 15),
    color: Colors.white,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "Tổng tiền COD".toUpperCase(),
                style: TextStyle(
                  fontFamily: "SF SemiBold",
                  fontSize: 14,
                  color: Color.fromRGBO(170, 170, 170, 1),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "₫${currencyFormatter.format((totalCod!).toInt()).toString()}",
                style: TextStyle(
                  fontFamily: "SF SemiBold",
                  fontSize: 17,
                  color: MaterialColors.primary,
                ),
              )
            ],
          ),
          Column(
            children: [
              Text(
                "Tiền hàng".toUpperCase(),
                style: TextStyle(
                  fontFamily: "SF SemiBold",
                  fontSize: 14,
                  color: Color.fromRGBO(170, 170, 170, 1),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "₫${currencyFormatter.format((totalBill!).toInt()).toString()}"
                "",
                style: TextStyle(
                  fontFamily: "SF SemiBold",
                  fontSize: 17,
                  color: MaterialColors.black,
                ),
              )
            ],
          ),
        ]),
  );
}

class _RouteDetailPageState extends State<RouteDetailPage>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  MessageEdgeModel messageEdgeModel = MessageEdgeModel();
  List<EdgeModel> listEdge = [];
  EdgeModel _edgeModelDoing = EdgeModel();
  bool isLoading = true;
  String alphabetItem = "";
  bool isLoadingSubmit = false;
  hanldeAcceptRoute(routeId, shipId) {
    setState(() {
      isLoadingSubmit = true;
    });
    String statusCode = "";
    ApiServices.postAcceptRoute(routeId, shipId)
        .then((value) => {
          setState(() {
            isLoadingSubmit = false;
            widget.status = 2;
          }),
              statusCode = value,
              if (statusCode == "Successful")
                {
                  setState(() => {widget.status = 2}),
                  hanldeGetListEdge(widget.routeId),
                  Fluttertoast.showToast(
                      msg: "Nhận chuyến hàng thành công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
              else
                {
                  dialog(),
                  setState(() {
                    isLoading = false;
                    isLoadingSubmit = false;
                  })
                },
            })
        .catchError((onError) => {
              print("onError: " + onError.toString()),
              setState(() {
                isLoading = false;
              })
            });
  }

  dialogDone() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        title: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/success-back2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            height: 120,
            child: OverflowBox(
              minHeight: 220,
              maxHeight: 220,
              child: Lottie.asset(
                'assets/lottie/success.json',
                repeat: false,

                controller: controller,
                // fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hoàn thành",
                style: TextStyle(
                    color: Colors.black87, fontFamily: "SF Bold", fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bạn đã hoàn thành chuyến hàng",
                style: TextStyle(
                    color: Colors.black45,
                    fontFamily: "SF Regular",
                    fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      "Quay lại",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "SF Medium",
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(56, 193, 114, 1),
                      textStyle: TextStyle(color: Colors.white),
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                  ),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    ).then((value) => {
          controller.reverse(),
          Navigator.pop(context),
        });
  }

  hanldeGetListEdge(String id) {
    var isTodo = false;
    ApiServices.getListEdge(id)
        .then((value) => {
          setState(() {
            isLoading = false;
          }),
              messageEdgeModel = value,
              if (messageEdgeModel.statusCode == "Successful")
                {
                  listEdge = messageEdgeModel.data!.map((item) {
                    if (item["status"] == 2) {
                      _edgeModelDoing = EdgeModel.fromJson(item);
                      isTodo = true;
                      alphabetItem =
                          alphabet[messageEdgeModel.data!.indexOf(item)];
                    }
                    return EdgeModel.fromJson(item);
                  }).toList(),
                  if (!isTodo && widget.status == 2)
                    {
                      // dialogDone(),
                      _edgeModelDoing = EdgeModel(),
                      controller.forward(),
                    }
                }
              else
                {dialog()},
              setState(() {
                isLoading = false;
                isLoadingSubmit = false;
              })
            })
        .catchError((onError) => {print(onError)});
  }

  dialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.only(bottom: 0, top: 20),
        // title: const Text(
        //   'Đã xảy ra lỗi gì đó!!',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //       color: Colors.black,
        //       fontFamily: "SF Bold",
        //       fontSize: 18),
        // ),
        actions: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                // color:25olors.red,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/2058/2058197.png"),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đã xảy ra lỗi gì đó!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(120, 120, 120, 1),
                    fontFamily: "SF Regular",
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        child: const Text(
                          "Quay lại",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SF SemiBold",
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(239, 81, 58, 1),
                          textStyle: TextStyle(color: Colors.white),
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => {
                          Navigator.pop(context),
                        },
                      ),
                    ),
                  )
                ]),
          )
        ],
      ),
    ).then((value) => {
          Navigator.pop(context),
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hanldeGetListEdge(widget.routeId);
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shipperId = context.read<AppProvider>().getUserId;
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(243, 255, 85, 76),
                          Color.fromARGB(255, 249, 136, 36)
                        ]),
                  ),
                ),
                title: Text(
                  "Chi tiết chuyến hàng",
                  style: TextStyle(
                      color: MaterialColors.white, fontFamily: "SF Bold"),
                ),
              ),
              body: Stack(
                children: [
                  if (!isLoading)
                    Container(
                        padding: EdgeInsets.only(bottom: 65),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              total_order(widget.totalBill, widget.totalCod),
                              SizedBox(
                                height: kSpacingUnit * 1.5,
                              ),
                              ...listEdge.map((item) {
                                var index = listEdge.indexOf(item);
                                return InkWell(
                                  child: pointPickup(item, index),
                                  onTap: () {
                                    if (widget.status == 2 &&
                                        _edgeModelDoing.id != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailPage(
                                                      edgeId: item.id!,
                                                      building:
                                                          item.buildingName!,
                                                      alphabet: alphabet[index],
                                                      statusEdge:
                                                          item.status!))).then(
                                          (value) => {
                                                setState(() {
                                                  isLoading = true;
                                                }),
                                                hanldeGetListEdge(
                                                    widget.routeId)
                                              });
                                    }
                                  },
                                );
                              }).toList(),
                              SizedBox(
                                height: kSpacingUnit * 1,
                              ),
                            ],
                          ),
                        )),
                  if (isLoading)
                    Positioned(
                      child: Container(
                        // color: Colors.white.withOpacity(0.5),
                        child: SpinKitDualRing(
                          color: MaterialColors.primary,
                          size: 40.0,
                        ),
                      ),
                    ),
                  if (isLoadingSubmit)
                    Positioned(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: SpinKitDualRing(
                          color: MaterialColors.primary,
                          size: 40.0,
                        ),
                      ),
                    ),
                ],
              )

              // Stack(
              //   children: [
              //     ListOrderPage(totalBill: widget.totalBill, totalCod: widget.totalCod),
              //     if (widget.status == 1)
              //       Positioned(
              //           bottom: 0,
              //           child: Container(
              //               // height: 70,
              //               decoration: BoxDecoration(color: Colors.white),
              //               padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              //               width: MediaQuery.of(context).size.width,
              //               child: Center(
              //                 child: SlideAction(
              //                   alignment: Alignment.bottomCenter,
              //                   textStyle: TextStyle(fontSize: 18, fontFamily: "SF Bold", color: Colors.white),
              //                   // innerColor: Color.fromRGBO(219, 98, 71, 1),
              //                   outerColor: Color.fromARGB(255, 12, 120, 209),
              //                   innerColor: MaterialColors.secondary,
              //                   // text: "Chấp nhận" + ,
              //                   text: "Nhận chuyến hàng",
              //                   height: 50,
              //                   sliderButtonIconSize: 35,
              //                   sliderRotate: false,
              //                   borderRadius: 10,
              //                   sliderButtonIconPadding: 13,
              //                   submittedIcon: Icon(
              //                     Icons.check,
              //                     color: Colors.white,
              //                   ),
              //                   sliderButtonYOffset: -8,
              //                   sliderButtonIcon: Icon(
              //                     Icons.arrow_forward,
              //                     color: Colors.white,
              //                   ),
              //                   onSubmit: () {
              //                     Future.delayed(
              //                       Duration(milliseconds: 200),
              //                       () => {
              //                         Navigator.pop(context),
              //                         // Navigator.push(
              //                         //   context,
              //                         //   MaterialPageRoute(
              //                         //     builder: (context) => OrderDetailPage(
              //                         //         status: 2,
              //                         //         statusEdge: StatusEdge.done),
              //                         //   ),
              //                         // )
              //                       },
              //                     );
              //                   },
              //                 ),
              //               )))
              //     else
              //       Positioned(
              //           bottom: 0,
              //           child: Container(
              //               decoration: BoxDecoration(color: Colors.white),
              //               padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              //               width: MediaQuery.of(context).size.width,
              //               child: Container(
              //                 height: 45,
              //                 child: ElevatedButton(
              //                   child: Text(
              //                     "Xem lộ trình hiện tại",
              //                     style: TextStyle(color: Colors.white, fontFamily: "SF Bold", fontSize: 16),
              //                   ),
              //                   style: ElevatedButton.styleFrom(
              //                     primary: MaterialColors.primary,
              //                     textStyle: TextStyle(color: Colors.black),
              //                     shadowColor: Colors.white,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                   ),
              //                   onPressed: () => {
              //                     if (_edgeModelDoing.id != null)
              //                       {
              //                         Navigator.push(
              //                                 context,
              //                                 MaterialPageRoute(
              //                                     builder: (context) =>
              //                                         OrderDetailPage(edgeId: _edgeModelDoing.id!, building: _edgeModelDoing.buildingName!, alphabet: alphabetItem, statusEdge: _edgeModelDoing.status!)))
              //                             .then((value) => {
              //                                   setState(() {
              //                                     isLoading = true;
              //                                   }),
              //                                   hanldeGetListEdge(widget.routeId)
              //                                 })
              //                       }
              //                   },
              //                 ),
              //               ))),
              //     if (isLoadingSubmit)
              //       Positioned(
              //         child: Container(
              //           color: Colors.white.withOpacity(0.5),
              //           child: SpinKitDualRing(
              //             color: MaterialColors.primary,
              //             size: 50.0,
              //           ),
              //         ),
              //       ),
              //   ],
              // ),

              ),
          if (widget.status == 1)
            Positioned(
                bottom: 0,
                child: Container(
                  // height: 70,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child:
                        // SlideAction(
                        //   alignment: Alignment.bottomCenter,
                        //   textStyle: TextStyle(
                        //       fontSize: 18,
                        //       fontFamily: "SF Bold",
                        //       color: Colors.white),
                        //   // innerColor: Color.fromRGBO(219, 98, 71, 1),
                        //   outerColor: Color.fromARGB(255, 12, 120, 209),
                        //   innerColor: MaterialColors.secondary,
                        //   // text: "Chấp nhận" + ,
                        //   text: "Nhận chuyến hàng",
                        //   height: 50,
                        //   sliderButtonIconSize: 35,
                        //   sliderRotate: false,
                        //   borderRadius: 10,
                        //   sliderButtonIconPadding: 13,
                        //   submittedIcon: Icon(
                        //     Icons.check,
                        //     color: Colors.white,
                        //   ),
                        //   sliderButtonYOffset: -8,
                        //   sliderButtonIcon: Icon(
                        //     Icons.arrow_forward,
                        //     color: Colors.white,
                        //   ),
                        //   onSubmit: () {
                        //     Future.delayed(
                        //       Duration(milliseconds: 200),
                        //       () => {
                        //         // Navigator.pop(context),

                        //         hanldeAcceptRoute(widget.routeId, shipperId)

                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (context) => OrderDetailPage(
                        //         //         status: 2,
                        //         //         statusEdge: StatusEdge.done),
                        //         //   ),
                        //         // )
                        //       },
                        //     );
                        //   },
                        // ),

                        ActionSlider.standard(
                      sliderBehavior: SliderBehavior.stretch,
                      rolling: true,
                      width: MediaQuery.of(context).size.width * 0.8,
                      backgroundColor: Color.fromARGB(243, 238, 113, 41),
                      toggleColor: Colors.white,
                      iconAlignment: Alignment.centerRight,
                      loadingIcon: const SizedBox(
                          width: 55,
                          child: Center(
                              child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.0, color: Colors.green),
                          ))),
                      successIcon: const SizedBox(
                          width: 55,
                          child: Center(child: Icon(Icons.arrow_forward))),
                      icon: const SizedBox(
                          width: 55,
                          child: Center(child: Icon(Icons.arrow_forward))),
                      action: (controller) async {
                        controller.loading(); //starts loading animation
                        Future.delayed(
                          Duration(milliseconds: 200),
                          () => {
                            // Navigator.pop(context),

                            hanldeAcceptRoute(widget.routeId, shipperId)
                          },
                        );
                        // await hanldeAcceptRoute(widget.routeId, shipperId);
                        controller.success(); //starts success animation
                      },
                      child: const Text(
                        "Chấp nhận",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "SF Bold",
                            color: Colors.white,
                            decoration: TextDecoration.none
                            ),
                      ),
                    ),
                  ),
                ))
          else if (_edgeModelDoing.id != null)
            Positioned(
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              MaterialColors.primary,
                              Color(0xfff7892b),
                            ]),
                      ),
                      height: 45,
                      child: ElevatedButton(
                        child: Text(
                          "Xem lộ trình hiện tại",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SF Bold",
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          textStyle: TextStyle(color: Colors.black),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => {
                          if (_edgeModelDoing.id != null)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetailPage(
                                          edgeId: _edgeModelDoing.id!,
                                          building:
                                              _edgeModelDoing.buildingName!,
                                          alphabet: alphabetItem,
                                          statusEdge: _edgeModelDoing
                                              .status!))).then((value) => {
                                    setState(() {
                                      isLoading = true;
                                    }),
                                    hanldeGetListEdge(widget.routeId)
                                  }),
                            }
                        },
                      ),
                    ))),
        ],
      );
    });
  }
}
