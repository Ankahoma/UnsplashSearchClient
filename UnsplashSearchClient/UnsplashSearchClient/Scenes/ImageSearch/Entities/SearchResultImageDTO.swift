//
//  SearchResultImageDTO.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

struct SearchResultImageDTO: Equatable, Hashable {
    let id: String
    let createdAt: Date
    let width: String
    let height: String
    let description: String
    let previewUrl: URL
    let downloadUrl: URL
    let author: String
    let image: UIImage
    let cathegory: String
    var downloaded = false
}
