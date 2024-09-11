//
//  ImageSearchViewController.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

protocol IImageSearchButtonHandler {
    func showGallery()
}

protocol IImageSearchView: AnyObject {
    func update()
    func updateItem(at index: Int)
    func updateProgress(at index: Int, progress: Float, totalSize: String)

    func showActivityIndicator()
    func hideActivityIndicator()

    func showDownloadMenu(at index: Int)
    func hideDownloadMenu(at index: Int)
}

protocol IImageSearchCellButtonsHandler {
    func downloadTapped(_ cell: SearchResultCell)
    func previewTapped(_ cell: SearchResultCell)
    func pauseTapped(_ cell: SearchResultCell)
    func resumeTapped(_ cell: SearchResultCell)
    func cancelTapped(_ cell: SearchResultCell)
}

class ImageSearchViewController: UIViewController {
    private let presenter: IImageSearchPresenter
    private let searchResultDataSource: IImageSearchResultDataSource
    private let searchResultDelegate: IImageSearchResultDelegate

    private var recentSearches: [String] = []
    private var filteredSearches: [String] = []

    private var searchBar: UISearchBar = .init()
    private var pageLoaded: Int = 1

    private lazy var contentView: ImageSearchView = {
        let view = ImageSearchView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        view.setSearchBarDelegate(self)
        view.setSuggestionsDataSource(self, delegate: self)

        return view
    }()

    init(presenter: IImageSearchPresenter,
         dataSource: IImageSearchResultDataSource,
         delegate: IImageSearchResultDelegate)
    {
        self.presenter = presenter
        searchResultDataSource = dataSource
        searchResultDelegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_: Bool) {
        searchBar.text = ""
        presenter.viewWillAppear()
        loadRecentSearches()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupAppearance()
    }

    override func loadView() {
        contentView.buttonEventDelegate = self
        view = contentView
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        pageLoaded = 1
        presenter.performNewSearch(with: searchText, at: pageLoaded)
        saveRecentSearch(searchText)
        contentView.hideSuggestions()
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filterSearchSuggestions(for: searchText)
        contentView.updateLayout(with: filteredSearches.count)
    }
}

extension ImageSearchViewController: IImageSearchButtonHandler {
    func showGallery() {
        presenter.showGallery()
    }
}

extension ImageSearchViewController: IImageSearchView {
    func updateItem(at index: Int) {
        contentView.updateItem(at: index)
    }

    func updateProgress(at index: Int, progress: Float, totalSize: String) {
        contentView.updateProgress(at: index, progress: progress, totalSize: totalSize)
    }

    func update() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }

    func showActivityIndicator() {
        contentView.showActivityIndicator()
    }

    func hideActivityIndicator() {
        contentView.hideActivityIndicator()
    }

    func showDownloadMenu(at index: Int) {
        if let cell = contentView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SearchResultCell {
            cell.showDownloadMenu()
        }
    }

    func hideDownloadMenu(at index: Int) {
        if let cell = contentView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SearchResultCell {
            cell.hideDownloadMenu()
        }
    }
}

extension ImageSearchViewController: INotifierDelegate {
    func showAlert(message: String) {
        if contentView.activityIndicator.isAnimating {
            hideActivityIndicator()
        }

        let alert = UIAlertController(title: "Something is wrong :(", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ImageSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        cell.textLabel?.text = filteredSearches[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = filteredSearches[indexPath.row]
        contentView.searchBar.text = selectedSearch
        searchBarSearchButtonClicked(contentView.searchBar)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        searchResultDataSource.getNumberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell {
            presenter.configureCell(cell, at: indexPath.row)
            cell.delegate = self
            cell.isUserInteractionEnabled = true

            return cell
        } else {
            fatalError(CommonError.failedToLoadData)
        }
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchResultDataSource.getNumberOfRows() - 2 {
            pageLoaded += 1
            presenter.updateSearchResult(at: pageLoaded)
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, shouldSelectItemAt _: IndexPath) -> Bool {
        true
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchResultDelegate.imageSelected(at: indexPath.item)
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        searchResultDelegate.imageDeselected(at: indexPath.item)
    }
}

extension ImageSearchViewController: IImageSearchCellButtonsHandler {
    func downloadTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.startDownloadImage(at: indexPath.row)
            contentView.updateItem(at: indexPath.row)
        }
    }

    func previewTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.showImagePreview(at: indexPath.row)
            contentView.updateItem(at: indexPath.row)
        }
    }

    func pauseTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.pauseDownloadImage(at: indexPath.row)
            contentView.updateItem(at: indexPath.row)
        }
    }

    func resumeTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.resumeDownloadImage(at: indexPath.row)
            contentView.updateItem(at: indexPath.row)
        }
    }

    func cancelTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.cancelDownloadImage(at: indexPath.row)
            contentView.updateItem(at: indexPath.row)
        }
    }
}

private extension ImageSearchViewController {
    func setupAppearance() {
        setupNavigationBar()
        setupNotifications()
    }

    func setupNavigationBar() {
        navigationItem.title = "ImageSearch"
        navigationItem.rightBarButtonItem = contentView.showGalleryButton
        navigationItem.leftBarButtonItem = contentView.changeItemsAlignmentButton
    }

    func setupNotifications() {
        Notifier.imageSearchNotifier = self
    }

    func loadRecentSearches() {
        let defaults = UserDefaults.standard
        recentSearches = defaults.stringArray(forKey: "recentSearches") ?? []
    }

    func saveRecentSearch(_ query: String) {
        if recentSearches.contains(query) {
            return
        }

        if recentSearches.count == 5 {
            recentSearches.removeFirst()
        }

        recentSearches.append(query)
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }

    func filterSearchSuggestions(for query: String) {
        filteredSearches = recentSearches.filter { $0.lowercased().contains(query.lowercased()) }
        if filteredSearches.isEmpty {
            contentView.hideSuggestions()
        } else {
            contentView.showSuggestions()
        }
        contentView.suggestionsTableView.reloadData()
    }
}
