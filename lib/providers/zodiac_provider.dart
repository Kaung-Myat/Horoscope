import 'package:flutter/cupertino.dart';
import 'package:zodiac/services/zodiac_service.dart';

import '../models/zodiac.dart';

class ZodiacProvider extends ChangeNotifier{
  final ZodiacService _zodiacService = ZodiacService();
  List<Zodiac> _zodiac = [];
  List<Zodiac> get getZodiac => _zodiac;
  bool isLoading = false;

  ZodiacProvider() {
    _zodiac = [];
  }

  Future<void> getAllZodiacs() async{
    try{
      isLoading = true;
      notifyListeners();

      final response  = await _zodiacService.getZodiacs();
      _zodiac = List.from(response);

      await Future.delayed(const Duration(seconds: 3),(){
        isLoading = false;
        notifyListeners();
      });
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }
}