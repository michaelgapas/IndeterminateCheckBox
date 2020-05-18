//
//  CheckBox.swift
//  CodeExamEmapta
//
//  Created by Michael San Diego on 5/6/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

protocol CheckBoxDelegate: class {
    func didTapCheckBox(at model:CheckBoxModel)
    func didTapView(at model:CheckBoxModel)
}
class CheckBox: UIView {
    
    weak var delegate:CheckBoxDelegate?
    
    let kNibName = "CheckBox"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnView: UIButton!
    
    private var checkBoxModel: CheckBoxModel!
    
    var caption: String? {
        get { return lblTitle?.text }
        set { lblTitle.text = newValue }
    }

    var image: UIImage? {
        get { return imgState.image }
        set { imgState.image = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
       
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    func initSubviews() {
        Bundle.main.loadNibNamed(kNibName, owner: self, options: nil)
        
        contentView.frame = bounds
        imgState.contentMode = UIView.ContentMode.scaleAspectFill
        imgState.clipsToBounds = true
        addSubview(contentView)
    }

    
    func configure(with model: CheckBoxModel) {
        
        self.checkBoxModel = model
        
        lblTitle.text = model.label
        
        switch model.state {
        case .checked:
            imgState.image = UIImage(named: "Checked")
        case .indeterminate:
            imgState.image = UIImage(named: "Indeterminate")
        default:
            imgState.image = UIImage(named: "Unchecked")
        }
    }
    
    @IBAction func didTapCheckBox(_ sender: Any) {
        guard self.checkBoxModel != nil else { return }
        delegate?.didTapCheckBox(at: self.checkBoxModel)
    }
    
//    @IBAction func didTapView(_ sender: Any) {
//        guard self.checkBoxModel != nil else { return }
//        delegate?.didTapView(at: self.checkBoxModel)
//    }
}
