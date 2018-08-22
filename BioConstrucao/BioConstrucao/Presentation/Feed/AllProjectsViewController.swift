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
    var project:Project?
    @IBOutlet weak var allProjectsTableView: UITableView!
    var imageServices: ImageServices!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageServices = ImageServices(delegate: self)

        self.projectServices = ProjectServices(delegate: self)
        self.projectServices.retrieveAllProjects(numberOfProjects: 1000)
        self.allProjectsTableView.delegate = self
        self.allProjectsTableView.dataSource = self
        self.allProjectsTableView.rowHeight = UITableViewAutomaticDimension
        self.allProjectsTableView.estimatedRowHeight = 100
        
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
    func didReceiveProjectById(project: Project) {
        
    }
    
    func receiveProjects(projects: [Project]) {
        self.projects = projects
        self.allProjectsTableView.reloadData()
    }
}

extension AllProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 288
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ProjectTableViewCell!
        
        if let projectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell {
            cell = projectTableViewCell
            cell.configureCell(project: projects[indexPath.row])
            project = projects[indexPath.row]
            if let image = projects[indexPath.row].image {
                //cell.projectImageView.isHidden = false
                
                cell.blurImage.isHidden = false
             
                    cell.projectImageView.image = image
           
                
                
            } else {
                if let pathImage = projects[indexPath.row].pathImage {
                    let ticket = (projectString, indexPath.row)
                    cell.blurImage.isHidden = true
                    self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
                    
                   // cell.projectImageView.isHidden = true
                   
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.projects.count > 0 {
            self.project = projects[indexPath.row]
            performSegue(withIdentifier: "SegueProjectDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? ProjectViewController {
            destiny.project = self.project
        }
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

