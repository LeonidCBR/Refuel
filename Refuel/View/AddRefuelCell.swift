//
//  AddRefuelDateLabelCell.swift
//  Refuel
//
//  Created by Яна Латышева on 06.12.2020.
//

import UIKit


protocol AddRefuelCellDelegate {
    
    var date: Date? { get set }
    var liters: Double? { get set }
    var cost: Double? { get set }
    var odometer: Int? { get set }
    
    func dateChanged(newDate date: Date)
    
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
        delegate?.date = currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        label.text = dateFormatter.string(from: currentDate)
        return label
    }()
    
    lazy private var datePicker: UIDatePicker = {
        // DEBUG
        let datePicker = UIDatePicker()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
            // TODO: check for old versions!
        }
        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
        return datePicker
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
        
        // TODO: check for old versions!
        // if #available(iOS 14.0, *)
        clipsToBounds = true
        datePicker.anchor(centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
        datePicker.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    private func configureSaveButton() {
        contentView.addSubview(saveButton)
        saveButton.anchor(width: 200,
                          height: 40,
                          centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
    }
    
    func setDate(to date: Date) {
        guard let cellOption = cellOption, cellOption == .dateLabel else { return }
        
        delegate?.date = date
        
        // set date to label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: date)
        dateLabel.text = dateStr
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleDateChanged() {
        delegate?.dateChanged(newDate: datePicker.date)
    }
    
    @objc private func handleSaveButtonTapped() {
        delegate?.saveButtonTapped()
    }
}


// MARK: - UITextFieldDelegate

extension AddRefuelCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let option = cellOption else { return }
        
        if option == .litersAmount {
            delegate?.liters = Double(textField.text ?? "")
            
        } else if option == .sum {
            delegate?.cost = Double(textField.text ?? "")
            
        } else if option == .odo {
            delegate?.odometer = Int(textField.text ?? "")
        }
    }
}
