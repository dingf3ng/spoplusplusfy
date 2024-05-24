import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/main.dart';

final Color goldColour = Color.fromRGBO(255, 232, 163, 1.0);
List<SvgPicture> picList = [];

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,),
          body:
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Text('Welcome,\nHere Are The Music For\nYou', style: TextStyle(fontSize: 40, color: goldColour),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 50,
                    ),
                  itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: Container(
                      child: picList[index],
                      decoration: BoxDecoration(
                        color: goldColour,
                        borderRadius: BorderRadius.circular(50),
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