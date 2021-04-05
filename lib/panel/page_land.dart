part of 'page_portrait.dart';

class PageLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    height -= MediaQuery.of(context).viewInsets.vertical;
    return SafeArea(
      child: Container(
        color: BACKGROUND_COLOR,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(flex: 1, child: SystemButtonGroup()),
                  Expanded(flex: 4, child: DirectionController())
                ],
              ),
            ),
            _ScreenDecoration(child: Screen.fromHeight(height * 0.8)),
            Expanded(
              child: Center(child: FunctionController()),
            ),
          ],
        ),
      ),
    );
  }
}
