import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final Client client = Client()
    .setProject("69dbcfd4000f59260ab6")
    .setEndpoint("https://sgp.cloud.appwrite.io/v1");

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
}
