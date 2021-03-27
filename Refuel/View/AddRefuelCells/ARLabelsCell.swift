//
//  LabelsCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit

class ARLabelsCell: UITableViewCell {

    // MARK: - Properties
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        label.text = dateFormatter.string(from: currentDate)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        selectionStyle = .none
        clipsToBounds = true

        contentView.addSubview(captionLabel)
        captionLabel.anchor(leading: contentView.leadingAnchor, paddingLeading: 15,
                            centerY: contentView.centerYAnchor)

        contentView.addSubview(dateLabel)
        dateLabel.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 15,
                         centerY: contentView.centerYAnchor)
    }
    
    func setDate(to date: Date) {     
        // set date to label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: date)
        dateLabel.text = dateStr
    }
}
