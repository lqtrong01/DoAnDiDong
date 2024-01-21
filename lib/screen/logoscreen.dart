import 'package:animate_do/animate_do.dart';
import 'package:app_thuong_mai/screen/loading_screen.dart';
import 'package:app_thuong_mai/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  bool isLogoLoading = true;
  bool isLoading = false;
  bool isFirst=true;

  Future<bool> _loadFS() async{
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveFirstUse') ?? true;
  }
  Future<void> _saveFS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveFirstUse', false);
  }

  void _delaylogo() async{
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isLogoLoading=false;
    });
  }

  @override
  void initState() {
    isLogoLoading=true;
    _loadFS().then((value) {
      setState(() {
        isFirst = value;
      });
    });
    _delaylogo();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return isLogoLoading?_logoScreen():(isLoading?LoadingScreen():(isFirst?_getStartedScreen():LoginScreen()));
  }

  Widget _logoScreen(){
    return Scaffold(backgroundColor: const Color.fromRGBO(87, 175, 115, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Stack(children: [
                Image.asset('assets/img/tomato.jpg',
                  width: MediaQuery.of(context).size.width-100,),
                Positioned(
                  top: 200,
                  left: 80,
                  child: FadeInUp(duration: const Duration(seconds: 1),child: Text("NDTT",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 50.0, color: Colors.white),))),
              ],),
            ),
            Container(padding: const EdgeInsets.only(left: 50.0),
              child: FadeInLeft(duration: const  Duration(seconds: 1),child: Text("Vephenomsoft",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 50.0, color: Colors.white),),),),
          ]
        ),);
  }

  Widget _getStartedScreen(){
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [ Image.asset('assets/img/bg.jpg',fit: BoxFit.fitHeight,alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                ),
              Positioned(
                top: 680,
                left: 115,
                child: ElevatedButton(style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent,),
                ) ,onPressed: () async {
                    setState(() {
                      isLoading=true;
                    });
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      isLoading=false;
                      _saveFS();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, '/login');
                    });
                        }, child: const Text("Get Started",style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w400),)),
              )
          ]),
          ],
        ),
      ),
    );
  }
}