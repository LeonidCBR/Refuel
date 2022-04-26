//
//  VehicleCell.swift
//  Refuel
//
//  Created by Яна Латышева on 31.03.2021.
//

import UIKit

class VehicleCell: UITableViewCell {
    
    // MARK: - Properties
    
    var vehicle: CDVehicle? {
        didSet {
            updateUI()
        }
    }
    
    private let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
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
        
        contentView.addSubview(manufacturerLabel)
        manufacturerLabel.anchor(top: contentView.topAnchor, paddingTop: 10.0,
                                 leading: contentView.leadingAnchor, paddingLeading: 10.0)
        
        contentView.addSubview(modelLabel)
        modelLabel.anchor(top: manufacturerLabel.bottomAnchor, paddingTop: 30.0,
                          bottom: contentView.bottomAnchor, paddingBottom: 50.0,
                          leading: contentView.leadingAnchor, paddingLeading: 15.0,
                          trailing: contentView.trailingAnchor, paddingTrailing: 15.0)
    }
    
    private func updateUI() {
        guard let vehicle = vehicle else { return }
        manufacturerLabel.text = vehicle.manufacturer
        modelLabel.text = vehicle.model
    }
}
