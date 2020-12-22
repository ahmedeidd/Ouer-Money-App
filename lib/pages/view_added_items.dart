import 'dart:io';
import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_helper.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/update_ourMoney_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as initl;

import 'add_new_item.dart';
class ViewOurMoney extends StatefulWidget
{
  final int index;
  final String imgs;
  ViewOurMoney({this.index, this.imgs});
  @override
  _ViewOurMoneyState createState() => _ViewOurMoneyState();
}

class _ViewOurMoneyState extends State<ViewOurMoney> with TickerProviderStateMixin
{
  var myDate = initl.DateFormat().add_Md().format(DateTime.now());
  AnimationController _controller;
  ScrollController _scrollController = ScrollController();
  String newImg;
  bool isSelected = false;
  bool isTrue = false;
  @override
  void initState()
  {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() { });
    getData();
    setData();
    _scrollController..addListener(() { });
  }
  //****************************************************************************
  setData() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('img', widget.imgs);
    });
  }
  //****************************************************************************
  getData() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      newImg = pref.getString('img');
      setData();
    });
  }
  //****************************************************************************
  @override
  void dispose()
  {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }
  //****************************************************************************
  @override
  Widget build(BuildContext context)
  {
    var providerWatchH = context.watch<DBHelper>();
    var providerWatchM = context.watch<OurMoney>();
      return WillPopScope(
        onWillPop: ()
        {
          _back();
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: Text(''),
            centerTitle: true,
            title: Text(
              '${providerWatchM.headerTitle[widget.index]}',
              style: TextStyle(
                color: Color(0xff9A9A9A),
                fontWeight: FontWeight.bold,
                fontFamily: 'AJ',
              ),
            ),
            actions:
            [
              IconButton(
                icon: Icon(Icons.arrow_forward),
                color: Colors.black54,
                onPressed: ()
                {
                  setState(()
                  {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  });
                },
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: providerWatchH.getAllOurMoney(providerWatchM.tables[widget.index]),
              builder: (context,AsyncSnapshot snapshot)
              {
                if(!snapshot.hasData)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(snapshot.hasError)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else
                {
                  return _buildListView(snapshot);
                }
              },
            ),
          ),
          floatingActionButton: _buildFloatButton(context),
        ),
      );
  }
  //****************************************************************************
  showAlertDialog(BuildContext context, AsyncSnapshot snapshot, index)
  {
    OurMoney ourMoney = OurMoney.fromMap(snapshot.data[index]);
    var providerReadH = context.read<DBHelper>();
    var providerReadM = context.read<OurMoney>();
    Widget cancelButton = FlatButton(
      onPressed: ()
      {
        setState(() {
          Navigator.of(context).pop();
        });
      },
      child: Text('لا'),
    );
    Widget notCancelButton = FlatButton(
      child: Text('نعم'),
      onPressed: ()
      {
        setState(() {
          isTrue = false;
          providerReadH.delete(ourMoney.id, providerReadM.tables[widget.index]);
          Navigator.of(context).pop();
        });
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text(
                  'حذف منتج',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(height: 2,),
              ],
            ),
          ),
          content: Text(
            'هل تريد حذف هذا المنتج ؟',
            textAlign: TextAlign.start,
            textDirection: TextDirection.rtl,
          ),
          actions: [
            cancelButton,
            notCancelButton,
          ],
        );
      },
    );
  }
  //****************************************************************************
  // Alert amount limit
  _showLimitAlert(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          content: Text(
            "تم الوصول إلى الحد الأقصى لهذا الإسبوع...",
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'AJ',
            ),
          ),
        );
      },
    );
  }
  //****************************************************************************
  Widget _buildListView(AsyncSnapshot snapshot)
  {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2 ,
      ),
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(vertical: 20,),
      itemCount: snapshot.data.length,
      itemBuilder: (context,index)
      {
        OurMoney ourMoney = OurMoney.fromMap(snapshot.data[index]);
        if(ourMoney.weekMoney >= 500){
          isTrue = true;
        }else if(ourMoney.weekMoney < 500){
          isTrue = false;
        }
        return Container(
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.50
              : MediaQuery.of(context).size.width * 0.25,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: index.isEven
                ? Color(0xFFE3F2FD).withOpacity(0.3)
                : Color(0xFFE8F5E9).withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(14),),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Text(
                            'المنتج: ',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[500],
                            ),
                          ),
                          Text(
                            '${ourMoney.product}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Text(
                            'السعر: ',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          Text(
                            '${ourMoney.price}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        children:
                        [
                          Text(
                            'العدد: ',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          Text(
                            '${ourMoney.noItems}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        children:
                        [
                          Text(
                            'المجموع: ',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          Text(
                            '${ourMoney.total}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        children:
                        [
                          Text(
                            'التاريخ: ',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          Text(
                            '${myDate}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[400],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: ClipOval(
                        child: Material(
                          child: Ink(
                            color: Colors.black87,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(()
                                {
                                  showAlertDialog(context, snapshot, index);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: ClipOval(
                        child: Material(
                          child: Ink(
                            color: Colors.teal,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                              onPressed: ()
                              {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => UpdateOurMoneyPage(
                                      headerTitle: ourMoney.headerTitle[widget.index],
                                      titles: ourMoney.titles[widget.index],
                                      tables: ourMoney.tables[widget.index],
                                      ourMoney: ourMoney,
                                      index: widget.index,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    ourMoney.img != null
                        ? Container(
                            alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            child: ClipOval(
                              child: Material(
                                child: Ink(
                                  color: Colors.amber,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.image,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    onPressed: ()
                                    {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context){
                                            return _viewReceipt(
                                              MediaQuery.of(context).size,
                                              context,
                                              ourMoney,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(""),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  //****************************************************************************
  Widget _viewReceipt(Size screenSize, BuildContext context, OurMoney ourMoney)
  {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children:
            [
              Container(
                width: screenSize.width,
                height: screenSize.height,
                alignment: Alignment.center,
                child: InteractiveViewer(
                  child: Image.file(
                    File(ourMoney.img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: ClipOval(
                      child: Material(
                        child: Ink(
                          color: Colors.amber,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                            ),
                            color: Colors.black,
                            onPressed: ()
                            {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //****************************************************************************
  Widget _buildFloatButton(BuildContext context)
  {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
      ),
      onPressed: ()
      {
        if(isTrue)
        {
          _showLimitAlert(context);
        }
        else
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context)
              {
                return AddNewItem(
                  index: widget.index,
                );
              },
            ),
            (route) => false,
          );
        }
      },
    );
  }
  //****************************************************************************
  void _back()
  {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
  //****************************************************************************
}
