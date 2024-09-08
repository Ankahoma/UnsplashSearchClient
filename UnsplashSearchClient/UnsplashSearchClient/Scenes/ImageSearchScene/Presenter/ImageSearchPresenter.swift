//
//  ImageSearchPresenter.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import Foundation

protocol IImageSearchPresenter {
    func viewWillAppear()
    func didLoad(ui: IImageSearchView)
    func performNewSearch(with searchQuery: String, at pageNumber: Int)
    func updateSearchResult(at pageNumber: Int)
    func configureCell(_ cell: SearchResultCell, at index: Int)

    func showImagePreview(at index: Int)

    func startDownloadImage(at index: Int)
    func pauseDownloadImage(at index: Int)
    func resumeDownloadImage(at index: Int)
    func cancelDownloadImage(at index: Int)
}

protocol IImageSearchResultDataSource {
    func getNumberOfRows() -> Int
    func getCellForRow(at index: Int) -> SearchResultImageDTO
}

protocol IImageSearchViewUpdateDelegate: AnyObject {
    func updateItem(id: String)
    func updateProgress(itemId: String, progress: Float, totalSize: String)
    func updateDownloadedItem(with image: SearchResultImageDTO)
}

protocol IImageSearchResultDelegate {
    func imageSelected(at index: Int)
    func imageDeselected(at index: Int)
}

final class ImageSearchPresenter: NSObject {
    weak var ui: IImageSearchView?
    private var interactor: IImageSearchInteractor
    private var router: ImageSearchRouter
    private var searchQuery: String = ""

    private var searchResult: [SearchResultImageDTO] = []
    init(interactor: IImageSearchInteractor, router: ImageSearchRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ImageSearchPresenter: IImageSearchPresenter {
    func viewWillAppear() {
        searchResult = []
    }

    func didLoad(ui: IImageSearchView) {
        interactor.uiUpdater = self
        self.ui = ui
    }

    func performNewSearch(with searchQuery: String, at pageNumber: Int) {
        searchResult = []
        self.searchQuery = searchQuery
        interactor.newSearchStarted()
        performSearch(with: searchQuery, at: pageNumber)
    }

    func updateSearchResult(at pageNumber: Int) {
        performSearch(with: searchQuery, at: pageNumber)
    }

    func configureCell(_ cell: SearchResultCell, at index: Int) {
        ui?.hideActivityIndicator()

        let imageObject = searchResult[index]
        let downloaded = imageObject.downloaded
        let downloadItem = interactor.getDownloadItem(for: imageObject)
        guard let image = imageObject.image else { return }
        cell.configure(with: image, downloaded: downloaded, downloadItem: downloadItem)
    }

    func showImagePreview(at index: Int) {
        guard let image = searchResult[index].image else { return }
        router.showImageDetails(image)
    }

    func startDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.startDownload(image)
    }

    func pauseDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.pauseDownload(image)
    }

    func resumeDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.resumeDownload(image)
    }

    func cancelDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.cancelDownload(image)
    }
}

extension ImageSearchPresenter: IImageSearchResultDataSource {
    func getNumberOfRows() -> Int {
        return searchResult.count
    }

    func getCellForRow(at index: Int) -> SearchResultImageDTO {
        return searchResult[index]
    }
}

extension ImageSearchPresenter: IImageSearchViewUpdateDelegate {
    func updateItem(id: String) {
        if let index = searchResult.firstIndex(where: { $0.id == id }) {
            searchResult[index].downloaded = true
            ui?.updateItem(at: index)
        }
    }

    func updateProgress(itemId: String, progress: Float, totalSize: String) {
        if let index = searchResult.firstIndex(where: { $0.id == itemId }) {
            ui?.updateProgress(at: index, progress: progress, totalSize: totalSize)
        }
    }

    func updateDownloadedItem(with image: SearchResultImageDTO) {
        if let index = searchResult.firstIndex(where: { $0.id == image.id }) {
            searchResult[index] = image
        }
    }
}

private extension ImageSearchPresenter {
    func performSearch(with searchQuery: String, at pageNumber: Int) {
        ui?.showActivityIndicator()
        interactor.requestData(with: searchQuery, pageNumber: pageNumber) { [weak self] result, error in

            guard let searchResult = result, error == nil else {
                if let error = error as? NetworkError {
                    Notifier.imageSearchErrorOccured(message: "Error: \(error.description)")
                } else {
                    Notifier.imageSearchErrorOccured(message: "Error: \(String(describing: error?.localizedDescription))")
                }
                return
            }
            self?.searchResult = searchResult
            self?.ui?.update()
        }
    }
}

extension ImageSearchPresenter: IImageSearchResultDelegate {
    func imageSelected(at index: Int) {
        if searchResult[index].downloaded == false {
            ui?.showDownloadMenu(at: index)
        } else {
            interactor.getDownloadedImage(with: searchResult[index].id) { [weak self] image, error in

                guard error == nil else {
                    Notifier.imageSearchErrorOccured(message: error?.localizedDescription ?? "Unknown error")
                    return
                }

                guard let image = image else {
                    Notifier.imageSearchErrorOccured(message: "Image Error")
                    return
                }
                self?.router.showImageDetails(image)
            }
        }
    }

    func imageDeselected(at index: Int) {
        ui?.hideDownloadMenu(at: index)
    }
}
