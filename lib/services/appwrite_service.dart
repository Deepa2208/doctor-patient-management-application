import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases databases;

  AppwriteService() {
    client =
        Client()
          ..setEndpoint('https://cloud.appwrite.io/v1') // Appwrite endpoint
          ..setProject('67ded3d9003dccc1a1e6'); // Your Appwrite Project ID

    account = Account(client);
    databases = Databases(client);
  }

  // User Registration (Auth + Database)
  Future<User> registerUser(
    String email,
    String password,
    Map<String, dynamic> userData,
    String role,
  ) async {
    try {
      // Step 1: Create user in Appwrite Authentication
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name:
            "${userData['first_name']} ${userData['last_name']}", // Combine names
      );

      // Step 2: Determine the collection ID based on the user role
      String collectionId =
          (role == 'doctors')
              ? '67ded414000a1664b9d3' // Doctor Collection ID
              : '67ded40100179828ab8e'; // Patient Collection ID

      // Step 3: Prepare user data to be stored
      Map<String, dynamic> data = {
        'email': email,
        'first_name': userData['first_name'],
        'last_name': userData['last_name'],
        'password': password,
        'city': userData['city'],
        if (role == 'doctors') ...{
          'hospital_name': userData['hospital_name'],
          'designation': userData['designation'],
        },
        if (role == 'patients') ...{
          'country': userData['country'],
          'age': int.parse(userData['age']),
          'gender': userData['gender'],
        },
      };

      // Step 4: Store user details in the Appwrite Database
      await databases.createDocument(
        databaseId: '67ded3f80005c55371f9', // Database ID
        collectionId: collectionId,
        documentId: user.$id, // Use the user ID as document ID
        data: data,
        permissions: [
          Permission.read(Role.any()), // Allow anyone to read
          Permission.write(Role.any()), // Allow anyone to write
        ],
      );

      print("User registration and data storage successful.");
      return user;
    } catch (e) {
      print("Error registering user: $e");
      throw Exception("Error storing user data: $e");
    }
  }

  // User Login
  Future<Session> loginUser(String email, String password) async {
    try {
      return await account.createEmailSession(email: email, password: password);
    } catch (e) {
      print("Login failed: $e");
      throw Exception("Login failed: $e");
    }
  }

  // Get user data from database
  Future<Document> getUserData(String userId, String role) async {
    try {
      String collectionId =
          (role == "doctors")
              ? '67ded414000a1664b9d3' // Doctor Collection ID
              : '67ded40100179828ab8e'; // Patient Collection ID

      return await databases.getDocument(
        databaseId: '67ded3f80005c55371f9', // Database ID
        collectionId: collectionId,
        documentId: userId,
      );
    } catch (e) {
      print("Failed to get user data: $e");
      throw Exception("Failed to get user data: $e");
    }
  }

  // User Logout
  Future<void> logoutUser() async {
    try {
      await account.deleteSession(sessionId: 'current');
      print("User logged out successfully.");
    } catch (e) {
      print("Logout failed: $e");
      throw Exception("Logout failed: $e");
    }
  }

  // Delete User Account
  // Future<void> deleteUser(String userId) async {
  //   try {
  //     await account.delete(userId: userId);
  //     print("User deleted successfully.");
  //   } catch (e) {
  //     print("Failed to delete user: $e");
  //     throw Exception("Failed to delete user: $e");
  //   }
  // }
}
