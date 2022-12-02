import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:effective_internship/models/marvel/character.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';

@DataClassName('Hero')
class Heroes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get imagePath => text()();

  @override
  Set<Column>? get primaryKey => {id};
}

@DriftDatabase(tables: [Heroes])
class MarvelDatabase extends _$MarvelDatabase {
  MarvelDatabase() : super(_openConnection());

  static MarvelDatabase? _database;

  static MarvelDatabase get instance {
    return _database ??= MarvelDatabase();
  }

  Future<void> insertOrUpdateHeroes(List<Hero> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(heroes, list);
    });
  }

  Future<List<Hero>> getHeroes() async {
    return select(heroes).get();
  }

  Future<Hero> getHero(int id) async {
    return (select(heroes)..where((table) => table.id.equals(id)))
        .getSingle();
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
