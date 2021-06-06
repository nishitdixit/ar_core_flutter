import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ARObject extends StatefulWidget {
  const ARObject({Key key}) : super(key: key);

  @override
  _ARObjectState createState() => _ARObjectState();
}

class _ARObjectState extends State<ARObject> {
  ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Augment Reality')),
          body: ArCoreView(
      onArCoreViewCreated: onArCoreViewCreated,
      enableTapRecognizer: true,
    ));
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('remove object?'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                arCoreController.removeNode(nodeName: name);
                Navigator.pop(context);
              }), IconButton(
              icon: Icon(
                Icons.cancel,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final plane = hits.first;
    final objectNode = ArCoreReferenceNode(
        name: 'object',
        object3DFileName: 'barrel.sfb',
        position: plane.pose.translation,
        rotation: plane.pose.rotation);
    arCoreController.addArCoreNodeWithAnchor(objectNode);
  }
}
