//
//  ImageDetailsViewModel.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 11.09.2024.
//

import UIKit

struct ImageDetailsViewModel {
    let image: UIImage
    let author: String?
    let width: String
    let height: String
    let createdAt: Date
    let imageDescription: String?
    let isPreview: Bool

    init(with galleryModel: GalleryImageViewModel) {
        image = galleryModel.image
        author = galleryModel.author
        width = galleryModel.width
        height = galleryModel.height
        createdAt = galleryModel.createdAt
        imageDescription = galleryModel.imageDescription
        isPreview = false
    }

    init(with searchResultModel: SearchResultImageDTO) {
        image = searchResultModel.image
        author = searchResultModel.author
        width = searchResultModel.width
        height = searchResultModel.height
        createdAt = searchResultModel.createdAt
        imageDescription = searchResultModel.imageDescription
        isPreview = true
    }
}
