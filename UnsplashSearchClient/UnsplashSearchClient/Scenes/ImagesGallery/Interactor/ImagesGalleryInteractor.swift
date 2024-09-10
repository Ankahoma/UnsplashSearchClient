//
//  ImagesGalleryInteractor.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import Foundation

protocol IImagesGalleryInteractor {
    func fetchImages(completion: @escaping ([[GalleryImageViewModel]]?, Error?) -> Void)
    func removeImages(_ image: GalleryImageViewModel)
}

final class ImagesGalleryInteractor {
    private let dataService: IImagesGalleryDataService
    
    init(dataService: IImagesGalleryDataService) {
        self.dataService = dataService
    }
}

extension ImagesGalleryInteractor: IImagesGalleryInteractor {
    
    func fetchImages(completion: @escaping ([[GalleryImageViewModel]]?, Error?) -> Void) {
        dataService.fetchImages() { result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }
            completion(result, nil)
        }
    }
    
    func removeImages(_ image: GalleryImageViewModel) {
            dataService.removeImage(image)
    }
}
