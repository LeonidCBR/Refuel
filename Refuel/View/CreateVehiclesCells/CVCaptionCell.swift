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
        label.font = UIFont.systemFont(ofSize: 14)
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
        contentView.addSubview(captionLabel)
        captionLabel.anchor(top: contentView.topAnchor, paddingTop: 30.0,
                            bottom: contentView.bottomAnchor, paddingBottom: 30.0,
                            centerX: contentView.centerXAnchor)
    }
    
    func setCaption(_ captionText: String) {
        captionLabel.text = captionText
    }
    
}
