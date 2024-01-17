import 'package:comarques_bloc/screens/selector_comarca.dart';
import 'package:flutter/material.dart';

import '../bloc/comarques_bloc.dart';
import '../model/provincia.dart';

class SelectorProvincia extends StatelessWidget {
  SelectorProvincia({
    super.key,
  });

  final ComarquesBloc comarquesBloc = ComarquesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de provincies'),
      ),
      body: StreamBuilder(
        stream: comarquesBloc.obtenirProvinciesStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _creaLlistaProvincies(snapshot.data ?? [])),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _creaLlistaProvincies(List<dynamic> data) {
    List<Widget> llista = [];
    for (Provincia provincia in data) {
      llista.add(ProvinciaRoundButton(
          nom: provincia.nom, img: provincia.imatge ?? ""));
      llista.add(const SizedBox(height: 20));
    }
    return llista;
  }
}

class ProvinciaRoundButton extends StatelessWidget {
  const ProvinciaRoundButton({required this.img, required this.nom, super.key});

  final String img;
  final String nom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => SelectorComarca(provincia: nom)),
          ),
        );
      }),
      child: CircleAvatar(
        radius: 110,
        backgroundImage: NetworkImage(img),
        child: Text(
          nom,
          textAlign: TextAlign.end,
          style: const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 40,
              shadows: [
                Shadow(
                    offset: Offset(2, 2), color: Colors.black, blurRadius: 3),
              ]),
        ),
      ),
    );
  }
}
