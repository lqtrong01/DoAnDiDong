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

  final List<String> localImage = [
    'assets/image/banana.png',
    'assets/image/chery.png',
    'assets/image/green-apple.png',
    'assets/image/orange.png',
    'https://firebasestorage.googleapis.com/v0/b/app-thuong-mai-ndtt.appspot.com/o/72bc2ace72850.png?alt=media&token=cfd5dd2d-b2c7-45e8-b7c2-4bb9f6c7d88c'
  ];
  int _quantity = 1;
  bool _txtdetail = true;

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

  @override
  Widget build(BuildContext context) {
    prize = products[widget.idx]['prize']['total_star'] /
        products[widget.idx]['prize']['total_prize'];
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
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
                        return Center(
                          child: Text('Error loading image'),
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 16.0,),
                            Text(
                              products[widget.idx]['pro_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 34),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Image(image: AssetImage('assets/icons/icons8-heart-24.png')),
                              onPressed: (){}
                            ),
                            const SizedBox(width: 16.0,)
                          ],
                        )),
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
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Product detail',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: _arrowTextDetail,
                                icon: Icon(Icons.arrow_drop_down))
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
                  decoration: BoxDecoration(
                  ),
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
                          // Xử lý thêm giỏ hàng
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
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Service',
                        style: TextStyle(fontSize: 18),
                      ),
                      RatingBar.builder(
                        initialRating: prize,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 24.0,
                        itemBuilder: (context, _) => Icon(
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
        ));
  }
}
