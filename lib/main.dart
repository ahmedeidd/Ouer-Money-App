import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:our_mony_app/databases/db_helper.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/view_weeks.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context){
            return DBHelper();
          },
        ),
        ChangeNotifierProvider(
          create: (context){
            return OurMoney({});
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
     supportedLocales: [
       const Locale('en', ''), // English, no country code
       const Locale('ar', ''), // Arabic, no country code
     ],
     debugShowCheckedModeBanner: false,
     routes: {
        '/': (context) => ViewWeeks(),
     },
    );
  }
}
