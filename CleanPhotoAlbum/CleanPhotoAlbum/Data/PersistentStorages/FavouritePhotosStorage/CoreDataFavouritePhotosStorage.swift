//
//  CoreDataFavouritePhotosStorage.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 02/03/23.
//

import Foundation
import CoreData

final class CoreDataFavouritePhotosStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func fetchRequest(for photo: PhotoModel) -> NSFetchRequest<FavouritePhotoEntity> {
        let request: NSFetchRequest = FavouritePhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", (\FavouritePhotoEntity.id)._kvcKeyPathString!, photo.id)
        return request
    }
    
    private func deleteEntity(for photo: PhotoModel, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: photo)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
}

extension CoreDataFavouritePhotosStorage: FavouritePhotosStorage {
    
    func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void) {
        
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = FavouritePhotoEntity.fetchRequest()
              //  request.sortDescriptors = [NSSortDescriptor(key: #keyPath(FavouritePhotoEntity.id), ascending: false)]
                // request.fetchLimit = maxCount
                let result = try context.fetch(request).map { $0.toDomain() }
                
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
           // guard let self = self else { return }
            do {
                //  try self.cleanUpQueries(for: query, inContext: context)
                let entity = FavouritePhotoEntity(photo: photo, insertInto: context)
                try context.save()
                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
        
    }
    
    func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteEntity(for: photo, in: context)
                try context.save()
                completion(.success(photo))
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataFavouritePhotosStorage Unresolved error \(error), \((error as NSError).userInfo)")
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
    
    func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        print("onClickForDetails photo id \(photo.id)")

        coreDataStorage.performBackgroundTask {[weak self] context in
            do {
                if let request = self?.fetchRequest(for: photo) {
                let result = try context.fetch(request)
                completion(.success(result.count > 0))
                }
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
}

