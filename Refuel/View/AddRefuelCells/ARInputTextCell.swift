//
//  ARInputTextCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit


protocol ARInputTextCellDelegate {

    func didGetLiters(_ liters: Double?)
    func didGetCost(_ cost: Double?)
    func didGetOdometer(_ odometer: Int?)
    
}


class ARInputTextCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: ARInputTextCellDelegate?
    
    var option: AddRefuelOption! {
        didSet {
            setKeyboardType()
        }
    }
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
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
    
    
    // MARK: - Methods
    
    private func configureUI() {
        selectionStyle = .none
        clipsToBounds = true
        
        textField.delegate = self
        
        contentView.addSubview(captionLabel)
        captionLabel.anchor(leading: contentView.leadingAnchor, paddingLeading: 15,
                            centerY: contentView.centerYAnchor)
        
        contentView.addSubview(textField)
        textField.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 15,
                         width: 100,
                         height: 30,
                         centerY: contentView.centerYAnchor)
    }
    
    private func setKeyboardType() {
        
        // TODO: - check it!
        
        switch option {
        case .litersAmount: textField.keyboardType = .decimalPad
        case .cost: textField.keyboardType = .decimalPad
        case .odometer: textField.keyboardType = .numberPad
        default:
            fatalError("DEBUG: unexpected value of cell option!")
        }
    }
    
    func setCaption(to text: String) {
        captionLabel.text = text
    }
    
    func setText(to text: String) {
        textField.text = text
    }
}


// MARK: - UITextFieldDelegate (Text validation)

extension ARInputTextCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // если уже есть , или . то false (decimal separator)
        guard let ds = NumberFormatter().decimalSeparator else {
            print("DEBUG: Error - Decimal separator is nil!!!\nIgnore!")
            return true
        }
        
        // Ignore input if text have contaned decimal separator already
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
        
        // Convert the value and pass it
        
        let number = NumberFormatter().number(from: textField.text ?? "")
        
        if  option == .litersAmount {
//            let liters = Double(textField.text ?? "")
            delegate?.didGetLiters( number?.doubleValue )
            
        } else if option == .cost {
//            let cost = Double(textField.text ?? "")
            delegate?.didGetCost( number?.doubleValue )
            
        } else if option == .odometer {
//            let odometer = Int(textField.text ?? "")
            delegate?.didGetOdometer( number?.intValue )
        }
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let value = Double(textField.text ?? ""), value == 0 {
            textField.text = ""
        }
        return true
    }
}
