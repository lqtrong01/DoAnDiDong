import 'package:app_thuong_mai/screen/cart_screen.dart';
import 'package:app_thuong_mai/screen/favourite_screen.dart';
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
  List<Map<dynamic, dynamic>> users = [];
  List<Map<dynamic,dynamic>> lst_cat = [];
  List<Map<dynamic, dynamic>> lst_favourite = [];
  double prize = 0.0;
  late int indexCheck;
  bool isCat = false;
  bool isFav = false;
  bool _isFav = false;
  bool isCheck = false;
  late int indexFav;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkData();
    _loadCountCategory();
  }

  Future<void> _loadCountCategory() async {
    try {
      DatabaseEvent event = await _databaseReference.child('users/${widget.userToken}').once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        var fetchedNumber = dataSnapshot.value as Map;
        setState(() {
          catNumber = fetchedNumber['categoryCount'];
          favouriteNumber = fetchedNumber['favouriteCount'];
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
  int favouriteNumber = 0;

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
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          users.add(value);
        });
        for(var category in users[widget.userToken]['cats']){
          lst_cat.add(category);
        }
        for(var favourite in users?[widget.userToken]['favourites']!){
          lst_favourite.add(favourite);
        }
      }
      setState(() {
        isCheck = false;
        for(int i = 0 ;i <lst_favourite.length;i++){
          if(lst_favourite[i]['token']==products[widget.idx]['token']){
            isCheck = true;
            if(lst_favourite[i]['status']==true){
              indexFav = lst_favourite[i]['fav_token'];
              isFav = false;
              _isFav = true;
            }
            else {
              indexFav = lst_favourite[i]['fav_token'];
              isFav = true;
              _isFav = false;
            }
          }
        }
        print(isFav);
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void addNewCategory() async {
    try {
      for(int i = 0;i<lst_cat.length;i++){
        if(lst_cat[i]['token']==products[widget.idx]['token']&&lst_cat[i]['status']==true){
          indexCheck = lst_cat[i]['cat_token'];
          isCat = true;
        }
      }
      isCat?true:false;
      if(isCat){
        await _databaseReference.child('users/${widget.userToken}').child('cats/${indexCheck}').update({
          'path': products[widget.idx]['path'],
          'origin': products[widget.idx]['origin'],
          'name': products[widget.idx]['pro_name'],
          'price': products[widget.idx]['price'].toString(),
          'quantity': (_quantity+lst_cat[indexCheck]['quantity']),
          'status': true,
          'token': widget.idx,
          'cat_token': indexCheck
        });
        showSnackbar('Cập nhật giỏ hàng thành công');
        isCat = false;
        {
          resetScreen();
        }
        
      }
      else if(isCat==false) {
        await _databaseReference.child('users/${widget.userToken}').child('cats/${catNumber}').set({
          'path': products[widget.idx]['path'],
          'origin':products[widget.idx]['origin'],
          'name': products[widget.idx]['pro_name'],
          'price': products[widget.idx]['price'].toString(),
          'quantity': _quantity,
          'status': true,
          'token': widget.idx,
          'cat_token': catNumber
        });
        showSnackbar('Thêm thành công vào giỏ hàng');
        catNumber++;
        await _databaseReference.update({'users/${widget.userToken}/categoryCount': catNumber,});
        {
          resetScreen();
        }
      }     
    } catch (error) {
      showSnackbar('Thêm thất bại');
    }
  }

  void resetScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DetailItem(userToken: widget.userToken,idx: widget.idx,)),
    );
  }

  Future<void> addFavourite() async {
    try{
      if(isCheck){
        if(isFav==true){
          await _databaseReference.child('users/${widget.userToken}').child('favourites/${indexFav}').update({
            'status': isFav,
          });
        }
        else{
          await _databaseReference.child('users/${widget.userToken}').child('favourites/${indexFav}').update({
          'status': isFav,
        });
        }
        showSnackbar('Chỉnh sửa yêu thích thành công');
        {
          resetScreen();
        }
      }
      else {
        await _databaseReference.child('users/${widget.userToken}').child('favourites/${favouriteNumber}').set({
            'path': products[widget.idx]['path'],
            'name': products[widget.idx]['pro_name'],
            'price': products[widget.idx]['price'].toString(),
            'origin': products[widget.idx]['origin'],
            'status': true,
            'token': widget.idx,
            'fav_token': favouriteNumber
        });
        showSnackbar('Thêm yêu thích thành công');
        favouriteNumber++;
        await _databaseReference.update({'users/${widget.userToken}/favouriteCount': favouriteNumber,});
        {
          resetScreen();
        }
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
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
                          icon: Image(
                            image: AssetImage('assets/icons/icons8-heart-24.png'),
                            color: _isFav?Colors.pink:Color.fromRGBO(96, 96, 96, 1),
                          ),
                          onPressed:() {
                            setState(() {
                              addFavourite();
                            });
                          }, 
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
                        setState(() {
                          showMaterialBanner('Bạn muốn thêm sản phẩm này vào giỏ hàng');
                        });
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
