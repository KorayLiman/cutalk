import 'dart:io';
import 'package:cutalk/models/Usermodel.dart';
import 'package:cutalk/pages/Settings_page.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/pages/Announcements_page.dart';
import 'package:cutalk/pages/Landing_page.dart';
import 'package:cutalk/pages/Talk_Page.dart';
import 'package:cutalk/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  File? image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late firebase_storage.Reference ref;
  final ImagePicker _picker = ImagePicker();
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            bottomNavigationBar: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(74, 0, 224, 1),
                Color.fromRGBO(142, 45, 226, 1)
              ])),
              child: TabBar(controller: _tabController, tabs: [
                Tab(
                  text: "Anasayfa",
                  iconMargin: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.home,
                  ),
                ),
                Tab(
                  icon: Icon(Icons.message),
                  text: "Sohbet",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.announcement),
                  text: "Duyurular",
                  iconMargin: EdgeInsets.all(0),
                )
              ]),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                      currentAccountPicture: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            _SelectFromGallery();
                                            Navigator.pop(context);
                                          },
                                          label: Text("Galeriden se??"),
                                          icon: Icon(
                                            Icons.browse_gallery,
                                          )),
                                      TextButton.icon(
                                          label: Text("Kameradan ??ek"),
                                          onPressed: () {
                                            _SelectFromCamera();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.camera))
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      accountName: FutureBuilder(
                        future:
                            GetUserName(FirebaseAuth.instance.currentUser?.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else {
                            return Text("??sim al??namad??");
                          }
                        },
                      ),
                      accountEmail: Text(
                          FirebaseAuth.instance.currentUser == null
                              ? "Mail al??namad??"
                              : FirebaseAuth.instance.currentUser!.email
                                  .toString())),
                  ListTile(
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ));
                    },
                    title: Text("Kullan??c?? ayarlar??"),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(74, 0, 224, 1),
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      showAboutDialog(
                          context: context,
                          applicationName: "C??Talk",
                          applicationVersion: "v1.0",
                          children: [
                            Text(
                                "Kullan??c?? foto??raf??n??z?? ayarlar butonundan avatar??n??z??n ??zerine t??klayarak de??i??tirebilirsiniz")
                            // Text("1- Kullan??c??lar sohbetlere foto??raf ekleyebilecek"),
                            // Text("2- Kullan??c??lar profil foto??raflar??n?? se??ebilecek"),
                            // Text("3- Mail do??rulama getirilecek"),
                            // Text("4- Duyurular b??l??m?? yap??lacak"),
                            // Text("5- Firestore izinleri d??zenlenecek"),
                            // Text("6- Sohbet ekleme aray??z?? iyile??tirilecek")
                          ]);
                    },
                    icon: Icon(Icons.question_mark)),
                IconButton(
                    onPressed: () async {
                      if (GoogleSignIn().currentUser != null) {
                        await GoogleSignIn().disconnect();
                      }

                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())),
                          (route) => false);
                    },
                    icon: Icon(Icons.logout))
              ],
              centerTitle: true,
              title: const Text("Cumhuriyet ??niversitesi"),
            ),
            body: TabBarView(
                controller: _tabController,
                children: [LandingPage(), TalkPage(), AnnouncementsPage()]),
          );
        } else {
          return Scaffold(
            bottomNavigationBar: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(74, 0, 224, 1),
                Color.fromRGBO(142, 45, 226, 1)
              ])),
              child: TabBar(controller: _tabController, tabs: [
                Tab(
                  text: "Anasayfa",
                  iconMargin: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.home,
                  ),
                ),
                Tab(
                  icon: Icon(Icons.message),
                  text: "Sohbet",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.announcement),
                  text: "Duyurular",
                  iconMargin: EdgeInsets.all(0),
                )
              ]),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                      currentAccountPicture: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/user_40px.png"),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            _SelectFromGallery();
                                            Navigator.pop(context);
                                          },
                                          label: Text("Galeriden se??"),
                                          icon: Icon(
                                            Icons.browse_gallery,
                                          )),
                                      TextButton.icon(
                                          label: Text("Kameradan ??ek"),
                                          onPressed: () {
                                            _SelectFromCamera();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.camera))
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      accountName: FutureBuilder(
                        future:
                            GetUserName(FirebaseAuth.instance.currentUser?.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else {
                            return Text("??sim al??namad??");
                          }
                        },
                      ),
                      accountEmail: Text(
                          FirebaseAuth.instance.currentUser == null
                              ? "Mail al??namad??"
                              : FirebaseAuth.instance.currentUser!.email
                                  .toString())),
                  ListTile(
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ));
                    },
                    title: Text("Kullan??c?? ayarlar??"),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(74, 0, 224, 1),
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      showAboutDialog(
                          context: context,
                          applicationName: "C??Talk",
                          applicationVersion: "v1.0",
                          children: [
                            Text(
                                "Kullan??c?? foto??raf??n??z?? ayarlar butonundan avatar??n??z??n ??zerine t??klayarak de??i??tirebilirsiniz")
                            // Text("1- Kullan??c??lar sohbetlere foto??raf ekleyebilecek"),
                            // Text("2- Kullan??c??lar profil foto??raflar??n?? se??ebilecek"),
                            // Text("3- Mail do??rulama getirilecek"),
                            // Text("4- Duyurular b??l??m?? yap??lacak"),
                            // Text("5- Firestore izinleri d??zenlenecek"),
                            // Text("6- Sohbet ekleme aray??z?? iyile??tirilecek")
                          ]);
                    },
                    icon: Icon(Icons.question_mark)),
                IconButton(
                    onPressed: () async {
                      if (GoogleSignIn().currentUser != null) {
                        await GoogleSignIn().disconnect();
                      }

                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())),
                          (route) => false);
                    },
                    icon: Icon(Icons.logout))
              ],
              centerTitle: true,
              title: const Text("Cumhuriyet ??niversitesi"),
            ),
            body: TabBarView(
                controller: _tabController,
                children: [LandingPage(), TalkPage(), AnnouncementsPage()]),
          );
        }
      },
    );
  }

  GetUserName(String? id) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("id", isEqualTo: id).get();
    return _result.docs[0]["name"];
  }

  void _SelectFromGallery() async {
    XFile? image1 = await _picker.pickImage(source: ImageSource.gallery);

    image = File(image1!.path);
    ref = storage
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("photo.png");
    var UploadTask = ref.putFile(image!);
    var url = await (await UploadTask).ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({"imagepath": url}, SetOptions(merge: true));
    setState(() {});
  }

  void _SelectFromCamera() async {
    XFile? image1 = await _picker.pickImage(source: ImageSource.camera);
    image = File(image1!.path);

    ref = storage
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("photo.png");
    var UploadTask = ref.putFile(image!);
    var url = await (await UploadTask).ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({"imagepath": url}, SetOptions(merge: true));

    setState(() {});
  }

  Future<String> getImageUrl() async {
    var userdoc = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    return userdoc["imagepath"];
  }
}
