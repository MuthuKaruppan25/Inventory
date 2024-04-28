import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Universal extends StatefulWidget {
  const Universal({Key? key}) : super(key: key);

  @override
  State<Universal> createState() => _UniversalState();
}

class _UniversalState extends State<Universal> {
  String shiftCharacter(String character) {
    int charCode = character.codeUnitAt(0);
    int shiftedCharCode = charCode + 1;
    String shiftedCharacter = String.fromCharCode(shiftedCharCode);
    return shiftedCharacter;
  }
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,26, 26, 29),
        title: Center(child: Text("Inventory")),

      ),
      body:StreamBuilder<QuerySnapshot>(

        stream:(_searchController.text=="")?FirebaseFirestore.instance.collection("Universal").orderBy("timestamp",descending: true).snapshots():FirebaseFirestore.instance.collection("Universal").where("name",isLessThanOrEqualTo: _searchController.text.toString().substring(0,_searchController.text.toString().length-1)+shiftCharacter(_searchController.text.toString()[_searchController.text.toString().length-1]),isGreaterThanOrEqualTo: _searchController.text.toString()).snapshots(),



        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError)
          {
            return Text("${snapshot.error}");
          }
          else
          {
            if(snapshot.hasData) {
              List<DocumentSnapshot>nn=snapshot.data.docs;
              final now = DateTime.now();
              final last24Hours = now.subtract(Duration(hours: 24));
              final filteredItems = nn.where((doc) {
                final timestamp = (doc["timestamp"] as Timestamp).toDate();
                return timestamp.isBefore(last24Hours);
              }).toList();
              final Items = nn.where((doc) {
                final timestamp = (doc["timestamp"] as Timestamp).toDate();

                return timestamp.isAfter(last24Hours);
              }).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: TextField(

                          controller: _searchController,
                          onChanged: (val){
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Search Item',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),

                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Text("Today",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                    SizedBox(height: 5,),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Items.length,
                      itemBuilder: (BuildContext context,ind){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            children: [
                              GestureDetector(

                                  child: Container(


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
                                                    padding: const EdgeInsets.only(left:15.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("${Items[ind]["firstname"]} ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),
                                                            Text("posted",style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),)
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          children: [
                                                            Text("Name: ",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),),
                                                            Text("${Items[ind]["name"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w700)),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: ()=>{
                                    showDialog<String>(

                                        context: context,

                                        builder: (BuildContext context) {


                                          return AlertDialog(

                                            title: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                child: Column(
                                                  children: [

                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [

                                                              Padding(
                                                                padding: const EdgeInsets.only(left:15.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text("${Items[ind]["firstname"]}  ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)),
                                                                        Text("posted",style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 5,),
                                                                    Text("${Items[ind]["name"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500)),
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Sales Price: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),
                                                                        Text("Rs.${Items[ind]["price"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )
                                                                    ,
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Stock Available: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${Items[ind]["quantity"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    ),

                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Item Type: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${Items[ind]["type"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("hsbn no: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${Items[ind]["hsbn"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("gst type: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${Items[ind]["gsttype"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),


                                          );}
                                    ),
                                  }
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          Text("Older",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                    SizedBox(height: 5,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context,ind){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(

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
                                                  padding: const EdgeInsets.only(left:15.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      Row(
                                                        children: [
                                                          Text("${filteredItems[ind]["firstname"]} ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),
                                                          Text("posted",style: GoogleFonts.poppins(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),)
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        children: [
                                                          Text("Name: ",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),),
                                                          Text("${filteredItems[ind]["name"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),

                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                  onTap: ()=>{
                                    showDialog<String>(

                                        context: context,

                                        builder: (BuildContext context) {


                                          return AlertDialog(

                                            title: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                child: Column(
                                                  children: [

                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [

                                                              Padding(
                                                                padding: const EdgeInsets.only(left:15.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text("${filteredItems[ind]["firstname"]}  ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)),
                                                                        Text("posted",style: GoogleFonts.poppins(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 5,),
                                                                    Text("${filteredItems[ind]["name"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold)),
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Sales Price: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),
                                                                        Text("Rs.${filteredItems[ind]["price"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )
                                                                    ,SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Stock Available: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${filteredItems[ind]["quantity"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )
                                                                    ,SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("Item Type: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${filteredItems[ind]["type"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )
                                                                    ,SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("hsbn no: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${filteredItems[ind]["hsbn"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 5,),
                                                                    Row(
                                                                      children: [
                                                                        Text("gst type: ",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold )),

                                                                        Text("${filteredItems[ind]["gsttype"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 14,)),
                                                                      ],
                                                                    )

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),


                                          );}
                                    ),
                                  }
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
