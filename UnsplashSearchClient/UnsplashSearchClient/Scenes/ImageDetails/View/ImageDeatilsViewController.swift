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
        dismiss(animated: true)
    }

    func shareButtonTapped() {
        shareImage()
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
        setupDescription()
    }

    func setupNavigationBar() {
        if viewModel.isPreview {
            navigationItem.rightBarButtonItem = contentView.dismissButton
        } else {
            navigationItem.rightBarButtonItem = contentView.dismissButton
            navigationItem.leftBarButtonItem =  contentView.shareButton
        }
    }

    func setupDescription() {
        if let description = viewModel.imageDescription {
            contentView.descriptionLabel.text = description
        } else {
            contentView.descriptionLabel.isHidden = true
        }

        if let authorName = viewModel.author {
            contentView.authorLabel.text = "by " + authorName
        } else {
            contentView.authorLabel.isHidden = true
        }

        contentView.dateLabel.text = "created at " + viewModel.createdAt.convert()
    }
}

private extension ImageDetailsViewController {
    func shareImage() {
        let itemsToShare: [Any] = [viewModel.image]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        present(activityViewController, animated: true, completion: nil)
    }
}
