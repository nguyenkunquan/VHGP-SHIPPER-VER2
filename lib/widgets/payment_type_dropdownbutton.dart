import 'package:flutter/material.dart';

class PaymentTypeDropDownButton extends StatefulWidget {
  final num paymentType;
  final ValueChanged<num> onPaymentTypeChanged; // ValueChanged<T> is used in Flutter for widget callbacks.

  PaymentTypeDropDownButton({required this.paymentType, required this.onPaymentTypeChanged});

  @override
  _PaymentTypeDropDownButtonState createState() =>
      _PaymentTypeDropDownButtonState();
}

class _PaymentTypeDropDownButtonState extends State<PaymentTypeDropDownButton> {
  late num paymentType;
  List<String> paymentTypeItems = ['Tiền mặt', 'Chuyển khoản'];

  @override
  void initState() {
    super.initState();
    paymentType = widget.paymentType;
  }

  @override
  Widget build(BuildContext context) {
    if(paymentType == 2) {
      return const Text(
        "Đã thanh toán",
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontFamily: "SF Semibold",
        ),
      );
    } // Set default payment type to "Tiền mặt" (0
    else {
      return DropdownButton<String>(
        value: paymentTypeItems[paymentType.toInt()],
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(
            color: Colors.black, fontFamily: "SF Semibold", fontSize: 16),
        underline: Container(
          height: 2,
          color: Colors.orangeAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == "Tiền mặt") {
              paymentType = 0;
            } else if (newValue == "Chuyển khoản") {
              paymentType = 1;
            }
          });
          widget.onPaymentTypeChanged(paymentType);
        },
        items: paymentTypeItems
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }
  }
}