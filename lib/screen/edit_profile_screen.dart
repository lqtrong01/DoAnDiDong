import 'dart:io';
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

  Future selectFile() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    
    final result = await FilePicker.platform.pickFiles();
    if(result==null) return;
    setState(() {
      pickerFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = '${pickerFile!.name}';
    final file = File(pickerFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    imageUrl = urlDownload;
    setState(() {
      uploadTask = null;
    });
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
        // Nếu đăng nhập thành công, thay đổi mật khẩu
        await userCredential.user!.updatePassword(newPassword);

        // Hiển thị thông báo thay đổi mật khẩu thành công
        //showSnackbar("Thay đổi mật khẩu thành công");
      } else {
        // Nếu đăng nhập lại không thành công, hiển thị thông báo lỗi
        //showSnackbar("Thay đổi mật khẩu không thành công");
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
                    onPressed: selectFile,
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
              FormContainerWidget(
                icon: const Icon(Icons.password_outlined),
                controller: password,
                hintText: "Password",
                isPasswordField: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
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
