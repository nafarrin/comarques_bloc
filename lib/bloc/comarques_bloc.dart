import 'dart:async';

import 'package:comarques_bloc/model/comarca.dart';
import 'package:comarques_bloc/model/provincia.dart';

import '../repository/comarques_repository.dart';

class ComarquesBloc {
  /* Implementació del patró Singleton */
  // Per tal de poder utilitzar el BLoC en diverses classes, farem
  // una implementació Singleton d'aquest.

  // Declarem una referència interna (privada) a
  // una instància de la mateixa classe
  // Aquesta propietat ha de ser estàtica per poder
  // referenciar-se des d'un constructor de factoría
  static ComarquesBloc? _comarquesBloc;

  // Declarem un constructor privat amb nom (_), de
  // manera que només es puga invocar des de dins
  ComarquesBloc._() {
    carregaProvincies();
  }

  // Definim el constructor com un mètode de factoria per
  // obtenir la instància o crear-ne una nova.
  factory ComarquesBloc() {
    // Utilitzem l'operador ??= per assignar
    // valor només si aquest és nul. Si la referència
    // _comarquesBloc és nul·la, crearem una nova instància
    // amb el constructor privat. Si la referència no és
    // nul·la, retornarem la que ja existeix.
    _comarquesBloc ??= ComarquesBloc._();
    return _comarquesBloc!;
  }

  /* Referències als repositoris */

  final _comarquesRepository = ComarquesRepository();

  /* Propietats que definiran l'estat de l'aplicació */

  String? _provinciaActual; // Província seleccionada (_provinciaActual)
  List<dynamic>? _llistaComarques; // Llista de comarques de la província
  // seleccionada (només nom i imatge)
  String? _nomComarcaActual; // Nom de la comarca seleccionada
  Comarca? comarcaActual; // Informació de la comarca seleccionada

  /* Controladors d'Streams */
  // Definim ara els controladors per als Streams sobre els que
  // emetrem els esdeveniments per informar a la interfície dels
  // canvis d'estat.

  // Controlador per a la llista de provincies
  final _provinciesController = StreamController<List<Provincia>>.broadcast();

  // Controlador per a la llista de comarques de la província actual
  final _comarquesController = StreamController<List<dynamic>?>.broadcast();

  // Controlador per a la informació de la comarca actual
  final _comarcaActualController = StreamController<Comarca?>.broadcast();

  /* Mètodes accessors */

  // Accessors per a provinciaActual

  String? get provinciaActual {
    return _provinciaActual;
  }

  set provinciaActual(String? provincia) {
    if (provincia != null) {
      if (_provinciaActual != provincia) {
        _provinciaActual = provincia;
        carregaComarques(_provinciaActual!);
      } else {
        actualitzaComarques();
      }
    }
  }

  // Accessors per a nomComarcaActual

  set nomComarcaActual(String? comarca) {
    if (comarca != null) {
      if (_nomComarcaActual != comarca) {
        _nomComarcaActual = comarca;
        carregaComarca(comarca);
      } else {
        actualitzaComarca();
      }
    }
  }

  // Getter per a l'Stream de _provinciesController
  Stream<List<Provincia>> get obtenirProvinciesStream =>
      _provinciesController.stream;

  // Getter per a l'Stream de _comarquesController
  Stream<List<dynamic>?> get obtenirComarquesStream =>
      _comarquesController.stream;

  // Getter per a l'Stream de _comarcaActualController
  Stream<Comarca?> get obtenirComarcaStream => _comarcaActualController.stream;

  /* Events del BLoC */

  void carregaProvincies() async {
    // Obtenim les províncies de del mètode corresponent del repositori
    List<dynamic> jsonProvincies =
        await _comarquesRepository.obtenirProvincies();

    //  El mapegem a una llista de províncies
    List<Provincia> provincies = List<Provincia>.from(
        jsonProvincies.map((provincia) => Provincia.fromJSON(provincia)));

    // I l'emetem l'Stream de les províncies
    _provinciesController.sink.add(provincies);
  }

  void carregaComarques(String provincia) async {
    List<dynamic> jsonComarques =
        await _comarquesRepository.obtenirComarquesAmbImatge(provincia);
    _llistaComarques = jsonComarques;

    // Emetem la llista per l'Stream corresponent
    _comarquesController.sink.add(_llistaComarques);
  }

  void actualitzaComarques() async {
    // Afegim una espera asíncrona de durada zero (Zero-Duration Delay)
    await Future.delayed(Duration.zero);
    // Emetem llista de comarques actual per l'Stream
    _comarquesController.sink.add(_llistaComarques);
  }

  void carregaComarca(String comarca) async {
    // Obtenim la informació sobre la comarca a través del repositori
    // i l'afegim a l'Stream del controlador corresponent.
    Comarca? infoComarca =
        await _comarquesRepository.obtenirInfoComarca(comarca);
    comarcaActual = infoComarca;
    _comarcaActualController.sink.add(comarcaActual);
  }

  void actualitzaComarca() async {
    // Afegim una espera asíncrona de durada zero (Zero-Duration Delay)
    await Future.delayed(Duration.zero);
    // Emetem la informació de la comarca actual per l'Stream de les comarques
    _comarcaActualController.sink.add(comarcaActual);
  }

  void dispose() {
    _provinciesController.close();
    _comarquesController.close();
    _comarcaActualController.close();
  }
}
