import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:effective_internship/constants/config.dart';
import 'package:effective_internship/database/database.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CharactersRepository extends GetxController {
  static const String _additionalOptions = '?series=24229&limit=10';

  MarvelDatabase get _database {
    return MarvelDatabase.instance;
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

  Future<Hero> _fromApi(Map<String, dynamic> data) async {
    final name = data['name'];
    final id = data['id'];
    final description = data['description'];

    final thumbnailUrl = '${data['thumbnail']!['path']}.jpg';
    final res = await Dio()
        .get(thumbnailUrl, options: Options(responseType: ResponseType.bytes));
    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(path.join(documentDirectory.path, '$id.jpg'))
      ..writeAsBytesSync(res.data);
    return Hero(
      id: id,
      name: name,
      description: description,
      imagePath: file.path,
    );
  }

  String _createHash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String _createRequest() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final str = '$timestamp${Config.privateKey}${Config.publicKey}';
    final hash = _createHash(str);
    return '${Config.baseUrl}$_additionalOptions&ts=$timestamp&apikey=${Config.publicKey}&hash=$hash';
  }

  Future<void> _saveHeroes(Iterable<dynamic> list) async {
    final heroes = <Hero>[];
    for (final hero in list) {
      heroes.add(await _fromApi(hero));
    }
    await _database.insertOrUpdateHeroes(heroes);
  }

  Future<List<Character>> getCharacters({bool needUpdate = true}) async {
    if (needUpdate && await _checkConnection()) {
      try {
        final value = await Dio().request(_createRequest());
        final Map<String, dynamic> response = value.data;
        final Iterable characters = response['data']!['results']!;
        await _saveHeroes(characters);
      } catch (error) {
        stderr.writeln(error);
      }
    }
    final response = await _database.getHeroes();
    return response.map(Character.fromDatabase).toList();
  }
}
