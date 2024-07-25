import 'package:flutter/material.dart';

class Tension{
  final String bras;
  final double tension;
  final String date;
  final TimeOfDay heure;

  Tension({required this.bras, required this.tension, required this.date, required this.heure});
  double getTension(){
    return this.tension;
  }
  String getBras(){
    return this.bras;
  }
  String getDate(){
    return this.date;
  }
}