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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        contentView.addSubview(manufacturerLabel)
        manufacturerLabel.anchor(top: contentView.topAnchor, paddingTop: 10.0,
                                 leading: contentView.leadingAnchor, paddingLeading: 10.0)
        
        contentView.addSubview(modelLabel)
        modelLabel.anchor(centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
    }
    
    private func updateUI() {
        guard let vehicle = vehicle else { return }
        manufacturerLabel.text = vehicle.manufacturer
        modelLabel.text = vehicle.model
    }
    
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

}
