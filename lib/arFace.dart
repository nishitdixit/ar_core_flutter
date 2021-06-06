import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class ARFace extends StatefulWidget {
  const ARFace({Key key}) : super(key: key);

  @override
  _ARFaceState createState() => _ARFaceState();
}

class _ARFaceState extends State<ARFace> {
  ArCoreFaceController arCoreFaceController;
  int selectedIndex = 0;
  List<String> images = [
    'assets/lion.png',
    'assets/tape_g4.png',
    'assets/joker.png',
    'assets/mustache.png',
  ];

  List<String> objectsFileName = [
    'tape3.sfb',
    'tape3.sfb',
    'tape3.sfb',
    'tape3.sfb',
  ];

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    loadMesh();
  }

 Future loadMesh() async {
    final ByteData textureBytes = await rootBundle.load(images[selectedIndex]);

   await arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: objectsFileName[selectedIndex]);
        return;
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('AR faces')),
          body: Stack(
        children: [
          ArCoreFaceView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableAugmentedFaces: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            widthFactor: double.infinity,
            child: Container(
              width: double.infinity,
              height: 120.0,
              padding: EdgeInsets.all(20.0),
              color: Color.fromRGBO(00, 00, 00, 0.7),
              child: buildListViewForImages(),
            ),
          )
        ],
      ),
    );
  }

  ListView buildListViewForImages() {
    return ListView.builder(
      itemCount: images.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
             selectedIndex = index;
            loadMesh().then((value) => setState(() {
             
            }));
            
          },
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Container(
              color: selectedIndex == index ? Colors.red : Colors.transparent,
              padding: selectedIndex == index ? EdgeInsets.all(8.0) : null,
              child: Image.asset(images[index]),
            ),
          ),
        );
      },
    );
  }
}
