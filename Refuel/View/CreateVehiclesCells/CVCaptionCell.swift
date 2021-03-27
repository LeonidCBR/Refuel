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
//        label.text = "Добавление транспортного средства"
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
        captionLabel.anchor(centerX: contentView.centerXAnchor,
                            centerY: contentView.centerYAnchor)
    }
    
    func setCaption(_ captionText: String) {
        captionLabel.text = captionText
    }
    
}
