import 'package:flutter/material.dart';

import '../bloc/comarques_bloc.dart';
import 'info_comarca.dart';

class SelectorComarca extends StatelessWidget {
  SelectorComarca({required this.provincia, super.key});

  final String provincia;
  // Definim una referència al BLoC
  final ComarquesBloc comarquesBloc = ComarquesBloc();

  @override
  Widget build(BuildContext context) {
    // Utilitzem el Setter per establir la provincia
    comarquesBloc.provinciaActual = provincia;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comarques de $provincia'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: comarquesBloc.obtenirComarquesStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _creaLlistaComarques(snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // Per a quan no té encara dades, mostrem un
            // giny indicador de progrés.
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  _creaLlistaComarques(List<dynamic> values) {
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        if (values.isNotEmpty) {
          String img = values[index]["img"];
          String comarca = values[index]["nom"];
          return ComarcaCard(img: img, comarca: comarca);
        } else {
          return const Center(
            child: Text("La llista és buida"),
          );
        }
      },
    );
  }
}

class ComarcaCard extends StatelessWidget {
  const ComarcaCard({required this.img, required this.comarca, super.key});

  final String img;
  final String comarca;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => InfoComarca(comarca: comarca))));
      }),
      child: Card(
        child: Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              image:
                  DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                comarca,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black,
                          blurRadius: 3),
                    ]),
              ),
            )),
      ),
    );
  }
}
