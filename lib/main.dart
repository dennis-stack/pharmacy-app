import 'package:flutter/material.dart';
import 'package:pharmacyApp/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: CartProviderWidget(
        provider: CartProvider(),
        child: MyApp(),
      ),
    ),
  );
}
