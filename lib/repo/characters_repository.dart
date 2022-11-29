import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:effective_internship/constants/config.dart';
import 'package:effective_internship/database/database.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:get/state_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class _HashTimestamp {
  const _HashTimestamp({
    required this.hash,
    required this.timestamp,
  });

  final String hash;
  final String timestamp;

}

class CharactersRepository extends GetxController {
  static const String _additionalOptions = 'limit=5';

  MarvelDatabase get _database {
    return MarvelDatabase.instance;
  }

  static const _notAvailableImagePath = 'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg';

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
    late final Response<dynamic> res;
    try {
      res = await Dio()
          .get(thumbnailUrl, options: Options(responseType: ResponseType.bytes));
    } on DioError catch (ex, s) {
      res = await Dio().get(_notAvailableImagePath, options: Options(responseType: ResponseType.bytes));
    }
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

  _HashTimestamp _createHash() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final str = '$timestamp${Config.privateKey}${Config.publicKey}';
    return _HashTimestamp(
      hash: md5.convert(utf8.encode(str)).toString(),
      timestamp: timestamp
    );
  }

  String _createRequest() {
    final hash = _createHash();
    return '${Config.baseUrl}?$_additionalOptions&ts=${hash.timestamp}&apikey=${Config.publicKey}&hash=${hash.hash}';
  }

  String _createByIdRequest({required int id}) {
    final hash = _createHash();
    return '${Config.baseUrl}/$id?ts=${hash.timestamp}&apikey=${Config.publicKey}&hash=${hash.hash}';
  }

  String _createFetchRequest(int offset) {
    final hash = _createHash();
    return '${Config.baseUrl}?$_additionalOptions&offset=$offset&ts=${hash.timestamp}&apikey=${Config.publicKey}&hash=${hash.hash}';
  }


  Future<List<Character>> _saveHeroes(Iterable<dynamic> list) async {
    final heroes = <Hero>[];
    for (final hero in list) {
      heroes.add(await _fromApi(hero));
    }
    await _database.insertOrUpdateHeroes(heroes);
    return heroes.map(Character.fromDatabase).toList();
  }

  Future<List<Character>> fetchCharacters(int offset) async {
    try {
      final value = await Dio().request(_createFetchRequest(offset));
      final Map<String, dynamic> response = value.data;
      final Iterable characters = (response['data'] as Map<String, dynamic>)['results']!;
      return _saveHeroes(characters);
    } on DioError catch(ex) {
      print(ex.response);
    }
    return [];
  }

  Future<List<Character>> getCharacters({bool needUpdate = true}) async {
    if (needUpdate && await _checkConnection()) {
      try {
        final value = await Dio().request(_createRequest());
        final Map<String, dynamic> response = value.data;
        final Iterable characters = response['data']!['results']!;
        return await _saveHeroes(characters);
      } catch (error) {
        stderr.writeln(error);
      }
    }
    final response = await _database.getHeroes();
    return response.map(Character.fromDatabase).toList();
  }

  Future<Character> getCharacter({required int id}) async {
    if (await _checkConnection()) {
      try {
        final value = await Dio().request(_createByIdRequest(id: id));
        final Map<String, dynamic> responce = value.data;
        final Iterable chars = responce['data']!['results']!;
        await _saveHeroes(chars);
      } catch (error) {
        stderr.writeln(error);
      }
    }
    final response = await _database.getHero(id);
    return Character.fromDatabase(response);
  }


}
