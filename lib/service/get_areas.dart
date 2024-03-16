import 'package:followupapp/models/area.dart';
import 'package:followupapp/service/database.dart';

Future<List<Area>> getAreas() async
// returns a list of all valid task states
{
  await whenDBUp();
  var response = await db!.rawQuery("SELECT DISTINCT area FROM Tasks;");
  List<Area> area = [];
  for (dynamic p in response) {
    area.add(Area(p["person"]));
  }

  return area;
}
