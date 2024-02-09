import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/Messages.dart';
import 'package:tutorhub/Myhomepage.dart';
import 'package:tutorhub/page2.dart';
void main() {
  //User user = User(userType: ); // You need
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: ChatBotApp(user: user)));
  //runApp(ChatBotApp(user: user));
}


class ChatBotApp extends StatelessWidget {
  final User user;
  //final String userType;

  const ChatBotApp({Key? key, required this.user
    //, required this.userType}): super(key: key
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorhub Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: Home(user: user),
    );
  }
}

class Home extends StatefulWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorhub Bot',style: TextStyle(fontWeight: FontWeight.w200,
        fontFamily: 'Salsa',
        color: Colors.white,)),
        backgroundColor: Color(0xff7F9A5B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(user:widget.user)),
            );
          },
        ),
      ),
       body: Opacity(
         opacity: 0.85, // Adjust the opacity value as needed
         child: Container(
           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('images/bg2.jpg'),
               fit: BoxFit.cover,
             ),
           ),
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color:Color(0xffa7b666),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.black),
                      )),
                  IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send,color: Colors.white,))
                ],
              ),
            )
          ],
        ),
      ),
      )
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}