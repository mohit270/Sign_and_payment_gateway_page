import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:upi_india/upi_india.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key, required this.context});
  final BuildContext context;
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String os = Platform.operatingSystem;
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "7389809913@paytm",
      receiverName: 'Mohit Kundnani',
      transactionRefId: '',
      transactionNote: 'Buy a Coffe For Namaste Yoga Team',
      amount: 49.00,
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.length == 0) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        Navigator.pop(widget.context);
        break;
      case UpiPaymentStatus.SUBMITTED:
        log('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        log('Transaction Failed');
        break;
      default:
        log('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upiDetails = UPIDetails(
        upiID: "7389809913@paytm",
        payeeName: "Mohit Kundnani",
        amount: 49,
        transactionNote: "Buy a Coffe For Namaste Yoga Team");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade600,
        title: const Text('THANK MOHIT KUNDNANI'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Platform.isAndroid
            ? Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'THANK FROM NAMASTE \nYOGA TEAM',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blueGrey.shade600),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Rs 49/-",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        color: Colors.blueGrey.shade600),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: displayUpiApps(),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _transaction,
                      builder: (BuildContext context,
                          AsyncSnapshot<UpiResponse> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                _upiErrorHandler(snapshot.error.runtimeType),
                                style: header,
                              ),
                            );
                          }
                          UpiResponse upiResponse = snapshot.data!;
                          String status = upiResponse.status ?? 'N/A';
                          _checkTxnStatus(status);

                          return displayTransactionData(
                              'Status', status.toUpperCase());
                        } else {
                          return const Center(
                            child: Text(''),
                          );
                        }
                      },
                    ),
                  )
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      'THANK FROM NAMASTE \nYOGA TEAM',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blueGrey.shade600),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Rs 49/-",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 40,
                          color: Colors.blueGrey.shade600),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    UPIPaymentQRCode(
                      size: 220,
                      upiDetails: upiDetails,
                      embeddedImagePath: 'images/upi.jpeg',
                      embeddedImageSize: const Size(60, 60),
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.circle,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Scan QR to Pay",
                      style: TextStyle(
                          color: Colors.blueGrey[600],
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
