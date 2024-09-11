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
    required init?(coder _: NSCoder) {
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
        setupAppearance()
    }
}

extension ImagesGalleryViewController: INotifierDelegate {
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ImagesGalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return galleryDataSource.getNumberOfSections()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = contentView.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
            
            headerView.headerLabel.text = galleryDataSource.getHeader(for: indexPath.section)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

        if elementKind == UICollectionView.elementKindSectionHeader {
            layoutAttributes.frame = CGRect(x: 0.0, y: 0.0, width: 64, height: 44)
        }
        return layoutAttributes
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 24)
    }
}

extension ImagesGalleryViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryDelegate.imageSelected(at: indexPath.section,
                                      index: indexPath.item,
                                      selectionModeIsOn: selectionModeIsOn) { numberOfSelectedItems in
            self.navigationItem.title = "\(numberOfSelectedItems) items selected"
            self.navigationItem.rightBarButtonItem = contentView.removeImagesButton
            
        }
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if selectionModeIsOn {
            galleryDelegate.imageDeselected(at: indexPath.section, index: indexPath.item) { numberOfSelectedItems in
                self.navigationItem.title = numberOfSelectedItems == 0 ? "Dowloaded images" : "\(numberOfSelectedItems) items selected"
                self.navigationItem.rightBarButtonItem = numberOfSelectedItems == 0 ? contentView.selectImagesButton : contentView.removeImagesButton
            }
        }
    }
}

private extension ImagesGalleryViewController {
    func setupAppearance() {
        navigationItem.title = "Dowloaded images"
        navigationItem.rightBarButtonItem = contentView.selectImagesButton
    }
}
