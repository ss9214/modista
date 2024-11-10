import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// import 'package:image_picker/image_picker.dart';


Map<String, dynamic> signupInfo = {};
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
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//MODISTA DESCRIPTION
class ModistaDesc extends StatefulWidget {
  final String username;

  ModistaDesc({required this.username});

  @override
  _ModistaDescState createState() => _ModistaDescState();
}

class _ModistaDescState extends State<ModistaDesc> {
  dynamic modist;
  
  @override
  // void initState() {
  //   super.initState();
  //   findModist(widget.username);
  // }

  Future<dynamic>findModist(username) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/api/post/modist'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        modist = result["Modist"];
      });
    } else {
      throw Exception('Failed to find modist');
    }
  }
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
                'assets/images/zara_mens_pants.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text("sriharisriva's profile", style: TextStyle(fontSize: 30)),
              Text("Srihari Srivatsa"),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => AIStylist(username: "sriharisriva")),
                    );
                  },
                  child: Text('AI Stylist'), // Move `child` here, outside of `onPressed`
                  ),
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(builder: (ctxt) => MakeAnOrder(username: "sriharisriva")),
                    );
                  }, child: Text('Make an Order'),
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

class MakeAnOrder extends StatelessWidget {
  final TextEditingController textfield = TextEditingController();//budget
  final TextEditingController textfield2 = TextEditingController();//style
  final TextEditingController textfield3 = TextEditingController();
  final String username;

  
  //checkbox
  @override
  MakeAnOrder({required this.username});

  void makeOrder(data) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/post/make-order/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
  }


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
          padding: EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              controller: textfield,
              decoration: InputDecoration(labelText: "How much are you willing to pay?"),
            ),
            TextField(
              controller: textfield2,
              decoration: InputDecoration(labelText: "List your favorite styles"),
            ),
            TextField(
              controller: textfield3,
              decoration: InputDecoration(labelText: "By proceeding, you are consenting to giving us pictures of your wardrobe. Type YES to confirm."),
            ),

              ElevatedButton(
                onPressed: () {
                  if (textfield3.text == "YES") {
  showDialog(
    context: ctxt,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Order Confirmation"),
        content: Text("Your order has been placed. You will receive an email shortly."),
        actions: [
          TextButton(
            onPressed: () {
              makeOrder({"modist":"sriharisriva","muse":"siddishczar","price":textfield.text,"styles":textfield2.text});
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(
                ctxt,
                MaterialPageRoute(builder: (ctxt) => MyHomePage(title: "MODISTA")),
              );
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
                },
                child: Text("Submit Order"),
              ),
            
          ],)
        )
      )
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
              Text("sriharisriva's profile", style: TextStyle(fontSize: 30)),
            ],
          ),
        ),
      ),
    );
  }
}

class GlobalSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'App Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Log out'),
            onTap: () {
              Navigator.push(
                      ctxt,
                      MaterialPageRoute(
                          builder: (ctxt) => MyHomePage(title: 'MODISTA')),
                    );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('My orders'),
            onTap: () {
              Navigator.push(
                      ctxt,
                      MaterialPageRoute(
                          builder: (ctxt) => MyOrders()),
                    );
            },
          )
        ],
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
      drawer: GlobalSidebar(),
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
                              username: 'sriharisriva',
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
                      'By: sriharisriva',
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
                              username: 'sriharisriva',
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
                      'By: sriharisriva',
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

class SignUpEmail extends StatelessWidget {
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
      drawer: GlobalSidebar(),
      body: Center(
        child: Column(
          children: [

            Text("Sign up here"),
            Row(
              children: [
                
              ],
            ),
            Text("Enter your email to proceed"),
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
                    ScaffoldMessenger.of(ctxt).showSnackBar(
                      SnackBar(content: Text('User exists, please go log in')),
                    );
                  } else {
                    signupInfo["email"] = email;
                    ScaffoldMessenger.of(ctxt).showSnackBar(
                      SnackBar(content: Text('User does not exist')),
                    );
                    // Proceed with signup
                    Navigator.push(
                      ctxt,
                      MaterialPageRoute(
                          builder: (ctxt) => MuseOrModistSignUp()),
                    );
                  }
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyOrders extends StatelessWidget {
  @override
  Future<Map<String, dynamic>> getOrders() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/post/get-orders/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"real_name": signupInfo["real_name"]}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Failed to check user existence');
    }
  }

  final real_name = signupInfo["real_name"];
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("$real_name's Orders"),
      ),
      drawer: GlobalSidebar(),
      body: Center(
        child: Column(
          children: [
            Text(''),
            Text('')
          ],
        ),
      ),
    );
  }
}

class MuseOrModistSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Signup Here"),
      ),
      drawer: GlobalSidebar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  signupInfo["user"] = "muse";
                  // Proceed with signup
                  Navigator.push(
                    ctxt,
                    MaterialPageRoute(builder: (ctxt) => SignUpInfo()),
                  );
                },
                child: Text('Muse'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  signupInfo["user"] = "modist";
                  // Proceed with signup
                  Navigator.push(
                    ctxt,
                    MaterialPageRoute(builder: (ctxt) => SignUpInfo()),
                  );
                },
                child: Text('Modist'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpInfo extends StatelessWidget {

  void createUser() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/post/create-user/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(signupInfo),
    );
    if (response.statusCode == 200) {
        // Successfully sent the data
        print('Signup successful');
      } else {
        // Handle errors from the server
        print('Failed to send signup data. Status code: ${response.statusCode}');
      }
  }

  final TextEditingController username = TextEditingController();
  final TextEditingController real_name = TextEditingController();
  final TextEditingController style_categories = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController pinterest = TextEditingController();
  final TextEditingController instagram = TextEditingController();

  // List<XFile>? wardrobeImages;
  // List<XFile>? stylePicsImages;
  // final ImagePicker _picker = ImagePicker();

  // Future<void> _pickWardrobeImages() async {
  //   final List<XFile>? selectedImages = await _picker.pickMultiImage();
  //   if (selectedImages != null) {
  //     setState(() {
  //       wardrobeImages = selectedImages;
  //     });
  //   }
  // }

  // Future<void> _pickStylePicsImages() async {
  //   final List<XFile>? selectedImages = await _picker.pickMultiImage();
  //   if (selectedImages != null) {
  //     setState(() {
  //       stylePicsImages = selectedImages;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Enter your information!"),
      ),
      drawer: GlobalSidebar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              TextField(
                controller: username,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: real_name,
                decoration: InputDecoration(labelText: "Real Name"),
              ),
              
              Column(
                children: [
                  if (signupInfo["user"] != "muse") ...[
                    TextField(
                      controller: style_categories,
                      decoration: InputDecoration(labelText: "Style Categories"),
                    ),
                    TextField(
                      controller: bio,
                      decoration: InputDecoration(labelText: "Bio"),
                    ),
                    TextField(
                      controller: pinterest,
                      decoration: InputDecoration(labelText: "Pinterest"),
                    ),
                    TextField(
                      controller: instagram,
                      decoration: InputDecoration(labelText: "Instagram"),
                    ),
                    SizedBox(height: 10)
                  ],
                  
                    ElevatedButton(onPressed: (){
                    if (signupInfo["user"] == "modist") {
                      signupInfo["username"] = username.text;
                      signupInfo["real_name"] = real_name.text;
                      signupInfo["style_cateogires"] = style_categories.text;
                      signupInfo["bio"] = bio.text;
                      signupInfo["user_info"] = {"pinterest":pinterest.text,"instagram":instagram.text};
                    } else {
                      signupInfo["username"] = username.text;
                      signupInfo["real_name"] = real_name.text;
                    }
                      createUser();
                      Navigator.push(
                        ctxt, 
                        MaterialPageRoute(builder: (ctxt) => MuseHome())
                      );
                    }, child: const Text("All done")
                    ),
                ],
                  // Add any other widgets here that are outside of the conditional block
              )


              // // Wardrobe Images Uploader
              // ElevatedButton(
              //   onPressed: _pickWardrobeImages,
              //   child: Text("Upload Wardrobe Images"),
              // ),
              // wardrobeImages != null
              //     ? Wrap(
              //         spacing: 10,
              //         children: wardrobeImages!.map((file) {
              //           return Image.file(File(file.path),
              //               width: 100, height: 100);
              //         }).toList(),
              //       )
              //     : Text("No wardrobe images selected"),

              // SizedBox(height: 10),


              // // Style Pics Images Uploader

              // ElevatedButton(
              //   onPressed: _pickStylePicsImages,
              //   child: Text("Upload Style Pics Images"),
              // ),
              // stylePicsImages != null
              //     ? Wrap(
              //         spacing: 10,
              //         children: stylePicsImages!.map((file) {
              //           return Image.file(File(file.path),
              //               width: 100, height: 100);
              //         }).toList(),
              //       )
            ],  //     : Text("No style pics images selected"),
          ),
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
                      MaterialPageRoute(builder: (context) => SignUpEmail()),
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
