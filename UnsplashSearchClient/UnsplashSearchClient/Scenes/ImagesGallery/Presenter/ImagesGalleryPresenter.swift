//
//  ImagesGalleryPresenter.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import Foundation

protocol IImagesGalleryPresenter {
    func didLoad(ui: IImagesGalleryView)
    func configureCell(_ cell: ImagesGalleryCell, at section: Int, index: Int, selectionMode: Bool)
    func removeButtonTapped()
}

protocol IImagesGalleryDataSource {
    func getNumberOfSections() -> Int
    func getNumberOfItemsInSection(_ section: Int) -> Int
    func getCellForRow(at section: Int, index: Int) -> GalleryImageViewModel
    func getHeader(for section: Int) -> String
}

protocol IImagesGalleryDelegate {
    func imageSelected(at section: Int, index: Int, selectionModeIsOn: Bool, numberOfSelectedItems: (Int) -> Void)
    func imageDeselected(at section: Int, index: Int, numberOfSelectedItems: (Int) -> Void)
}

final class ImagesGalleryPresenter {
    weak var ui: IImagesGalleryView?
    private var interactor: IImagesGalleryInteractor
    private var router: ImagesGalleryRouter

    private var fetchResult: [[GalleryImageViewModel]] = [[]]

    private var selectedImages: [GalleryImageViewModel] = []

    init(interactor: IImagesGalleryInteractor, router: ImagesGalleryRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ImagesGalleryPresenter: IImagesGalleryPresenter {
    func didLoad(ui: any IImagesGalleryView) {
        self.ui = ui
        fetchImages()
        self.ui?.update()
    }

    func configureCell(_ cell: ImagesGalleryCell, at section: Int, index: Int, selectionMode: Bool) {
        let image = fetchResult[section][index].image
        cell.configure(with: image, selectionModeIsOn: selectionMode)
    }

    func removeButtonTapped() {
        if selectedImages.isEmpty == false {
            for image in selectedImages {
                interactor.removeImages(image)
            }
            selectedImages = []

            fetchImages()
            ui?.update()
        }
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDataSource {
    func getNumberOfSections() -> Int {
        return fetchResult.count
    }

    func getNumberOfItemsInSection(_ section: Int) -> Int {
        return fetchResult[section].count
    }

    func getCellForRow(at section: Int, index: Int) -> GalleryImageViewModel {
        return fetchResult[section][index]
    }

    func getHeader(for section: Int) -> String {
        guard let item = fetchResult[section].first else {
            return "Empty Header"
        }
        return item.cathegory
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDelegate {
    func imageSelected(at section: Int, index: Int, selectionModeIsOn: Bool, numberOfSelectedItems: (Int) -> Void) {
        if selectionModeIsOn {
            selectedImages.append(fetchResult[section][index])
            ui?.setCellSelectionIcon(at: IndexPath(item: index, section: section), isSelected: true)
            numberOfSelectedItems(selectedImages.count)
        } else {
            selectedImages = []
            guard let sourceVC = ui as? ImagesGalleryViewController else {
                fatalError(CommonError.failedToShowModalWindow)
            }
            router.showImageModally(with: ImageDetailsViewModel(with: fetchResult[section][index]), at: sourceVC)
        }
    }

    func imageDeselected(at section: Int, index: Int, numberOfSelectedItems: (Int) -> Void) {
        let image = fetchResult[section][index]
        selectedImages = selectedImages.filter { $0.id != image.id }
        ui?.setCellSelectionIcon(at: IndexPath(item: index, section: section), isSelected: false)
        numberOfSelectedItems(selectedImages.count)
    }
}

private extension ImagesGalleryPresenter {
    func fetchImages() {
        interactor.fetchImages { [weak self] result, error in

            guard let fetchResult = result, error == nil else {
                if let error = error as? NetworkError {
                    Notifier.imageSearchErrorOccured(message: "Error: \(error.description)")
                } else {
                    Notifier.imageSearchErrorOccured(message: "Error: \(String(describing: error?.localizedDescription))")
                }
                return
            }
            self?.fetchResult = fetchResult
        }
    }
}
