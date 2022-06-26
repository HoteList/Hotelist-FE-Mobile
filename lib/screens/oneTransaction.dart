import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class oneTransaction extends StatefulWidget {

  final Transaction transaction;

  const oneTransaction({ Key? key, required this.transaction}) : super(key: key);

  @override
  _oneTransaction createState() => _oneTransaction(transaction);
}

class _oneTransaction extends State<oneTransaction> {

  Transaction transaction;

  _oneTransaction(this.transaction);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        titleSpacing: -40.0,
      ),
      body:
        Padding(padding: EdgeInsets.all(22.0), child: 
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