//
//  AddRefuelDateLabelCell.swift
//  Refuel
//
//  Created by Яна Латышева on 06.12.2020.
//

import UIKit

protocol AddRefuelCellDelegate {
    var dateDelegate: Date? { get set }
    var litersDelegate: Double? { get set }
    var sumDelegate: Double? { get set }
    var odoDelegate: Int? { get set }
    func saveButtonTapped()
}

class AddRefuelCell: UITableViewCell {

    // MARK: - Properties
    var delegate: AddRefuelCellDelegate?
    
    var cellOption: CellOption? {
        didSet {
            guard let option = cellOption else { return }
            switch option {
            case .dateLabel:
                configureCaptionLabel(withText: option.description)
                configureDateLabel()
            case .datePicker:
                configureDatePicker()
            case .litersAmount:
                configureCaptionLabel(withText: option.description)
                configureTextField()
            case .sum:
                configureCaptionLabel(withText: option.description)
                configureTextField()
            case .odo:
                configureCaptionLabel(withText: option.description)
                configureTextField()
            case .save:
                configureSaveButton()
            }
        }
    }
    
    lazy private var captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        let currentDate = Date()
        delegate?.dateDelegate = currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        label.text = dateFormatter.string(from: currentDate)
        return label
    }()
    
    lazy private var datePicker: UILabel = {
        // DEBUG
        let dp = UILabel()
        dp.font = UIFont.boldSystemFont(ofSize: 16)
        dp.text = "DEBUG: !date picker is here!"
        return dp
    }()
    
    lazy private var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self,
                         action: #selector(handleSaveButtonTapped),
                         for: .touchUpInside)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func configureCaptionLabel(withText text: String) {
        captionLabel.text = text
        contentView.addSubview(captionLabel)
        captionLabel.anchor(leading: contentView.leadingAnchor, paddingLeading: 15,
                            centerY: contentView.centerYAnchor)
    }
    
    private func configureDateLabel() {
        print("DEBUG: configure date")
        contentView.addSubview(dateLabel)
        dateLabel.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 15,
                         centerY: contentView.centerYAnchor)
    }
    
    private func configureTextField() {
        contentView.addSubview(textField)
        textField.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 15,
                         width: 100,
                         height: 30,
                         centerY: contentView.centerYAnchor)
    }
    
    private func configureDatePicker() {
        contentView.addSubview(datePicker)
        datePicker.anchor(centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
    }
    
    private func configureSaveButton() {
        contentView.addSubview(saveButton)
        saveButton.anchor(width: 200,
                          height: 40,
                          centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleSaveButtonTapped() {
        delegate?.saveButtonTapped()
    }
}


// MARK: - UITextFieldDelegate

extension AddRefuelCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let option = cellOption else { return }
        
        if option == .litersAmount {
            delegate?.litersDelegate = Double(textField.text ?? "")
        }

        if option == .sum {
            delegate?.sumDelegate = Double(textField.text ?? "")
        }

        if option == .odo {
            delegate?.odoDelegate = Int(textField.text ?? "")
        }
    }
}
