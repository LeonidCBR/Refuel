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
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let odometerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
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

        // TODO: - Consider to add a horizontal constraint to the odometerLabel and the descriptionLabel

    }
    
    private func updateUI() {
        guard let refuel = refuel else { return }

        dateLabel.text = refuel.date?.toString()
        odometerLabel.text = "\(refuel.odometer)"

        guard let liters = refuel.liters.toString() else {
            print("DEBUG: Error while converting liters => \(refuel.liters)!")
            return
        }

        guard let cost = refuel.cost.toString() else {
            print("DEBUG: Error while converting cost => \(refuel.cost)!")
            return
        }

        descriptionLabel.text = "\(liters) л, \(cost) руб."
    }
}
