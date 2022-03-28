
import 'package:flutter/material.dart';
import 'media_input_route.dart';
import 'db_animal.dart';

class ListRoute extends StatelessWidget {
  const ListRoute({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    var nextRoute = MaterialPageRoute(
                builder: (context) => const MediaInputRoute()
              );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Liste Déroulante"),
          bottom: const TabBar(tabs: [
             Padding(padding: EdgeInsets.all(8.0),child: Icon(Icons.pets),),
             Padding(padding: EdgeInsets.all(8.0),child: Icon(Icons.cruelty_free),
             ),
          ]),
        ),
        body: const TabBarView(
          children: [SQLList(dbName: "Fido"),SQLList(dbName: "Fuzzy"),]),
        floatingActionButton: FloatingActionButton(
          onPressed:  ()=>{Navigator.push(context,nextRoute)},
          child: const Icon(Icons.next_plan),
        ),
      ),
    );

  }
}

class SQLList extends StatefulWidget {
  const SQLList({
    Key? key,
    required this.dbName,
  }) : super(key: key);

  final String dbName;

  @override
  State<SQLList> createState() => _SQLListState();
}

class _SQLListState extends State<SQLList> {
  late AnimalDB sqlDB;
  List<Animal> entries = List.empty();

  @override
  void initState() {
    super.initState();
    sqlDB = AnimalDB(name: widget.dbName);
    loadData();
  }

  Future<void> loadData() async {
    await sqlDB.openDb();
    await refreshData();
  }

  Future<void> refreshData() async {
    List<Animal> _entries = await sqlDB.get();
    setState(() {
      entries = _entries;
    });  
  }
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              var nbDeleted = await sqlDB.delete(entries[index].id);
              debugPrint("Deleted $nbDeleted");
              refreshData();
            },
          ),
          title:  Text('${entries[index]}'),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}