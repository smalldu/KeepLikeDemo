//
//  ZZTapLabel.swift
//  KeepLikeDemo
//
//  Created by duzhe on 16/3/13.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

protocol ZZTapLabelDelegate:NSObjectProtocol{
    
    func tapLabel(label:ZZTapLabel)
    
}

class ZZTapLabel: UILabel {

    weak var delegate:ZZTapLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapLabel")
        self.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func tapLabel(){
        
        delegate?.tapLabel(self)
    }
    
    
}
