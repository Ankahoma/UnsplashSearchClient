//
//  ImageSearchRouter.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

final class ImageSearchRouter {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showImageModally(with image: ImageDetailsViewModel, at sourceVC: ImageSearchViewController) {
        let parameters = ImageDetailsAssembly.Parameters(image: image)
        let destinationVC = ImageDetailsAssembly.createModule(parameters: parameters)
        let imageViewerNavigationController = UINavigationController(rootViewController: destinationVC)
        sourceVC.present(imageViewerNavigationController, animated: true)
    }

    func showGallery() {
        let dataService = CoreDataService()

        let dependencies = ImagesGalleryAssembly.Dependencies(navigationController: navigationController, dataService: dataService)

        let viewController = ImagesGalleryAssembly.createModule(with: dependencies)
        navigationController.pushViewController(viewController, animated: true)
    }
}
