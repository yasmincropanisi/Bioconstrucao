//
//  AllWorkshopsViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class AllWorkshopsViewController: UIViewController {
    
    var location:Location!
    var workshopServices: WorkshopServices!
    var workshops: [Workshop] = [Workshop]()
    @IBOutlet weak var allWorkshopsTableView: UITableView!
    var imageServices: ImageServices!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageServices = ImageServices(delegate: self)
        
        self.workshopServices = WorkshopServices(delegate: self)
        self.workshopServices.retrieveAllWorkshops(city: (location?.city)!, state: (location?.state)!)
        self.allWorkshopsTableView.delegate = self
        self.allWorkshopsTableView.dataSource = self
        // Do any additional setup after loading the view.
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
extension AllWorkshopsViewController: WorkshopServicesDelegate {
    func receiveWorkshops(workshops: [Workshop]) {
        self.workshops = workshops
        self.allWorkshopsTableView.reloadData()
    }
}

extension AllWorkshopsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workshops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WorkshopTableViewCell!
        
        if let projectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WorkshopTableViewCell", for: indexPath) as? WorkshopTableViewCell {
            cell = projectTableViewCell
            cell.configureCell(workshop: workshops[indexPath.row])
//            if let image = workshops[indexPath.row].image {
//                //cell.projectImageView.isHidden = false
//                cell.workshopImageView.alpha = 0
//                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
//                    cell.workshopImageView.image = image
//                    cell.workshopImageView.alpha = 1
//                }, completion: { (Bool) -> Void in    }
//                )
//
//            } else {
//                if let pathImage = workshops[indexPath.row].pathImage {
//                    let ticket = (projectString, indexPath.row)
//
//                    self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
//
//                    // cell.projectImageView.isHidden = true
//
//                }
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension AllWorkshopsViewController: UITableViewDelegate {
    
}


extension AllWorkshopsViewController: HeaderViewDelegate {
    func seeAllTapped(_ view: HeaderView) {
    }
    
    func setNumberOfGuides(_ view: HeaderView, number: Int) {
        view.seeAllButton.titleLabel?.text = " \(NSLocalizedString("seeAll", comment: "")) \(number)"
    }
}

extension AllWorkshopsViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == projectString {
            self.workshops[ticket.1].image = image
        }
        self.allWorkshopsTableView.reloadData()
    }
}


