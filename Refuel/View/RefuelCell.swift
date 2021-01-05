//
//  RefuelCell.swift
//  Refuel
//
//  Created by Яна Латышева on 13.12.2020.
//

import UIKit

class RefuelCell: UITableViewCell {
    
    // MARK: - Properties
    
    var refuel: Refuel! {
        didSet {
            updateUI()
        }
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let litersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let odometerLabel: UILabel = {
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
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    
    // MARK: - Methods
    
    private func configureUI() {

        let stackView = UIStackView(arrangedSubviews: [dateLabel,
                                                       litersLabel,
                                                       costLabel,
                                                       odometerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
//        stackView.spacing = 7.0
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor,
                         bottom: contentView.bottomAnchor,
                         leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor)
    }
    
    
    private func updateUI() {
        //TODO: use NumberFormatter and DateFormatter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: refuel.date)
        dateLabel.text = dateStr
        
        litersLabel.text = "\(refuel.liters)"
        costLabel.text = "\(refuel.cost)"
        odometerLabel.text = "\(refuel.odometer)"
    }
}
