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
  List<Map<dynamic, dynamic>> displayProduct = [];
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

  void performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // Nếu truy vấn tìm kiếm trống, hiển thị tất cả sản phẩm
        displayProduct = List.from(products);
      } else {
        // Nếu có truy vấn tìm kiếm, lọc danh sách theo truy vấn
        displayProduct = products.where((product) {
          return product['pro_name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
  void onSearchTextChanged() {
    performSearch(txtSearch.text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.search, size: 24,),
                                    color: Colors.black,
                                    onPressed: (){

                                    },
                                  ),
                                  title: TextField(
                                    controller: txtSearch,
                                    onChanged: (value) {
                                      onSearchTextChanged();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search anything...',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                              onSearchTextChanged();


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
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 144.0, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        return Container();
                      }
                    },
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
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 144.0,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Item(
                      path: products[index]['path'],
                      name: products[index]['pro_name'],
                      price: products[index]['price'],
                      origin: products[index]['origin'],
                      idx: (products[index]['token']).toInt(),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar:const BotNav(idx: 0),
    );
  }
}
