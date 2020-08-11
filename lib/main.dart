import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './util.dart' as util;

void main() {
  runApp(new MaterialApp(
    title: "Weather app",
    home: new Home(),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



//front end starting

class _HomeState extends State<Home> {
String cityentered;
Future _gotonext(BuildContext context) async {
   Map results =await Navigator
       .of(context)
       .push(
     new MaterialPageRoute(
         builder: (BuildContext context){
       return new changecity();
     }
     )
   );
if(results !=null && results.containsKey('enter')){
  setState(() {
    cityentered=results['enter'];
  });

}
}



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: new Text("Weather",
        style:new TextStyle(
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.w400
        )),
        actions: <Widget>[
          IconButton(icon: new Icon(Icons.menu), onPressed: () {_gotonext(context); })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
          child: new Image.asset("images/umbrella.png",
          width: 490,
         height: 1200,
          fit: BoxFit.fill,
          ),
        ),
          new Container(
              margin: const EdgeInsets.fromLTRB(300.0,10.9,0.0,0.0),
            child: new Text('${cityentered == null ? util.defaultcity : cityentered}',
            style: new TextStyle(
              fontSize: 23.0,
              color: Colors.white70,
            ),),
      ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
//          new Container(

            updatewidget(cityentered)

  ],
      ),
    );

  }
Future <Map> getweather(String appId,String city) async{
  String url ='http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric';

  http.Response response= await http.get(url);

  return json.decode(response.body);

}
Widget updatewidget(String city) {
  return new FutureBuilder(
    future: getweather(util.appId, city==null ? util.defaultcity : city) ,
    builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
      if(snapshot.hasData){
        Map content=snapshot.data;
        return new Container(

          margin: const EdgeInsets.fromLTRB(26.0, 200.0, 0.0, 0.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ListTile(
                title: new Text(
                  content['main']['temp'].toString()+' C',
                  style: new TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                  ),
                ),
                subtitle: new ListTile(
                  title: new Text(
                    'Min:${content['main']['temp_min'].toString()} C\n'
                    'Max:${content['main']['temp_max'].toString()} C\n',
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white60

                    ),

                  ),
                ),
              )
            ],
          ),
        );
      }else{
        return Container();
      }
    }
  );}
}//front end ending


class changecity extends StatelessWidget {
var cityenteredcontroller =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("Change City"),
        centerTitle: true,
      ),
      body:new Stack(
     children:<Widget>[ new ListView(
        children: <Widget>[
          new Image.asset('images/white_snow.png',
          width: 490.0,
          height:650.0,
          fit: BoxFit.fill,)

        ],
      ),
       new ListView(
         children: <Widget>[
           new ListTile(
             title: new TextField(
               decoration: new InputDecoration(
                hintText: 'Enter City'
               ),
               controller: cityenteredcontroller,
               keyboardType: TextInputType.text,
             ),
           ),
           new ListTile(
             title: new FlatButton(
               
                 onPressed: () {
Navigator.pop(context,{
  'enter':cityenteredcontroller.text
});
                 },
               child: new Text("ENTERED",),
             textColor: Colors.white,
               color: Colors.redAccent,
             ),
           )
         ],
       )
     ],
      ),
    );
  }
}



