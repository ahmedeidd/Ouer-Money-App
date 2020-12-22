import 'package:flutter/material.dart';
import 'package:our_mony_app/databases/db_helper.dart';
import 'package:our_mony_app/databases/db_provider.dart';
import 'package:our_mony_app/widgets/custom_view.dart';
import 'package:our_mony_app/widgets/no_money.dart';
import 'package:provider/provider.dart';
class CustomWeek extends StatefulWidget
{
  final int index;
  CustomWeek({@required this.index});
  @override
  _CustomWeekState createState() => _CustomWeekState();
}

class _CustomWeekState extends State<CustomWeek>
{
  @override
  Widget build(BuildContext context)
  {
    var providerWatchH = context.watch<DBHelper>();
    var providerSelectM = context.select((OurMoney ourMoney) => ourMoney.tables[widget.index]);
    return Container(
      child: FutureBuilder(
        future: providerWatchH.getAllOurMoney(providerSelectM),
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
          {
            try
            {
              OurMoney ourMoney = OurMoney.fromMap(snapshot.data[0]);
              return CustomView(
                snapshot: ourMoney,
                index: widget.index,
                child: CircularProgressIndicator(),
              );
            }
            catch(e)
            {
              var screenSize = MediaQuery.of(context).size;
              var orientation = MediaQuery.of(context).orientation;
              var providerWatchM = context.watch<OurMoney>();
              return NoMoney(
                orientation: orientation,
                screenSize: screenSize,
                headerTitle: providerWatchM,
                index: widget.index,
              );
            }
          }
          else if(snapshot.hasError)
          {
            return Text('Nothing to view');
          }
          else
          {
            return CustomView(
              index: widget.index,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
