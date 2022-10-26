import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:effective_internship/database/database.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// extension HeroEx on Hero {
Future<Hero> fromApi(Map<String, dynamic> data) async {
  final name = data['name'];
  final id = data['id'];
  final description = data['description'];

  print('done1');
  final thumbnailUrl = '${data['thumbnail']!['path']}.jpg';
  final res = await Dio().get(thumbnailUrl, options: Options(responseType: ResponseType.bytes));
  final documentDirectory = await getApplicationDocumentsDirectory();

  final file = File(path.join(documentDirectory.path, '$id.jpg'))
    ..writeAsBytesSync(res.data);
  print('file => ${file.path}');
  return Hero(
      id: id,
      name: name,
      description: description,
      imagePath: file.path,
  );
}
// }

class CharactersRepository extends GetxController {
  static const String _baseUrl =
      'https://gateway.marvel.com:443/v1/public/characters';
  static const String _additionalOptions = '?series=24229&limit=2';
  static const String _publicKey = 'bec75f5786230c12f6c78e7940844074';
  static const String _privateKey = '807ba57856a1230adb113edd3f44924df04168ac';

  MarvelDatabase? md;

  MarvelDatabase get _database {
    return md ??= MarvelDatabase();
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      stderr.writeln('No connection');
      return false;
    }
    return false;
  }


  String _createHash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String _createRequest() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _createHash('$timestamp$_privateKey$_publicKey');
    return '$_baseUrl${_additionalOptions}&ts=$timestamp&apikey=$_publicKey&hash=$hash';
  }

  Future<void> _saveHeroes(Iterable<dynamic> list) async {
    print('saved len => ${list.length}' );
    final heroes = <Hero>[];
    for (var e in list) {
      print(e['id']);
      heroes.add(await fromApi(e));
    }

    print('saved paths => ${heroes.map((e) => e.imagePath)}' );
    await _database.insertHeroes(heroes);
  }

  Future<List<Character>> getCharacters() async {
    if (await _checkConnection()) {
      try {
        final value = await Dio().request(_createRequest());
        final Map<String, dynamic> response = value.data;
        final Iterable characters = response['data']!['results']!;
        await _saveHeroes(characters);

        // return List.from(characters.map((e) => Character.fromJson(e)));
      } catch (error) {
        stderr.writeln(error);
      }
    }
    final response = await _database.getHeroes();
    log('len => ${response.length} ulrs => ${response.map((e) => e.description)}', name: 'hero');
    return response.map(Character.fromDatabase).toList();
  }
}
