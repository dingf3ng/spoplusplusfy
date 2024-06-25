import 'package:spoplusplusfy/Classes/person.dart';

class FollowerManager {
  static late Map<Person, List<Person>> _followerMap;
  static late Map<Person, List<Person>> _followingMap;
  static late Set<Person> _validPerson;

  FollowerManager._private();

  static FollowerManager init(Map<Person, List<Person>> followerMap,
      Map<Person, List<Person>> followingMap, Set<Person> validPerson) {
    _followerMap = followerMap;
    _followingMap = followingMap;
    _validPerson = validPerson;
    return FollowerManager._private();
  }

  static List<Person> getFollowerList(Person person) {
    if (_followerMap[person] == null) throw 'Error';
    return _followerMap[person]!;
  }

  static List<Person> getFollowingList(Person person) {
    if (_followingMap[person] == null) throw 'Error';
    return _followingMap[person]!;
  }

  static void addToFollowing(Person subject, Person object) {
    _followingMap.update(subject, (following) => following..add(object),
        ifAbsent: () => [object]);
    _followerMap.update(object, (follower) => follower..add(subject),
        ifAbsent: () => [subject]);
  }

  static void removeFromFollowing(Person subject, Person object) {
    _followingMap.update(subject, (list) => list..remove(object));
    _followerMap.update(object, (list) => list..remove(subject));
  }

  static void removeFromFollower(Person subject, Person object) {
    _followerMap.update(subject, (list) => list..remove(object));
    _followingMap.update(object, (list) => list..remove(subject));
  }

  static void deletePerson(Person) {
    _validPerson.remove(Person);
  }
}
