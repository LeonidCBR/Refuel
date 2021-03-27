//
//  CVInputTextCell.swift
//  Refuel
//
//  Created by Яна Латышева on 26.03.2021.
//

import UIKit

protocol CVInputTextCellDelegate {
    func didChangeText(_ inputTextCell: CVInputTextCell, withText text: String)
}

class CVInputTextCell: UITableViewCell {

    // MARK: - Properties
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    var delegate: CVInputTextCellDelegate?
    var cellOption: InputTextCellOption!
    
    
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
        contentView.addSubview(textField)
        
        // TODO: add constraint to width = contentView.width * 0.70
        
        textField.anchor(width: 200.0,
                         height: 30.0,
                         centerX: contentView.centerXAnchor,
                         centerY: contentView.centerYAnchor)
    }
    
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
}


// MARK: - UITextFieldDelegate

extension CVInputTextCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didChangeText(self, withText: textField.text ?? "")
    }
}
