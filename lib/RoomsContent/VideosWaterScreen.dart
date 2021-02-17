
import 'package:dreslamelshahawy/PlayerPage.dart';
import 'package:dreslamelshahawy/RoomsContent/WaterScreenHelper.dart';
import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  final String id ;


  const MyCard({Key key,this.id}) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10000*5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final move = _animationController.value * MediaQuery.of(context).size.height;
          return Stack(children: [
            WaterDrop(
              child: child,
              params: [

                WaterDropParam(top: 0 + move, height: 40, left: 10, width: 100),
                // WaterDropParam(top: 10 + move, height: 100, left: 280, width: 100),
                // WaterDropParam(top: 155 + move, height: 35, left: 135, width: 35),
                // WaterDropParam(top: 0 + move, height: 40, left: 250, width: 70),
                WaterDropParam(top: 0 + move, height: 40, left: MediaQuery.of(context).size.width-120, width: 100),

                // WaterDropParam(top: 20 + move, height: 40, left: 20, width: 40),
                // WaterDropParam(top: 140 + move, height: 50, left: 15, width: 40),
                // WaterDropParam(top: 20 + move, height: 30, left: 200, width: 30),
                // WaterDropParam(top: 120 + move, height: 20, left: 360, width: 20),
              ],
            ),
            Text('dd')
          ],);
        },
        child: YoutubePlayerPage(widget.id),
      ),
    );
  }
}
