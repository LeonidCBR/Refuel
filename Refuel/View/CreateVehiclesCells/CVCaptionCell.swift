//
//  LabelCell.swift
//  Refuel
//
//  Created by Яна Латышева on 26.03.2021.
//

import UIKit

class CVCaptionCell: UITableViewCell {

    // MARK: - Properties
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        selectionStyle = .none
        clipsToBounds = true

        contentView.addSubview(captionLabel)
        captionLabel.anchor(top: contentView.topAnchor, paddingTop: 20.0,
                            bottom: contentView.bottomAnchor, paddingBottom: 20.0,
                            leading: contentView.leadingAnchor, paddingLeading: 15.0,
                            trailing: contentView.trailingAnchor, paddingTrailing: 15.0)
    }
    
    func setCaption(_ captionText: String) {
        captionLabel.text = captionText
    }
    
}
