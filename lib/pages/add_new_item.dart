import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_mony_app/databases/db_helper.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/view_added_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AddNewItem extends StatefulWidget {
  final int index;

  AddNewItem({@required this.index});

  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  String product, img;
  double price, noItems, weekMoney;
  DateTime date;
  var focus;
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _noItemsController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool isPrice = true;
  bool isNoItem = true;

  // ***************************************************************************
  // function get an image
  final picker = ImagePicker();
  Future getAnImage(ImageSource source) async {
    final PickedFile pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        img = pickedFile.path;
        setDate(pickedFile.path);
      } else {
        return Center(
          child: Text("No Selected Image"),
        );
      }
    });
  }

  //****************************************************************************
  // use sharedPreferences to set date
  setDate(String mypath) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('key', mypath);
    });
  }

  //****************************************************************************
  // use sharedPreferences to get date
  getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      img = prefs.getString('key');
    });
  }

  //****************************************************************************
  // use sharedPreferences to delete date
  deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
    });
  }

  //****************************************************************************
  @override
  void initState() {
    super.initState();
    focus = FocusNode();
    _productController.addListener(() {
      _productController.value = _productController.value.copyWith(
        text: _productController.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: _productController.text.length,
          ),
        ),
      );
    });
    _priceController.addListener(() {
      _priceController.value = _priceController.value.copyWith(
        text: _priceController.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: _priceController.text.length,
          ),
        ),
      );
    });
    _noItemsController.addListener(() {
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
  clearText() {
    setState(() {
      _productController.buildTextSpan(
        style: TextStyle(
          color: Colors.greenAccent,
        ),
      );
    });
  }

  //****************************************************************************
  @override
  void dispose() {
    _productController.dispose();
    _priceController.dispose();
    _noItemsController.dispose();

    super.dispose();
  }

  //****************************************************************************
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          _back();
          return Future.value(false);
        },
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            title: Text(
              'إضافة مصروف',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 16,
                height: 1.7,
                fontFamily: 'AJ',
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => ViewOurMoney(
                            index: widget.index,
                            imgs: img,
                          ),
                        ),
                        (route) => false,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    _product(),
                    SizedBox(
                      height: 20,
                    ),
                    _price(),
                    SizedBox(
                      height: 20,
                    ),
                    _noItems(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: screenSize.width * 0.50,
                            height: screenSize.height * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  width: 2.0,
                                  color: Colors.white,
                                ),
                                vertical: BorderSide(
                                  width: 2.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                img != null
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: InteractiveViewer(
                                                child: Image.file(
                                                  File(img),
                                                  fit: BoxFit.cover,
                                                  width:
                                                      screenSize.width * 0.40,
                                                  height:
                                                      screenSize.height * 0.25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: ClipOval(
                                              child: Material(
                                                child: Ink(
                                                  color: Colors.blue
                                                      .withOpacity(0.05),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        deleteData();
                                                        getDate();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Text(
                                          'إضافة اسعار\n المنتجات كصورة هنا!',
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: screenSize.width * 0.40,
                          height: screenSize.height * 0.1,
                          child: FlatButton.icon(
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.blue,
                              size: 20,
                            ),
                            color: Colors.blue.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            splashColor: Colors.blue.withOpacity(0.03),
                            highlightColor: Colors.blue.shade50,
                            label: Text(
                              'إضافة صورة',
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'AJ',
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(22),
                                        topRight: Radius.circular(22),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ListTile(
                                                leading: Icon(Icons.photo),
                                                title: Text(
                                                  'الصور',
                                                  style: TextStyle(
                                                    fontFamily: 'AJ',
                                                  ),
                                                ),
                                                onTap: () {
                                                  getAnImage(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text(
                                                  'الكاميرا',
                                                  style: TextStyle(
                                                    fontFamily: 'AJ',
                                                  ),
                                                ),
                                                onTap: () {
                                                  getAnImage(
                                                      ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 45,
                      margin: EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        onPressed: () async {
                          await _submit();
                          setState(() {});
                        },
                        child: Text(
                          'حفظ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'AJ',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //****************************************************************************
  _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      OurMoney ourMoney = OurMoney.fromMap({
        'product': product,
        'price': price,
        'noItems': noItems,
        'weekMoney': weekMoney,
        'img': img,
      });
      var providerReadH = context.read<DBHelper>();
      var providerReadM = context.read<OurMoney>();
      await providerReadH.creatOurMoney(
          ourMoney, providerReadM.tables[widget.index]);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ViewOurMoney(
                  index: widget.index,
                  imgs: img,
                )),
      );
    }
    // Dismiss the keyboard
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  //****************************************************************************
  Widget _product() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          validator: (val) {
            if (val.isEmpty) {
              return "يجب عليك اضافة منتج";
            } else {
              return null;
            }
          },
          controller: _productController,
          onChanged: (val) {
            setState(() {
              product = val;
            });
          },
          autofocus: true,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'AJ',
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            hintText: 'إسم المنتج',
            alignLabelWithHint: true,
            hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'AJ',
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
      ),
    );
  }

  //****************************************************************************
  Widget _price() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          validator: (val) {
            if (val.length == 0) {
              return "يجب عليك اضافة سعر المنتج";
            } else {
              return null;
            }
          },
          controller: _priceController,
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
          onChanged: (val) {
            setState(() {
              if (_priceController.text.isEmpty) {
                isPrice = true;
              } else {
                isPrice = false;
                price = double.parse(val);
              }
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp('[0-9,.]'),
            ),
            FilteringTextInputFormatter.deny(
              RegExp(r"[\s\b|\s\b]"),
            ),
          ],
          textAlign: isPrice ? TextAlign.right : TextAlign.left,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'السعر',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'AJ',
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
      ),
    );
  }

  //****************************************************************************
  Widget _noItems() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          validator: (val) {
            if (val.length == 0) {
              return "يجب عليك اضافة عدد المنتج";
            } else {
              return null;
            }
          },
          controller: _noItemsController,
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
          onChanged: (val) {
            setState(() {
              if (_noItemsController.text.isEmpty) {
                isNoItem = true;
              } else {
                isNoItem = false;
                noItems = double.parse(val);
              }
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp('[0-9,.]'),
            ),
            FilteringTextInputFormatter.deny(
              RegExp(r"[\s\b|\s\b]"),
            ),
          ],
          textAlign: isNoItem ? TextAlign.right : TextAlign.left,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'العدد',
            hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'AJ',
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
      ),
    );
  }

  //****************************************************************************
  _back() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => ViewOurMoney(
                index: widget.index,
              )),
      (route) => false,
    );
  }
  //****************************************************************************
}
