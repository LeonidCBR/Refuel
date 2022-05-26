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

    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
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
                             //bottom: contentView.bottomAnchor, paddingBottom: 25.0,
                             leading: contentView.leadingAnchor, paddingLeading: 10.0)

        contentView.addSubview(costLabel)
        costLabel.anchor(top: odometerLabel.topAnchor,
                                trailing: contentView.trailingAnchor, paddingTrailing: 10.0)

        contentView.addSubview(serviceLabel)
        serviceLabel.anchor(top: odometerLabel.bottomAnchor, paddingTop: 10.0,
                            bottom: contentView.bottomAnchor, paddingBottom: 25.0,
                            leading: contentView.leadingAnchor, paddingLeading: 10.0,
                            trailing: contentView.trailingAnchor, paddingTrailing: 10.0)
    }

    private func updateUI() {
        guard let service = service else { return }

        dateLabel.text = service.date?.toString()
        odometerLabel.text = "\(service.odometer)"
        serviceLabel.text = service.text

        let currencySymbol = Locale.current.currencySymbol ?? "" // "$"
        if let cost = service.cost.toString() {
            costLabel.text = "\(cost) \(currencySymbol)"
        } else {
            costLabel.text = "\(service.cost) \(currencySymbol)"
        }
    }

}
