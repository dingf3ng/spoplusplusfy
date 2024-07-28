/// An interface for objects that have a name property.
///
/// Classes that implement this interface should provide methods
/// to get and set a name.
abstract interface class Name {
  /// Retrieves the name of the object.
  ///
  /// Returns a [String] representing the name of the object.
  String getName();

  /// Sets the name of the object.
  ///
  /// Parameters:
  /// - [name]: A [String] representing the new name to be set.
  void setName(String name);
}