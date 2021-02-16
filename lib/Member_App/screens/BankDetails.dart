import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankDetails extends StatefulWidget {
  var bankData;

  BankDetails({this.bankData});

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bank Details', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.bankData["BankName"] == "" ? "Bank Of Baroda"
             : "${widget.bankData["BankName"]}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
            ),
            leading: Icon(Icons.account_balance),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.bankData["UPIID"] == null ? "UPI Id : 9995552221@upi"
                  :"UPI Id : ${widget.bankData["UPIID"]}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Account Number : ${widget.bankData["AccountNo"]}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "IFSC Number : ${widget.bankData["IFSCCode"]}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(widget.bankData["UPIID"] == null ? "Address : Surat, Gujarat"
                 : "Adress : ${widget.bankData["BankAddress"]}",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300],)

        ],
      ),
    );
  }
}
