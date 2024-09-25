// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:confetti/confetti.dart';

class MyDrawer extends StatelessWidget {

  const MyDrawer ({
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Drawer(
      backgroundColor: cs.surface,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          SizedBox(
            height: 104,
            child:
              DrawerHeader(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(color: cs.primary),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => {Navigator.of(context).pop()}, 
                      icon: Icon(Icons.arrow_back, color: cs.onPrimary),
                      iconSize: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Settings", style: TextStyle(color: cs.onPrimary, fontSize: 20))
                    )
                  ],
                )
              ),
          ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ExpansionTile(
                  title: Text("Color theme", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: cs.onSurface)),
                  shape: const Border(bottom: BorderSide()),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ColorButton(clr: Colors.deepPurple),
                        const ColorButton(clr: Colors.orange),
                        ColorButton(clr: Colors.blue[900]!),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorButton(clr: Colors.brown),
                          ColorButton(clr: Colors.green),
                          ColorButton(clr: Colors.pink)
                        ],
                                           ),
                     )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () => {SystemChannels.platform.invokeMethod('SystemNavigator.pop')},
                child: const Row(
                  children: [ 
                    Padding(
                      padding: EdgeInsets.only(left: 13.0, right: 8.0, top: 10.0),
                      child: Icon(Icons.exit_to_app_rounded, color: Color.fromARGB(255, 223, 85, 85)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text("Exit app", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 223, 85, 85))),
                    )
                  ]
                ),
              )
            ],
          ),
        
      );
    
  }

}

class ColorButton extends StatelessWidget {
  final Color? clr;

  const ColorButton ({
    super.key,
    required this.clr
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton.filled(
          onPressed: () => {}, 
          color: clr,
          icon: const Icon(Icons.circle),
          style: IconButton.styleFrom(backgroundColor: clr),
        
      ),
    );
  }
}