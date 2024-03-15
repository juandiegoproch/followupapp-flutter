import 'package:followupapp/models/person.dart';
import 'package:followupapp/service/database.dart';

Future<List<Person>> getPeople() async
// returns a list of all valid task states
{
  await whenDBUp();
  var response = await db!.rawQuery("SELECT DISTINCT person FROM Tasks;");
  List<Person> people = [];
  for (dynamic p in response)
  {
    people.add(Person(p["person"]));
  }

  return people;
}