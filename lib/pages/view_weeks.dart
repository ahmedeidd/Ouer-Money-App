import 'package:flutter/material.dart';
import 'package:our_mony_app/widgets/custom_week.dart';
class ViewWeeks extends StatefulWidget
{
  @override
  _ViewWeeksState createState() => _ViewWeeksState();
}

class _ViewWeeksState extends State<ViewWeeks>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context)
  {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.3,
          backgroundColor: Colors.white,
          leading: Text(''),
          title: Text(
            'فلوسك',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'AJ',
              color: Colors.black87,
            ),
          ),
        ),
        body: _viewAllWeeks(),
      ),
    );
  }
  //****************************************************************************
  Future<bool> _onBackPressed() async
  {
    return showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          content: Text(
            'هل تريد الخروج من البرنامج؟',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          actions: [
            FlatButton(
              child: Text('لا'),
              onPressed: ()
              {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('نعم'),
              onPressed: ()
              {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false ;
  }
  //****************************************************************************
  Widget _viewAllWeeks()
  {
    return Align(
      alignment: Alignment.center,
      child: Container(
        color: Color(0xfff9f9f9),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  CustomWeek(index: 0),
                  CustomWeek(index: 1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  CustomWeek(index: 2),
                  CustomWeek(index: 3),
                ],
              ),
              CustomWeek(index: 4),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
  //****************************************************************************
}