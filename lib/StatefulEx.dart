import "package:flutter/material.dart";

class StateFulExample extends StatefulWidget {
  const StateFulExample({super.key});

  @override
  State<StateFulExample> createState() => _StateFulExampleState();
}

class _StateFulExampleState extends State<StateFulExample> {
  int counter = 0;
  void incrementcounter(){
    setState(() {
      counter ++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        incrementcounter();
      }, child: Icon(Icons.add),),
      body: Center(child: Text('$counter', style: TextStyle(fontSize: 20),)),
    );
  }
}