//
//  DatePickerCell.swift
//  Refuel
//
//  Created by Яна Латышева on 08.12.2020.
//

import UIKit


protocol DatePickerCellDelegate  {
    
    func dateChanged(to date: Date)

}


class DatePickerCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: DatePickerCellDelegate?
    
    var datePicker: UIDatePicker = {
        // DEBUG
        let datePicker = UIDatePicker()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
            // TODO: check for old versions!
        }
        
        return datePicker
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
        
        datePicker.addTarget(self,
                             action: #selector(handleDateChanged),
                             for: .valueChanged)
        
        contentView.addSubview(datePicker)
        
        // TODO: check for old versions!
        // if #available(iOS 14.0, *)
        
        datePicker.anchor(centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
        datePicker.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    func setDate(to date: Date) {
        datePicker.setDate(date, animated: false)
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleDateChanged() {
        delegate?.dateChanged(to: datePicker.date)
    }
}
