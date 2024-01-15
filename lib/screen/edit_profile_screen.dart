

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
  String image_url = '';
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  late String imageUrl;
  PlatformFile? pickerFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    _fetchData();
    imageUrl = '';
  }

  Future<void> _fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DatabaseEvent event = await _databaseReference
            .child('users')
            .orderByChild('detail/email')
            .equalTo('abc@gmail.com')
            .once();
        DataSnapshot? dataSnapshot = event.snapshot;

        if (dataSnapshot != null && dataSnapshot.value != null) {
          // List<dynamic> userData = (dataSnapshot.value)!.values.first;
          List<dynamic> userData = dataSnapshot.value as List;
          setState(() {
            name.text = userData[widget.userToken]['detail']['name']??'';
            email.text = userData[widget.userToken]['detail']['email']??'';
            password.text = userData[widget.userToken]['detail']['password']??'';
            location.text = userData[widget.userToken]['detail']['location']??'';
            phone.text = userData[widget.userToken]['detail']['phone']??'';
          });
          print(userData);
        }
        
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
    buildProgress();
  }

  void editUser() async {
    try {
      if(name.text.isNotEmpty&&email.text.isNotEmpty&&phone.text.isNotEmpty&&location.text.isNotEmpty&&password.text.isNotEmpty){
        await _databaseReference.child('users/${0}').child('detail').set({
          'name': name.text.toString(),
          'email': email.text.toString(),
          'phone': phone.text.toString(),
          'location': location.text.toString(), 
          'password': password.text.toString(),
          'avt_path': imageUrl,
        });
        await _databaseReference.child('users/${0}').set({
          'categoryCount': 0,
        });
       
      }
      else { }
      
    } catch (error) {
      print(error.toString());
    }
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: uploadTask?.snapshotEvents,
    builder: (context, snapshot) {
      if(snapshot.hasData){
        final data = snapshot.data!;
        double progress = data.bytesTransferred / data.totalBytes;
        return SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.green,
              ),
              Center(
                child: Text(
                  '${(100*progress).roundToDouble()}%',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      } else {
        return const SizedBox(height: 50,);
      }
      
    },
  );

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
                        'image_url',
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
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.location_on_outlined),
                controller: location,
                hintText: "Địa điểm",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.phone_android_outlined),
                controller: phone,
                hintText: "Phone",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                icon: const Icon(Icons.password_outlined),
                controller: password,
                hintText: "Password",
                isPasswordField: true,
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
                      editUser();
                      uploadFile();
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
