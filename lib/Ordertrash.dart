import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Orderstrash extends StatefulWidget {
  final String dropdownValue;
  const Orderstrash({required this.dropdownValue});

  @override
  State<Orderstrash> createState() => _OrderstrashState();
}

class _OrderstrashState extends State<Orderstrash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,26, 26, 29),
        title: Center(child: Text("Sales Orders")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DropdownSearch<String>.multiSelection(
            //
            //   dropdownDecoratorProps: DropDownDecoratorProps(
            //     dropdownSearchDecoration: InputDecoration(
            //       labelText: "Customer",
            //       hintText: "select or type the ",
            //     ),
            //   ),
            //   asyncItems:(x)async{
            // List<String>x=[];
            // var m=await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email.toString()).doc("customers").collection("customers").get();
            // m.docs.forEach((element) {x.add(element.data()["name"]);});
            // print(x);
            // return x;
            // },
            // ),

            StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection(widget.dropdownValue).doc("salesordertrash").collection("salesordertrash").orderBy("soid").snapshots(),


              builder: (context, AsyncSnapshot snapshot) {
                if(snapshot.hasError)
                {
                  return Text("${snapshot.error}");
                }
                else
                {
                  if(snapshot.hasData) {
                    List<DocumentSnapshot>nn=snapshot.data.docs;
                    List<String> mm=["Ordered","Invoice"];
                    return SingleChildScrollView(
                      child: Column(
                        children: [

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
                                        height: 203,
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
                                                        Row(
                                                          children: [
                                                            Text("Soid: ${nn[ind]["soid"]}",style:GoogleFonts.poppins(color: Colors.grey, fontSize: 25,)),
                                                            SizedBox(width: 6,),(nn[ind]["level"]==4)?Icon(Icons.check_circle_rounded,color: Colors.greenAccent,):SizedBox()
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text("${nn[ind]["cusname"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 25,)),
                                                        SizedBox(height: 5,),
                                                        Text("Product: ${nn[ind]["product"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,))
                                                        ,SizedBox(height: 5,),
                                                        Text("Quantity: ${nn[ind]["quantity"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,))
                                                        ,SizedBox(height: 5,),
                                                        Text("Price: ${nn[ind]["price"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,))
                                                        ,SizedBox(height: 6,),
                                                        Row(
                                                          children: [
                                                            Text("Ordered",style:GoogleFonts.poppins(color: Colors.black, fontSize: 10,)),

                                                            (nn[ind]["level"]<0)?Icon(Icons.circle_outlined,color: Colors.black,size: 13,):Icon(Icons.circle,color: Colors.blue,size: 13,),SizedBox(width: 6,),
                                                            Text("Invoiced",style:GoogleFonts.poppins(color: Colors.black, fontSize: 10,)),

                                                            (nn[ind]["level"]<1)?Icon(Icons.circle_outlined,color: Colors.black,size: 13,):Icon(Icons.circle,color: Colors.blue,size: 13,), SizedBox(width: 6,),
                                                            //   Text("Shipped",style:GoogleFonts.poppins(color: Colors.black, fontSize: 10,)),
                                                            //
                                                            //   (nn[ind]["level"]<3)?Icon(Icons.circle_outlined,color: Colors.black,size: 13,):Icon(Icons.circle,color: Colors.blue,size: 13,),SizedBox(width: 6,),
                                                            //   Text("delivered",style:GoogleFonts.poppins(color: Colors.black, fontSize: 10,)),
                                                            //
                                                            //   (nn[ind]["level"]<4)?Icon(Icons.circle_outlined,color: Colors.black,size: 13,):Icon(Icons.circle,color: Colors.blue,size: 13,),SizedBox(width: 6,),
                                                          ],
                                                        )
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
                                                          await FirebaseFirestore.instance.collection(
                                                              widget.dropdownValue).doc("salesorder")
                                                              .collection("salesorder").doc(nn[ind]["soid"].toString())
                                                              .set({
                                                            "soid": nn[ind]["soid"],
                                                            "level": nn[ind]["level"],
                                                            "cusname": nn[ind]["cusname"],
                                                            "product": nn[ind]["product"],
                                                            "quantity": nn[ind]["quantity"],
                                                            "price": nn[ind]["price"],
                                                          });
                                                         await FirebaseFirestore.instance.collection(widget.dropdownValue).doc("salesordertrash").collection("salesordertrash").doc(nn[ind]["soid"].toString()).delete();
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
                                                        await FirebaseFirestore.instance.collection(widget.dropdownValue).doc("salesordertrash").collection("salesordertrash").doc(nn[ind]["soid"].toString()).delete();
                                                      },child: Text("Delete",style: TextStyle(color: Colors.black),)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),

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
          ],
        ),
      ),
    );
  }
}
