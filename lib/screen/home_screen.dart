import 'package:app_thuong_mai/Item/item.dart';
import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtSearch = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Egg');
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> products = [];
  List<Map<dynamic, dynamic>> waters = [];
  List<Map<dynamic, dynamic>> vegetables = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['shop_cat'];

        data.forEach((key, value) {
          products.add(value);
        });
        for(int i = 0;i<products.length;i++){
          if(products[i]['type']=='water')
            waters.add(products[i]);
          else vegetables.add(products[i]);
        }
        setState(() {}); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  final List<String> carouselImages = [
    'https://oatuu.org/wp-content/uploads/2023/06/adding-items-to-your-amazon-fresh-order-a-comprehensive-guide-2.jpg',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (customIcon.icon == Icons.search) {
                          customIcon = const Icon(Icons.cancel);
                          customSearchBar = Expanded(
                            child: ListTile(
                              trailing: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 28,
                              ),
                              title: TextField(
                                controller: txtSearch,
                                decoration: InputDecoration(
                                  hintText: 'Search anything...',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        } else {
                          customIcon = const Icon(Icons.search);
                          customSearchBar = const Text('....');
                          txtSearch.clear();
                        }
                      });
                    },
                    icon: customIcon,
                  ),
                  const SizedBox(width: 8.0),
                  customSearchBar,
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            CarouselSlider(
              items: carouselImages.map((image) {
                return Image(image: NetworkImage(image), fit: BoxFit.cover);
              }).toList(),
              options: CarouselOptions(
                height: 100.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 144.0, 
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: vegetables.length,
                itemBuilder: (context, index) {
                  if (index < vegetables.length) {
                    return Item(
                      path: vegetables[index]['path'],
                      name: vegetables[index]['pro_name'],
                      price: vegetables[index]['price'],
                      origin: vegetables[index]['origin'],
                      idx: vegetables[index]['token']??0, // Use 0 as the default value if 'token' is null
                    );
                  } else {
                    // Handle the case when the index is out of range
                    return Container(); // or any other fallback UI
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 144.0,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: waters.length,
                itemBuilder: (context, index) {
                  return Item(
                    path: waters[index]['path'],
                    name: waters[index]['pro_name'],
                    price: waters[index]['price'],
                    origin: waters[index]['origin'],
                    idx: (waters[index]['token']).toInt(),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BotNav(idx: 0),
    );
  }
}
