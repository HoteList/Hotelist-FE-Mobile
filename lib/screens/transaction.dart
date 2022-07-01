import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/screens/oneTransaction.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({ Key? key }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPage();
}

class _TransactionPage extends State<TransactionPage> {

  @override
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(snapshot.data![index].hotel_name.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(snapshot.data![index].room_detail_name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Row(
                                  children: [
                                    Text(snapshot.data![index].book_date, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                const Icon(Icons.arrow_right,)
                            ]
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (
                                OneTransaction(transaction: snapshot.data![index])
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
                return const SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
              }
            }
          ),
        ),
      ]),
    );
  }
}