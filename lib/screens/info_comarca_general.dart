import 'package:flutter/material.dart';

import '../bloc/comarques_bloc.dart';
import '../model/comarca.dart';

class InfoComarcaGeneral extends StatelessWidget {
  InfoComarcaGeneral({super.key});

  // Definim una referència al BLoC
  final ComarquesBloc comarquesBloc = ComarquesBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: comarquesBloc.obtenirComarcaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Comarca c = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 80),
                Image.network(c.img ?? ""),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        //info["comarca"],
                        c.comarca,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        //'Capital: ${info["capital"]}',
                        'Capital: ${c.capital}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        //info["desc"],
                        c.desc ?? "",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
