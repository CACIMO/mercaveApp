// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/_home/home.page.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:path/path.dart';
import 'app/core/services/session/session.service.dart';

void main() { 
  //  Set flag to show authentication view only once, before build app - [start]
  WidgetsFlutterBinding.ensureInitialized();
  SessionService.setItem(key: 'loginPageDisplayed', value:'false').then((value) => runApp(
    MaterialApp(
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      debugShowCheckedModeBanner: false,
      //home: HomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage()
      },
    ),
    )
  );
  // Set flag to show authentication view only once, before build app - [End]
  
    
} 
