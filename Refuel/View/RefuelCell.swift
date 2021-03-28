//
//  RefuelCell.swift
//  Refuel
//
//  Created by Яна Латышева on 13.12.2020.
//

import UIKit

class RefuelCell: UITableViewCell {
    
    // MARK: - Properties
    
    var refuel: CDRefuel? {
        didSet {
            updateUI()
        }
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14) //.systemBoldFont(ofSize: 16)
        return label
    }()
    
    private let odometerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        contentView.addSubview(dateLabel)
        dateLabel.anchor(top: contentView.topAnchor, paddingTop: 15.0,
                         centerX: contentView.centerXAnchor)
        
        contentView.addSubview(odometerLabel)
        odometerLabel.anchor(top: dateLabel.bottomAnchor, paddingTop: 10.0,
                             bottom: contentView.bottomAnchor, paddingBottom: 25.0,
                             leading: contentView.leadingAnchor, paddingLeading: 10.0)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: odometerLabel.topAnchor,
                                trailing: contentView.trailingAnchor, paddingTrailing: 10.0)
    }
    
    private func updateUI() {
        //TODO: use NumberFormatter and DateFormatter
        guard let refuel = refuel else {
            print("DEBUG: Refuel is nil!")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: refuel.date!)
        dateLabel.text = dateStr
        
        descriptionLabel.text = "\(refuel.liters) л, \(refuel.cost) руб."
        
        odometerLabel.text = "\(refuel.odometer)"
    }
}
