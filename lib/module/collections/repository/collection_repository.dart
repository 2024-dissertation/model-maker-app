import 'package:frontend/module/collections/models/collection.dart';

abstract class CollectionRepository {
  Future<List<Collection>> getCollections();
  Future<Collection> getCollectionById(int collectionId);
  Future<Collection> createCollection(Map<String, dynamic> collection);
  Future<Collection> updateCollection(Collection collection);
  Future<void> deleteCollection(int collectionId);
}
