//
//  ImageDeatilsView.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

class ImageDetailsView: UIView {
    
    var buttonEventDelegate: IImageDetailsButtonHandler?
    
    lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close,
                                     target: self,
                                     action: #selector(dismissButtonTapped))
        return button
    }()
    
    lazy var downloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"),
                                     style: .plain, target: self, action: #selector(downloadButtonTapped))
        button.isEnabled = false
        return button
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                     style: .plain, target: self, action: #selector(shareButtonTapped))
        button.image = UIImage(systemName: "square.and.arrow.up")
        button.isEnabled = false
        return button
    }()
    
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                     style: .plain, target: self, action: #selector(deleteButtonTapped))
        button.isEnabled = false
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    
    init() {
        super.init(frame: .zero)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
}

private extension ImageDetailsView {
    
    func setConstraints() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc func dismissButtonTapped() {
        buttonEventDelegate.dismissButtonTapped()
    }
    
    @objc func downloadButtonTapped() {
        buttonEventDelegate.downloadButtonTapped()
    }
    
    @objc func shareButtonTapped() {
        buttonEventDelegate.shareButtonTapped()
    }
    
    @objc func deleteButtonTapped() {
        
    }
    
}

