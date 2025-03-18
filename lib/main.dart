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
  String filtroSelecionado = "todas";
  
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tempoPrepController = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  final TextEditingController _categoria = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _tempoPrepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 251, 251),
          appBar: AppBar(
            title: Text("CookBook",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            backgroundColor: const Color.fromARGB(255, 254, 192, 222),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(20, 0, 67, 250),
                      filled: true,
                      labelText: "Pesquisar",
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
                        color: Color.fromARGB(20, 0, 67, 250),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: filtroSelecionado,
                          items: [
                            DropdownMenuItem(value: "todas", child: Text("Todas")),
                            DropdownMenuItem(
                              value: "categoria",
                              child: Text("Categoria"),
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
                      color: Color.fromARGB(20, 0, 67, 250),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(60, 250, 0, 208),)),
                  onPressed: () => _mostrarPopupAdicionarReceita(context),
                  child: Text("Adicionar Nova Receita", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _mostrarPopupAdicionarReceita(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Nova Receita'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título da Receita',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _descricaoController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _tempoPrepController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tempo de Preparo (minutos)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                                SizedBox(height: 15),
                TextField(
                  controller: _tag,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                                SizedBox(height: 15),
                TextField(
                  controller: _categoria,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Título: ${_tituloController.text}');
                print('Descrição: ${_descricaoController.text}');
                print('Tempo de Preparo: ${_tempoPrepController.text} minutos');
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}