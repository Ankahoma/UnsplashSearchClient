//
//  ImagesGalleryRouter.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

final class ImagesGalleryRouter {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showImageModally(with image: ImageDetailsViewModel, at sourceVC: ImagesGalleryViewController) {
        let parameters = ImageDetailsAssembly.Parameters(image: image)
        let destinationVC = ImageDetailsAssembly.createModule(parameters: parameters)
        let imageViewerNavigationController = UINavigationController(rootViewController: destinationVC)
        sourceVC.present(imageViewerNavigationController, animated: true)
    }
}
