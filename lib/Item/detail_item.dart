import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class DetailItem extends StatefulWidget {
  final int idx;
  final int userToken;
  const DetailItem({super.key, required this.idx, required, required this.userToken});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> products = [];
  List<dynamic> infoUser = [];
  List<Map<dynamic,dynamic>> lst_cat = [];
  double prize = 0.0;
  late int indexCheck;
  late bool isCheck;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkData();
    _loadCountCategory();
    isCheck = false;
  }

  Future<void> _loadCountCategory() async {
    try {
      DatabaseEvent event = await _databaseReference.child('users/${widget.userToken}').child('categoryCount').once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        int fetchedUserNumber = dataSnapshot.value as int;
        setState(() {
          catNumber = fetchedUserNumber;
        });
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
        List<dynamic> data = (dataSnapshot.value as Map)['shop_cat'];

        data.forEach((value) {
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
      _quantity>=products[widget.idx]['quantity']?products[widget.idx]['quantity']:_quantity++;
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

  Future<void> _checkData() async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use orderByChild and equalTo to fetch user data based on email
        DatabaseEvent event = await _databaseReference
            .child('users')
            .orderByChild('detail/email')
            .equalTo(user.email)
            .once();
        DataSnapshot? dataSnapshot = event.snapshot;
        
        if (dataSnapshot != null && dataSnapshot.value != null) {
          List<dynamic> userDataMap = dataSnapshot.value as List;
          userDataMap.forEach((value){
            infoUser.add(value);
          });

          setState(() {
          });
          print(infoUser[0]['cats']);
          for(var values in infoUser[0]['cats']){
            lst_cat.add(values);
          }
          // print(indexCheck);
        } else {
          // Handle the case where no data is found
          print("No data found for user with email: ${user.email}");
        }
      }
    } catch (error) {
      // Handle errors during the data fetching process
      print("Error fetching data: $error");
    }
  }

  void addNewCategory() async {
    try {
      for(int i = 0;i<lst_cat.length;i++){
        if(lst_cat[i]['name']==products[widget.idx]['pro_name'] && lst_cat[i]['status']==true){
          indexCheck = lst_cat[i]['cat_token'];
          isCheck = true;
        }
      }
      
      if(isCheck){
          await _databaseReference.child('users/${widget.userToken}').child('cats/${indexCheck}').set({
          'path': products[widget.idx]['path'],
          'name': products[widget.idx]['pro_name'],
          'price': products[widget.idx]['price'].toString(),
          'quantity': (_quantity+lst_cat[indexCheck]['quantity']),
          'status': true,
          'token': widget.idx,
          'cat_token': indexCheck
        });
        showSnackbar('Cập nhật giỏ hàng thành công');
        isCheck = false;
      }
      else{
        await _databaseReference.child('users/${widget.userToken}').child('cats/${catNumber}').set({
          'path': products[widget.idx]['path'],
          'name': products[widget.idx]['pro_name'],
          'price': products[widget.idx]['price'].toString(),
          'quantity': _quantity,
          'status': true,
          'token': widget.idx,
          'cat_token': catNumber
        });
        showSnackbar('Thêm thành công vào giỏ hàng');
        catNumber++;
        await _databaseReference.update({'categoryCount': catNumber,});
      }     
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
            child: const Text('Không', style: TextStyle(color: Colors.white))
          ),
          TextButton(
            onPressed: (){
              setState(() {
                addNewCategory();
              });
            }, 
            child: const Text('Có', style: TextStyle(color: Colors.white))
          ),
        ]
      )
    );
  }
  String path = '';
  String name = '';
  String price = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    try
    {
      prize = products[widget.idx]['prize']['total_star'] / products[widget.idx]['prize']['total_prize'];
      path = products[widget.idx]['path'];
      name = products[widget.idx]['pro_name'];
      price = products[widget.idx]['price'];
      description = products[widget.idx]['description'];

    } catch(e){print(e.toString());}
        
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
                      path,
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 16.0,),
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Image(image: AssetImage('assets/icons/icons8-heart-24.png')),
                          onPressed: (){}
                        ),
                      
                      ],
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
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
                              SizedBox(width: 5,)
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          price.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                        description,
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
                  border: Border.all(width: 0.5, color: const Color.fromRGBO(196, 198, 198, 1))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                            fontSize: 18, color: Color.fromRGBO(87, 175, 115, 1)),
                      ),
                      onPressed: () {
                        showMaterialBanner('Bạn muốn thêm sản phẩm này vào giỏ hàng');
                      },
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 2.0,),
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
                        color: Color.fromRGBO(244, 166, 13, 1),
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
