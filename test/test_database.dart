import 'package:spoplusplusfy/Classes/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  DatabaseHelper database = DatabaseHelper();
  database.getRandomPlaylist();
}