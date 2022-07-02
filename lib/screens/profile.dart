import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/models/user_model.dart';
import 'package:hotelist_fe_mobile/screens/editProfile.dart';
import 'package:hotelist_fe_mobile/screens/login.dart';
import 'package:hotelist_fe_mobile/screens/oneTransaction.dart';
import 'package:hotelist_fe_mobile/utils/user_geolocator.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

import '../utils/geocode_location.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Position? _currentPosition;
  String? address = "";
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final currentPosition = await UserGeolocator.getCurrentPosition();
    final transaction = await getTransactionsByUserId();
    getAddress(currentPosition.latitude, currentPosition.longitude);
    transaction.sort((a, b) => b.book_date.compareTo(a.book_date));
    transaction.where((element) => DateTime.parse(element.book_date).isAfter(DateTime.now())).toList();
    setState(() {
      _currentPosition = currentPosition;
      transactions = transaction;
    });
  }

  void getAddress(double? lat, double? lot) async {
    final res = await GeocodeLocation.getAddress(lat, lot);

    setState(() {
      address = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
        Expanded(child: 
          FutureBuilder<User>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.data!.image != "") (
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ClipRRect(child: 
                            Image.network(snapshot.data!.image),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        )
                      ) else (
                        Container(
                          child: ClipRRect(child:
                            Center(
                              child: Text(
                                snapshot.data!.username[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown
                          ),
                        )
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "${snapshot.data!.username} (${snapshot.data!.full_name})",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          if (_currentPosition != null) (
                            Text(
                              address!,
                              style: const TextStyle(color: Colors.grey),
                            )
                          ) else (
                            const Text(
                              "Unknown position",
                              style: TextStyle(color: Colors.grey),
                            )
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => (
                                    EditProfilePage(user: snapshot.data!,)
                                  )
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 219, 145, 105)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Edit Profile"),
                                Icon(Icons.chevron_right_rounded)
                              ],
                            ),
                          ) 
                        ],
                      ),
                    ],
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
        SizedBox(height: MediaQuery.of(context).size.height / 16,),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: const Text(
                  "My Transaction",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                margin: const EdgeInsets.only(bottom: 10),
              ),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: transactions.length > 5 ? 5 : transactions.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, _) => const SizedBox(width: 10,),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OneTransaction(
                            transaction: transactions[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 219, 145, 105),
                      shadowColor: Colors.blueGrey,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                transactions[index].hotel_name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 5),
                            ),
                            Text(
                              "${transactions[index].room_detail_name} room",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Text(
                                  transactions[index].book_date,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 12,),
              ElevatedButton(
                onPressed: () {
                  UserSecureStorage.deleteToken();
                  UserSecureStorage.deleteId(); 
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: const Center(
                    child: Text("Logout"),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 219, 145, 105)
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}