import 'package:spoplusplusfy/Classes/person.dart';

/// Manages follower relationships between [Person] objects.
///
/// This class provides methods for initializing and managing follower and following
/// relationships between people in the application.
class FollowerManager {
  /// Maps a person to their list of followers.
  static late Map<Person, List<Person>> _followerMap;

  /// Maps a person to their list of people they are following.
  static late Map<Person, List<Person>> _followingMap;

  /// Set of valid person objects.
  static late Set<Person> _validPerson;

  /// Private constructor to prevent instantiation.
  FollowerManager._private();

  /// Initializes the FollowerManager with the provided data.
  ///
  /// Parameters:
  /// - [followerMap]: A map of persons to their followers.
  /// - [followingMap]: A map of persons to the people they are following.
  /// - [validPerson]: A set of valid person objects.
  ///
  /// Returns an instance of [FollowerManager].
  static FollowerManager init(Map<Person, List<Person>> followerMap,
      Map<Person, List<Person>> followingMap, Set<Person> validPerson) {
    _followerMap = followerMap;
    _followingMap = followingMap;
    _validPerson = validPerson;
    return FollowerManager._private();
  }

  /// Retrieves the list of followers for a given person.
  ///
  /// Parameters:
  /// - [person]: The person whose followers are to be retrieved.
  ///
  /// Returns a list of [Person] objects who are followers of the given person.
  /// Throws an error if the person is not in the follower map.
  static List<Person> getFollowerList(Person person) {
    if (_followerMap[person] == null) throw 'Error';
    return _followerMap[person]!;
  }

  /// Retrieves the list of people a given person is following.
  ///
  /// Parameters:
  /// - [person]: The person whose following list is to be retrieved.
  ///
  /// Returns a list of [Person] objects who are being followed by the given person.
  /// Throws an error if the person is not in the following map.
  static List<Person> getFollowingList(Person person) {
    if (_followingMap[person] == null) throw 'Error';
    return _followingMap[person]!;
  }

  /// Adds a following relationship between two people.
  ///
  /// Parameters:
  /// - [subject]: The person who will follow.
  /// - [object]: The person to be followed.
  static void addToFollowing(Person subject, Person object) {
    _followingMap.update(subject, (following) => following..add(object),
        ifAbsent: () => [object]);
    _followerMap.update(object, (follower) => follower..add(subject),
        ifAbsent: () => [subject]);
  }

  /// Removes a following relationship between two people.
  ///
  /// Parameters:
  /// - [subject]: The person who will unfollow.
  /// - [object]: The person to be unfollowed.
  static void removeFromFollowing(Person subject, Person object) {
    _followingMap.update(subject, (list) => list..remove(object));
    _followerMap.update(object, (list) => list..remove(subject));
  }

  /// Removes a follower relationship between two people.
  ///
  /// Parameters:
  /// - [subject]: The person who will remove a follower.
  /// - [object]: The person to be removed as a follower.
  static void removeFromFollower(Person subject, Person object) {
    _followerMap.update(subject, (list) => list..remove(object));
    _followingMap.update(object, (list) => list..remove(subject));
  }

  /// Removes a person from the set of valid persons.
  ///
  /// Parameters:
  /// - [person]: The person to be removed.
  static void deletePerson(Person person) {
    _validPerson.remove(person);
  }
}