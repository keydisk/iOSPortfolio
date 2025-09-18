//
//  BookMarkCell.swift
//  SearchApp
//
//  Created by JuYoung choi on 9/16/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Domain

class BookMarkCell: UITableViewCell {

    static let identifier = "BookMarkCell"

    private var articleImageViewHeightConstraint: Constraint?
    var onLayoutUpdateNeeded: (() -> Void)?

    // MARK: - UI Components
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground // Placeholder color

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Kingfisher의 이미지 다운로드 작업을 취소하고 이미지를 초기화
        articleImageView.kf.cancelDownloadTask()
        articleImageView.image = nil

        // 텍스트 레이블 초기화
        titleLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Public Methods

    /// Configures the cell with an image, title, and date.
    public func configure(model: BookMarkEntity) {

        articleImageView.kf.setImage(
            with: model.thumbmailUrl,
            placeholder: UIImage(systemName: "photo.artframe"),
            options: [
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let value):
                let image = value.image

                let aspectRatio = image.size.height / image.size.width
                let newHeight = self.articleImageView.frame.width * aspectRatio
                self.articleImageViewHeightConstraint?.update(offset: newHeight)

            case .failure:
                self.articleImageViewHeightConstraint?.update(offset: 60)
            }

            self.onLayoutUpdateNeeded?()
        }

        titleLabel.text = model.title
        dateLabel.text  = model.printDate
    }

    // MARK: - Private Methods

    private func setupUI() {
        // Add subviews to the cell's content view
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        articleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(80)
            self.articleImageViewHeightConstraint = make.height.equalTo(60).priority(.high).constraint
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(articleImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(articleImageView.snp.top)
        }

        dateLabel.snp.makeConstraints { make in

            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }

}
