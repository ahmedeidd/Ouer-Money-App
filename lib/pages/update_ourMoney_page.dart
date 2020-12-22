import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_helper.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/view_added_items.dart';
import 'package:provider/provider.dart';
class UpdateOurMoneyPage extends StatefulWidget
{
  final String headerTitle;
  final String titles;
  final String tables;
  final OurMoney ourMoney;
  final int index;
  UpdateOurMoneyPage({
    @required this.headerTitle,
    @required this.titles,
    @required this.tables,
    @required this.ourMoney,
    @required this.index,
  });
  @override
  _UpdateOurMoneyPageState createState() => _UpdateOurMoneyPageState();
}

class _UpdateOurMoneyPageState extends State<UpdateOurMoneyPage>
{
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _noItemsController = TextEditingController();
  DBHelper helper;
  @override
  void initState()
  {
    super.initState();
    helper = DBHelper();
    _productController.text = widget.ourMoney.product;
    _productController.addListener(()
    {
      _productController.value = _productController.value.copyWith(
        text: _productController.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: _productController.text.length,
          ),
        ),
      );
    });
    _priceController.text = widget.ourMoney.price.toString();
    _priceController.addListener(()
    {
      _priceController.value = _priceController.value.copyWith(
        text: _priceController.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: _priceController.text.length,
          ),
        ),
      );
    });
    _noItemsController.text = widget.ourMoney.noItems.toString();
    _noItemsController.addListener(()
    {
      _noItemsController.value = _noItemsController.value.copyWith(
        text: _noItemsController.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: _noItemsController.text.length,
          ),
        ),
      );
    });
  }
  //****************************************************************************
  @override
  Widget build(BuildContext context)
  {
    var providerWatchM = context.watch<OurMoney>();
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()
        {
          _back();
          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: Text(''),
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              'تعديل المنتج',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontFamily: 'AJ',
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.black54,
                  ),
                  onPressed: ()
                  {
                    setState(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewOurMoney(index: widget.index,),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children:
                [
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _productController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17,),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'AJ',
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: 'Montserrat'),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17,),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _noItemsController,
                    style: TextStyle(fontFamily: 'Montserrat'),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17,),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 45,
                    margin: EdgeInsets.all(7.0),
                    child: FlatButton(
                      color: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      onPressed: () async
                      {
                        setState(()
                        {
                          final updateOurMoney = OurMoney({
                            'id': widget.ourMoney.id,
                            'product': _productController.text,
                            'price': double.tryParse(_priceController.text),
                            'noItems': double.tryParse(_noItemsController.text),
                          });
                          helper.update(updateOurMoney, providerWatchM.tables[widget.index]);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => ViewOurMoney(index: widget.index,)),
                            (route) => false,
                          );
                        });
                      },
                      child: Text(
                        'تعديل',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'AJ',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //****************************************************************************
  void _back()
  {
    setState(()
    {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ViewOurMoney(index: widget.index,),),
        (route) => false,
      );
    });
  }
  //****************************************************************************
}

