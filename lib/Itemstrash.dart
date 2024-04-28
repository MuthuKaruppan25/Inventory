import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Itemstrash extends StatefulWidget {
  final String dropdownValue;
  const Itemstrash({required this.dropdownValue});

  @override
  State<Itemstrash> createState() => _ItemstrashState();
}

class _ItemstrashState extends State<Itemstrash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
    ),
      body:StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection(widget.dropdownValue).doc("itemstrash").collection("itemstrash").snapshots()
        //where("name",isLessThanOrEqualTo: _searchController.text.toString().substring(0,_searchController.text.toString().length-1)+shiftCharacter(_searchController.text.toString()[_searchController.text.toString().length-1]),isGreaterThanOrEqualTo: _searchController.text.toString()).snapshots(),



        ,builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasError)
        {
          return Text("${snapshot.error}");
        }
        else
        {
          if(snapshot.hasData) {
            List<DocumentSnapshot>nn=snapshot.data.docs;


            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(alignment: Alignment.center,
                        child: Text("Trash For Items",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 16),)),
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: nn.length,
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
                                                Container(
                                                    width:200,
                                                    child: Text("${nn[ind]["name"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 13,))),
                                                SizedBox(height: 5,),

                                                Row(
                                                  children: [
                                                    Icon(Icons.currency_rupee_rounded,size: 15,),SizedBox(width: 5,),
                                                    Text("${nn[ind]["price"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                                  ],
                                                )
                                                ,SizedBox(height: 5,),
                                                Text("Item Type: ${nn[ind]["type"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                                SizedBox(height: 5,),
                                                Text("Gst Type: ${nn[ind]["gsttype"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                                SizedBox(height: 5,),
                                                Text("Stock Available: ${nn[ind]["quantity"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                                SizedBox(height: 5,),
                                                Text("HSBN No: ${nn[ind]["hsbn"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                                // SizedBox(height: 5,),
                                                // Text("Type: ${nn[ind]["type"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,))

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(255, 231,	245,	254),
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: TextButton(onPressed: ()async{
                                                  await FirebaseFirestore.instance.collection(widget.dropdownValue).doc("items").collection("items").doc(nn[ind]["name"]).set({
                                                    "name":nn[ind]["name"],
                                                    "price":nn[ind]["price"],
                                                    "quantity":nn[ind]["quantity"],
                                                    "type":nn[ind]["type"],
                                                    "gsttype":nn[ind]["gsttype"],
                                                    "hsbn":nn[ind]["quantity"],
                                                    "timestamp":Timestamp.now()
                                                  });


                                                  await FirebaseFirestore.instance.collection("Universal").doc(nn[ind]["name"]).set({
                                                    "firstname":widget.dropdownValue,
                                                    "name":nn[ind]["name"],
                                                    "price":nn[ind]["price"],
                                                    "quantity":nn[ind]["quantity"],
                                                    // "type":dropdownvalue2.toString(),
                                                    "hsbn":nn[ind]["quantity"],
                                                    "timestamp":Timestamp.now()
                                                  });
                                                  await FirebaseFirestore.instance.collection(widget.dropdownValue).doc("itemstrash").collection("itemstrash").doc(nn[ind]["name"]).delete();
                                                },child: Row(
                                                  children: [
                                                    Text("Restore",style: TextStyle(color: Colors.black)),
                                                    SizedBox(width: 10,),
                                                    Icon(Icons.edit,color: Colors.black,),
                                                  ],
                                                ),)),


                                            SizedBox(height: 5,),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(255, 231,	245,	254),
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              child: TextButton(onPressed: ()async{
                                                await FirebaseFirestore.instance.collection(widget.dropdownValue).doc("itemstrash").collection("itemstrash").doc(nn[ind]["name"]).delete();
                                              },child: Text("Delete",style: TextStyle(color: Colors.black),)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                            )
                          ],
                        ),
                      );SizedBox();
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
