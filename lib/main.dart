import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'allfunctions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Firebase.apps.isEmpty){
    await Firebase.initializeApp();
  }
  runApp(
    MaterialApp(
      home: firstpage(),
      routes: {
        "/homepage":(context)=>homepage(""),
        "/regionpage":(context)=>region(),
      },
    )
  );
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  _firstpageState createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:Container(
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: double.infinity,),
              Container(width: 130,child: ElevatedButton(onPressed: (){}, child: Text("ADMIN LOGIN"))),
              Container(width: 130,child: ElevatedButton(onPressed: (){}, child: Text(" LOGIN"))),
              Container(
                width: 130,
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>loginhome()));
                }, child: Text("USER LOGIN")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class loginhome extends StatefulWidget {
  const loginhome({Key? key}) : super(key: key);

  @override
  _loginhomeState createState() => _loginhomeState();
}

class _loginhomeState extends State<loginhome> {
  String? useruid = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = " ";
  String password = " ";
  bool alreadylogged=false;
  late FocusNode passFnode;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user){
      if(user == null){
        alreadylogged=false;
      }
      else{
        alreadylogged=true;
        useruid=user.uid.toString();
      }
    });
    passFnode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    passFnode.dispose();

    super.dispose();
  }
  bool _loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 400,
                child: FlutterLogo()
            ),
            Container(
              width: 250,
              child: TextField(
                cursorHeight: 20,
                onChanged: (String s) {
                  email = s;
                },
                onSubmitted: (s) {
                  passFnode.requestFocus();
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "EMAIL",
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
            ),
            Container(
              width: 250,
              child: TextField(
                cursorHeight: 20,
                focusNode: passFnode,
                onChanged: (String s) {
                  password = s;
                },
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(13),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "PASSWORD",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            UserCredential usercred = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                email: email, password: password);
                            useruid = usercred.user?.uid;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>region()),ModalRoute.withName("/regionpage"));
                          } on FirebaseAuthException catch (e) {
                            if(e.code=="user-not-found")
                              print("USER NOT FOUND");
                            else if(e.code=="invalid-email")
                              print("INVALID EMAIL");
                            else if(e.code=="wrong-password")
                              print("WRONG PASSWORD");
                          } catch (e) {

                          }
                        },
                        child: Text("LOGIN")),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class region extends StatefulWidget {
  const region({Key? key}) : super(key: key);

  @override
  _regionState createState() => _regionState();
}

class _regionState extends State<region> {
  List<String> regionNames=["SATHY","PULIAMPATTI","KURUMANDUR","ATHANI","PARIYUR","APPAKUDAL","KUGALUR","BHAVANI","KOLAPPALUR","VAKANPATT",];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemCount: regionNames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing:10 ,crossAxisSpacing: 10), itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  child: Container(
                    child: Card(
                      elevation: 4,
                        child: Center(child: Text(regionNames.elementAt(index)),),
                    ),
                  ),
                  onTap: (){
                    if(index==0){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>sathy()));
                    }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class sathy extends StatefulWidget {
  const sathy({Key? key}) : super(key: key);

  @override
  _sathyState createState() => _sathyState();
}

class _sathyState extends State<sathy> {
  List<String> sathyregion=["BIT","ARASUR","ARIYAPPAM PALAYAM","GANDHI NAGAR","PERIYAKIDIVERI","KODIVERI","ALATHUCOMBAI","ONDIYUR","BHAVANISAGAR","SADUMUGAI"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sathyregion.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing:10 ,crossAxisSpacing: 10), itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Card(
                      elevation: 4,
                      child: Center(child: Text(sathyregion.elementAt(index)),),
                    ),
                  ),
                  onTap: (){
                    if(index==0){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>bit()));
                    }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class bit extends StatefulWidget {
  const bit({Key? key}) : super(key: key);

  @override
  _bitState createState() => _bitState();
}

class _bitState extends State<bit> {
  List<String> bitblocks=["AERO BLOCK","AS BLOCK","SF BLOCK","IB BLOCK"];
  List<Widget> navigator=[
    aeroblock(),
    asblock(),
    sfblock(),
    ibblock(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bitblocks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing:10 ,crossAxisSpacing: 10), itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Card(
                      elevation: 4,
                      child: Center(child: Text(bitblocks.elementAt(index)),),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>navigator.elementAt(index)));

                    // if(index==0){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>sathy()));
                    // }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class aeroblock extends StatefulWidget {
  const aeroblock({Key? key}) : super(key: key);

  @override
  _aeroblockState createState() => _aeroblockState();
}

class _aeroblockState extends State<aeroblock> {
  List<String> ab1post1=[];
  String ab1p1angle="";
  String ab1p1crash="";
  String ab1p1current="";
  String ab1p1fire="";
  String ab1p1relay="";
  String ab1p1safety="";

  String ab1p2angle="";
  String ab1p2crash="";
  String ab1p2current="";
  String ab1p2fire="";
  String ab1p2relay="";
  String ab1p2safety="";

  String ab1p3angle="";
  String ab1p3crash="";
  String ab1p3current="";
  String ab1p3fire="";
  String ab1p3relay="";
  String ab1p3safety="";

  String ab1p4angle="";
  String ab1p4crash="";
  String ab1p4current="";
  String ab1p4fire="";
  String ab1p4relay="";
  String ab1p4safety="";

  post1func ()async{
    List<String> ab1post1=[];
    DatabaseReference mainref=await FirebaseDatabase.instance.ref("AB1");
    Stream<DatabaseEvent> relay = await mainref.child("Relay").limitToLast(1).onValue;
    relay.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1p1relay=(iter.current.value.toString());
        ab1post1.add(ab1p1relay);
      }setState(() {

      });

    });

    DatabaseReference mainref2=await FirebaseDatabase.instance.ref("AB2");

    Stream<DatabaseEvent> relay2 = await mainref2.child("Relay").limitToLast(1).onValue;
    relay2.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1p2relay=(iter.current.value.toString());
        print(ab1p2relay);
      }setState(() {

      });
    });

    DatabaseReference mainref3=await FirebaseDatabase.instance.ref("AB3");
    Stream<DatabaseEvent> relay3 = await mainref3.child("Relay").limitToLast(1).onValue;
    relay3.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1p3relay=(iter.current.value.toString());
        print("relay 3 "+ab1p3relay);
      }setState(() {

      });
    });

    DatabaseReference mainref4=await FirebaseDatabase.instance.ref("AB4");

    Stream<DatabaseEvent> relay4 = await mainref4.child("Relay").limitToLast(1).onValue;
    relay4.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1p4relay=(iter.current.value.toString());
        print("relay 3 "+ab1p3relay);
      }setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30,),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("AB1")));
                      },child: Text("POST NO 1"),),
                      ab1p1relay=="0"?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("AB2")));
                      },child: Text("POST NO 2"),),
                      ab1p2relay=="0"?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)

                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("AB3")));
                      },child: Text("POST NO 3"),),
                      ab1p3relay=="0"?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)

                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("AB4")));
                      },child: Text("POST NO 4"),),
                      ab1p4relay=="0"?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    post1func();

  }
}

class asblock extends StatefulWidget {
  const asblock({Key? key}) : super(key: key);

  @override
  _asblockState createState() => _asblockState();
}

class _asblockState extends State<asblock> {
  String asp1relay="";
  String asp2relay="";
  String asp3relay="";

  fbfunc() async{
      Stream<DatabaseEvent> p1ref=await FirebaseDatabase.instance.ref("ASB1").child("Relay").limitToLast(1).onValue;
      p1ref.listen((event) {
        var iter=event.snapshot.children.iterator;
        while(iter.moveNext()){
          asp1relay=iter.current.value.toString();
          print(asp1relay);
          setState(() {

          });
        }
      });
      Stream<DatabaseEvent> p2ref=await FirebaseDatabase.instance.ref("ASB2").child("Relay").limitToLast(1).onValue;
      p2ref.listen((event) {
        var iter=event.snapshot.children.iterator;
        while(iter.moveNext()){
          asp2relay=iter.current.value.toString();
          print(asp2relay);
          setState(() {

          });
        }
      });
      Stream<DatabaseEvent> p3ref=await FirebaseDatabase.instance.ref("ASB3").child("Relay").limitToLast(1).onValue;
      p3ref.listen((event) {
        var iter=event.snapshot.children.iterator;
        while(iter.moveNext()){
          asp3relay=iter.current.value.toString();
          print(asp3relay);
          setState(() {

          });
        }
      });
  }
  @override
  void initState() {
    fbfunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("ASB1")));
                      },child: Text("POST NO 1"),),
                      (asp1relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("ASB2")));

                      },child: Text("POST NO 2"),),
                      (asp2relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("ASB3")));

                      },child: Text("POST NO 3"),),
                      (asp3relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ibblock extends StatefulWidget {
  const ibblock({Key? key}) : super(key: key);

  @override
  _ibblockState createState() => _ibblockState();
}

class _ibblockState extends State<ibblock> {
  String ibp1relay="";
  String ibp2relay="";
  String ibp3relay="";
  fbfunc() async{
    Stream<DatabaseEvent> p1ref=await FirebaseDatabase.instance.ref("IB1").child("Relay").limitToLast(1).onValue;
    p1ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ibp1relay=iter.current.value.toString();
        print(ibp1relay);
        setState(() {

        });
      }
    });
    Stream<DatabaseEvent> p2ref=await FirebaseDatabase.instance.ref("IB2").child("Relay").limitToLast(1).onValue;
    p2ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ibp2relay=iter.current.value.toString();
        print(ibp2relay);
        setState(() {

        });
      }
    });
    Stream<DatabaseEvent> p3ref=await FirebaseDatabase.instance.ref("IB3").child("Relay").limitToLast(1).onValue;
    p3ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ibp3relay=iter.current.value.toString();
        print(ibp3relay);
        setState(() {

        });
      }
    });
  }
  @override
  void initState() {
    fbfunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30,),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("IB1")));
                      },child: Text("POST NO 1"),),
                      (ibp1relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("IB2")));

                      },child: Text("POST NO 2"),),
                      (ibp2relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("IB3")));

                      },child: Text("POST NO 3"),),
                      (ibp3relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class sfblock extends StatefulWidget {
  const sfblock( {Key? key}) : super(key: key);

  @override
  _sfblockState createState() => _sfblockState();
}

class _sfblockState extends State<sfblock> {
  String sfp1relay="";
  String sfp2relay="";
  String sfp3relay="";
  String sfp4relay="";

  fbfunc() async{
    Stream<DatabaseEvent> p1ref=await FirebaseDatabase.instance.ref("SF1").child("Relay").limitToLast(1).onValue;
    p1ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        sfp1relay=iter.current.value.toString();
        print(sfp1relay);
        setState(() {

        });
      }
    });
    Stream<DatabaseEvent> p2ref=await FirebaseDatabase.instance.ref("SF2").child("Relay").limitToLast(1).onValue;
    p2ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        sfp2relay=iter.current.value.toString();
        print(sfp2relay);
        setState(() {

        });
      }
    });
    Stream<DatabaseEvent> p3ref=await FirebaseDatabase.instance.ref("SF3").child("Relay").limitToLast(1).onValue;
    p3ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        sfp3relay=iter.current.value.toString();
        print(sfp3relay);
        setState(() {

        });
      }
    });
    Stream<DatabaseEvent> p4ref=await FirebaseDatabase.instance.ref("SF4").child("Relay").limitToLast(1).onValue;
    p4ref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        sfp4relay=iter.current.value.toString();
        print(sfp4relay);
        setState(() {

        });
      }
    });
  }
  @override
  void initState() {
    fbfunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("SF1")));
                      },child: Text("POST NO 1"),),
                      (sfp1relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("SF2")));

                      },child: Text("POST NO 2"),),
                      (sfp2relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("SF3")));

                      },child: Text("POST NO 3"),),
                      (sfp3relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  Image(image: AssetImage("images/streetlight2.png"),height: 100,width: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage("SF4")));

                      },child: Text("POST NO 4"),),
                      (sfp4relay=="0")?CircleAvatar(backgroundColor: Colors.red,radius: 8,):CircleAvatar(backgroundColor: Colors.green,radius: 8,)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class homepage extends StatefulWidget {
  final String postno;
  const homepage(this.postno,{Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: GestureDetector(
                child: Container(
                  height: 150,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("AUTOMATED STREET LIGHT"),
                            )
                        ),
                        Expanded(
                          flex: 1,
                            child: Image(image: AssetImage("images/streetlight.png"),))
                      ],
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>streetlight(widget.postno)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: GestureDetector(
                child: Container(
                  height: 150,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("WOMEN SAFETY"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Image(image: AssetImage("images/safety.png"),height: 80,))
                      ],
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>safety(widget.postno)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: GestureDetector(
                child: Container(
                  height: 150,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("ACCIDENT DETECTOR"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Image(image: AssetImage("images/accident.png"),))
                      ],
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>accident(widget.postno)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class streetlight extends StatefulWidget {
  final String postno;

  const streetlight(this.postno,{Key? key}) : super(key: key);

  @override
  _streetlightState createState() => _streetlightState();
}

class _streetlightState extends State<streetlight> {
  String ab1pangle="";
  String ab1pcrash="";
  String ab1pcurrent="";
  String ab1pfire="";
  String ab1prelay="";
  String ab1psafety="";
  fbfunc() async{
    print(widget.postno);
    DatabaseReference mainref=await FirebaseDatabase.instance.ref(widget.postno);
    Stream<DatabaseEvent> data = await mainref.child("Crash").limitToLast(1).onValue;
    data.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1pcrash=(iter.current.value.toString());
        print(ab1pcrash);
      }
      setState(() {

      });
    });
    Stream<DatabaseEvent> crash = await mainref.child("Angledeviation").limitToLast(1).onValue;
    crash.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1pangle=(iter.current.value.toString());
      }setState(() {

      });
    });
    Stream<DatabaseEvent> current = await mainref.child("Current").limitToLast(1).onValue;
    current.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1pcurrent=(iter.current.value.toString());
        print(ab1pcurrent+"current");
      }setState(() {

      });
    });
    Stream<DatabaseEvent> fire = await mainref.child("Fire").limitToLast(1).onValue;
    fire.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1pfire=(iter.current.value.toString());
      }setState(() {

      });
    });
    Stream<DatabaseEvent> relay = await mainref.child("Relay").limitToLast(1).onValue;
    relay.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1prelay=(iter.current.value.toString());

      }setState(() {

      });

    });
    Stream<DatabaseEvent> safety = await mainref.child("Safety").limitToLast(1).onValue;
    safety.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        ab1psafety=(iter.current.value.toString());
      }setState(() {

      });

    });
  }
  @override
  void initState() {
    fbfunc();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                height: 125,
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Post No",style: TextStyle(fontSize: 23),),
                                Text(widget.postno,style: TextStyle(fontSize: 17),)
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Image(image: AssetImage("images/streetlight2.png"),))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                height: 125,
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Current",style: TextStyle(fontSize: 23),),
                                Text(ab1pcurrent,style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(""))
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            //   child: Container(
            //     height: 125,
            //     child: Card(
            //       elevation: 4,
            //       child: Row(
            //         children: [
            //           Expanded(
            //               flex: 2,
            //               child: Padding(
            //                 padding: const EdgeInsets.only(left: 10),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                   children: [
            //                     Text("Voltage",style: TextStyle(fontSize: 23),),
            //                     Text("",style: TextStyle(fontSize: 18),)
            //                   ],
            //                 ),
            //               )
            //           ),
            //           Expanded(
            //               flex: 1,
            //               child: Image(image: AssetImage("images/voltage.png"),))
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                height: 125,
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Relay",style: TextStyle(fontSize: 23),),
                                Text(ab1prelay,style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(""))
                    ],
                  ),
                ),
              ),
            ),
            // Switch(value: !relayswitch, onChanged: (a){})

          ],
        ),
      )
    );
  }

}

class safety extends StatefulWidget {
  final String postno;

  const safety(this.postno,{Key? key}) : super(key: key);

  @override
  _safetyState createState() => _safetyState();
}

class _safetyState extends State<safety> {
  String safety="";
  @override
  void initState() {
    fbfunc();
  }
  fbfunc() async {
    DatabaseReference mainref=await FirebaseDatabase.instance.ref(widget.postno);
    Stream<DatabaseEvent> data = await mainref.child("Safety").limitToLast(1).onValue;
    data.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        safety=(iter.current.value.toString());
        print("safety"+safety);
      }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (safety=="1")?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/alert.png")),
            Text("PROBLEM AT POST NO "+widget.postno,style: TextStyle(fontSize: 20),)
          ],
        ),
      ):Center(child: Text("NO PROBLEM",style: TextStyle(fontSize: 20),)),
    );
  }
}

class accident extends StatefulWidget {
  final String postno;
  const accident(this.postno,{Key? key}) : super(key: key);

  @override
  _accidentState createState() => _accidentState();
}

class _accidentState extends State<accident> {
  String postno="";
  String crash="";
  String fire="";
  String angle="";
  @override
  void initState() {
    fbfunc();
  }
  fbfunc() async{
    DatabaseReference mainref=await FirebaseDatabase.instance.ref(widget.postno);
    Stream<DatabaseEvent> data = await mainref.child("Crash").limitToLast(1).onValue;
    data.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        crash=(iter.current.value.toString());
        //print(ab1pcrash);
      }
      setState(() {

      });
    });
    Stream<DatabaseEvent> crashref = await mainref.child("Angledeviation").limitToLast(1).onValue;
    crashref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        angle=(iter.current.value.toString());
      }setState(() {

      });
    });
    Stream<DatabaseEvent> fireref = await mainref.child("Fire").limitToLast(1).onValue;
    fireref.listen((event) {
      var iter=event.snapshot.children.iterator;
      while(iter.moveNext()){
        fire=(iter.current.value.toString());
        print(fire+"fire");
      }setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  height: 125,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Post No",style: TextStyle(fontSize: 23),),
                                  Text(widget.postno,style: TextStyle(fontSize: 17),)
                                ],
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Image(image: AssetImage("images/streetlight2.png"),))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  height: 125,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Fire",style: TextStyle(fontSize: 23),),
                                  (fire=="1")?Text("Fire Detected",style: TextStyle(fontSize: 18),):Text("No Fire Detected",style: TextStyle(fontSize: 18),)

                                ],
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Image(image: AssetImage("images/fire.png"),))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  height: 125,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Crash",style: TextStyle(fontSize: 23),),
                                  (crash=="1")?Text("Accident detected",style: TextStyle(fontSize: 18),):Text("No Accident Detected",style: TextStyle(fontSize: 18))

                                ],
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Image(image: AssetImage("images/accident.png"),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  height: 125,
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Angledeviation",style: TextStyle(fontSize: 23),),
                                  (angle=="1")?Text("Angle deviation detected",style: TextStyle(fontSize: 18),):Text("No Angle Deviaition Detected",style: TextStyle(fontSize: 18))

                                ],
                              ),
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("")
                        )
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
        )
    );
  }
}








