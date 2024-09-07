//
//  DataService.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import Foundation

protocol IImageSearchDataService {
    func save(image: SearchResultImageDTO)
}

final class DataService: IImageSearchDataService {
    func save(image: SearchResultImageDTO) {}
}
