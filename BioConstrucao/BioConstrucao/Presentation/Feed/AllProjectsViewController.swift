//
//  AllProjectsViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 09/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class AllProjectsViewController: UIViewController {

    var location:Location!
    var projectServices: ProjectServices!
    var projects: [Project] = [Project]()
    @IBOutlet weak var allProjectsTableView: UITableView!
    var imageServices: ImageServices!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageServices = ImageServices(delegate: self)

        self.projectServices = ProjectServices(delegate: self)
        self.projectServices.retrieveAllProjects(city: (location?.city)!, state: (location?.state)!)
        self.allProjectsTableView.delegate = self
        self.allProjectsTableView.dataSource = self
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
extension AllProjectsViewController: ProjectServicesDelegate {
    func receiveProjects(projects: [Project]) {
        self.projects = projects
        self.allProjectsTableView.reloadData()
    }
}

extension AllProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ProjectTableViewCell!
        
        if let projectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell {
            cell = projectTableViewCell
            cell.configureCell(project: projects[indexPath.row])
            if let image = projects[indexPath.row].image {
                //cell.projectImageView.isHidden = false
                cell.projectImageView.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
                    cell.projectImageView.image = image
                    cell.projectImageView.alpha = 1
                }, completion: { (Bool) -> Void in    }
                )
                
            } else {
                if let pathImage = projects[indexPath.row].pathImage {
                    let ticket = (projectString, indexPath.row)
                    
                    self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
                    
                   // cell.projectImageView.isHidden = true
                   
                }
            }
        }
        
        return cell
    }
    
    
}

extension AllProjectsViewController: UITableViewDelegate {
    
}


extension AllProjectsViewController: HeaderViewDelegate {
    func seeAllTapped(_ view: HeaderView) {
    }
    
    func setNumberOfGuides(_ view: HeaderView, number: Int) {
        view.seeAllButton.titleLabel?.text = " \(NSLocalizedString("seeAll", comment: "")) \(number)"
    }
}

extension AllProjectsViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == projectString {
            self.projects[ticket.1].image = image
        }
        self.allProjectsTableView.reloadData()
    }
}

