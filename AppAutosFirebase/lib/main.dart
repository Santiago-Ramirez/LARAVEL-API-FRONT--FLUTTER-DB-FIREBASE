import 'package:appautosfirebase/models/Auto.dart';
import 'package:appautosfirebase/services/autos_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(title: 'App de autos'),
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
                    FutureBuilder<http.Response>(
                        future: EditarAutoApi(
                            widget.data.data.toString(),
                            marcaController.text,
                            modeloController.text,
                            colorController.text,
                            int.parse(precioController.text),
                            matriculaController.text),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Exito al editar la informacion"),
                            ));
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

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
                    FutureBuilder<http.Response>(
                        future: createAuto(
                            marcaController.text,
                            modeloController.text,
                            colorController.text,
                            int.parse(precioController.text),
                            matriculaController.text),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Alert!!"),
                                  content: new Text("You are awesome!"),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

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
                        FutureBuilder<http.Response>(
                            future: eliminarAuto(idx.toString()),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Alert!!"),
                                      content: new Text("You are awesome!"),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

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
