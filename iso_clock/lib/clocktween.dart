import 'package:flutter/material.dart';

class BoxData {
  double height;
  double width;

  Map<String, dynamic> get map {
    return {
      "width": this.width,
      "height": this.height,
    };
  }

  BoxData({this.height, this.width});
}

class InnerBox extends StatelessWidget {
  final BoxData dims;
  InnerBox({this.dims});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Main Face
        Container(
          width: dims.width,
          height: dims.height,
          color: Colors.white,
        ),

        // Right Face
        Padding(
          padding: EdgeInsets.only(left: dims.width),
          child: Transform(
            alignment: FractionalOffset.topLeft,
            transform: Matrix4.skewY(0.9),
            child: Container(
              width: 40.0, // grows down
              height: dims.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blue[500], Colors.blue[800]])),
            ),
          ),
        ),

        // Bottom Face
        Padding(
          padding: EdgeInsets.only(top: dims.height),
          child: Transform(
            alignment: FractionalOffset.topLeft,
            transform: Matrix4.skewX(0.7), // skew will not go out of y bounds
            child: Container(
              width: dims.width,
              height: 80.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[400], Colors.blue[700]])),
            ),
          ),
        ),
      ],
    );
  }
}

class InnerBoxPositioned extends StatelessWidget {
  final BoxData dims;
  InnerBoxPositioned({this.dims});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90.0,
      left: 30.0,
      child: Stack(
        children: <Widget>[
          // Main Face
          Container(
            width: dims.width,
            height: dims.height,
            color: Colors.white,
          ),

          // Right Face
          Padding(
            padding: EdgeInsets.only(left: dims.width),
            child: Transform(
              alignment: FractionalOffset.topLeft,
              transform: Matrix4.skewY(0.9),
              child: Container(
                width: 40.0, // grows down
                height: dims.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.blue[500], Colors.blue[800]]),
                        ),
              ),
            ),
          ),

          // Bottom Face
          Padding(
            padding: EdgeInsets.only(top: dims.height),
            child: Transform(
              alignment: FractionalOffset.topLeft,
              transform: Matrix4.skewX(0.7), // skew will not go out of y bounds
              child: Container(
                width: dims.width,
                height: 80.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[400], Colors.blue[700]])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.topLeft,
      transform: Matrix4.skewX(0.7),
      child: Container(
        width: 100.0,
        height: 120.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[300], Colors.blue[900]]),
        ),
      ),
    );
  }
}

class Digit extends StatefulWidget {
  Digit({Key key, this.duration}) : super(key: key);

  final Duration duration;

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> with SingleTickerProviderStateMixin {
  final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(30, 90, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 60, 120),
  );

  AnimationController _controller;

  bool _first = true;

  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // widget stuff
  final double _digitWidth = 100.0;
  final double _digitHeight = 150.0;

  final dims1 = BoxData(width: 40.0, height: 30.0);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.skewX(-0.2),
      child: Container(
        width: _digitWidth,
        height: _digitHeight,
        child: ClipRect(
          // Need to add all colors below ClipRect to eliminate anti-aliasign artifacts
          clipBehavior: Clip.antiAlias,
          //
          // Main Digit
          //
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.blue[500], 
                    Colors.blue[800]
                  ]),
            ),
            child: Stack(
              children: [
                //
                // Hole BackFace
                //
                BackFace(),

                Positioned(top: 30.0, left: 30.0, child: InnerBox(dims: dims1)),

                PositionedTransition(
                  rect: relativeRectTween.animate(_controller),
                  child: InnerBox(dims: dims1),
                ),            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
