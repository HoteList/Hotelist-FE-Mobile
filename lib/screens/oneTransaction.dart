import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class OneTransaction extends StatefulWidget {

  final Transaction transaction;

  const OneTransaction({ Key? key, required this.transaction}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _OneTransaction createState() => _OneTransaction(transaction);
}

class _OneTransaction extends State<OneTransaction> {

  Transaction transaction;

  _OneTransaction(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        iconTheme: IconThemeData(color: Colors.amber.shade700),
        elevation: 0,
        titleSpacing: -10.0,
      ),
      body:
        Padding(padding: EdgeInsets.all(16.0), child: 
          Column(children: [
            Row(children: [
              Text("Hotel Name : ", style: TextStyle(fontWeight: FontWeight.bold),),
              Text(transaction.hotel_name)
            ],),
            Row(children: [
              Text("Room id : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(transaction.room_id.toString())
            ],),
            Row(children: [
              Text("Room Name : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(transaction.room_detail_name)
            ],),
            Row(children: [
              Text("Date : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(transaction.book_date)
            ],)
          ],
        ) 
      )
    );
  }
}