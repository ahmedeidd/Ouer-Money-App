import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/view_added_items.dart';
class NoMoney extends StatefulWidget
{
  final Orientation orientation;
  final Size screenSize;
  final OurMoney headerTitle;
  final int index;
  const NoMoney({
    @required this.orientation,
    @required this.screenSize,
    @required this.headerTitle,
    @required this.index,
  });
  @override
  _NoMoneyState createState() => _NoMoneyState();
}

class _NoMoneyState extends State<NoMoney>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        setState(()
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ViewOurMoney(index: widget.index,)),
            (route) => false,
          );
        });
      },
      child: Stack(
        children:
        [
          Container(
            width: widget.orientation == Orientation.portrait
                ? (widget.index == 4
                    ? widget.screenSize.width * 0.83
                    : widget.screenSize.width * 0.40)
                :(widget.index == 4
                   ? widget.screenSize.width * 0.63
                   : widget.screenSize.width * 0.30),
            height: widget.orientation == Orientation.portrait
                ? widget.screenSize.height * 0.25
                : widget.screenSize.height * 0.45,
            margin: EdgeInsets.all(17.0),
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(22)),
              boxShadow:
              [
                BoxShadow(
                  color: Color(0xffEBEBEB),
                  offset: Offset.zero,
                )
              ],
            ),
            child: Center(
              child: Text(
                'لا يوجد أي منتج',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff707070),
                  fontSize: 16,
                  height: 1.7,
                  fontFamily: 'AJ',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 25,
            left: 0,
            child: Text(
              widget.headerTitle.headerTitle[widget.index],
              style: TextStyle(
                color: Color(0xff9A9A9A),
                fontWeight: FontWeight.bold,
                fontFamily: 'AJ',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
