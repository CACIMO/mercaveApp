// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/_home/home.page.dart';
import 'package:mercave/app/ui/constants.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(primaryColor: kCustomSecondaryColor),
    debugShowCheckedModeBanner: false,
    home: HomePage()));
