import 'package:flutter/material.dart';
class OurMoney with ChangeNotifier
{
  // Fields
  int _id;
  String _product;
  double _price;
  double _noItems;
  double _total;
  double _weekMoney;
  String _img;

  List<String> titles =
  [
    'الأول',
    'الثاني',
    'الثالث',
    'الرابع',
    'إضافات',
  ];

  List<String> headerTitle =
  [
    'الإسبوع الأول',
    'الإسبوع الثاني',
    'الإسبوع الثالث',
    'الإسبوع الرابع',
    'منتجات إضافية',
  ];

  List<String> tables =
  [
    'tableOne',
    'tableTwo',
    'tableThree',
    'tableFour',
    'tableExtra',
  ];

  //getter
  String get img => _img;
  double get weekMoney => _weekMoney;
  double get total => _total;
  double get noItems => _noItems;
  double get price => _price;
  String get product => _product;
  int get id => _id;

  // Constructor
  OurMoney(dynamic obj)
  {
    notifyListeners();
    _id = obj['id'];
    _product = obj['product'];
    _price = obj['price'];
    _noItems = obj['noItems'];
    _total = obj['total'];
    _weekMoney = obj['weekMoney'];
    _img = obj['img'];
  }

  // Named Constructor
  OurMoney.fromMap(Map<String,dynamic> data)
  {
    _id = data['id'];
    _product = data['product'];
    _price = data['price'];
    _noItems = data['noItems'];
    _total = data['total'];
    _weekMoney = data['weekMoney'];
    _img = data['img'];
  }

  // Methods
  ourmoney(Map<String, dynamic> obj) async
  {
    notifyListeners();
    _id = await obj['id'];
    _product = await obj['product'];
    _price = await obj['price'];
    _noItems = await obj['noItems'];
    _total = await obj['total'];
    _weekMoney = await obj['weekMoney'];
    _img = await obj['img'];
  }

  Map<String, dynamic> convertToMap()
  {
    notifyListeners();
    return
    {
      'id': _id,
      'product': _product,
      'price': _price,
      'noItems': _noItems,
      'total': _total,
      'weekMoney': _weekMoney,
      'img': _img,
    };
  }

  notifyListeners();
}