import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spoplusplusfy/main.dart';

final Color goldColour = Color.fromRGBO(255, 232, 163, 1.0);
List<AssetImage> picList = [];

class Mainpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    picList.add(AssetImage('/assets/image/'));
    return
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,),
          body:
          Column(
            children: [
              Text(
                'Welcome,\nHere Are The Music For\nYou...',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 40,
                  color: goldColour,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 250,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                    ),
                  itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: Container(
                      child: Image(image: picList[index]),
                      decoration: BoxDecoration(
                        color: goldColour,
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                  ),
                  itemCount: picList.length),
                ),
              ),
            ],
          ),
        ),
      );
  }
}