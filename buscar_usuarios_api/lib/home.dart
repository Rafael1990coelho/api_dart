import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuario"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: pegarUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erro: ${snapshot.error}');
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data is List) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var usuario = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(usuario['id'].toString()),
                  ),
                  title: Text(usuario['name']),
                  subtitle: Text(usuario['website']),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }
        },
      ),
    );
  }

  Future<List<dynamic>> pegarUsuarios() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      print('Resposta recebida: ${resposta.body}');
      return jsonDecode(resposta.body);
    } else {
      print('Falha na resposta: ${resposta.statusCode}');
      throw Exception("Nao foi possivel carregar os usuarios");
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Homepage(),
  ));
}
