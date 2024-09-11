//
//  ImageDeatilsViewController.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

protocol IImageDetailsDelegate: AnyObject {
    func updateImageView(with image: UIImage)
}

protocol IImageDetailsButtonHandler: AnyObject {
    func dismissButtonTapped()
    func downloadButtonTapped()
    func shareButtonTapped()
}

class ImageDetailsViewController: UIViewController {
    private let viewModel: ImageDetailsViewModel
    private lazy var contentView = ImageDetailsView()

    init(with viewModel: ImageDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        updateImageView(with: viewModel.image)
    }

    override func loadView() {
        contentView.buttonEventDelegate = self
        view = contentView
    }
}

extension ImageDetailsViewController: IImageDetailsButtonHandler {
    func dismissButtonTapped() {
        
    }
    
    func downloadButtonTapped() {
        
    }
    
    func shareButtonTapped() {
        
    }
    
    
}

extension ImageDetailsViewController: IImageDetailsDelegate {
    func updateImageView(with image: UIImage) {
        contentView.imageView.image = image
    }
}

private extension ImageDetailsViewController {
    func setupAppearance() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = contentView.dismissButton
    }
}
