//
//  ParentViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 14/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ParentViewController: ButtonBarPagerTabStripViewController {


    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    override func viewDidLoad() {
//        // change selected bar color
//        settings.style.buttonBarBackgroundColor = .white
//        settings.style.buttonBarItemBackgroundColor = .white
//        settings.style.selectedBarBackgroundColor = greenColor
//        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
//        settings.style.selectedBarHeight = 2.0
//        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemTitleColor = .gray
//        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
//        settings.style.buttonBarLeftContentInset = 0
//        settings.style.buttonBarRightContentInset = 0
//
//        settings.style.buttonBarItemFont = UIFont(name:"Helvetica",size:18)!
//
//        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
//            guard changeCurrentIndex == true else { return }
//            oldCell?.label.textColor = .gray
//            newCell?.label.textColor = greenColor
//        }
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
        // set up style before super view did load is executed
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        //-
        
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont(name:"HelveticaNeue",size:19)!
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
//        settings.style.buttonBarMinimumLineSpacing = 0

                settings.style.buttonBarLeftContentInset = 0
                settings.style.buttonBarRightContentInset = 0
        super.viewDidLoad()
        
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
 
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
        
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
        return [child_1, child_2]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
