import 'package:flutter/material.dart';
import 'package:lat_uas/models/user.dart';
import 'package:lat_uas/providers/current_user.dart';
import 'package:lat_uas/providers/user_log.dart';
import 'package:lat_uas/services/auth_service.dart';
import 'package:lat_uas/theme/theme.dart';
import 'package:lat_uas/theme/theme_provider.dart';
import 'package:lat_uas/views/pages/landing_page.dart';
import 'package:lat_uas/views/widget_tree.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final User? user = await AuthService.currentLoggedInUser();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUser(user: user)),
        ChangeNotifierProvider(create: (_) => UserLog()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider(create: (_) => CurrentUser()),
        // ChangeNotifierProvider(create: (_) => UserLog()),
      ],
      child: MyApp(initialUser: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? initialUser;
  const MyApp({super.key, this.initialUser});

  // This widget is the root of your application.
  @override
  void getThemeMode(context) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? mode = sharedPref.getString('mode');
    if (mode == 'system') {
      Provider.of<ThemeProvider>(context, listen: false).setSystemMode();
    }
    if (mode == 'light') {
      Provider.of<ThemeProvider>(context, listen: false).setLightMode();
    }
    if (mode == 'dark') {
      Provider.of<ThemeProvider>(context, listen: false).setDarkMode();
    }
  }

  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final ThemeMode themeMode = themeProvider.mode == 'light'
        ? ThemeMode.light
        : themeProvider.mode == 'dark'
        ? ThemeMode.dark
        : themeProvider.mode == 'system'
        ? ThemeMode.system
        : ThemeMode.system;

    return MaterialApp(
      title: 'Flutter Demo',

      // initialRoute: initialUser == null ? '/' : '/home',
      // routes: {
      //   '/': (context) => LandingPage(),
      //   // '/login': (context) => LoginPage(),
      //   // '/register': (context) => RegisterPage(),
      //   // '/profile': (context) => ProfilePage(),
      //   '/home': (context) => WidgetTree(),
      // },
      debugShowCheckedModeBanner: false,
      theme: themeMode == ThemeMode.light ? lightMode : darkMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: initialUser == null ? LandingPage() : WidgetTree(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
