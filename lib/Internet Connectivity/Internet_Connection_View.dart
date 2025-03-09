import 'package:b_connectivity/Internet%20Connectivity/Bloc/Connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/Connectivity_state.dart';
import 'Bloc/Connectivity_event.dart';

class InternetConnectionView extends StatefulWidget {
  const InternetConnectionView({super.key});

  @override
  State<InternetConnectionView> createState() => _InternetConnectionViewState();
}

class _InternetConnectionViewState extends State<InternetConnectionView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();

    // Force check connectivity when view initializes
    Future.delayed(Duration.zero, () {
      context.read<ConnectivityBloc>().add(ConnectivityCheckEvent());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Text(
          "Internet Connection",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocConsumer<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityConnected) {
              _showCustomSnackBar(
                  context,
                  "Internet Connected",
                  Colors.green.shade700,
                  Icons.wifi
              );
              _animationController.reset();
              _animationController.forward();
            }
            else if (state is ConnectivityDisconnected) {
              _showCustomSnackBar(
                  context,
                  "Internet Not Connected",
                  Colors.red.shade700,
                  Icons.wifi_off
              );
              _animationController.reset();
              _animationController.forward();
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: state is ConnectivityConnected
                      ? [Colors.teal.shade100, Colors.green.shade50]
                      : state is ConnectivityDisconnected
                      ? [Colors.teal.shade100, Colors.red.shade50]
                      : [Colors.teal.shade100, Colors.grey.shade100],
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildStateContent(state),
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<ConnectivityBloc>().add(ConnectivityCheckEvent());
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text("Check Again", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStateContent(ConnectivityState state) {
    if (state is ConnectivityConnected) {
      return ScaleTransition(
        scale: _animation,
        child: Card(
          key: const ValueKey('connected'),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.wifi, size: 80, color: Colors.green.shade700),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Internet Connected",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You are connected to the internet and can use all features.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else if (state is ConnectivityDisconnected) {
      return ScaleTransition(
        scale: _animation,
        child: Card(
          key: const ValueKey('disconnected'),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.wifi_off, size: 80, color: Colors.red.shade700),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Internet Not Connected",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Please check your internet connection and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return Card(
        key: const ValueKey('checking'),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Checking Connection...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Please wait while we detect your network status.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showCustomSnackBar(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}