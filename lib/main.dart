import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_to_do/HomePage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
