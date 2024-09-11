//
//  ImagesGalleryCell.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 10.09.2024.
//

import UIKit

class ImagesGalleryCell: UICollectionViewCell {
    static let identifier = "ImagesGalleryCell"

    var selectionModeCheck: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGreen
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }

    func configure(with image: UIImage, selectionModeIsOn: Bool) {
        selectionModeCheck.isHidden = !selectionModeIsOn
        setSelected()

        imageView.image = image
    }

    func setSelected() {
        if isSelected {
            var config = UIImage.SymbolConfiguration(paletteColors: [.white, .systemGreen])
            selectionModeCheck.preferredSymbolConfiguration = config
            selectionModeCheck.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            selectionModeCheck.image = UIImage(systemName: "circle")
        }
    }
}

private extension ImagesGalleryCell {
    func setConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectionModeCheck)

        NSLayoutConstraint.activate([
            selectionModeCheck.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            selectionModeCheck.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),

            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
