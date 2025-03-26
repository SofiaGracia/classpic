class CarpetaManager {

  static Map <String, String> obtindreValorsCurs(String curs){

    //List<String> valorsCurs = [];
    Map<String, String> valorsCurs = {};

    final num = curs[0];
    var grup = curs.substring(1).trim();

    bool contePunt = grup.contains('.');

    if (contePunt){

      final parts = grup.split('.');
      final cicle = parts[0];
      final modalitat = parts[1];

      //CES
      //CIBER
      //1
      valorsCurs['cicle'] = cicle;
      valorsCurs['modalitat'] = modalitat;
      valorsCurs['num'] = num;

    }else{

      final iniciCicle = grup[0];

      if (iniciCicle.toUpperCase() == 'E') {

        final lletra = grup.substring(3);
        var cicle = grup.substring(0, 3);

        //ESO
        //1, 2, 3, 4
        //A, B, C, D
        valorsCurs['cicle'] = cicle;
        valorsCurs['modalitat'] = num;
        valorsCurs['num'] = lletra;

      } else {

        final lletres = grup.substring(2);
        grup = grup.substring(0, 2);

        //BA
        //1, 2
        //HN
        valorsCurs['cicle'] = grup;
        valorsCurs['modalitat'] = num;
        valorsCurs['num'] = lletres;
      }
    }
    return valorsCurs;
  }

}