import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:get/state_manager.dart';

class CharactersRepository extends GetxController {

  static const String _baseUrl = 'https://gateway.marvel.com:443/v1/public/characters';
  static const String _additionalOptions = '?series=24229';
  static const String _publicKey = 'bec75f5786230c12f6c78e7940844074';
  static const String _privateKey = '807ba57856a1230adb113edd3f44924df04168ac';

  String _createHash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String _createRequest() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _createHash('$timestamp$_privateKey$_publicKey');
    return '$_baseUrl${_additionalOptions}&ts=$timestamp&apikey=$_publicKey&hash=$hash';

  }

  Future<List<Character>> getCharacters() {
    return Dio().request(_createRequest()).then(
      (value) {
        final Map<String, dynamic> response = value.data;
        final Iterable characters = response['data']!['results']!;
        return List.from(characters.map((e) => Character.fromJson(e)));
      },
      onError: (err, a) {
        // print()
        print((err as DioError).response);
        return [];
      },
    );
  }

}
