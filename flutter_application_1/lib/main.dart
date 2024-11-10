import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MODISTA',
      theme: ThemeData(
        // This is the theme of your application.
        // test
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 241, 228, 189)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MODISTA'),
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

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Future<Map<String, dynamic>> checkUser(email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/post/check-user/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return {
        "userExists": result['data'],
        "userName": result['user'],
      };
    } else {
      throw Exception('Failed to check user existence');
    }
  }

  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("MODISTA", 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Login Here"),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  Map<String, dynamic> response = await checkUser(email);
                  bool userExists = response['userExists'];
                  if (userExists) {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => MuseHome()),
                    );
                  } else {
                    ScaffoldMessenger.of(ctxt).showSnackBar(
                      SnackBar(
                          content: Text('User does not exist, go to signup')),
                    );
                    // Proceed with signup
                  }
                },
                child: Text('Check if User Exists'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//MODISTA DESCRIPTION
class ModistaDesc extends StatelessWidget {
  final String username;

  ModistaDesc({required this.username});

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MODISTA", 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text("MODISTA"),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/zara_leather_jacket.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/nfp_blue.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text('$username\'s profile', style: TextStyle(fontSize: 30)),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => AIStylist(username: username)),
                    );
                  },
                  child: Text('AI Stylist'), // Move `child` here, outside of `onPressed`
                  ),
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => AIStylist(username: username)),
                    );
                  }, child: Text('Personal Stylist'),
                  ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AIStylist extends StatelessWidget {
  final String username;

  AIStylist({required this.username});

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MODISTA", 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text("Have the AI Style your wardrobe."),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/zara_leather_jacket.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/nfp_blue.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text('$username\'s profile', style: TextStyle(fontSize: 30)),
            ],
          ),
        ),
      ),
    );
  }
}




class MuseHome extends StatefulWidget {
  @override
  _MuseHomeState createState() => _MuseHomeState();
}

class _MuseHomeState extends State<MuseHome> {
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MODISTA", 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Modistas:"),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                height: 677,
                child: ListView(
                  children: [
                    // First item in the horizontal list
                    GestureDetector(
                      onTap: () {
                        // Navigate to ModistaDesc screen when tapped
                        Navigator.push(
                          ctxt,
                          MaterialPageRoute(
                            builder: (ctxt) => ModistaDesc(
                              // You can pass any data you need to ModistaDesc here
                              username: 'usr345689',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 248, 248, 248),
                          border: Border.all(
                            color: Colors.black,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/zara_leather_jacket.png',
                              width: 150,
                              height: 150,
                            ),
                            Image.asset(
                              'assets/images/zara_mens_pants.png',
                              width: 150,
                              height: 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'By: usr345689',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 45, 40, 40),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to ModistaDesc screen when tapped
                        Navigator.push(
                          ctxt,
                          MaterialPageRoute(
                            builder: (ctxt) => ModistaDesc(
                              username: 'usr57899',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 248, 248, 248),
                          border: Border.all(
                            color: Colors.black,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/nfp_blue.png',
                              width: 150,
                              height: 150,
                            ),
                            Image.asset(
                              'assets/images/ab_jeans.png',
                              width: 150,
                              height: 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'By: usr57899',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 45, 40, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SignUpScreen extends StatelessWidget {
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("MODISTA", 
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Sign up here"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fname,
                    decoration: InputDecoration(labelText: "First Name"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: lname,
                    decoration: InputDecoration(labelText: "Surname"),
                  ),
                ),
              ],
            ),
            Spacer(),
            //Text($fname $lname),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => MuseHome()),
                    );
                  },
                  child: const Text("Signup")),
            ),
          ],
        ),
      ),
    );
  }
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
        title: Text("MODISTA"),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                ":/ Your computer has restarted due to an error",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text("Login")),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text("Sign Up")),
            ),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
