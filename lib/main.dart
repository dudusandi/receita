import 'package:flutter/material.dart';
import 'package:receita/banco.dart';

void main() {
  runApp(const MainApp());
  inicializarBancoDados();
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
  final TextEditingController _pesquisaController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _tempoPrepController.dispose();
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder:
            (context) => Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 251, 251),
              appBar: AppBar(
                title: Text(
                  "CookBook",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color.fromARGB(255, 254, 192, 222),
              ),
              body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _pesquisaController,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(20, 0, 67, 250),
                          filled: true,
                          labelText: "Pesquisar",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Filtro da Pesquisa",
                          style: TextStyle(fontSize: 19),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(20, 0, 67, 250),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: filtroSelecionado,
                              items: [
                                DropdownMenuItem(
                                  value: "todas",
                                  child: Text("Todas"),
                                ),
                                DropdownMenuItem(
                                  value: "categoria",
                                  child: Text("Categoria"),
                                ),
                                DropdownMenuItem(
                                  value: "tag",
                                  child: Text("Tag"),
                                ),
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
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _carregarReceitas(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro ao carregar receitas'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text('Nenhuma receita encontrada'),
                              );
                            } else {
                              final receitas = snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                itemCount: receitas.length,
                                itemBuilder: (context, index) {
                                  final receita = receitas[index];
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 16),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      title: Text(
                                        receita['titulo'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Text(
                                            receita['descricao'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.timer, size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                '${receita['tempoPreparo']} min',
                                              ),
                                              SizedBox(width: 16),
                                              Icon(Icons.category, size: 16),
                                              SizedBox(width: 4),
                                              Text(receita['categoria']),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Chip(
                                            label: Text(receita['tag']),
                                            backgroundColor: Color.fromARGB(
                                              40,
                                              250,
                                              0,
                                              208,
                                            ),
                                            padding: EdgeInsets.zero,
                                            labelStyle: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        _mostrarDetalhesReceita(
                                          context,
                                          receita,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(60, 250, 0, 208),
                        ),
                      ),
                      onPressed: () => _mostrarPopupAdicionarReceita(context),
                      child: Text(
                        "Adicionar Nova Receita",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  // Receitas baseado no filtro selecionado
  Future<List<Map<String, dynamic>>> _carregarReceitas() async {
    String texto = _pesquisaController.text;

    switch (filtroSelecionado) {
      case 'categoria':
        return buscarReceitasPorCategoria(texto);
      case 'tag':
        return buscarReceitasPorTag(texto);
      case 'todas':
      default:
        if (texto.isNotEmpty) {
          return buscarReceitasPorTexto(texto);
        } else {
          return buscarTodasReceitas();
        }
    }
  }

  // Mostrar os detalhes da receita
  void _mostrarDetalhesReceita(
    BuildContext context,
    Map<String, dynamic> receita,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(receita['titulo']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Categoria: ${receita['categoria']}'),
                SizedBox(height: 8),
                Text('Tag: ${receita['tag']}'),
                SizedBox(height: 8),
                Text('Tempo de preparo: ${receita['tempoPreparo']} minutos'),
                SizedBox(height: 16),
                Text(
                  'Descrição:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(receita['descricao']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                excluirReceita(receita['id']);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Popup para Adicionar uma Receita
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
              onPressed: () async {
                int tempoPreparo = int.tryParse(_tempoPrepController.text) ?? 0;
                await adicionarReceita(
                  _tituloController.text,
                  _descricaoController.text,
                  tempoPreparo,
                  _tag.text,
                  _categoria.text,
                );
                _tituloController.clear();
                _descricaoController.clear();
                _tempoPrepController.clear();
                _tag.clear();
                _categoria.clear();
                Navigator.of(context).pop();
                setState(() {});
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Receita adicionada')));
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
