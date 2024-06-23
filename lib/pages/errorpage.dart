import 'package:flutter/material.dart';


class ErrorPage extends StatefulWidget {
  final bool isLoading;

  ErrorPage({required this.isLoading});

  @override
  State<ErrorPage> createState() => _ErrorState();
}

class _ErrorState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/skyblue.png'),
                fit: BoxFit.cover
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 300,),
              Image(
                image: AssetImage('images/location_pointer.png'),
                width: 100,
                height: 100,
              ),
              Center(
                child: Text('Location not found', style:TextStyle(
                  fontSize: 30,
                  fontFamily: 'Jersey25-Regular',
                )
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0,24,0,0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Retry'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
