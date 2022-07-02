import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/models/room_detail_model.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:hotelist_fe_mobile/screens/room_details.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class OneTransaction extends StatefulWidget {

  final Transaction transaction;

  const OneTransaction({ Key? key, required this.transaction}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<OneTransaction> createState() => _OneTransaction();
}

class _OneTransaction extends State<OneTransaction> {

  RoomDetail? roomDetail;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final roomDetail = await getRoomDetailsById(widget.transaction.room_id.toString());

    setState(() => this.roomDetail = roomDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 219, 145, 105)),
        elevation: 0,
        titleSpacing: -10.0,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selesai",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.blueGrey.shade400,
                  thickness: 0.3,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tanggal Pemesanan"),
                    Text(widget.transaction.book_date)
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Detail Pemesanan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.transaction.hotel_name,
                    )
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              height: 50,
                              child: Swiper(
                                itemBuilder: (BuildContext context, int idx) {
                                  return Image.network(
                                    roomDetail!.image!.split(",")[idx],
                                    fit: BoxFit.cover,  
                                  );
                                },
                                itemCount: roomDetail != null ? roomDetail!.image!.split(",").length : 0,
                                autoplay: roomDetail != null && roomDetail!.image!.split(",").length > 1 ? true : false,
                                autoplayDelay: 3000,
                                layout: SwiperLayout.DEFAULT,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.transaction.room_detail_name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Divider(
                                  color: Colors.transparent,
                                  thickness: 0.3,
                                  height: 5,
                                ),
                                Text(
                                  "1 × Rp${roomDetail != null ? roomDetail!.price : 0}"
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.blueGrey.shade400,
                          thickness: 0.3,
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Harga",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Divider(
                                  color: Colors.transparent,
                                  thickness: 0.3,
                                  height: 5,
                                ),
                                Text(
                                  "Rp${roomDetail != null ? roomDetail!.price : 0}"
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 219, 145, 105),
                                onPrimary: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetails(
                                      roomDetail: roomDetail!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Lihat Ruangan"
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      //   Padding(padding: EdgeInsets.all(16.0), child: 
      //     Column(children: [
      //       Row(children: [
      //         Text("Hotel Name : ", style: TextStyle(fontWeight: FontWeight.bold),),
      //         Text(widget.transaction.hotel_name)
      //       ],),
      //       Row(children: [
      //         Text("Room id : ", style: TextStyle(fontWeight: FontWeight.bold)),
      //         Text(widget.transaction.room_id.toString())
      //       ],),
      //       Row(children: [
      //         Text("Room Name : ", style: TextStyle(fontWeight: FontWeight.bold)),
      //         Text(widget.transaction.room_detail_name)
      //       ],),
      //       Row(children: [
      //         Text("Date : ", style: TextStyle(fontWeight: FontWeight.bold)),
      //         Text(widget.transaction.book_date)
      //       ],)
      //     ],
      //   ) 
      // )
    );
  }
}