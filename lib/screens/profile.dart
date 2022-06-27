import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/models/user_model.dart';
import 'package:hotelist_fe_mobile/screens/editProfile.dart';
import 'package:hotelist_fe_mobile/screens/login.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
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
                if (snapshot.data!.image != "") {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: ClipRRect(child: 
                                Image.network(snapshot.data!.image), 
                                borderRadius: BorderRadius.circular(70),
                              ),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: const BorderRadius.all(Radius.circular(70))
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data!.username} (${snapshot.data!.full_name})",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  snapshot.data!.email,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            TextButton(onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => (
                                      EditProfilePage(user: snapshot.data!,)
                                    )
                                  ),
                                );
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.amber.shade700
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: 
                            ElevatedButton(
                              onPressed: () {
                                UserSecureStorage.deleteToken();
                                UserSecureStorage.deleteId(); 
                                Navigator.pop(context);
                              },
                              child: const Text("Log Out"),
                            ),
                        ),
                      ]
                    )
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
                      // SizedBox(height: 25,),
                      Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.full_name, style: TextStyle(fontSize: 20)),
                      // SizedBox(height: 25,),
                      Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.email, style: TextStyle(fontSize: 20)),
                      // SizedBox(height: 25,),
                      Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(snapshot.data!.username, style: TextStyle(fontSize: 20)),
                      // SizedBox(height: 25,),
                      ElevatedButton(onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (
                                EditProfilePage(user: snapshot.data!,)
                              )
                            ),
                          );
                        },
                        child: const Text("Edit")
                      ),
                      // SizedBox(height: 30,),
                      ElevatedButton(onPressed: () async {
                          await UserSecureStorage.deleteToken();
                          await UserSecureStorage.deleteId(); 
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                        },
                        child: const Text("Log Out")
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