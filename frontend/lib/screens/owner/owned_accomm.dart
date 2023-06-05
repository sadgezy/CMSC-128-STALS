import 'package:stals_frontend/components/rating.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OwnedAccommPage extends StatefulWidget {
  OwnedAccommPage({super.key});
  @override
  _OwnedAccommPageState createState() => _OwnedAccommPageState();
}

const _checkurl = 'https://img.icons8.com/?size=512&id=11695&format=png';
const _noturl = 'https://img.icons8.com/?size=512&id=TfRrgMHDWJk3&format=png';

//data information:
class Item1 extends StatelessWidget {
  const Item1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 75,
          ),
          Text("Max Capacity : 2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php4,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     //couldnt use the image asset for some reason
        //     image: NetworkImage(_noturl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 4",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php3,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 6",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php2,000",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //     fit: BoxFit.scaleDown,
          //     scale: 0.5,
          //     alignment: Alignment.center,
          //     image: NetworkImage(_checkurl))
          ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 8",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php1,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item5 extends StatelessWidget {
  const Item5({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 210, 80, 184),
              Color.fromARGB(255, 226, 203, 100)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_noturl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php8,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item6 extends StatelessWidget {
  const Item6({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 71, 151, 194),
              Color.fromARGB(255, 72, 210, 157)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 4",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php3,000",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class Item7 extends StatelessWidget {
  const Item7({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 125, 85, 217),
              Color.fromARGB(255, 88, 111, 57)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_noturl))
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("Max Capacity : 6",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php2,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Availability: Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _OwnedAccommPageState extends State<OwnedAccommPage> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
  int _currentIndex = 0;
  List cardList = [
    const Item1(),
    const Item2(),
    const Item3(),
    const Item4(),
    const Item5(),
    const Item6(),
    const Item7()
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isOwner) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    return Scaffold(
        //App bar start
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          title: const Text(
            "Return to me",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        //end of Appbar

        //Main Content for body start


        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Stack(alignment: Alignment.topRight, children: [
                  SizedBox(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/room_stock.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/owned/accomm/edit');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 25, 83, 95)),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                      ))
                ])
              ]),
              const SizedBox(
                height: 10,
              ),

              //Apartment Details
              //Reviews

              Row(
                //optional
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Apartment 1",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(children: [
                    StarRating(
                      rating: rating,
                      onRatingChanged: (rating) =>
                          setState(() => this.rating = rating),
                      color: Colors.black,
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "100+ reviews",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
              ),

              //Contact Information Box
              const Column(
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  //Profile icon and name of owner
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage("assets/images/room_stock.jpg"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "Hanse Hernandez",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  //Location Details
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "Barangay Batong Malake, Los Baños, Laguna",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  //Contact Info
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.blue,
                        size: 33,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "09123456978 / 0912-4201-619",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //end of Owner Information

              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.black,
              ),

              //Cards information
              //Alternative Cards
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: cardList.map((card) {
                      return Builder(builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: Colors.blueAccent,
                            child: card,
                          ),
                        );
                      });
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(cardList, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              //End of Cards

              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.black,
              ),

              //Description
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 4,
                    width: 25,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      FittedBox(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "About Name",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                        width: 5,
                      ),
                      SizedBox(
                        width: 450,
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"
                            " do eiusmod tempor incididunt ut labore et dolore magna "
                            "aliqua. Ut enim ad minim veniam, quis nostrud "
                            "exercitation ullamco laboris nisi ut aliquip ex ea "
                            "commodo consequat."),
                      ),
                    ],
                  ))
                ],
              ),
              //end of Description
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.black,
              ),

              //Highlights
              const FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  "Highlights",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(
                  height: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.pets,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Pets Allowed",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.bathtub_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Own Bathroom",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.restaurant_menu,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Cooking Allowed",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.wifi,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "With Internet Connection",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.ac_unit,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Air - Conditioned Room",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.bedtime_off,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "No Curfew",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.electric_meter_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Own Meter",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.bed_sharp,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Furnished",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.desk,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Semi Furnished",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.drive_eta_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Parking Space",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.local_laundry_service_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Laundry Allowed",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.nights_stay_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Overnight Visitors Allowed",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.directions_walk,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "Visitors Allowed",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.video_camera_front_outlined,
                              color: Colors.blue,
                              size: 40,
                            ),
                            FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  "CCTV in the Area",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )),
              //End of Highlights
            ]))
          ]),
        ));
  }
}
