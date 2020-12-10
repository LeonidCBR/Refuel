//
//  ButtonCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit


protocol ButtonCellDelegate {

    func saveButtonTapped()

}


class ButtonCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: ButtonCellDelegate?
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
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
        
        saveButton.addTarget(self,
                         action: #selector(handleSaveButtonTapped),
                         for: .touchUpInside)
        
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
