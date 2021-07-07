//
//  MultiLineTextCell.swift
//  Refuel
//
//  Created by Яна Латышева on 03.07.2021.
//

import UIKit

protocol MultiLineTextCellDelegate {
    func didGetText(_ text: String)
}

class MultiLineTextCell: UITableViewCell {

    // MARK: - Properties

    var delegate: MultiLineTextCellDelegate?

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    // TODO: - Insert placeholder
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.keyboardType = .default
        tv.layer.borderColor = UIColor.systemBlue.cgColor
        tv.layer.borderWidth = 1.5
        return tv
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


        contentView.addSubview(captionLabel)
        captionLabel.anchor(top: contentView.topAnchor, paddingTop: 20.0,
                            leading: contentView.leadingAnchor, paddingLeading: 15)

        contentView.addSubview(textView)
        textView.anchor(top: captionLabel.bottomAnchor, paddingTop: 10.0,
                        bottom: contentView.bottomAnchor, paddingBottom: 20.0,
                        leading: contentView.leadingAnchor, paddingLeading: 15,
                        trailing: contentView.trailingAnchor, paddingTrailing: 15,
                        height: 100)        
    }

    func setTextCaptionLabel(to text: String) {
        captionLabel.text = text
    }

    func setText(to text: String) {
        textView.text = text
    }

}


// MARK: - UITextViewDelegate

extension MultiLineTextCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didGetText(textView.text)
    }
}
