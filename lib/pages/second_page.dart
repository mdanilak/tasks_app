import 'package:flutter/material.dart';
import 'package:tasks_app/pages/home_page.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  Widget build(BuildContext context) {
    // Here I built a layout only containing a button for now
    // The button helps the user navigate back to the home screen
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                }, label: const Text("Back to Home Screen"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}