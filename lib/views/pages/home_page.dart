import 'package:flutter/material.dart';
import 'package:lat_uas/providers/current_user.dart';
import 'package:lat_uas/providers/user_log.dart';
import 'package:lat_uas/services/auth_service.dart';
import 'package:lat_uas/theme/theme_provider.dart';
import 'package:lat_uas/views/pages/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl = 'https://picsum.photos/300/200';

  void refreshImage() {
    setState(() {
      imageUrl =
          'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>().user;
    final logs = context.watch<UserLog>().users;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hwellcomw to Home Page, ${currentUser?.username}"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text("Menu Header")),
              ListTile(
                title: Text("Item 1"),
                leading: Icon(Icons.ac_unit_outlined),
              ),
              ListTile(
                title: Text("Item 2"),
                leading: Icon(Icons.ac_unit_outlined),
              ),
              ListTile(
                title: Text("Item 3"),
                leading: Icon(Icons.ac_unit_outlined),
              ),
              ListTile(
                title: Text("Item 4"),
                leading: Icon(Icons.ac_unit_outlined),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await AuthService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LandingPage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Home Page"),
                    ElevatedButton(onPressed: () {}, child: Text("Home")),

                    // SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AutofillGroup(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "This is a container with 80% of screen height",
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Sample Input',
                                  hintText: "enter something",
                                  border: OutlineInputBorder(),
                                ),
                                autofillHints: [AutofillHints.username],
                              ),
                            ),
                            SizedBox(height: 20),
                            OrientationBuilder(
                              builder: (context, orientation) {
                                if (MediaQuery.of(context).orientation ==
                                    Orientation.portrait) {
                                  return Text("Portrait Mode");
                                } else {
                                  return Text("Landscape Mode");
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black54),
                              ),
                              child: Center(
                                child: Text(
                                  "Styled Container",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: AlignmentGeometry.xy(0, 0),
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  width: 300,
                                  height: 300,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: .2),
                                        Colors.black,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(bottom: 10),
                                  width: 300,
                                  height: 300,
                                  alignment: Alignment(0, 1),
                                  child: Text(
                                    "Hello",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: Column(
                                  children: [
                                    Text("This is a card"),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Card Button"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: logs.length,
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // jangan scroll sendiri
                      itemBuilder: (_, i) {
                        return ListTile(
                          title: Text("User: ${logs[i].username}"),
                        );
                      },
                    ),
                    Image.network(
                      imageUrl,
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,

                      errorBuilder: (c, e, s) => Icon(Icons.broken_image),
                    ),
                    ElevatedButton(
                      onPressed: refreshImage,
                      child: Text("Load Random Image"),
                    ),
                    SizedBox(height: 20),
                    DropdownButton(
                      value: Provider.of<ThemeProvider>(context).mode,
                      items: [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      ],
                      onChanged: (value) async {
                        if (value == 'system') {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setSystemMode();
                        }
                        if (value == 'light') {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setLightMode();
                        }
                        if (value == 'dark') {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setDarkMode();
                        }
                        if (value != null) {
                          SharedPreferences sharedPref =
                              await SharedPreferences.getInstance();
                          sharedPref.setString('mode', value);
                        }
                      },
                    ),

                    Image.asset(
                      'assets/images/kaela.jpeg',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/images/kaela.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ImageIcon(
                      AssetImage('assets/images/kaela.jpeg'),
                      size: 30,
                      // color: Colors.blue,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/kaela.jpeg',
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
