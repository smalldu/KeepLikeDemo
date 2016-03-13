//
//  ZZTopBarController.swift
//  KeepLikeDemo
//
//  Created by duzhe on 16/3/13.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

private let sw:CGFloat = UIScreen.mainScreen().bounds.width
private let sh:CGFloat = UIScreen.mainScreen().bounds.height

private let topItemWid:CGFloat = 44

class ZZTopBarController: UIViewController {
    
    private var viewControllers:[UIViewController]
    private var topValues:[String] = []
    /// 顶部bar的颜色
    var topBarColor:UIColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    
    private var angelLayer:CALayer!
    private var scrollView:UIScrollView
    private var topBarView:UIView!
    private var toplabs:[ZZTapLabel] = []
    
    var selectedItem:Int = 0{
        didSet{
            toplabs.forEach { (lab) -> () in
                lab.textColor = UIColor(white: 0.8, alpha: 0.8)
            }
            toplabs[selectedItem].textColor = UIColor.whiteColor()
        }
    }
    var topLayerOriX:CGFloat = 0
    
    init(viewControllers:[UIViewController],topValues:[String]){
        self.viewControllers = viewControllers
        self.topValues = topValues
        self.scrollView = UIScrollView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewControllers.count == 0 || topValues.count == 0{
            fatalError("子VC和topValues不能为0个")
        }
        
        topBarView = UIView()
        topBarView.frame = CGRectMake(0,0, sw, 64)
        self.view.addSubview(topBarView)
        topBarView.backgroundColor = topBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.scrollView.frame = CGRectMake(0, 64, sw, sh-64)
        self.view.addSubview(self.scrollView)
        let x = CGFloat(self.viewControllers.count)
        self.scrollView.contentSize = CGSizeMake(sw*x,sh-64)
//        self.scrollView.contentOffset = CGPointMake(0,0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        var originX = (sw - x*topItemWid)/2
        topLayerOriX = originX+12
        angelLayer = CALayer()
        angelLayer.frame = CGRectMake(topLayerOriX, 51 , 20 , 13)
        angelLayer.contents = UIImage(named: "angel")?.CGImage
        angelLayer.contentsGravity = kCAGravityTop
        angelLayer.contentsScale = UIScreen.mainScreen().scale
//        angelLayer.backgroundColor = UIColor.redColor().CGColor
        self.topBarView.layer.addSublayer(angelLayer)
        
        var i = 0
        for vc in self.viewControllers{
            
            self.addChildViewController(vc)
            self.scrollView.addSubview(vc.view)
            vc.view.frame = CGRectMake(CGFloat(i)*sw, 10, sw, sh-54)
            
            let lab = ZZTapLabel(frame: CGRectMake(originX, 20, topItemWid, topItemWid))
            lab.text = topValues[i]
            lab.font = UIFont.systemFontOfSize(13)
            lab.textAlignment = .Center
            lab.tag = i
            lab.delegate = self
//            lab.textColor = UIColor.whiteColor()
            self.toplabs.append(lab)
            
            originX += topItemWid
            self.topBarView.addSubview(lab)
            
            i++
        }
        selectedItem = 0
    }
    
}



extension ZZTopBarController:UIScrollViewDelegate,ZZTapLabelDelegate{

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = topItemWid*scrollView.contentOffset.x/sw
        guard x >= 0 && x <= CGFloat(topItemWid)*CGFloat(viewControllers.count-1) else{return}
        let oriX = topLayerOriX+x
        self.angelLayer.frame.origin.x = oriX
        if x%topItemWid == 0 && self.selectedItem != Int(x/topItemWid){
           self.selectedItem = Int(x/topItemWid)
        }
    }
    
    func tapLabel(label: ZZTapLabel) {
        let index = label.tag
        
        let oriX = topLayerOriX+CGFloat(index*44)
        
        let scrollX = CGFloat(index)*sw
        self.scrollView.contentOffset.x = scrollX
        let ani = CABasicAnimation()
        ani.duration = 0.4
        ani.keyPath = "frame.origin.x"
        ani.fromValue = self.angelLayer.frame.origin.x
        ani.toValue = oriX
        self.angelLayer.addAnimation(ani, forKey: "xxs")

        self.selectedItem = index
    }
    

}
