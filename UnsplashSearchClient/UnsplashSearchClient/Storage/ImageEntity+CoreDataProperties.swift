//
//  ImageEntity+CoreDataProperties.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var imageData: Data
    @NSManaged public var author: String
    @NSManaged public var createdAt: Date
    @NSManaged public var width: String
    @NSManaged public var height: String
    @NSManaged public var title: String
    @NSManaged public var cathegory: String
    

}

extension ImageEntity : Identifiable {

}
