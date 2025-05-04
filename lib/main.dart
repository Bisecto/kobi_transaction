import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test/views/app_screens/transaction_activity.dart';
import 'bloc/transaction_bloc/transaction_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOBI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
       // fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
      ),
      home: BlocProvider(
        create: (context) => TransactionBloc(),
        child: const TransactionActivityPage(),
      ),
    );
  }
}