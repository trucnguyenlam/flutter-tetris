import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:tetris/gamer/gamer.dart';

class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(child: LeftController()),
          Expanded(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))),
              ),
              Expanded(flex: 6, child: FunctionController()),
            ],
          )),
        ],
      ),
    );
  }
}

const Size _DIRECTION_BUTTON_SIZE = const Size(48, 48);

const Size _SYSTEM_BUTTON_SIZE = const Size(28, 28);

class FunctionController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AlignPositioned(
          dx: _DIRECTION_BUTTON_SIZE.width / 1.4,
          dy: -_DIRECTION_BUTTON_SIZE.height / 3,
          child: _Button(
              enableLongPress: false,
              icon: Icon(Icons.rotate_right),
              size: _DIRECTION_BUTTON_SIZE,
              onTap: () {
                Game.of(context)?.rotate();
              }),
        ),
        AlignPositioned(
          dx: -_DIRECTION_BUTTON_SIZE.width / 1.4,
          dy: _DIRECTION_BUTTON_SIZE.height / 3,
          child: _Button(
              enableLongPress: false,
              icon: Icon(Icons.arrow_downward_sharp),
              size: _DIRECTION_BUTTON_SIZE,
              onTap: () {
                Game.of(context)?.drop();
              }),
        ),
      ],
    );
  }
}

class SystemButtonGroup extends StatelessWidget {
  static const _systemButtonColor = const Color(0xFF2dc421);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _Button(
            size: _SYSTEM_BUTTON_SIZE,
            icon: (true == GameState.of(context)?.muted) ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
            color: _systemButtonColor,
            enableLongPress: false,
            onTap: () => Game.of(context)?.soundSwitch()),
        _Button(
            size: _SYSTEM_BUTTON_SIZE,
            icon: GameStates.paused == GameState.of(context)?.states ? Icon(Icons.play_arrow_sharp) : Icon(Icons.pause),
            color: _systemButtonColor,
            enableLongPress: false,
            onTap: () => Game.of(context)?.pauseOrResume()),
        _Button(
            size: _SYSTEM_BUTTON_SIZE,
            icon: Icon(Icons.refresh_sharp),
            enableLongPress: false,
            color: Colors.red,
            onTap: () => Game.of(context)?.reset()),
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Description(
      text: 'drop',
      child: _Button(
        enableLongPress: false,
        size: Size(90, 90),
        onTap: () => Game.of(context)?.drop(),
      ),
    );
  }
}

class LeftController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: SystemButtonGroup()),
        Expanded(
          flex: 6,
          child: DirectionController(),
        ),
      ],
    );
  }
}

class DirectionController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AlignPositioned(
          dx: -_DIRECTION_BUTTON_SIZE.width,
          dy: -_DIRECTION_BUTTON_SIZE.height / 2,
          child: _Button(
              size: _DIRECTION_BUTTON_SIZE,
              icon: Transform.scale(
                scale: 1.5,
                child: Icon(Icons.chevron_left),
              ),
              onTap: () {
                Game.of(context)?.left();
              }),
        ),
        AlignPositioned(
          dx: _DIRECTION_BUTTON_SIZE.width,
          dy: -_DIRECTION_BUTTON_SIZE.height / 2,
          child: _Button(
              size: _DIRECTION_BUTTON_SIZE,
              icon: Transform.scale(
                scale: 1.5,
                child: Icon(Icons.chevron_right),
              ),
              onTap: () {
                Game.of(context)?.right();
              }),
        ),
        AlignPositioned(
          dy: _DIRECTION_BUTTON_SIZE.height / 1.5,
          child: _Button(
            size: _DIRECTION_BUTTON_SIZE,
            icon: Transform.scale(
              scale: 1.5,
              child: Icon(Icons.keyboard_arrow_down_sharp),
            ),
            onTap: () {
              Game.of(context)?.down();
            },
          ),
        ),
      ],
    );
  }
}

class _Button extends StatefulWidget {
  final Size size;
  final Widget? icon;

  final VoidCallback onTap;

  ///the color of button
  final Color color;

  final bool enableLongPress;

  const _Button({
    Key? key,
    required this.size,
    required this.onTap,
    this.icon,
    this.color = Colors.blue,
    this.enableLongPress = true,
  }) : super(key: key);

  @override
  _ButtonState createState() {
    return _ButtonState();
  }
}

///show a hint text for child widget
class _Description extends StatelessWidget {
  final String text;

  final Widget child;

  final AxisDirection direction;

  const _Description({
    Key? key,
    required this.text,
    this.direction = AxisDirection.down,
    required this.child,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (direction) {
      case AxisDirection.right:
        widget = Row(mainAxisSize: MainAxisSize.min, children: <Widget>[child, SizedBox(width: 8), Text(text)]);
        break;
      case AxisDirection.left:
        widget = Row(
          children: <Widget>[Text(text), SizedBox(width: 8), child],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case AxisDirection.up:
        widget = Column(
          children: <Widget>[Text(text), SizedBox(height: 8), child],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case AxisDirection.down:
        widget = Column(
          children: <Widget>[child, SizedBox(height: 8), Text(text)],
          mainAxisSize: MainAxisSize.min,
        );
        break;
    }
    return DefaultTextStyle(
      child: widget,
      style: TextStyle(fontSize: 12, color: Colors.black),
    );
  }
}

class _ButtonState extends State<_Button> {
  Timer? _timer;

  bool _tapEnded = false;

  Color? _color;

  @override
  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = widget.color;
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      elevation: 2,
      shape: CircleBorder(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) async {
          if (mounted)
            setState(() {
              _color = widget.color.withOpacity(0.5);
            });
          if (_timer != null) {
            return;
          }
          _tapEnded = false;
          widget.onTap();
          if (!widget.enableLongPress) {
            return;
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (_tapEnded) {
            return;
          }
          _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
            if (!_tapEnded) {
              widget.onTap();
            } else {
              t.cancel();
              _timer = null;
            }
          });
        },
        onTapCancel: () {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          if (mounted)
            setState(() {
              _color = widget.color;
            });
        },
        onTapUp: (_) {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          if (mounted)
            setState(() {
              _color = widget.color;
            });
        },
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          margin: EdgeInsets.zero,
          child: widget.icon,
        ),
      ),
    );
  }
}
