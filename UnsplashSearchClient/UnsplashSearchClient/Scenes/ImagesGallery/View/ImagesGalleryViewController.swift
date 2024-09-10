//
//  ImagesGalleryViewController.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

protocol IImagesGalleryView: AnyObject {
    func update()
    func setCellSelectionIcon(at indexPath: IndexPath, isSelected: Bool)
}

protocol IImagesGalleryButtonsHandler {
    func selectImagesButtonTapped()
    func removeImagesButtonTapped()
}

class ImagesGalleryViewController: UIViewController {
    private let presenter: IImagesGalleryPresenter
    private let galleryDataSource: IImagesGalleryDataSource
    private let galleryDelegate: IImagesGalleryDelegate
    private var selectionModeIsOn = false
    
    private lazy var contentView: ImagesGalleryView = {
        let view = ImagesGalleryView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        view.buttonEventDelegate = self
        
        return view
    }()
    
    init(presenter: IImagesGalleryPresenter, galleryDataSource: IImagesGalleryDataSource, galleryDelegate: IImagesGalleryDelegate) {
        self.presenter = presenter
        self.galleryDataSource = galleryDataSource
        self.galleryDelegate = galleryDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupAppearance()
    }
    
    override func loadView() {
        view = contentView
    }
}

extension ImagesGalleryViewController: IImagesGalleryView {
    
    func update() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }
    
    func setCellSelectionIcon(at indexPath: IndexPath, isSelected: Bool) {
        guard let cell = contentView.collectionView.cellForItem(at: indexPath) as? ImagesGalleryCell else { return }
        cell.isSelected = isSelected
        cell.setSelected()
    }
}

extension ImagesGalleryViewController: IImagesGalleryButtonsHandler {
    func selectImagesButtonTapped() {
        selectionModeIsOn.toggle()
        update()
    }
    
    func removeImagesButtonTapped() {
        presenter.removeButtonTapped()
        update()
    }
}

extension ImagesGalleryViewController: INotifierDelegate {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImagesGalleryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return galleryDataSource.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryDataSource.getNumberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesGalleryCell.identifier, for: indexPath) as? ImagesGalleryCell {
            
            presenter.configureCell(cell, at: indexPath.section, index: indexPath.item, selectionMode: selectionModeIsOn)
            cell.isUserInteractionEnabled = true
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ImagesGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryDelegate.imageSelected(at: indexPath.section,
                                      index: indexPath.item,
                                      selectionModeIsOn: selectionModeIsOn)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if selectionModeIsOn {
            galleryDelegate.imageDeselected(at: indexPath.section, index: indexPath.item)
        }
    }
}

private extension ImagesGalleryViewController {
    func setupAppearance() {
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        navigationItem.title = "Dowloaded images"
        navigationItem.rightBarButtonItems = [contentView.selectImagesButton, contentView.removeImagesButton]
    }
}
