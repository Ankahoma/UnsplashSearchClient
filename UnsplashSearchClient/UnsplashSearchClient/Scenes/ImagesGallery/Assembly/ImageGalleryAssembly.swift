//
//  ImageGalleryAssembly.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

enum ImagesGalleryAssembly {
    struct Dependencies {
        let navigationController: UINavigationController
        let dataService: IImagesGalleryDataService
    }

    static func createModule(with dependecies: Dependencies) -> ImagesGalleryViewController {
        let interactor = ImagesGalleryInteractor(dataService: dependecies.dataService)
        let router = ImagesGalleryRouter(navigationController: dependecies.navigationController)
        let presenter = ImagesGalleryPresenter(interactor: interactor, router: router)
        let viewController = ImagesGalleryViewController(presenter: presenter, galleryDataSource: presenter, galleryDelegate: presenter)

        return viewController
    }
}
