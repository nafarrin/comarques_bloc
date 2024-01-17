//import 'package:exemple_async/info_comarques.dart';
import 'package:comarques_bloc/bloc/comarques_bloc.dart';
import 'package:flutter/material.dart';

import 'info_comarca_detall.dart';
import 'info_comarca_general.dart';

class InfoComarca extends StatefulWidget {
  const InfoComarca({
    required this.comarca,
    super.key,
  }); // Afegim this.comarca al constructor

// Definim la propietat com a final, per a que el constructor puga ser constant
  final String? comarca;

  @override
  State<InfoComarca> createState() => _InfoComarcaState();
}

class _InfoComarcaState extends State<InfoComarca> {
  // Definim una referència al BLoC
  final ComarquesBloc comarquesBloc = ComarquesBloc();

  // Index per a la barra de navegació inferior
  late int indexActual;

  @override
  void initState() {
    super.initState();
    indexActual = 0;
  }

  @override
  Widget build(BuildContext context) {
    comarquesBloc.nomComarcaActual = widget.comarca!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 18),
          backgroundColor: const Color.fromARGB(125, 255, 255, 255),
          foregroundColor: Colors.black87,
          elevation: 0,
          title: [
            Text('${widget.comarca}.General.'),
            Text('${widget.comarca}. Oratge.'),
          ][indexActual]),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            indexActual = index;
          });
        },
        selectedIndex: indexActual,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'La comarca',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Informació i oratge',
          ),
        ],
      ),
      body: <Widget>[
        InfoComarcaGeneral(),
        const InfoComarcaDetall(),
      ][indexActual],
    );
  }
}
