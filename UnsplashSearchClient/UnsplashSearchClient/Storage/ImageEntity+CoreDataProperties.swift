//
//  ImageEntity+CoreDataProperties.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//
//

import CoreData
import Foundation

public extension ImageEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged var id: String
    @NSManaged var imageData: Data
    @NSManaged var author: String?
    @NSManaged var createdAt: Date
    @NSManaged var width: String
    @NSManaged var height: String
    @NSManaged var imageDescription: String?
    @NSManaged var cathegory: String
}

extension ImageEntity: Identifiable {}
