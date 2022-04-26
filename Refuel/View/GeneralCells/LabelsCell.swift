//
//  LabelsCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit

class LabelsCell: UITableViewCell {

    // MARK: - Properties
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
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
        captionLabel.anchor(top: contentView.topAnchor, paddingTop: 20,
                            bottom: contentView.bottomAnchor, paddingBottom: 20,
                            leading: contentView.leadingAnchor, paddingLeading: 15)


        contentView.addSubview(valueLabel)
        valueLabel.anchor(top: contentView.topAnchor, paddingTop: 20,
                          bottom: contentView.bottomAnchor, paddingBottom: 20,
                          trailing: contentView.trailingAnchor, paddingTrailing: 15)

        // TODO: - Consider to add a horizontal constraint to the captionLabel and the valueLabel

    }


    func setTextCaptionLabel(to text: String) {
        captionLabel.text = text
    }

    func setTextValueLabel(to text: String) {
        valueLabel.text = text
    }

    func getTextValueLabel() -> String? {
        return valueLabel.text
    }

}
