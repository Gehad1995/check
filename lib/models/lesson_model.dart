import 'package:alqgp/models/part_model.dart';

class LessonModle {
  String? name;
  bool BookmarkValus;
  // Map<dynamic, dynamic>? parts;
  // LessonModle();
  // Map<String, dynamic> toJson() => {'title': title, 'description': des, 'modle': modle};
//   LessonModle.fromSnapshot(snapshot)
//       : name = snapshot.data()['name'],
//         parts = snapshot.data()['parts'];
// }

  List<PartModel>? parts;
  LessonModle({this.name, this.parts, required this.BookmarkValus});

  // receiving data from server
  factory LessonModle.fromMap(Map<String, dynamic> map) {
    List<PartModel> partList = [];
    int count = 1;
    while (true) {
      if (map.containsKey('part$count')) {
        partList.add(PartModel.fromMap(map['part$count']));
        count++;
      } else {
        break;
      }
    }


//  // sending data to our server
//   Map<String, dynamic> toMap() {
//     return {
//       'BookmarkValu': BookmarkValus,
      
//     };
//   }
    return LessonModle(
      name: map['name'],
      parts: partList,
      BookmarkValus: map['BookmarkValu'],
    );
  }
}
