import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/screens/oneTransaction.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class Transaction_page extends StatefulWidget {
  const Transaction_page({ Key? key }) : super(key: key);

  @override
  State<Transaction_page> createState() => _Transaction_page();
}

class _Transaction_page extends State<Transaction_page> {

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(child: 
          FutureBuilder<List<Transaction>>(
            future: getTransactionsByUserId(),
            builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(child:
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child:
                            Row(children: [
                              Column(children: [
                                  Text(snapshot.data![index].hotel_name.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16,),
                                  Text(snapshot.data![index].room_detail_name, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(width: 100,),
                              Row(children: [
                                  Text(snapshot.data![index].book_date, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                              SizedBox(width: 50,),
                              Column(children: [
                                Icon(Icons.arrow_right,)
                              ],)
                            ]
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (
                                oneTransaction(transaction: snapshot.data![index])
                              )
                            )
                          );
                        },
                        splashColor: Colors.blue.withAlpha(30),
                      )
                    );
                  }
                );
              } else if (snapshot.hasError) {
                UserSecureStorage.deleteToken();
                UserSecureStorage.deleteId();
                return Text("${snapshot.error}");
              } else {
                return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
              }
            }
          ),
        ),
      ]),
    );
  }
}