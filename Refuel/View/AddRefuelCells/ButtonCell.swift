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
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self,
                     action: #selector(handleSaveButtonTapped),
                     for: .touchUpInside)
        btn.setTitle("Сохранить", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        return btn
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
        
        contentView.addSubview(saveButton)
        
        // TODO: add constraint to width = contentView.width * 0.70
        
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
