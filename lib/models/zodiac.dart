class Zodiac {
  int id;
  String name;
  String myanmarMonth;
  String zodiacSignImageUrl;
  String zodiacSign2ImageUrl;
  String dates;
  String element;
  String elementImageUrl;
  String lifePurpose;
  String loyal;
  String representativeFlower;
  String angry;
  String character;
  String prettyFeatures;
  List traits;

  Zodiac({
    required this.id,
    required this.name,
    required this.myanmarMonth,
    required this.zodiacSignImageUrl,
    required this.zodiacSign2ImageUrl,
    required this.dates,
    required this.element,
    required this.elementImageUrl,
    required this.lifePurpose,
    required this.loyal,
    required this.representativeFlower,
    required this.angry,
    required this.character,
    required this.prettyFeatures,
    required this.traits,
  });

  @override
  String toString(){
    return 'Zodiac{'
        'id: $id, '
        'name: $name,'
        'myanmarMonth: $myanmarMonth,'
        'zodiacSignImageUrl: $zodiacSignImageUrl,'
        'zodiacSign2ImageUrl: $zodiacSign2ImageUrl,'
        'dates: $dates,'
        'element: $element,'
        'elementImageUrl: $elementImageUrl,'
        'lifePurpose: $lifePurpose,'
        'loyal: $loyal,'
        'representativeFlower: $representativeFlower,'
        'angry: $angry,'
        'character: $character,'
        'prettyFeatures: $prettyFeatures,'
        'traits : $traits'
        '}';
        // 'traits: $traits';
  }
}

class Trait {
  String name;
  int percentage;

  Trait({
    required this.name,
    required this.percentage,
  });

  // factory Trait.fromJson(Map<String, dynamic> json) => Trait(
  //   name: json["name"],
  //   percentage: json["percentage"],
  // );

  // Map<String, dynamic> toJson() => {
  //   "name": name,
  //   "percentage": percentage,
  // };
}
