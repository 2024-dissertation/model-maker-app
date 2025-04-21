import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:frontend/module/collections/models/collection.dart';
import 'package:frontend/module/collections/repository/collection_repository.dart';

class CollectionRepositoryImpl extends AbstractRepository
    implements CollectionRepository {
  CollectionRepositoryImpl({super.apiDataSource});

  @override
  Future<List<Collection>> getCollections() async {
    try {
      final data = await apiDataSource.getCollections();
      final collections = data['collections'] as List;
      return collections.map((e) => CollectionMapper.fromMap(e)).toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Collection> createCollection(Map<String, dynamic> collection) async {
    try {
      final data = await apiDataSource.createCollection(collection);
      return CollectionMapper.fromMap(data['collection']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<void> deleteCollection(int collectionId) async {
    try {
      await apiDataSource.deleteCollection(collectionId);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Collection> getCollectionById(int collectionId) async {
    try {
      final data = await apiDataSource.getCollectionById(collectionId);
      return CollectionMapper.fromMap(data['collection']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<Collection> updateCollection(Collection collection) async {
    try {
      final data = await apiDataSource.updateCollection(collection.toMap());
      return CollectionMapper.fromMap(data['collection']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }
}
