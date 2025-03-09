import 'package:b_connectivity/Internet%20Connectivity/Bloc/Connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Internet Connectivity/Internet_Connection_View.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> ConnectivityBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InternetConnectionView(),
      ),
    );
  }
}
