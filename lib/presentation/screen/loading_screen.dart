import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.local_florist,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            SpinKitFadingCircle(
              color: Theme.of(context).colorScheme.secondary,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
