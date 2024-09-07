//
//  SearchResultImageDTO.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

struct SearchResultImageDTO: Equatable, Hashable {
    let id: String
    let previewUrl: URL
    let downloadUrl: URL
    let cathegory: String
    let image: UIImage?
    var downloaded = false
}
