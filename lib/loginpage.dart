import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  double height=0;
  double width=0;
  int _pageState=0;
  Color _backgroundColor=Colors.white;
  Color _textColor=Colors.black;
  double _loginYOffset=0;
  bool _keyboardVisible=false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        _keyboardVisible=visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    switch(_pageState){
      case 0:
        _backgroundColor=Colors.white;
        _textColor=Colors.black;
        _loginYOffset=height;
        break;
      case 1:
        _backgroundColor=Color(0xFFD34D5B);
        _textColor=Colors.white;
        _loginYOffset=_keyboardVisible?height/6:height/3;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    _pageState=0;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                child: AnimatedContainer(
                  color: _backgroundColor,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(
                    milliseconds: 800,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width/50,vertical: height/50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height/15),
                        child: CircleAvatar(
                          radius: width/10,
                          backgroundImage: AssetImage('images/Avatar.jpg'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height/15),
                        child: Text(
                          "Hello, There",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textColor,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.bold,
                            fontSize: height/30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('images/Fill.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _pageState=1;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width/30),
                          decoration: BoxDecoration(
                            color: Color(0xFFB40284A),
                            borderRadius: BorderRadius.circular(width/10),
                          ),
                          child: Center(
                            child: Text(
                                'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "WorkSans",
                                fontSize: height/40,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(
                  milliseconds: 1000
                ),
                transform: Matrix4.translationValues(0, _loginYOffset, 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  )
                ),
                child: LoginDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LoginDetails extends StatefulWidget {
  @override
  _LoginDetailsState createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {

  double height=0;
  double width=0;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width/30,vertical: height/10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerLeft,
              height: 90,
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                controller: usernameController,
                validator: (val){
                  if(val.isEmpty){
                    return 'Username should not be empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    FontAwesomeIcons.ghost,
                    color: Colors.grey,
                  ),
                  hintText: 'Username',
                  hintStyle: kHintTextStyle,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextFormField(
                controller: passwordController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                validator: (val){
                  if(val.isEmpty){
                    return 'Password should not be empty';
                  }
                  return null;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: 'Password',
                  hintStyle: kHintTextStyle,
                ),
              ),
            ),
            SizedBox(
              height: height/20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              width: double.infinity,
              child: RaisedButton(
                elevation: 5.0,
                onPressed: ()async{
                  if(_formKey.currentState.validate()){
                    String username = usernameController.text;
                    String password = passwordController.text;
                    print(password);
                    print('Successful');
                    SharedPreferences preferences=await SharedPreferences.getInstance();
                    preferences.setString('username', username);
                    Navigator.pushReplacementNamed(context,'/create');
                  }
                  },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xFFB40284A),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
