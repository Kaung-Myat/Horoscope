import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/zodiac.dart';
import '../utils/constants.dart';

class ZodiacService {
  Future<List<Zodiac>> getZodiacs() async {
    String content = await rootBundle.loadString(jsonFilePath);
    List dataList = json.decode(content);

    List<Zodiac> zodiacs = dataList.map((e) {
      return Zodiac(
        id: e["Id"],
        name: e["Name"] ?? '',
        myanmarMonth: e['MyanmarMonth'] ?? '',
        zodiacSignImageUrl: e['ZodiacSignImageUrl'] ?? '',
        zodiacSign2ImageUrl: e['ZodiacSign2ImageUrl'] ?? '',
        dates: e['Dates'] ?? '',
        element: e['Element'] ?? '',
        elementImageUrl: e['ElementImageUrl'] ?? '',
        lifePurpose: e['LifePurpose'] ?? '',
        loyal: e['Loyal'] ?? '',
        representativeFlower: e['RepresentativeFlower'] ?? '',
        angry: e['Angry'] ?? '',
        character: e['Character'] ?? '',
        prettyFeatures: e['PrettyFeatures'] ?? '',
        traits: e["Traits"].map((data){
          return Trait(
              name: data["name"],
              percentage: data["percentage"]
          );
        }).toList(),
      );
    }).toList();

    return zodiacs;
  }
}

// void main() {
//   ZodiacService zs = ZodiacService();
//   zs.getZodiacs().then((data) {
//    print(data.toString());
//   }).catchError((error) {
//     print(error);
//   });
// }
