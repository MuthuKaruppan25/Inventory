import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/Itemstrash.dart';
import 'package:inventory/Ordertrash.dart';
import 'package:inventory/company.dart';
import 'package:inventory/customer.dart';
import 'package:inventory/customertrash.dart';
import 'package:inventory/items.dart';
import 'package:inventory/order.dart';
import 'package:inventory/signin.dart';
import 'package:inventory/universal.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
class Home extends StatefulWidget {
  final String dropdownValue;
  const Home({required this.dropdownValue});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? mtoken="";
  void initState(){
    super.initState();
    req();
    get();
    initInfo();

  }
  initInfo()async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitialize,

    );
    void _onNotificationTap(NotificationResponse notificationResponse){
      // Handle notification tap

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Universal()),
      );


    }
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
      }
      BigTextStyleInformation bigTextStyleInformation=BigTextStyleInformation(
        message.notification!.body.toString(),htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('dbnoti', 'dbnoti',importance: Importance.max,styleInformation: bigTextStyleInformation,priority: Priority.high,playSound: true,);
      NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, notificationDetails,payload: message.data['title']);
    });




  }
  void get()async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    mtoken= fcmToken!;

    String user =await FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance.collection("Usertokens").doc(user).set({
      "tokens":mtoken,
      "user":user
    }).then((value) => print("Successful"));
  }
  void req()async{
    FirebaseMessaging messaging=FirebaseMessaging.instance;
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print('User granted');
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print('User granted provisional');
    }
    else{
      print('User declined');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(

        backgroundColor: Colors.white,
        width: 180,
        child: ListView(
          children: [
            DrawerHeader(decoration: BoxDecoration(color: Colors.white),
              child:Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Row(

                  children: [
                    Icon(Icons.data_exploration,color: Colors.deepPurple,),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'inven',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'EX',
                            style: GoogleFonts.poppins(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'pert',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            ListTile(
              onTap: ()async{
                await FirebaseAuth.instance.signOut();
                PersistentNavBarNavigator.pushNewScreen(
                  context,

                  screen: Signin(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );},
              hoverColor: Colors.blueAccent,
              title: Text("Logout"),
            ),
            ListTile(
              onTap: ()async{

                PersistentNavBarNavigator.pushNewScreen(
                  context,

                  screen: Company(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );},
              hoverColor: Colors.blueAccent,
              title: Text("Change profile"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,26, 26, 29),
        title: Center(child: Text("${widget.dropdownValue}'s Inventory")),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: Icon(Icons.notification_add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        StreamBuilder<DocumentSnapshot>(
    stream:FirebaseFirestore.instance.collection(widget.dropdownValue).doc("personal").snapshots(),


    builder: (context, AsyncSnapshot snapshot) {
    if(snapshot.hasError)
    {
    return Text("${snapshot.error}");
    }
    else
    {
    if(snapshot.hasData) {
    DocumentSnapshot nn=snapshot.data;
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255,26, 26, 29)
      ),
      height: 252,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    nn.get("name")
                    ,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    nn.get("gstno"),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.phone,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text(
                        nn.get("phone"),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );}
    else{
      return CircularProgressIndicator();
      }
    }}),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Manage All",style: GoogleFonts.poppins(color: Colors.black, fontSize: 18,)),

                ],),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Items(dropdownValue: widget.dropdownValue),
                        ),
                      );
                  },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3), // changes the shadow position
                          ),

                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Column(
                                children: [
                                  Text("Items",style:GoogleFonts.poppins(color: Colors.black, fontSize: 15,)),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Container(height: 50,width: 50,
                                        child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhS0I_z93xg5Y-g3SmgqwqesxlqH9rvp3lvILcA0MQAbkSH5SR589_3cgce6kVpkFg-Jzi8tOfbxY&usqp=CAU&ec=48665699'),
                                  )),
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Customer(dropdownValue: widget.dropdownValue),
                        ),
                      );
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3), // changes the shadow position
                          ),

                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("Customers",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,))),
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Container(height: 60,width: 60,
                                child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeOqJlZbM83qVeuyEM_qAjL3yu1SX5yhWKuM9L2pMYCA&usqp=CAU&ec=48665699'),
                              )),
                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Orders(dropdownValue: widget.dropdownValue),
                        ),
                      );
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3), // changes the shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("Orders",style:GoogleFonts.poppins(color: Colors.black, fontSize: 15,))),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Container(height: 50,width: 50,
                                child: Image.network('https://cdn-icons-png.flaticon.com/512/1356/1356594.png'),
                              )),
                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                    ),
                  ),


                  // Add more containers as needed
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sales Activity",style: GoogleFonts.poppins(color: Colors.black, fontSize: 18,)),
                  Icon(Icons.refresh)
                ],),
            ),
            ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,

                itemCount: 2,
                itemBuilder: (context,index){
                  List<String> a=["https://static.vecteezy.com/system/resources/previews/004/461/894/original/invoice-payments-flat-illustration-bill-pay-online-receipt-cartoon-concept-internet-banking-account-ebanking-user-credit-cards-transactions-instant-money-transfer-by-click-metaphor-vector.jpg",
                    "https://media.istockphoto.com/id/1445750699/pt/vetorial/welcoming-cartoon-parcel-delivery-service-vector-illustration.jpg?s=612x612&w=0&k=20&c=THGXX2WGlbMCZxA58p1yzPByB2dKEn6v_Es_FBA7LSs="
                    ];

                  List<String> b=["Quantity to be invoiced","Quantity already invoiced",];


                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5.0,
                                blurRadius: 5.0,
                                offset: Offset(0, 3), // changes the shadow position
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width*0.9,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Container(height: 70,width: 70,
                                              child: Image.network(a[index])),

                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                  StreamBuilder(
                                      stream:FirebaseFirestore.instance
                                              .collection(widget.dropdownValue).doc("salesorder").collection("salesorder").where("level",isEqualTo: index).snapshots(),
                                      builder:(context,AsyncSnapshot snapshot){

                                      if(snapshot.hasData) {

                                        return Text("${snapshot.data.docs.length}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 30,));
                                      }
                                      else
                                      return CircularProgressIndicator();


                                      }),
                                        SizedBox(height: 5,),
                                        Text(b[index],style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trash",style: GoogleFonts.poppins(color: Colors.black, fontSize: 18,)),

                ],),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Itemstrash(dropdownValue: widget.dropdownValue),
                        ),
                      );
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3), // changes the shadow position
                          ),

                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Column(
                                children: [
                                  Text("Items",style:GoogleFonts.poppins(color: Colors.black, fontSize: 15,)),
                                  SizedBox(height: 10,),
                                  Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Container(height: 50,width: 50,
                                        child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhS0I_z93xg5Y-g3SmgqwqesxlqH9rvp3lvILcA0MQAbkSH5SR589_3cgce6kVpkFg-Jzi8tOfbxY&usqp=CAU&ec=48665699'),
                                      )),
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  Customertrash(dropdownValue: widget.dropdownValue),
                        ),
                      );
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3), // changes the shadow position
                          ),

                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("Customers",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,))),
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Container(height: 60,width: 60,
                                child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeOqJlZbM83qVeuyEM_qAjL3yu1SX5yhWKuM9L2pMYCA&usqp=CAU&ec=48665699'),
                              )),
                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                    ),
                  ),



                  // Add more containers as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
