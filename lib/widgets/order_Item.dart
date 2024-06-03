// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fc_native_image_resize/fc_native_image_resize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tmp_path/tmp_path.dart';
import 'package:path/path.dart' as p;

import 'package:another_flushbar/flushbar.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vhgp_deli/models/OrderCompleteModel.dart';
import 'package:vhgp_deli/ojt/apis/apiServices.dart';
import 'package:vhgp_deli/widgets/payment_type_dropdownbutton.dart';
import '../ojt/globals.dart' as globals;

import '../Colors/color.dart';
import '../Json/constrain.dart';
import '../apis/apiServices.dart';
import '../models/MessageEdgeModel.dart';
import '../models/OrderEdgeModel.dart';
import '../ojt/globals.dart' as globals;

class OrderItem extends StatefulWidget {
  Function callback;
  Function callbackCancel;
  num status;
  num segment;
  num index;
  String orderId;
  num total;
  num shipCost;
  List listProduct;
  String customerNote;
  String orderNote;
  String phone;
  String name;
  String shipperId;
  num orderActionId;
  num paymentType;
  num statusEdge;

  List<OrderEdgeModel> orderEdgeList;
  OrderItem({
    Key? key,
    required this.status,
    required this.orderEdgeList,
    required this.statusEdge,
    required this.callback,
    required this.callbackCancel,
    required this.segment,
    required this.index,
    required this.orderId,
    required this.total,
    required this.shipCost,
    required this.listProduct,
    required this.customerNote,
    required this.orderNote,
    required this.phone,
    required this.name,
    required this.shipperId,
    required this.orderActionId,
    required this.paymentType,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  bool isLoadingButton = false;
  bool isLoadingButtonDialog = false;
  num activeRadio = 0;
  File? _image;
  final _nativeImgUtilPlugin = FcNativeImageResize();

  num paymentTypeChange = 0;

  @override
  void initState() {
    super.initState();
    paymentTypeChange = widget.paymentType;
  }

  String activeRadioMessage = "";
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    var dest = tmpPath() + p.extension(pickedFile!.name);
    await _nativeImgUtilPlugin.resizeFile(
          srcFile: pickedFile.path,
          destFile: dest,
          width: 600,
          height: 600,
          quality: 90,
          keepAspectRatio: true,
          format: 'jpeg'
    );
    if(pickedFile != null) {
      setState(() {
        _image = File(dest);  
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber != "") {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  String getCameraText(num action) {
    switch (action) {
      case OrderAction.pickupStore:
        return "Chụp ảnh lấy hàng";
      case OrderAction.deliveryHub:
        return "Chụp ảnh giao hàng";
      case OrderAction.pickupHub:
        return "Chụp ảnh lấy hàng";
      case OrderAction.deliveryCus:
        return "Chụp ảnh giao hàng";
      default:
        return "Chụp ảnh lấy hàng";
    }
  }

  String getCompleteText(num action) {
    switch (action) {
      case OrderAction.pickupStore:
        return "Đã lấy hàng";
      case OrderAction.deliveryHub:
        return "Đã giao hàng";
      case OrderAction.pickupHub:
        return "Đã lấy hàng";
      case OrderAction.deliveryCus:
        return "Đã giao hàng";
      default:
        return "Đã lấy hàng";
    }
  }
  handleUpdateShipperStatus(num status) {
      String statusCode = "";
      ApiServices2.updateStatusShipper(status)
          .then((value) => {
                statusCode = value,
                if (statusCode == "Successful")
                  {
                    print("Update status success"),
                  }
                else
                  {
                    print("Update status fail"),
                  }
          })
          .catchError((onError) => {print("onError: " + onError.toString())});
    }

  Future<void> hanldeComplte(
      num index, num orderActionId, String shipperId, num actionType) async {
    MessageEdgeModel messageEdgeModel;
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng chọn ảnh"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      isLoadingButton = true;
    });

    // var check = false;

   String base64Image = base64Encode(_image!.readAsBytesSync());
    // var base64Image = base64Encode(_image!.readAsBytesSync()); 
    // img.Image originalImage = img.decodeImage(_image!.readAsBytesSync())!;
    // img.Image resizedImage = img.copyResize(originalImage, width: 800);
    // List<int> imageBytes = img.encodeJpg(resizedImage);
    // String base64Image = base64Encode(imageBytes);
    

   print(base64Image);
   var orderCompleteModel = OrderCompleteModel(
        shipperId: shipperId,
        actionType: actionType,
        image: base64Image,
    );
    try {
      var response = await ApiServices.orderComplete(
        orderActionId,
        orderCompleteModel,
      );
      print(paymentTypeChange.toInt());
      await ApiServices.updatePaymentType(widget.orderId, paymentTypeChange.toInt());

      if (response != null && response.statusCode == "Successful") {
        if (actionType == OrderAction.deliveryCus && actionType == OrderAction.deliveryHub) {
          globals.shippingOrderCounter -= 1;
          await handleUpdateShipperStatus(0);
        }
        else {
          await handleUpdateShipperStatus(2);
        }
        setState(() {
          widget.callback(index);
          isLoadingButton = false;
        });
      } else {
        setState(() {
          isLoadingButton = false;
        });
      }
    } catch (error) {
      print("onError: " + error.toString());
      setState(() {
        isLoadingButton = false;
      });
    }
  }

  hanldeCancel(num index, num orderActionId, String shipperId, num actionType,
      String message) {
    // setState(() {
    //   isLoadingButtonCancelDialog = true;
    //   // widget.orderEdgeList[index].actionStatus = 3;
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    // });
    widget.callbackCancel(index, orderActionId, shipperId, actionType, message);
  }

  Future<void> hanldeComplteDialog(num index, StateSetter mystate,
      num orderActionId, String shipperId, num actionType) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng chụp ảnh"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    mystate(() {
      isLoadingButtonDialog = true;
    });

  // Convert image to base64
  String base64Image = base64Encode(_image!.readAsBytesSync());
  // var base64Image = base64Encode(_image!.readAsBytesSync()); 
    // img.Image originalImage = img.decodeImage(_image!.readAsBytesSync())!;
    // img.Image resizedImage = img.copyResize(originalImage, width: 300);
    // List<int> imageBytes = img.encodeJpg(resizedImage);
    // String base64Image = base64Encode(imageBytes);
  print(base64Image);
  var orderCompleteModel = OrderCompleteModel(
        shipperId: shipperId,
        actionType: actionType,
        image: base64Image,
    );
    try {
      var response = await ApiServices.orderComplete(
        orderActionId,
        orderCompleteModel,
      );
      ApiServices.updatePaymentType(widget.orderId, paymentTypeChange.toInt());

      if (response != null && response.statusCode == "Successful") {
        if (orderActionId == OrderAction.deliveryCus) {
          globals.shippingOrderCounter -= 1;
        }
        mystate(() {
          widget.callback(index);
          isLoadingButtonDialog = false;
        });
        Navigator.pop(context);
      } else {
        mystate(() {
          isLoadingButtonDialog = false;
        });
      }
    } catch (error) {
      print("onError: " + error.toString());
      mystate(() {
        isLoadingButtonDialog = false;
      });
    }
  }

  showModal(
    index,
    orderStatus,
    List listProduct,
    String customerNote,
    String orderNote,
    String phone,
    String name,
    num total,
    num shipCost,
    num segment,
    String shipperId,
    num orderActionId,
    num paymentType,
  ) {
    getMessageAction(action) {
      switch (action) {
        case OrderAction.pickupStore:
          return "Trả tiền mặt cho nhà hàng";
        case OrderAction.pickupHub | OrderAction.deliveryHub:
          return "---";
        case OrderAction.deliveryCus:
          if (paymentTypeChange == 0) {
            return "Thu tiền mặt khách hàng";
          } else if (paymentTypeChange == 1) {
            return "Thanh toán qua VNPay";
          } else return "";
        default:
          return "---";
      }
    }

    geTotalAction(action) {
      switch (action) {
        case OrderAction.pickupStore:
          return Text(
            "- ₫${currencyFormatter.format((total).toInt()).toString()}",
            style: TextStyle(
                color: MaterialColors.orange,
                fontFamily: "SF Semibold",
                fontSize: 16),
          );
        case OrderAction.pickupHub | OrderAction.deliveryHub:
          return Text(
            "- ₫${currencyFormatter.format((total).toInt()).toString()}",
            style: TextStyle(
                color: MaterialColors.orange,
                fontFamily: "SF Semibold",
                fontSize: 16),
          );
        case OrderAction.deliveryCus:
          return Text(
            "+ ₫${currencyFormatter.format((total + shipCost).toInt()).toString()}",
            style: TextStyle(
                color: MaterialColors.success,
                fontFamily: "SF Semibold",
                fontSize: 16),
          );
        default:
          return Text(
            "- ₫${currencyFormatter.format((total).toInt()).toString()}",
            style: TextStyle(
                color: MaterialColors.orange,
                fontFamily: "SF Semibold",
                fontSize: 16),
          );
      }
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        builder: (BuildContext context) {
          var messageAction = getMessageAction(segment);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                              color: Colors.black87,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              mystate(() =>
                                  {activeRadio = 0, activeRadioMessage = ""});
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Chi tiết đơn hàng",
                              style: const TextStyle(
                                  fontFamily: "SF Bold",
                                  fontSize: 18,
                                  color: Colors.black87)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            headerDialog(segment, phone, name),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromRGBO(
                                              230, 230, 230, 1)))),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Ghi chú khách hàng",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                      fontFamily: "SF Regular",
                                      fontSize: 16),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: 32,
                                        ),
                                        child: Text(
                                          customerNote == ""
                                              ? "Không có"
                                              : customerNote,
                                          style: const TextStyle(
                                              color: MaterialColors.black,
                                              fontFamily: "SF Medium",
                                              fontSize: 16),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromRGBO(
                                              230, 230, 230, 1)))),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Ghi chú đơn hàng",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                      fontFamily: "SF Regular",
                                      fontSize: 16),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: 32,
                                        ),
                                        child: Text(
                                          orderNote == ""
                                              ? "Không có"
                                              : orderNote,
                                          style: const TextStyle(
                                              color: MaterialColors.black,
                                              fontFamily: "SF Medium",
                                              fontSize: 16),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromRGBO(
                                              230, 230, 230, 1)))),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Danh sách món",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                      fontFamily: "SF Regular",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (listProduct.isNotEmpty)
                              ...[
                                ...listProduct,
                              ].map((item) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 10, top: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${item["quantity"]} x",
                                              style: const TextStyle(
                                                  color: MaterialColors.black,
                                                  fontFamily: "SF Regular",
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                item["productName"],
                                                style: const TextStyle(
                                                    color: MaterialColors.black,
                                                    fontFamily: "SF Regular",
                                                    fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "₫${currencyFormatter.format((item["price"]).toInt()).toString()}",
                                        style: const TextStyle(
                                            color: MaterialColors.black,
                                            fontFamily: "SF Regular",
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromRGBO(
                                              230, 230, 230, 1)))),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (segment == OrderAction.deliveryCus) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phương thức thanh toán",
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1),
                                        fontFamily: "SF Regular",
                                        fontSize: 16),
                                  ),
                                  PaymentTypeDropDownButton(
                                    paymentType: paymentTypeChange,
                                    onPaymentTypeChanged: (newPaymentType) {
                                      setState(() {
                                        paymentTypeChange = newPaymentType;
                                        messageAction =
                                            getMessageAction(segment);
                                        print(paymentType);
                                      });
                                      mystate(() => {isLoadingButton = true, paymentTypeChange = newPaymentType});
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       "Tổng cộng",
                            //       style: TextStyle(
                            //           color: Color.fromRGBO(50, 50, 50, 1),
                            //           fontFamily: "SF Regular",
                            //           fontSize: 16),
                            //     ),
                            //     Text(
                            //       "đ${currencyFormatter.format((total).toInt()).toString()}",
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontFamily: "SF Semibold",
                            //           fontSize: 16),
                            //     )
                            //   ],
                            // ),
                            // if (segment == OrderAction.deliveryCus) ...[
                            //   SizedBox(
                            //     height: 15,
                            //   ),
                            //   Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         "Phí giao hàng",
                            //         style: TextStyle(
                            //             color: Color.fromRGBO(50, 50, 50, 1),
                            //             fontFamily: "SF Regular",
                            //             fontSize: 16),
                            //       ),
                            //       Text(
                            //         "đ${currencyFormatter.format((shipCost).toInt()).toString()}",
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontFamily: "SF Semibold",
                            //             fontSize: 16),
                            //       )
                            //     ],
                            //   ),
                            // ],
                            SizedBox(
                              height: 12,
                            ),
                            if (segment == OrderAction.deliveryCus ||
                                segment == OrderAction.pickupStore) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        messageAction,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1),
                                            fontFamily: "SF Regular",
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  geTotalAction(segment),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (orderStatus == StatusOrderAction.todo)
                      Container(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                    child: Text(
                                      "Thất bại",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "SF Medium",
                                          fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(230, 230, 230, 1),
                                      textStyle: TextStyle(color: Colors.black),
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => isLoadingButtonDialog
                                        ? null
                                        : dialogOrder(index, orderActionId,
                                            shipperId, segment),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(7)),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                    child: isLoadingButtonDialog
                                        ? SpinKitDualRing(
                                            color: Colors.white,
                                            size: 25.0,
                                            lineWidth: 3,
                                          )
                                        : Text(
                                            getCompleteText(segment),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "SF SemiBold",
                                                fontSize: 15),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      textStyle: TextStyle(color: Colors.white),
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // onPressed: () => {
                                    //   hanldeComplteDialog(index, mystate,
                                    //       orderActionId, shipperId, segment),
                                    // },
                                    onPressed: isLoadingButtonDialog
                                        ? null
                                        : () => hanldeComplteDialog(index, mystate,
                                            orderActionId, shipperId, segment),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
            );
          });
        });
  }

  Widget headerDialog(num action, String phone, String name) {
    switch (action) {
      case OrderAction.pickupStore:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),

                  // padding: const EdgeInsets.only(right: 15, left: 0),
                  child: Image(
                    // color:25olors.red,
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/1532/1532692.png"),
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nhà Hàng",
                    style: const TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1),
                        fontFamily: "SF Regular",
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: MaterialColors.black,
                        fontFamily: "SF Bold",
                        fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        );
      case (OrderAction.pickupHub | OrderAction.deliveryHub):
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),

                  // padding: const EdgeInsets.only(right: 15, left: 0),
                  child: Image(
                    // color:25olors.red,
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3788/3788029.png"),
                  )),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hub ",
                        style: const TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontFamily: "SF Regular",
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            color: MaterialColors.black,
                            fontFamily: "SF Bold",
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      case OrderAction.deliveryCus:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),

                  // padding: const EdgeInsets.only(right: 15, left: 0),
                  child: Image(
                    // color:25olors.red,
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/1144/1144709.png"),
                  )),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đặt bởi",
                        style: const TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontFamily: "SF Regular",
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            color: MaterialColors.black,
                            fontFamily: "SF Bold",
                            fontSize: 16),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _makePhoneCall(phone);
                    },
                    child: Icon(
                      Icons.phone_in_talk,
                      size: 24,
                      color: Color.fromRGBO(100, 100, 100, 1),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      default:
        return Container();
    }
  }

  dialogOrder(index, num orderActionId, String shipperId, num actionType) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.all(15),
        contentPadding:
            EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        titlePadding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn lý do thất bại',
                style: TextStyle(
                    color: Colors.black, fontFamily: "SF Bold", fontSize: 18),
              ),
              InkWell(
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black54,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return SizedBox(
            height: getSizeDialog(actionType).toDouble(),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...getMessageCancel(actionType).map((e) {
                          return InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Row(children: [
                                            Icon(
                                                activeRadio == e["id"]
                                                    ? Icons.radio_button_checked
                                                    : Icons
                                                        .radio_button_unchecked,
                                                size: 22,
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 1)),
                                          ]),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Row(children: [
                                            Text(
                                              e["message"],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      100, 100, 100, 1),
                                                  fontFamily: "SF Medium",
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              mystate(() {
                                activeRadio = e["id"];
                                activeRadioMessage = e["message"];
                                print(
                                    "activeRadioMessage" + activeRadioMessage);
                              });
                            },
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (activeRadio != 0) {
                      {
                        Navigator.pop(context);
                        dialogConfirmOrder(index, orderActionId, shipperId,
                            actionType, activeRadioMessage);
                        // mystate(() => {
                        //       activeRadio = 0,
                        //       activeRadioMessage = "",
                        //     }),
                      }
                      ;
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  activeRadio == 0
                                      ? MaterialColors.primary.withOpacity(0.2)
                                      : MaterialColors.primary,
                                  activeRadio == 0
                                      ? MaterialColors.primary2.withOpacity(0.2)
                                      : MaterialColors.primary2,
                                ]),
                            // border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Xác nhận",
                                style: TextStyle(
                                    color: activeRadio == 0
                                        ? Color.fromRGBO(200, 200, 200, 1)
                                        : Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: "SF Bold",
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    ).then((value) => {
          setState(() => {activeRadio = 0})
        });
  }

  // dialogOrderSuccess() {
  //   return showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       insetPadding: EdgeInsets.all(15),
  //       contentPadding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
  //       titlePadding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
  //       title: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
  //       content: StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
  //         return SizedBox(
  //           height: 400,
  //           child: Column(
  //             // crossAxisAlignment: CrossAxisAlignment.center,
  //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       Positioned(
  //                           top: 0,
  //                           left: 0,
  //                           right: 0,
  //                           bottom: 0,
  //                           child: Image(
  //                               // color:70olors.red,

  //                               fit: BoxFit.cover,
  //                               image: NetworkImage("https://cdn-icons-png.flaticon.com/512/7518/7518748.png"))),
  //                       Image(
  //                           // color:70olors.red,
  //                           height: 50,
  //                           width: 50,
  //                           fit: BoxFit.cover,
  //                           image: NetworkImage("https://i.pinimg.com/564x/86/fb/cd/86fbcdecb33bba33c132c46b6a53506a.jpg")),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               // InkWell(
  //               //   onTap: () {
  //               //     activeRadio == 0
  //               //         ? null
  //               //         : {
  //               //             Navigator.pop(context),
  //               //             // mystate(() => {
  //               //             //       activeRadio = 0,
  //               //             //       activeRadioMessage = "",
  //               //             //     }),
  //               //           };
  //               //   },
  //               //   child: Container(
  //               //     color: Colors.white,
  //               //     child: Column(
  //               //       children: [
  //               //         Container(
  //               //           height: 45,
  //               //           decoration: BoxDecoration(
  //               //             borderRadius: BorderRadius.circular(10),
  //               //             color: activeRadio == 0 ? MaterialColors.grey : MaterialColors.primary,
  //               //             border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
  //               //           ),
  //               //           child: Row(
  //               //             crossAxisAlignment: CrossAxisAlignment.center,
  //               //             mainAxisAlignment: MainAxisAlignment.center,
  //               //             children: [
  //               //               Text(
  //               //                 "Xác nhận",
  //               //                 style: TextStyle(color: activeRadio == 0 ? Color.fromRGBO(200, 200, 200, 1) : Color.fromARGB(255, 255, 255, 255), fontFamily: "SF Bold", fontSize: 16),
  //               //               ),
  //               //             ],
  //               //           ),
  //               //         ),
  //               //       ],
  //               //     ),
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   ).then((value) => {
  //         setState(() => {activeRadio = 0})
  //       });
  // }

  dialogConfirmOrder(num index, num orderActionId, String shipperId,
      num actionType, String message) {
    return Dialogs.materialDialog(
        dialogShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        // msg: 'Bạn sẽ không thể nhận được đơn hàng cho đến khi mở lại',
        msgAlign: TextAlign.center,
        // title: "Bạn có chắc muốn hủy đơn hàng?",
        color: Colors.white,
        context: context,
        customView: Container(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Hủy đơn hàng",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "SF SemiBold",
                    fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bạn muốn hủy đơn với lý do: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SF Regular",
                            fontSize: 15),
                      ),
                      TextSpan(
                        text: '$message',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "SF SemiBold",
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.symmetric(vertical: 5),
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
                                Color.fromRGBO(220, 220, 220, 1),
                                Color.fromRGBO(200, 200, 200, 1)
                              ])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.black54,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          const Text(
                            'Đóng',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1,
                              fontFamily: "SF SemiBold",
                            ),
                          ),
                        ],
                      )),
                ),
              )),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 38,
                child: InkWell(
                  onTap: () {
                    hanldeCancel(
                        index, orderActionId, shipperId, actionType, message);
                  },
                  child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.symmetric(vertical: 5),
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
                              colors: [Colors.redAccent, Colors.red])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          const Text(
                            'Hủy',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1,
                              fontFamily: "SF SemiBold",
                            ),
                          ),
                        ],
                      )),
                ),
              )),
        ]);
    //     showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) => AlertDialog(
    //     contentPadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
    //     titlePadding: EdgeInsets.only(left: 15, right: 15, top: 15),
    //     title: Text(
    //       'Hủy đơn hàng',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(color: Colors.black, fontFamily: "SF Bold", fontSize: 18),
    //     ),
    //     content: Text.rich(
    //       TextSpan(
    //         children: [
    //           TextSpan(
    //             text: 'Bạn có chắc muốn hủy đơn với lý do: ',
    //             style: TextStyle(color: Colors.black, fontFamily: "SF Regular", fontSize: 16),
    //           ),
    //           TextSpan(
    //             text: '$message',
    //             style: TextStyle(color: Colors.black, fontFamily: "SF SemiBold", fontSize: 16),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: <Widget>[
    //       Container(
    //         padding: EdgeInsets.all(5),
    //         child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //           Expanded(
    //             child: Container(
    //                 decoration: const BoxDecoration(color: Colors.white),
    //                 // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
    //                 width: MediaQuery.of(context).size.width,
    //                 child: SizedBox(
    //                   height: 38,
    //                   child: InkWell(
    //                     onTap: () {
    //                       hanldeCancel(index, orderActionId, shipperId, actionType, message);
    //                     },
    //                     child: Container(
    //                         // width: MediaQuery.of(context).size.width,
    //                         // padding: const EdgeInsets.symmetric(vertical: 5),
    //                         alignment: Alignment.center,
    //                         decoration: BoxDecoration(
    //                             borderRadius: const BorderRadius.all(Radius.circular(8)),
    //                             boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
    //                             gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.redAccent, Colors.red])),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             const Text(
    //                               'Hủy',
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 color: Colors.white,
    //                                 height: 1,
    //                                 fontFamily: "SF SemiBold",
    //                               ),
    //                             ),
    //                           ],
    //                         )),
    //                   ),
    //                 )),
    //           ),
    //           Padding(padding: EdgeInsets.all(7)),
    //           Expanded(
    //             child: SizedBox(
    //               height: 40,
    //               child: ElevatedButton(
    //                 child: Text(
    //                   "Đóng",
    //                   style: TextStyle(color: Colors.black, fontFamily: "SF SemiBold", fontSize: 15),
    //                 ),
    //                 style: ElevatedButton.styleFrom(
    //                   primary: Colors.white,
    //                   textStyle: TextStyle(color: Colors.black),
    //                   shadowColor: Colors.white,
    //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.black45, width: 1)),
    //                 ),
    //                 onPressed: () => {Navigator.pop(context)},
    //               ),
    //             ),
    //           ),
    //         ]),
    //       )
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromRGBO(220, 220, 220, 1)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "#${widget.orderId}",
                      style: TextStyle(
                        fontFamily: "SF Regular",
                        color: MaterialColors.black,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                            // color:70olors.red,
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            image: NetworkImage((widget.segment ==
                                        OrderAction.pickupStore ||
                                    widget.segment == OrderAction.pickupHub)
                                ? "https://cdn-icons-png.flaticon.com/512/4521/4521931.png"
                                : "https://cdn-icons-png.flaticon.com/512/7541/7541900.png")),
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            ((widget.segment == OrderAction.pickupStore ||
                                    widget.segment == OrderAction.pickupHub)
                                ? "Lấy Hàng"
                                : "Giao hàng"),
                            style: TextStyle(
                              fontFamily: "SF Medium",
                              color: MaterialColors.primary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.statusEdge == StatusEdge.todo) ...[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text(
                          getCameraText(widget.segment),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SF Bold",
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MaterialColors.primary,
                          textStyle: TextStyle(color: Colors.black),
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      if (_image != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            _image!,
                            height: 500,
                            width: 500,
                          ),
                        ),
                    ],
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(220, 220, 220, 1),
                  thickness: 1,
                ),
              ],
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border(
              //           top: BorderSide(
              //               color: Color.fromRGBO(220, 220, 220, 1)))),
              // ),
              SizedBox(
                height: 10,
              ),
              if (widget.listProduct.isNotEmpty)
                ...widget.listProduct.map((item) {
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${item["quantity"]} x",
                                style: const TextStyle(
                                    color: MaterialColors.black,
                                    fontFamily: "SF Regular",
                                    fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  item["productName"],
                                  style: const TextStyle(
                                      color: MaterialColors.black,
                                      fontFamily: "SF Regular",
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "₫${currencyFormatter.format((item["price"]).toInt()).toString()}",
                          style: const TextStyle(
                              color: MaterialColors.black,
                              fontFamily: "SF Regular",
                              fontSize: 14),
                        )
                      ],
                    ),
                  );
                }).toList(),
              SizedBox(
                height: 5,
              ),

              // SizedBox(
              //   height: 5,
              // ),
              if (widget.statusEdge == StatusEdge.todo ||
                  widget.statusEdge == StatusEdge.done)
                Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                showModal(
                                    widget.index,
                                    widget.status,
                                    widget.listProduct,
                                    widget.customerNote,
                                    widget.orderNote,
                                    widget.phone,
                                    widget.name,
                                    widget.total,
                                    widget.shipCost,
                                    widget.segment,
                                    widget.shipperId,
                                    widget.orderActionId,
                                    widget.paymentType);
                                // dialogOrder(
                                //     mystate,
                                //     listProduct,
                                //     note,
                                //     phone,
                                //     name,
                                //     total,
                                //     shipCost,
                                //     segment,
                                //     shipperId,
                                //     orderActionId,
                                //     paymentType);
                              },
                              child: Container(
                                height: 40,
                                child: TextButton(
                                  child: Text(
                                    "Xem chi tiết",
                                    style: TextStyle(
                                        color: MaterialColors.primary,
                                        fontFamily: "SF SemiBold",
                                        fontSize: 15),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MaterialColors.white,
                                    textStyle: TextStyle(
                                        color: MaterialColors.primary),
                                    shadowColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: MaterialColors.primary),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: null,
                                ),
                              ),
                            )),
                        if (widget.status == StatusOrderAction.todo) ...[
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      MaterialColors.primary,
                                      Color(0xfff7892b),
                                    ]),
                              ),
                              height: 40,
                              child: ElevatedButton(
                                child: isLoadingButton
                                    ? SpinKitDualRing(
                                        color: Colors.white,
                                        size: 25.0,
                                        lineWidth: 3,
                                      )
                                    : Text(
                                        getCompleteText(widget.segment),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "SF SemiBold",
                                            fontSize: 15),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  textStyle: TextStyle(color: Colors.black),
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // onPressed: () => {
                                //   hanldeComplte(
                                //       widget.index,
                                //       widget.orderActionId,
                                //       widget.shipperId,
                                //       widget.segment),
                                // },
                                onPressed: isLoadingButton
                                    ? null
                                    : () => hanldeComplte(
                                        widget.index,
                                        widget.orderActionId,
                                        widget.shipperId,
                                        widget.segment),
                              ),
                            ),
                          )
                        ]
                      ],
                    ))
              else
                SizedBox(
                  height: 10,
                ),
            ],
          ),
        ));
        
  }
}
