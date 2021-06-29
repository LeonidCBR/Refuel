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
        label.font = UIFont.boldSystemFont(ofSize: 14) //.systemBoldFont(ofSize: 16)
        return label
    }()

    private let odometerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
        guard let service = service else {
            print("DEBUG: Service is nil!")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: service.date!)
        dateLabel.text = dateStr

        odometerLabel.text = "\(service.odometer)"

        costLabel.text = "\(service.cost) руб."

        serviceLabel.text = service.text

//        let tmpText = "\(service.date!) \(service.odometer) \(service.cost) \(service.text!)"
//        textLabel?.text = tmpText
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

}
