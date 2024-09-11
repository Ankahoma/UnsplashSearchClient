//
//  ImagesGalleryView.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

class ImagesGalleryView: UIView {
    var buttonEventDelegate: IImagesGalleryButtonsHandler?

    private var selectionModeOn = false {
        didSet {
            selectImagesButton.title = selectionModeOn ?
                "Cancel" : "Select"
            removeImagesButton.tintColor = selectionModeOn ?
                .red : .systemBackground
            removeImagesButton.isHidden = !selectionModeOn
        }
    }

    lazy var selectImagesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select",
                                     style: .plain, target: self, action: #selector(selectButtonTapped))
        return button
    }()

    lazy var removeImagesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                     style: .plain, target: self, action: #selector(removeButtonTapped))
        button.tintColor = .systemBackground
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ImagesGalleryCell.self, forCellWithReuseIdentifier: ImagesGalleryCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionHeader.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsMultipleSelection = true
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setupAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
}

extension ImagesGalleryView {
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }

    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
}

private extension ImagesGalleryView {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSpacing = CGFloat(2)
        let sectionSpacing = CGFloat(20)

        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2 / 3), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)

            let verticalStackItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 2))
            let verticalStackItem = NSCollectionLayoutItem(layoutSize: verticalStackItemSize)
            verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)

            let verticalStackGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
            let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalStackGroupSize, repeatingSubitem: verticalStackItem, count: 2)

            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(3 / 5))
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item, verticalStackGroup])

            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionSpacing / 2, leading: 0, bottom: sectionSpacing, trailing: 0)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(24.0))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
        return layout
    }

    func setupAppearance() {
        backgroundColor = .systemBackground
        setConstraints()
    }

    func setConstraints() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    @objc func selectButtonTapped() {
        selectionModeOn.toggle()
        buttonEventDelegate?.selectImagesButtonTapped()
    }

    @objc func removeButtonTapped() {
        buttonEventDelegate?.removeImagesButtonTapped()
    }
}
