import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/pages/view_added_items.dart';
import 'package:provider/provider.dart';
class CustomView extends StatefulWidget
{
  final OurMoney snapshot;
  final int index;
  final Widget child;
  CustomView({this.snapshot, @required this.index, this.child});

  @override
  _CustomViewState createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView>
{
  @override
  Widget build(BuildContext context)
  {
    return _buildViewer(context);
  }
  //****************************************************************************
  Widget _buildViewer(BuildContext context)
  {
    var headerTitle = context.select((OurMoney value) => value.headerTitle[widget.index] );
    var screenSize = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      onTap: ()
      {
        setState(()
        {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ViewOurMoney(index: widget.index,)),
            (route) => false,
          );
        });
      },
      child: Stack(
        children:
        [
          Container(
            width: orientation == Orientation.portrait
                ? (widget.index == 4
                    ? screenSize.width * 0.83
                    : screenSize.width * 0.40)
                : (widget.index == 4
                    ? screenSize.width * 0.78
                    : screenSize.width * 0.30),
            height: orientation == Orientation.portrait
                ? screenSize.height * 0.25
                : screenSize.height * 0.45,
            margin: EdgeInsets.all(7.0),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffEBEBEB),
                  offset: Offset.zero,
                )
              ],
            ),
            child: widget.snapshot != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Container(
                        child: Center(
                          child: Text(
                            'إجمالي المبلغ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xff707070),
                              fontFamily: 'AJ',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        child: Center(
                          child: Text(
                            '${widget.snapshot.weekMoney}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Color(0xff707070),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: widget.child,),
          ),
          Positioned(
            top: 15.0,
            right: 0.0,
            left: 0.0,
            child: Text(
              headerTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff9A9A9A),
                fontWeight: FontWeight.bold,
                fontFamily: 'AJ',
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 0,
            left: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 30,
                height: 30,
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
        ],
      ),
    );
  }
  //****************************************************************************
}
