/*
              List<String> listeID = [];
              List<String> listeCodeCM = [];
              List<String> listeDate_Visite = [];
              List<String> listeDuree_visite_en_jours = [];
              List<String> listeMotif_Visite = [];
              List<String> listeNOTE_1 = [];
              List<String> listeRapport_Visite = [];
              //print(snapshot.data);

              for (var i = 0; i < 10; i++) {
                listeID.add(snapshot.data[i]['ID']);
                listeCodeCM.add(snapshot.data[i]['Code_CM']);
                listeDate_Visite.add(snapshot.data[i]['Date_Visite']);
                listeDuree_visite_en_jours.add(snapshot.data[i]['Duree_visite_en_jours']);
                listeMotif_Visite.add(snapshot.data[i]['Motif_Visite']);
                listeNOTE_1.add(snapshot.data[i]['NOTE_1']);
                listeRapport_Visite.add(snapshot.data[i]['Rapport_Visite']);
              }
              final listOfColumns = snapshot.data.map((dynamic value) {
                print(value['Code_CM']);
              }).toSet().toList();
              return DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Code CM',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date visite',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Durée',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Motif',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Note',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rapport',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: <DataRow>[
//                      for (var i = 0; i < 10; i++) {
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(listeID[0].toString())),
                      DataCell(Text(listeCodeCM[0].toString())),
                      DataCell(Text(listeDate_Visite[0].toString())),
                      DataCell(Text(listeDuree_visite_en_jours[0].toString())),
                      DataCell(Text(listeMotif_Visite[0].toString())),
                      DataCell(Text(listeNOTE_1[0].toString())),
                      DataCell(Text(listeRapport_Visite[0].toString())),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(listeID[1].toString())),
                      DataCell(Text(listeCodeCM[1].toString())),
                      DataCell(Text(listeDate_Visite[1].toString())),
                      DataCell(Text(listeDuree_visite_en_jours[1].toString())),
                      DataCell(Text(listeMotif_Visite[1].toString())),
                      DataCell(Text(listeNOTE_1[1].toString())),
                      DataCell(Text(listeRapport_Visite[1].toString())),
                    ],
                  ),
//                    }
                ],
              );
*/