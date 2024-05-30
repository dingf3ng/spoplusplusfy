
import 'package:spoplusplusfy/Classes/person.dart';

class FollowerManager {

  static late Map<Person, List<Person>> _followerMap;
  static late Map<Person, List<Person>> _followingMap;
  static late Set<Person> _validPerson;

  FollowerManager._private();

  static FollowerManager init(
      Map<Person, List<Person>> followerMap,
      Map<Person, List<Person>> followingMap,
      Set<Person> validPerson
      ) {
    _followerMap = followerMap;
    _followingMap = followingMap;
    _validPerson = validPerson;
    return FollowerManager._private();
  }

  List<Person> getFollowerList(Person person) {
    if(_followerMap[person] == null) throw 'Error';
    return _followerMap[person]!;
  }

  List<Person> getFollowingList(Person person) {
    if(_followingMap[person] == null) throw 'Error';
    return _followingMap[person]!;
  }

  void deletePerson(Person) {
    _validPerson.remove(Person);
  }
}