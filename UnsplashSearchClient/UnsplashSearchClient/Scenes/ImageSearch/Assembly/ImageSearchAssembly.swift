//
//  ImageSearchAssembly.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

import UIKit

enum ImageSearchAssembly {
    struct Dependencies {
        let navigationController: UINavigationController
        let networkService: INetworkService
        let downloadService: DownloadService
        let dataService: IImageSearchDataService
    }

    static func createModule(with dependecies: Dependencies) -> ImageSearchViewController {
        let interactor = ImageSearchInteractor(downloadService: dependecies.downloadService,
                                               networkService: dependecies.networkService, dataService: dependecies.dataService)
        let router = ImageSearchRouter(navigationController: dependecies.navigationController)
        let presenter = ImageSearchPresenter(interactor: interactor, router: router)
        let viewController = ImageSearchViewController(presenter: presenter, dataSource: presenter, delegate: presenter)

        return viewController
    }
}
