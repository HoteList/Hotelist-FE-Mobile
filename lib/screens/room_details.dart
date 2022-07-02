import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/models/room_detail_model.dart';
import 'package:hotelist_fe_mobile/models/transaction_model.dart';
import 'package:intl/intl.dart';

import '../constants/color_constant.dart';
import '../utils/user_secure_storage.dart';

class RoomDetails extends StatefulWidget {
  final RoomDetail roomDetail;
  const RoomDetails({ Key? key, required this.roomDetail }) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  DateTime nowDate = DateTime.now();
  DateTime? newDate;
  bool flag = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 219, 145, 105)),
        titleSpacing: -10.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: getTransactionByRoomIdAtTime(widget.roomDetail.id.toString(), newDate != null ? DateFormat('yyyy-MM-dd').format(newDate!) : DateFormat('yyyy-MM-dd').format(nowDate)),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  UserSecureStorage.deleteToken();
                  UserSecureStorage.deleteId();
                  return Text("${snapshot.error}");
                }
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int idx) {
                              return Image.network(
                                widget.roomDetail.image!.split(",")[idx],
                                fit: BoxFit.cover,  
                              );
                            },
                            itemCount: widget.roomDetail.image!.split(",").length,
                            autoplay: widget.roomDetail.image!.split(",").length > 1 ? true : false,
                            autoplayDelay: 3000,
                            layout: SwiperLayout.DEFAULT,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(
                                widget.roomDetail.name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.attach_money,
                                          color: Color.fromARGB(255, 219, 145, 105),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Rp.${widget.roomDetail.price!}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.hotel,
                                          color: Color.fromARGB(255, 219, 145, 105),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${widget.roomDetail.capacity.toString()} kamar ${snapshot.data != null && snapshot.data!.length >= widget.roomDetail.capacity! ? "Unavailable" : "Available"}",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.roomDetail.description!.length > 100 && flag) (
                                      Text(widget.roomDetail.description!.substring(0, 97) + "...")
                                    ) else (
                                      Text(widget.roomDetail.description!)
                                    ),
                                    if (widget.roomDetail.description!.length > 100 && flag) (
                                      TextButton(child: const Text(
                                        "Show More",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 219, 145, 105)
                                        ),
                                      ), onPressed: () {
                                        setState(() {
                                          flag = false;
                                        });
                                      },)
                                    ) else if (widget.roomDetail.description!.length > 100 && !flag) (
                                      TextButton(child: const Text(
                                        "Show Less",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 219, 145, 105)
                                        ),
                                      ), onPressed: () {
                                        setState(() {
                                          flag = true;
                                        });
                                      },)
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, color: Color.fromARGB(255, 219, 145, 105),),
                                  TextButton(
                                    child: Text(
                                      newDate != null ? DateFormat('EEEE, dd-MM-yyyy').format(newDate!) : DateFormat('EEEE, dd-MM-yyyy').format(nowDate),
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                    ),
                                    onPressed: () async {
                                      DateTime? selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: newDate != null ? newDate! : nowDate,
                                        firstDate: nowDate,
                                        lastDate: DateTime(nowDate.year + 2),
                                      );
                                      if (selectedDate == null) return;
                                      setState(() =>
                                        newDate = selectedDate
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(255, 219, 145, 105)
                                  ),
                                  child: const Text("Book"),
                                  onPressed: snapshot.data != null && snapshot.data!.length >= widget.roomDetail.capacity! ? null : () async {
                                    showDialog(context: context, builder: (BuildContext context) {
                                      return const CircularProgressIndicator();
                                    });
                                    dynamic resp = await addTransaction(widget.roomDetail.id, newDate != null ? DateFormat('yyyy/MM/dd').format(newDate!) : DateFormat('yyyy/MM/dd').format(nowDate));
                                    Navigator.pop(context);
                                    showDialog(context: context, builder: (BuildContext context) {
                                      return AlertDialog(title: Text(resp == "Error" ? "Error" : "Berhasil Book"),);
                                    });
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ); 
                  }
                );
              }
            ),
          ),
        ],
      )
    );
  }
}