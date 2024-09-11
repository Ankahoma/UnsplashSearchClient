//
//  SectionHeader.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 11.09.2024.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"

    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupAppearance() {
        addSubview(headerLabel)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
