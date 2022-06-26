import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/models/user_model.dart';
import 'package:hotelist_fe_mobile/screens/editProfile.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({ Key? key }) : super(key: key);

  @override
  State<Profile_page> createState() => _Profile_page();
}

class _Profile_page extends State<Profile_page> {

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(child: 
          FutureBuilder<User>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.image != "") {
                  return Center(child: 
                    Column(children: [
                      Container(
                        child: ClipRRect(child: 
                          Image.network(snapshot.data!.image), 
                          borderRadius: BorderRadius.circular(300),
                        ),
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(300))
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.full_name, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.email, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.username, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      ElevatedButton(onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (
                                Edit_Profile_page(user: snapshot.data!,)
                              )
                            ),
                          );
                        },
                        child: Text("Edit")
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton(onPressed: () {
                          UserSecureStorage.deleteToken();
                          UserSecureStorage.deleteId(); 
                          Navigator.pop(context);
                        },
                        child: Text("Log Out"),
                      ),
                    ])
                  );
                } else {
                  return Center(child: 
                    Column(children: [
                      Container(
                        child: ClipRRect(child: 
                          Image.network("https://images-ext-2.discordapp.net/external/d87yrm_CwOAdx9AWhBQz4Aoh7oVBg7hilafLL__S984/https/i.pinimg.com/474x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg"), 
                          borderRadius: BorderRadius.circular(300),
                        ),
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(300))
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.full_name, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.email, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.username, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 25,),
                      ElevatedButton(onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (
                                Edit_Profile_page(user: snapshot.data!,)
                              )
                            ),
                          );
                        },
                        child: Text("Edit")
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton(onPressed: () {
                          UserSecureStorage.deleteToken();
                          UserSecureStorage.deleteId(); 
                          Navigator.pop(context);
                        },
                        child: Text("Log Out")
                      ),
                    ])
                  );
                }
              } else if (snapshot.hasError) {
                UserSecureStorage.deleteToken();
                UserSecureStorage.deleteId();
                return Text("${snapshot.error}");
              } else {
                return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
              }
            }
          ),
        )
      ]),
    );
  }
}