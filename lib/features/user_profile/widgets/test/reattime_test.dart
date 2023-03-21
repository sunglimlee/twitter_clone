import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/providers.dart';

class RealtimeTest extends ConsumerWidget {
  const RealtimeTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'FlAppwrite Realtime Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(databases: ref.watch(appWriteDatabasesProvider)),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  final Databases _database;

  const HomePage({required Databases databases, Key? key})
      : _database = databases,
        super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Map<String, dynamic>> items = [];
  TextEditingController _nameController = TextEditingController();
  RealtimeSubscription? subscription;
  late final Client client;
  final itemsCollection = 'COLLECTION_ID';

  @override
  void initState() {
    super.initState();
    client = Client()
            .setEndpoint('<http://localhost/v1>') // your endpoint
            .setProject('YOUR_PROJECT_ID') //your project id
        ;
    login();
    loadItems();
    subscribe();
  }

  login() async {
    try {
      await Account(client).createAnonymousSession();
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  loadItems() async {
    try {
      final res = await widget._database.listDocuments(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetsCollection);
      setState(() {
        items = List<Map<String, dynamic>>.from(res.documents);
      });
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  void subscribe() {
    final realtime = Realtime(client);

    subscription = realtime.subscribe([
      'collections.<collectionId>.documents'
    ]); //replace <collectionId> with the ID of your items collection, which can be found in your collection's settings page.

    // listen to changes
    subscription!.stream.listen((data) { // listen 하면서 여기서는 계속 체크하면서 메모리 값을 변경하고 setState 를 해준다. ConsumerStateful 이여야 함.
      // data will consist of `event` and a `payload`
      if (data.payload.isNotEmpty) {
        if (data.events.contains("database.document.create")) {
          var item = data.payload;
          items.add(item);
          setState(() {}); // 여기도 결론은 setState 를 이용해서 지금 메모리에 있는 값을 변경하고 있어...
        }
        if (data.events.contains("database.documents.delete")) {
          var item = data.payload;
          items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlAppwrite Realtime Demo'),
      ),
      body: ListView(children: [
        ...items.map((item) => ListTile(
              title: Text(item['name']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await widget._database.deleteDocument(
                    databaseId: AppWriteConstants.databaseId,
                    collectionId: AppWriteConstants.tweetsCollection,
                    documentId: item['\$id'],
                  );
                },
              ),
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // dialog to add new item
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add new item'),
              content: TextField(
                controller: _nameController,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // add new item
                    final name = _nameController.text;
                    if (name.isNotEmpty) {
                      _nameController.clear();
                      _addItem(name);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addItem(String name) async {
    try {
      await widget._database.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: '\$id',
        data: {'name': name},
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any())
        ],
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
