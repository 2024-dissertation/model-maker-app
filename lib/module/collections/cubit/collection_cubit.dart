import 'package:equatable/equatable.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/collections/models/collection.dart';
import 'package:frontend/module/collections/repository/collection_repository.dart';

part 'collection_state.dart';

class CollectionCubit extends SafeCubit<CollectionState> {
  final CollectionRepository collectionRepository = getIt();

  CollectionCubit() : super(CollectionInitial());

  Future<void> fetchCollections() async {
    if (state is CollectionInitial) {
      safeEmit(CollectionLoading());
    }

    try {
      final collections = await collectionRepository.getCollections();
      safeEmit(CollectionLoaded(collections));
    } catch (e) {
      safeEmit(CollectionError(e.toString()));
    }
  }

  Future<void> deleteCollection(int collectionId) async {
    if (state is! CollectionLoaded) return;

    final collections = (state as CollectionLoaded).collections;

    try {
      collectionRepository.deleteCollection(collectionId);
      final updatedCollections = collections
          .where((collection) => collection.id != collectionId)
          .toList();
      safeEmit(CollectionLoaded(updatedCollections));
    } catch (e) {
      safeEmit(CollectionError(e.toString()));
    }
  }

  Future<void> createCollection(Map<String, dynamic> collection) async {
    if (state is! CollectionLoaded) return;

    final collections = (state as CollectionLoaded).collections;

    try {
      final newCollection =
          await collectionRepository.createCollection(collection);
      final updatedCollections = [...collections, newCollection];
      safeEmit(CollectionLoaded(updatedCollections));
    } catch (e) {
      safeEmit(CollectionError(e.toString()));
    }
  }

  Future<void> saveCollection(Collection collection) async {
    if (state is! CollectionLoaded) return;

    final collections = (state as CollectionLoaded).collections;

    try {
      final updatedCollection =
          await collectionRepository.updateCollection(collection);
      final updatedCollections = collections.map((collection) {
        if (collection.id == updatedCollection.id) {
          return updatedCollection;
        }
        return collection;
      }).toList();
      safeEmit(CollectionLoaded(updatedCollections));
    } catch (e) {
      safeEmit(CollectionError(e.toString()));
    }
  }
}
