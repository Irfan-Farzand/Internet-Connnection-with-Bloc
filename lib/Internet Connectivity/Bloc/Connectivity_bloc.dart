import 'dart:async';
import 'package:b_connectivity/Internet%20Connectivity/Bloc/Connectivity_event.dart';
import 'package:b_connectivity/Internet%20Connectivity/Bloc/Connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityLostEvent>((event, emit) => emit(ConnectivityDisconnected()));
    on<ConnectivityGainEvent>((event, emit) => emit(ConnectivityConnected()));

    // Check initial connectivity
    _checkInitialConnectivity();

    // Listen for changes
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      // Check if the result contains wifi or mobile connection
      if (result.toString().contains('wifi') || result.toString().contains('mobile')) {
        add(ConnectivityGainEvent());
      } else {
        add(ConnectivityLostEvent());
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      // Simple string check that works with both list and single results
      if (result.toString().contains('wifi') || result.toString().contains('mobile')) {
        add(ConnectivityGainEvent());
      } else {
        add(ConnectivityLostEvent());
      }
    } catch (e) {
      add(ConnectivityLostEvent());
    }
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}