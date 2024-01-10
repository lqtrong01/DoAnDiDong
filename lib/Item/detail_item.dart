import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class DetailItem extends StatefulWidget {
  final int idx;
  const DetailItem({super.key, required this.idx});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> products = [];
  double prize = 0.0;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadCountCategory();
  }

  Future<void> _loadCountCategory() async {
    try {
      DatabaseEvent event = await _databaseReference.child('categoryCount').once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        int fetchedUserNumber = dataSnapshot.value as int;
        setState(() {
          catNumber = fetchedUserNumber;
        });
        print(catNumber);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
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
        setState(() {}); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  int _quantity = 1;
  bool _txtdetail = true;
  int catNumber = 0;

  void _incrementCounter() {
    setState(() {
      _quantity++;
    });
  }

  void _minusQuantity() {
    setState(() {
      _quantity > 2 ? _quantity-- : _quantity = 1;
    });
  }

  void _arrowTextDetail() {
    setState(() {
      if (_txtdetail)
        _txtdetail = false;
      else
        _txtdetail = true;
    });
  }
  void addNewCategory() async {
    String catName = 'cat${catNumber}';
    try {
      await _databaseReference.child('users/user0').child('cats/${catName}').set({
        'name': products[widget.idx]['pro_name'],
        'price': products[widget.idx]['price'].toString(),
        'quantity': _quantity,
        'status': true,
      });
      showSnackbar('Thêm thành công vào giỏ hàng');
      catNumber++;
      await _databaseReference.update({'categoryCount': catNumber,});
    } catch (error) {
      showSnackbar('Thêm thất bại');
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  showMaterialBanner(String text, ){
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(text), 
        contentTextStyle: const TextStyle(color: Colors.black ,fontSize: 30),
        backgroundColor: Colors.green[500],
        leadingPadding: const EdgeInsets.only(right: 30),
        leading: const Icon(Icons.info, size: 32,),
        actions:[
          TextButton(
            onPressed: ()=> ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('Dismiss')
          ),
          TextButton(
            onPressed: (){
              addNewCategory();
            }, 
            child: const Text('Continue')
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    prize = products[widget.idx]['prize']['total_star'] /
        products[widget.idx]['prize']['total_prize'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Thông tin chi tiết',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                      products[widget.idx]['path'],
                      width: 280,
                      height: 430,
                      loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: Text('Error loading image'),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 16.0,),
                        Text(
                          products[widget.idx]['pro_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Image(image: AssetImage('assets/icons/icons8-heart-24.png')),
                          onPressed: (){}
                        ),
                        const SizedBox(width: 16.0,)
                      ],
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 16.0,),
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _minusQuantity,
                                icon: const Icon(Icons.remove)
                              ),
                              Text(_quantity.toString()),
                              IconButton(
                                onPressed: _incrementCounter,
                                icon: const Icon(Icons.add)
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          products[widget.idx]['price'].toString()
                        ),
                        const SizedBox(width: 16.0,)
                      ],
                    ),
                  ),
                  const Divider(thickness: 2,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Product detail',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: _arrowTextDetail,
                            icon: const Icon(Icons.arrow_drop_down))
                      ],
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        products[widget.idx]['description'],
                        softWrap: _txtdetail,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16.0,),
            Positioned(
              bottom: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                            fontSize: 18, color: Colors.green[500]),
                      ),
                      onPressed: () {
                        showMaterialBanner('Bạn muốn thêm sản phẩm này vào giỏ hàng');
                      },
                    ),
                  ],
                )
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.0, color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Service',
                      style: TextStyle(fontSize: 18),
                    ),
                    RatingBar.builder(
                      initialRating: prize,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.yellowAccent,
                      ),
                      onRatingUpdate: (rating) {
                        // Xử lý khi đánh giá được cập nhật
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
