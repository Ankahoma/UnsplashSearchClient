//
//  ImageSearchView.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

final class ImageSearchView: UIView {
    var buttonEventDelegate: IImageSearchButtonHandler?
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var twoColumnsLayout: UICollectionViewLayout!
    private var oneColumnLayout: UICollectionViewLayout!
    private var isCurrentLayoutTwoColumned = true

    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search image with keyword..."
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createTwoColumnsLayout())
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsMultipleSelection = true
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    lazy var suggestionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")

        return tableView
    }()

    lazy var showGalleryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled"),
                                     style: .plain, target: self, action: #selector(galleryButtonTapped))

        return button
    }()

    lazy var changeItemsAlignmentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"),
                                     style: .plain, target: self, action: #selector(changeItemsAlignmentButtonTapped))

        return button
    }()

    lazy var activityIndicator: UIActivityIndicatorView = .init(style: .large)

    init() {
        super.init(frame: .zero)
        setConstraints()
        twoColumnsLayout = createTwoColumnsLayout()
        oneColumnLayout = createOneColumnLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        backgroundColor = .systemBackground
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(suggestionsTableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            suggestionsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo:
                suggestionsTableView.isHidden ?
                    searchBar.bottomAnchor : suggestionsTableView.bottomAnchor,
                constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        tableViewHeightConstraint = suggestionsTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }

    func updateLayout(with numberOfRows: Int) {
        let height = CGFloat(numberOfRows) * 44.0
        tableViewHeightConstraint.constant = min(height, 220)

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    func setSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }

    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }

    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }

    func setSuggestionsDataSource(_ dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        suggestionsTableView.dataSource = dataSource
        suggestionsTableView.delegate = delegate
    }

    func showSuggestions() {
        suggestionsTableView.isHidden = false
    }

    func hideSuggestions() {
        suggestionsTableView.isHidden = true
    }

    func updateItem(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }

    func updateProgress(at index: Int, progress: Float, totalSize: String) {
        DispatchQueue.main.async { [weak self] in
            if let cell = self?.collectionView.cellForItem(at: IndexPath(row: index,
                                                                         section: 0)) as? SearchResultCell
            {
                cell.updateProgress(progress: progress, totalSize: totalSize)
            }
        }
    }

    func showActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func createTwoColumnsLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    func createOneColumnLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    @objc func galleryButtonTapped() {
        buttonEventDelegate?.showGallery()
    }

    @objc func changeItemsAlignmentButtonTapped() {
        if isCurrentLayoutTwoColumned {
            collectionView.collectionViewLayout = oneColumnLayout
            layoutIfNeeded()
            changeItemsAlignmentButton.image = UIImage(systemName: "square.grid.2x2")
            isCurrentLayoutTwoColumned = false
        } else {
            collectionView.collectionViewLayout = twoColumnsLayout
            layoutIfNeeded()
            changeItemsAlignmentButton.image = UIImage(systemName: "rectangle.grid.1x2")
            isCurrentLayoutTwoColumned = true
        }
    }
}
