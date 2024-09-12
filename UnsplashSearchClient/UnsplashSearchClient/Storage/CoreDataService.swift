//
//  CoreDataService.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import CoreData
import Foundation
import UIKit

protocol IImageSearchDataService {
    func save(image: SearchResultImageDTO)
}

protocol IImagesGalleryDataService {
    func fetchImages(completion: ([[GalleryImageViewModel]]?, Error?) -> Void)
    func removeImage(_ image: GalleryImageViewModel)
}

final class CoreDataService {
    private let entityName = "ImageEntity"

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UnsplashSearchClient")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

extension CoreDataService: IImageSearchDataService {
    func save(image: SearchResultImageDTO) {
        persistentContainer.performBackgroundTask { context in
            if self.imageExists(with: image.id) == false {
                let entity = ImageEntity(context: context)
                entity.id = image.id
                entity.createdAt = image.createdAt
                entity.width = image.width
                entity.height = image.height
                entity.author = image.author
                entity.imageDescription = image.imageDescription
                entity.cathegory = image.cathegory

                if let imageData = image.image.pngData() {
                    entity.imageData = imageData
                }

                self.saveContext(context: context)
            }
        }
    }
}

extension CoreDataService: IImagesGalleryDataService {
    func fetchImages(completion: ([[GalleryImageViewModel]]?, Error?) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ImageEntity>(entityName: entityName)

        do {
            let fetchResult = try context.fetch(fetchRequest)
            let images = fetchResult.map { image in

                GalleryImageViewModel(id: image.id,
                                      image: UIImage(data: image.imageData) ?? UIImage(),
                                      author: image.author,
                                      createdAt: image.createdAt,
                                      width: image.width,
                                      height: image.height,
                                      imageDescription: image.imageDescription,
                                      cathegory: image.cathegory)
            }

            completion(sortImagesByCathegory(images), nil)
        } catch {
            completion(nil, error)
        }
    }

    func removeImage(_ image: GalleryImageViewModel) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ImageEntity>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id as CVarArg)

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext(context: context)
        } catch let error as NSError {
            fatalError("Could not delete item. \(error), \(error.userInfo)")
        }
    }
}

private extension CoreDataService {
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error occured while saving context.  \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func imageExists(with id: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ImageEntity>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let items = try context.fetch(fetchRequest)
            return items.isEmpty == false
        } catch let error as NSError {
            fatalError("Could not delete item. \(error), \(error.userInfo)")
        }
    }

    func sortImagesByCathegory(_ images: [GalleryImageViewModel]) -> [[GalleryImageViewModel]] {
        let cathegories = [String](Set(images.map { $0.cathegory }))

        let model = cathegories.map { cathegory in
            images.filter { $0.cathegory == cathegory }
        }

        let modelSorted = model.sorted(by: {
            guard let firstSection = $0.first, let secondSection = $1.first else { return false }
            return firstSection.cathegory < secondSection.cathegory

        })
        return modelSorted
    }
}
