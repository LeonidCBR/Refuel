//
//  InputTextCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit


protocol InputTextCellDelegate {

    func didGetValue(_ textField: UITextField, tableViewCell: UITableViewCell)
}


class InputTextCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: InputTextCellDelegate?

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.preferredFont(forTextStyle: .body)
        tf.adjustsFontForContentSizeCategory = true
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        return tf
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
        
        textField.delegate = self

        contentView.addSubview(textField)
        textField.anchor(top: contentView.topAnchor, paddingTop: 20.0,
                         bottom: contentView.bottomAnchor, paddingBottom: 20.0,
                         trailing: contentView.trailingAnchor, paddingTrailing: 15.0,
                         width: 100.0,
                         height: 34.0)

        contentView.addSubview(captionLabel)
        captionLabel.anchor(leading: contentView.leadingAnchor, paddingLeading: 15.0,
                            centerY: textField.centerYAnchor)
    }


    func setTextCaptionLabel(to text: String) {
        captionLabel.text = text
    }

}


// MARK: - UITextFieldDelegate (Text validation)

extension InputTextCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let ds = NumberFormatter().decimalSeparator else {
            print("DEBUG: Error - Decimal separator is nil!!!\nIgnore!")
            return true
        }
        
        // Ignore input if text have contaned decimal separator ("," or ".") already
        if string == ds {
            if let text = textField.text, text.contains(ds) {
                return false
            }
        }
        
        // Ignore input if text have nore then 4 digits after decimal separator
        if let _ = Int(string) {
            if let text = textField.text, text.split(separator: Character(ds)).count >= 2, text.split(separator: Character(ds))[1].count >= 4 {
                return false
            }
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didGetValue(textField, tableViewCell: self)
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        // Clear text field if it's text equals 0
        if let value = Double(textField.text ?? ""), value == 0 {
            textField.text = ""
        }

        return true
    }
}
