import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  Future gettingUserData() async {
    await HelperFunction.getUserNameFromSF().then((value) => setState(() => userName = value!));
    await HelperFunction.getUserEmailFromSF().then((value) => setState(() => email = value!));

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((value) => setState(() => groups = value));
  }

  String getId(String res) => res.substring(0, res.indexOf("_"));

  String getName(String res) => res.substring(res.indexOf("_") + 1);

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]),
                    userName: snapshot.data['fullName']
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: popUpDialog,
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "No te has unido a ningún grupo, toca el ícono Agregar para crear un grupo o también busca desde el botón de búsqueda superior.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  popUpDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
              (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Crear Grupo",
                  textAlign: TextAlign.left,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading == true
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                      onChanged: (val) => setState(() => groupName = val),
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() => _isLoading = true);

                        DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                            .whenComplete(() => _isLoading = false);

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Grupo creado correctamente")));
                      }
                    },
                    child: const Text("Crear"),
                  )
                ],
              );
            }
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Chat Firebase',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Icon(
                Icons.account_circle,
                size: 150,
              ),
            ),
            ListTile(
              title: Text(userName),
            ),
            ListTile(
              title: Text(email),
            ),
            const Divider(),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(

                  userName: userName,
                  email: email,
                )));
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Log out'),
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Seguro que quieres salir?"),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                    (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  }
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: popUpDialog,
        child: const Icon(Icons.add),
      ),
      body: groupList()
    );
  }
}
