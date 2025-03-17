import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String filtroSelecionado = "nome";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(
          title: Text("CookBook"),
          backgroundColor: Colors.blue.shade50,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.blueGrey.shade100,
                    filled: true,
                    label: Text("Pesquisar"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Filtro da Pesquisa", style: TextStyle(fontSize: 19)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: filtroSelecionado,
                        items: [
                          DropdownMenuItem(value: "nome", child: Text("Nome")),
                          DropdownMenuItem(
                            value: "ingrediente",
                            child: Text("Ingrediente"),
                          ),
                          DropdownMenuItem(value: "tag", child: Text("Tag")),
                        ],
                        onChanged: (String? novoValor) {
                          setState(() {
                            filtroSelecionado = novoValor!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey.shade100,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => adicionar(),
                child: Text("Adicionar Nova Receita"),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

void adicionar() {}
