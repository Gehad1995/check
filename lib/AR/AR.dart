import 'package:alqgp/consts.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/src/material/colors.dart';

class AR extends StatefulWidget {
  final int chaptNum;
  const AR({super.key, required this.chaptNum});

  @override
  State<AR> createState() => _ARState(chaptNum);
}

class _ARState extends State<AR> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;
  int chapnum = 0;
  _ARState(int chapterNum) {
    chapnum = chapterNum;
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'AR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8EA3E2),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ARView(
                  onARViewCreated: onARViewCreated,
                ),
              ),
            ),
            Row(
              children: [
                // Expanded(
                //   child: ElevatedButton(
                //       onPressed: () => onLocalObjectButtonPressed(),
                //       child:  Text("Add / Remove Local Object")),
                // ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(155, 165, 71, 197)),
                      onPressed: () => onWebObjectAtButtonPressed(chapnum),
                      child: Text("Add / Remove the object")),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "images/Beatingheart.glb",
          showWorldOrigin: true,
          handleTaps: false,
        );
    this.arObjectManager.onInitialize();
  }

  // Future<void> onLocalObjectButtonPressed() async {
  //   if (localObjectNode != null) {
  //     arObjectManager.removeNode(localObjectNode!);
  //     localObjectNode = null;
  //   } else {
  //     var newNode = ARNode(
  //         type: NodeType.localGLTF2,
  //         uri: "images/heart.glb",
  //         scale: Vector3(0.2, 0.2, 0.2),
  //         position: Vector3(0.0, 0.0, 0.0),
  //         rotation: Vector4(1.0, 0.0, 0.0, 0.0));
  //     bool? didAddLocalNode = await arObjectManager.addNode(newNode);
  //     localObjectNode = (didAddLocalNode!) ? newNode : null;
  //   }
  // }

  Future<void> onWebObjectAtButtonPressed(int name) async {
    String urlLink = '';
    switch (name) {
      case 1:
        urlLink =
            "https://github.com/Gehad1995/2022-GP1-Group23/raw/main/images/circulatory_system.glb";
        break;
      case 2:
        urlLink =
            "https://github.com/Gehad1995/2022-GP1-Group23/raw/main/images/diaphragm_non-commercial.glb";
        break;
      case 3:
        urlLink =
            "https://github.com/Gehad1995/2022-GP1-Group23/raw/main/images/disgestive_system.glb";
        break;
      case 4:
        urlLink =
            "https://github.com/Gehad1995/2022-GP1-Group23/raw/main/images/urinary_system_final.glb";
        break;
      case 5:
        urlLink =
            "https://github.com/Gehad1995/2022-GP1-Group23/raw/main/images/male_full_body_ecorche.glb";
        break;
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode =
          ARNode(type: NodeType.webGLB, uri: urlLink, scale: Vector3(1, 1, 1));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}
