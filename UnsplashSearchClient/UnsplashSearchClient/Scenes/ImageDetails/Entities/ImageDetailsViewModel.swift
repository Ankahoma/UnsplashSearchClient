//
//  ImageDetailsViewModel.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 11.09.2024.
//

import UIKit

struct ImageDetailsViewModel {
    let image: UIImage
    let author: String
    let width: String
    let height: String
    let createdAt: Date
    let isPreview: Bool
    
    init(with galleryModel: GalleryImageViewModel) {
        self.image = galleryModel.image
        self.author = galleryModel.author
        self.width = galleryModel.width
        self.height = galleryModel.height
        self.createdAt = galleryModel.createdAt
        self.isPreview = false
        
    }
    
    init(with searchResultModel: SearchResultImage) {
        self.image = searchResultModel.image
        self.author = searchResultModel.author
        self.width = searchResultModel.width
        self.height = searchResultModel.height
        self.createdAt = searchResultModel.createdAt
        self.isPreview = true
    }
}
