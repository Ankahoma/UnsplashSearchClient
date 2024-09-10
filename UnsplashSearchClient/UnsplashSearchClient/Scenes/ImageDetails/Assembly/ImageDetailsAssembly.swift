//
//  ImageDetailsAssembly.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

enum ImageDetailsAssembly {
    struct Parameters {
        let image: ImageDetailsViewModel
    }

    static func createModule(parameters: Parameters) -> ImageDetailsViewController {
        let viewController = ImageDetailsViewController(with: parameters.image)

        return viewController
    }
}
