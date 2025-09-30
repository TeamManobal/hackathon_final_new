import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'main_ui.dart'; 

// --- HELPER FUNCTION: Request Permissions ---
Future<void> _requestPermissions() async {
 await [
  Permission.camera,
  Permission.microphone,
  Permission.storage,
 ].request();
}

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
   );
   await _requestPermissions();
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   title: "Sports Analyzer",
   debugShowCheckedModeBanner: false,
   theme: ThemeData(
    primaryColor: const Color(0xFF0D47A1),
    colorScheme: ColorScheme.fromSwatch().copyWith(
     primary: const Color(0xFF0D47A1),
     secondary: const Color(0xFFFF6F00),
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
     elevation: 0,
     centerTitle: true,
     titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
     ),
    ),
   ),
   home: const AuthCheck(),
   routes: {
    '/login': (context) => const LoginPage(),
   },
  );
 }
}

class AuthCheck extends StatelessWidget {
 const AuthCheck({super.key});

 @override
 Widget build(BuildContext context) {
  return FutureBuilder<List<CameraDescription>>(
   future: availableCameras(),
   builder: (context, cameraSnapshot) {
    if (cameraSnapshot.connectionState != ConnectionState.done) {
     return const SplashScreen();
    }

    final cameras = cameraSnapshot.data ?? [];
    if (cameraSnapshot.hasError || cameras.isEmpty) {
     return const Scaffold(
      body: Center(child: Text("Error: No cameras available or permission denied.")),
     );
    }

    return StreamBuilder<User?>( 
     stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context, authSnapshot) {
      if (authSnapshot.connectionState == ConnectionState.waiting) {
       return const SplashScreen();
      }

      if (authSnapshot.hasData) {
       return MainPage(cameras: cameras);
      }

      return const LoginPage();
     },
    );
   },
  );
 }
}

// --- Updated SplashScreen with 3-second delay ---
class SplashScreen extends StatefulWidget {
 const SplashScreen({super.key});

 @override
 State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 bool _showContent = false;

 @override
 void initState() {
   super.initState();
   Future.delayed(const Duration(seconds: 3), () {
     if (mounted) setState(() => _showContent = true);
   });
 }

 @override
 Widget build(BuildContext context) {
   if (!_showContent) {
     return const Scaffold(
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.sports_soccer, size: 80, color: Color(0xFF0D47A1)),
             SizedBox(height: 20),
             Text(
               "Sports Analyzer",
               style: TextStyle(
                 fontSize: 24,
                 fontWeight: FontWeight.bold,
                 color: Color(0xFF0D47A1),
               ),
             ),
             SizedBox(height: 20),
             CircularProgressIndicator(),
           ],
         ),
       ),
     );
   } else {
     return const SizedBox.shrink(); // Lets FutureBuilder/StreamBuilder continue
   }
 }
}
