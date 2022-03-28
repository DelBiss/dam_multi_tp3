import 'dart:async';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';


class AnimalDB {
  final String name;
  final int nbEntries;
  Database? db;

    AnimalDB({required this.name, this.nbEntries = 100});

    Future<void> openDb() async {
        debugPrint("Open DB $nbEntries for table $name");
        db = await openDatabase(
    
            join(await getDatabasesPath(), 'dev','$name.db'),
            
            onUpgrade: (db, oldVersion, newVersion) async {
                await db.delete(name);
                debugPrint("Generating $nbEntries for table $name");
                Batch batch = db.batch();
                for (int i = 0; i < nbEntries; i++) {
                    batch.insert(name, {'id': i, 'name' : '$name$i', 'age':Random().nextInt(100)}, conflictAlgorithm: ConflictAlgorithm.replace,);
                }
                await batch.commit(noResult: true);
            },
            onCreate: (db, version) async {
                debugPrint("Creating Table");
                await db.execute('CREATE TABLE $name(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
                debugPrint("Generating $nbEntries for table $name");
                Batch batch = db.batch();
                for (int i = 0; i < nbEntries; i++) {
                    batch.insert(name, {'id': i, 'name' : '$name$i', 'age':Random().nextInt(100)}, conflictAlgorithm: ConflictAlgorithm.replace,);
                }
                await batch.commit(noResult: true);
            },
            version: 4,
        );
    }

    Future<List<Animal>> get() async {
        if (db != null){
            final List<Map<String, dynamic>> maps = await db!.query(name);
            return List.generate(
                maps.length,
                (i) {
                    return Animal(
                        id: maps[i]['id'],
                        name: maps[i]['name'],
                        age: maps[i]['age'],
                    );
                }
            );
        }
        return List.empty();   
    }
        
    Future<int> delete(int id) {
        if(db != null){
            return db!.delete(
                name,
                where: 'id = ?',
                whereArgs: [id],
            );
        }
        return Future(()=>-1);
    }
}

class Animal {
  final int id, age;
  final String name;
  const Animal({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  @override
  String toString() {
    return 'Animal{id: $id, name: $name, age: $age}';
  }
}