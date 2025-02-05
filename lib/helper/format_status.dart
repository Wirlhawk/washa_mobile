// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';

String formatStatus(int statusCode) {
  String status = '';
  switch (statusCode) {
    case 0:
      status = 'Cancelled';
    case 1:
      status = 'Pending';
    case 2:
      status = 'Washing';
    case 3:
      status = 'Drying';
    case 4:
      status = 'On Delivery';
    case 5:
      status = 'Done';
    default:
      status = 'Pending';
  }
  return status;
}
