import 'package:appautosfirebase/models/Auto.dart';
import 'package:appautosfirebase/services/autos_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vm_service/vm_service.dart';

class Data {
  int data = 0;

  Data(this.data);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerAutos()))
                  },
                  child: const Text("Ver autos"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const crearAuto()))
                  },
                  child: const Text("Registrar autos"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EliminarAuto()))
                  },
                  child: const Text("Eliminar autos"),
                ),
              ),
            ],
          ),
        ));
  }
}

class VerAutos extends StatelessWidget {
  const VerAutos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista autos"),
      ),
      body: FutureBuilder<List<Auto>>(
        future: getAllAutos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            print(snapshot);
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data?.length,
                itemBuilder: ((context, index) {
                  var idx = snapshot.data?[index].Id ?? 0;
                  final data = Data(idx);
                  return Card(
                    child: ListTile(
                      title: Text("${snapshot.data?[index].marca}"),
                      subtitle: Text(
                          "Color: ${snapshot.data?[index].color}, Precio: \$${snapshot.data?[index].precio}"),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => EditarAuto(data: data))));
                      },
                    ),
                  );
                }));
          } else
            return const Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

class EditarAuto extends StatefulWidget {
  final Data data;
  const EditarAuto({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _EditarAutoState();
}

class _EditarAutoState extends State<EditarAuto> {
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final precioController = TextEditingController();
  final colorController = TextEditingController();
  final matriculaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar Auto"),
        ),
        body: FutureBuilder<Auto>(
          future: getAuto(widget.data.data),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error");
              }
            }
            marcaController.text = snapshot.data?.marca ?? "";
            modeloController.text = snapshot.data?.modelo ?? "";
            precioController.text = snapshot.data?.precio.toString() ?? "";
            matriculaController.text = snapshot.data?.matricula ?? "";
            colorController.text = snapshot.data?.color ?? "";

            return ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: marcaController,
                      decoration: const InputDecoration(labelText: "Marca:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: modeloController,
                    decoration: const InputDecoration(labelText: "Modelo:"),
                    keyboardType: TextInputType.text,
                    key: UniqueKey(),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: colorController,
                      decoration: const InputDecoration(labelText: "Color:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: precioController,
                      decoration: const InputDecoration(labelText: "Precio:"),
                      keyboardType: TextInputType.number,
                      key: UniqueKey(),
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: matriculaController,
                      decoration:
                          const InputDecoration(labelText: "Matricula:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                ElevatedButton(
                  onPressed: () => {
                    Alert(
                      context: context,
                      title: "Auto editado con exito",
                      desc:
                          "El auto ha sido editado con exito sin ningun error.",
                    ).show(),
                    FutureBuilder<http.Response>(
                        future: EditarAutoApi(
                            widget.data.data.toString(),
                            marcaController.text,
                            modeloController.text,
                            colorController.text,
                            int.parse(precioController.text),
                            matriculaController.text),
                        builder: ((context, snapshot) {
                          return const CircularProgressIndicator();
                        }))
                  },
                  child: Text("Editar"),
                )
              ],
            );
          },
        ));
  }
}

class crearAuto extends StatefulWidget {
  const crearAuto({super.key});

  @override
  State<StatefulWidget> createState() => _CrearAutoState();
}

class _CrearAutoState extends State<crearAuto> {
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final precioController = TextEditingController();
  final colorController = TextEditingController();
  final matriculaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear Auto"),
        ),
        body: FutureBuilder<Auto>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error");
              }
            }

            return ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: marcaController,
                      decoration: const InputDecoration(labelText: "Marca:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: modeloController,
                    decoration: const InputDecoration(labelText: "Modelo:"),
                    keyboardType: TextInputType.text,
                    key: UniqueKey(),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: colorController,
                      decoration: const InputDecoration(labelText: "Color:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: precioController,
                      decoration: const InputDecoration(labelText: "Precio:"),
                      keyboardType: TextInputType.number,
                      key: UniqueKey(),
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: matriculaController,
                      decoration:
                          const InputDecoration(labelText: "Matricula:"),
                      keyboardType: TextInputType.text,
                      key: UniqueKey(),
                    )),
                ElevatedButton(
                  onPressed: () => {
                    Alert(
                      context: context,
                      title: "Auto creado con exito",
                      desc:
                          "El auto ha sido creado sin exito sin ningun error.",
                    ).show(),
                    FutureBuilder<http.Response>(
                        future: createAuto(
                            marcaController.text,
                            modeloController.text,
                            colorController.text,
                            int.parse(precioController.text),
                            matriculaController.text),
                        builder: ((context, snapshot) {
                          return const CircularProgressIndicator();
                        }))
                  },
                  child: Text("Crear auto"),
                )
              ],
            );
          },
        ));
  }
}

class EliminarAuto extends StatelessWidget {
  const EliminarAuto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eliminar auto"),
      ),
      body: FutureBuilder<List<Auto>>(
        future: getAllAutos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            print(snapshot);
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data?.length,
                itemBuilder: ((context, index) {
                  var idx = snapshot.data?[index].Id ?? 0;
                  final data = Data(idx);
                  return Card(
                    child: ListTile(
                      title: Text("${snapshot.data?[index].marca}"),
                      subtitle: Text(
                          "Color: ${snapshot.data?[index].color}, Precio: \$${snapshot.data?[index].precio}"),
                      trailing: Icon(Icons.delete),
                      onTap: () {
                        Alert(
                          context: context,
                          title: "Auto eliminado con exito",
                          desc:
                              "El auto ha sido eliminado con exito sin ningun error.",
                        ).show();
                        FutureBuilder<http.Response>(
                            future: eliminarAuto(idx.toString()),
                            builder: ((context, snapshot) {
                              return const CircularProgressIndicator();
                            }));
                      },
                    ),
                  );
                }));
          } else
            return const Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    // ignore: prefer_const_constructors
    const VerAutos(),
    // ignore: prefer_const_constructors
    const crearAuto(),
    // ignore: prefer_const_constructors
    const EliminarAuto(),
    // ignore: prefer_const_constructors
    // const FormAutomoviles(),
    // const FormClientes()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'Ver autos',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos_sharp),
            label: 'Agregar carros',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Eliminar carros',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 94, 187, 248),
        onTap: _onItemTapped,
      ),
    );
  }
}
