import 'dart:io';
import 'dart:typed_data';
import 'package:app_thuong_mai/Item/utils.dart';
import 'package:app_thuong_mai/screen/profile_screen.dart';
import 'package:app_thuong_mai/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';


class EditProfileScreen extends StatefulWidget {
  final int userToken;
  const EditProfileScreen({super.key, required this.userToken});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController location = TextEditingController();
  String imageUrl = '';
  String userID = '';
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();
  FirebaseAuth _auth = FirebaseAuth.instance;

  PlatformFile? pickerFile;
  UploadTask? uploadTask;
  List<Map<dynamic, dynamic>> user = [];

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
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user.add(value);
        });
        setState(() {
          name.text = user[widget.userToken]['detail']['name'];
          email.text = user[widget.userToken]['detail']['email'];
          location.text = user[widget.userToken]['detail']['location'];
          imageUrl = user[widget.userToken]['detail']['avatar']??'';
          phone.text = user[widget.userToken]['detail']['phone'];
          userID = user[widget.userToken]['detail']['userID'];
          password.text = user[widget.userToken]['detail']['password'].toString();
        }); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> selectAndUploadImageToFirebase() async {
  final file =  await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    Uint8List imageData = await File(file.path!).readAsBytes();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('images');
    Reference referenceUpLoad = referenceDireImages.child(fileName);

    try {
      await referenceUpLoad.putData(imageData, SettableMetadata(contentType: 'image'));
      
      // Lấy đường dẫn URL của ảnh sau khi tải lên
      String downloadUrl = await referenceUpLoad.getDownloadURL();
      print('Download URL: $downloadUrl');
      
      imageUrl = downloadUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      // Xử lý lỗi nếu cần thiết
      return null;
    }
  }

  void editUser() async {
    try {
      if(name.text.isNotEmpty&&email.text.isNotEmpty&&phone.text.isNotEmpty&&location.text.isNotEmpty&&password.text.isNotEmpty){
        await _databaseReference.child('users/${widget.userToken}').child('detail').update({
          'name': name.text.toString(),
          'email': email.text.toString(),
          'phone': phone.text.toString(),
          'location': location.text.toString(), 
          'password': password.text.toString(),
          'avatar': imageUrl??'',
          'token': widget.userToken
        });
        //changePassword(currentPassword, password.text);
        showSnackbar('Cập nhật thông tin thành công');
      }
      else { 
        showSnackbar('Cập nhật thông tin không thành công');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      // Đăng nhập lại để xác thực mật khẩu hiện tại
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'txt_email.text',
        password: currentPassword,
      );

      // Kiểm tra xem đăng nhập lại có thành công không
      if (userCredential.user != null) {
        await userCredential.user!.updatePassword(newPassword);
        showSnackbar("Thay đổi mật khẩu thành công");
      } else {
        showSnackbar("Thay đổi mật khẩu không thành công");
      }
    } catch (e) {
      print("Error changing password: $e");
      // Xử lý lỗi thay đổi mật khẩu
      //showSnackbar("Thay đổi mật khẩu không thành công");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color.fromRGBO(87, 175, 115, 1),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân', style: TextStyle(color: Colors.black),),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(userToken: widget.userToken,)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0,),
                Container(
                  width: 300,
                  height: 300,
                  color: const Color.fromRGBO(87, 175, 115, 1),
                  child: Center(
                    child: pickerFile!=null?
                      Image.file(
                        File(pickerFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      :
                      (Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(87, 175, 115, 1),
                      ),
                    ),
                    child: Text('Select File'),
                    onPressed: selectAndUploadImageToFirebase,
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.person),
                controller: name,
                hintText: "Username",
                isPasswordField: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.email_outlined),
                controller: email,
                hintText: "Email",
                isPasswordField: false,
                isEnable: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.location_on_outlined),
                controller: location,
                hintText: "Địa điểm",
                isPasswordField: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.phone_android_outlined),
                controller: phone,
                hintText: "Phone",
                isPasswordField: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // FormContainerWidget(
              //   icon: const Icon(Icons.password_outlined),
              //   controller: password,
              //   hintText: "Password",
              //   isPasswordField: true,
              //   isEnable: false,
              //   validator: (String? value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter some text';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(87, 175, 115, 1)
                      ),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(87, 175, 115, 1)
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        editUser();  
                        //uploadFile();
                      });
                      
                      //uploadFile();
                      //Navigator.pop(context);
                    },
                    child: const Text('Lưu'),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
