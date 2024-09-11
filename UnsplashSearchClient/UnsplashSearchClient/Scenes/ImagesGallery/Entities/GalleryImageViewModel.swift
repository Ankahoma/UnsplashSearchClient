//
//  GalleryImageViewModel.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

struct GalleryImageViewModel: Equatable {
    let id: String
    let image: UIImage
    let author: String?
    let createdAt: Date
    let width: String
    let height: String
    let imageDescription: String?
    let cathegory: String
}
