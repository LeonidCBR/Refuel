//
//  ServiceCell.swift
//  Refuel
//
//  Created by Яна Латышева on 29.06.2021.
//

import UIKit

class ServiceCell: UITableViewCell {

    // MARK: Properties

    var service: CDService? {
        didSet {
            return updateUI()
        }
    }

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
        print("DEBUG: configure UI of service cell")
    }

    private func updateUI() {
        guard let service = service else {
            print("DEBUG: Service is nil!")
            return
        }

        print("DEBUG: \(service.date) \(service.odometer) \(service.cost) \(service.text)")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

}
