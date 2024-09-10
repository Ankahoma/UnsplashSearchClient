//
//  SearchResultCell.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

final class SearchResultCell: UICollectionViewCell {
    
    static let identifier = String(describing: SearchResultCell.self)
    var delegate: IImageSearchCellButtonsHandler?
    
    private var downloadingPaused = false
    
    private lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var downloadedMark: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.badge.checkmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.size.width/2
        button.isEnabled = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(downloadButtonTapped),
                         for: .touchUpInside)
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    private lazy var previewButton: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(previewButtonTapped),
                         for: .touchUpInside)
        button.setTitle("Preview", for: .normal)
        return button
    }()
    
    private lazy var downloadMenuStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [downloadButton, previewButton])
        
        stackView.backgroundColor = .init(white: 1, alpha: 0.7)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var pauseOrResumeButton: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(pauseOrResumeButtonTapped),
                         for: .touchUpInside)
        button.setTitle("Pause", for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
        label.widthAnchor.constraint(equalToConstant: 96).isActive = true
        label.textColor = .label
        
        return label
    }()
    
    private var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.tintColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pauseAndCancelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pauseOrResumeButton, cancelButton])
        
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [progressLabel, progressView])
        
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var downloadControlStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pauseAndCancelStackView, progressStackView])
        
        stackView.backgroundColor = .init(white: 1, alpha: 0.7)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupAppearance()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
}

extension SearchResultCell {
    
    func configure(with image: UIImage, downloaded: Bool, downloadItem: DownloadItem?) {
        resultImageView.image = image
        
        var showDownloadControl = false
        
        if let downloadItem = downloadItem {
            showDownloadControl = true
            
            if downloadItem.isDownloading {
                pauseOrResumeButton.setTitle("Pause", for: .normal)
                progressLabel.text = "Downloading..."
            } else {
                pauseOrResumeButton.setTitle("Resume", for: .normal)
                progressLabel.text = "Paused"
                downloadingPaused = true
            }
        }
        
        downloadedMark.isHidden = !downloaded
        downloadControlStackView.isHidden = !showDownloadControl
        downloadMenuStackView.isHidden = downloaded || !isSelected
    }
    
    func updateProgress(progress: Float, totalSize : String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
    func showDownloadMenu() {
        
        UIView.transition(with: downloadMenuStackView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.downloadMenuStackView.isHidden = false
        })
    }
    
    func hideDownloadMenu() {
        UIView.transition(with: downloadMenuStackView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.downloadMenuStackView.isHidden = true
        })
    }
}

private extension SearchResultCell {
    
    func setupAppearance() {
        downloadMenuStackView.isHidden = true
        downloadControlStackView.isHidden = true
        
        setConstraints()
    }
    
    func setConstraints() {
        contentView.addSubview(resultImageView)
        contentView.addSubview(downloadMenuStackView)
        contentView.addSubview(downloadControlStackView)
        contentView.addSubview(downloadedMark)
        
        NSLayoutConstraint.activate([
            
            resultImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            resultImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            downloadedMark.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant: 8),
            downloadedMark.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            
            
            downloadMenuStackView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor),
            downloadMenuStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            downloadMenuStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            downloadControlStackView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor),
            downloadControlStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            downloadControlStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            progressView.widthAnchor.constraint(equalTo: downloadMenuStackView.widthAnchor, multiplier: 1),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            
            pauseOrResumeButton.trailingAnchor.constraint(equalTo: downloadMenuStackView.centerXAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: pauseOrResumeButton.trailingAnchor, constant: 12)
            
        ])
    }
}

private extension SearchResultCell {
    
    @objc func downloadButtonTapped() {
        delegate?.downloadTapped(self)
    }
    
    @objc func previewButtonTapped() {
        delegate?.previewTapped(self)
    }
    
    @objc func pauseOrResumeButtonTapped() {
        if downloadingPaused {
            delegate?.resumeTapped(self)
        } else {
            delegate?.pauseTapped(self)
        }
        downloadingPaused.toggle()
    }
    
    @objc func cancelButtonTapped() {
        delegate?.cancelTapped(self)
    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}

