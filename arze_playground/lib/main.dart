import 'package:flutter/material.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      navigatorObservers: [routeObserver],
      routes: {
        '/': (context) => Screen1(),
        'screen2': (context) => Screen2(),
      },
    );
  }
}

class ScreenWrapper extends StatefulWidget {
  final Widget child;
  final Function() onLeaveScreen;
  final String routeName;
  ScreenWrapper({this.child, this.onLeaveScreen, @required this.routeName});

  @override
  State<StatefulWidget> createState() {
    return ScreenWrapperState();
  }
}

class ScreenWrapperState extends State<ScreenWrapper> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onLeaveScreen() {
    if (widget.onLeaveScreen != null) {
      widget.onLeaveScreen();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    App.routeObserver.unsubscribe(this);
  }

  @override
  void didPush() {
    print('*** Entering screen: ${widget.routeName}');
  }

  void didPushNext() {
    print('*** Leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPop() {
    print('*** Going back, leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPopNext() {
    print('*** Going back to screen: ${widget.routeName}');
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      onLeaveScreen: () {
        print("***** Here's my special handling for leaving screen1!!");
      },
      routeName: '/',
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: SafeArea(
          child: Column(
            children: [
              Text('This is Screen1'),
              FlatButton(
                child: Text('Press here to go to screen 2'),
                onPressed: () {
                  Navigator.pushNamed(context, 'screen2');
                },
              ),
              FlatButton(
                child: Text(
                    "Press here to go back (only works if you've pushed before)"),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      routeName: 'screen2',
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              Text('This is Screen2'),
              FlatButton(
                child: Text('Press here to go to screen 1'),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              FlatButton(
                child: Text(
                    "Press here to go back (only works if you've pushed before)"),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
