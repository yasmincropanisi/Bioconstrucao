//
//  ProjectViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

    var project: Project?
    var project_id: String?
    var projectServices: ProjectServices?
    var imageServices: ImageServices!
    var workers: [Worker]?
    var sections = ["Details", "Construtores"]

    
    @IBOutlet weak var projectTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageServices = ImageServices(delegate: self)
        if let project = self.project {
            self.projectServices = ProjectServices(delegate: self)
        }
        setupProject()
        projectTableView.delegate = self
        projectTableView.dataSource = self
        navigationController?.delegate = self
     self.projectTableView.contentInset = UIEdgeInsets.zero
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.barTintColor = .clear
            }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProjectDetails() {
        guard let project_id = self.project_id else {return}
        self.projectServices?.retrieveProjectByID(id: project_id)
    }
    
    func setupProject() {
        guard let project = self.project else {fetchProjectDetails(); return }
        self.workers = project.workers
        setupProjectView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupProjectView() {
        guard let project = self.project else {return}
//        self.projectName.text = project.name
//        self.projectDescription.text = "Lorem"
//        self.projectLocation.text = "\(project.city!), \(project.state!)"
//        self.projectImage.image = project.image!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destiny = segue.destination as? TourDetailsViewController {
//            destiny.tour = self.tour
//        }
//
//        if let destiny = segue.destination as? AllToursViewController {
//            destiny.resultLocation = self.result
//            destiny.resultGuide = self.guide
//        }
    }

}

extension ProjectViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == projectsTicket {
            self.project?.image = image
            //self.imageView.image = image
        } else if ticket.0 == workerTicket {
            self.workers![ticket.1].image = image
            self.projectTableView.reloadData()

        }
    }
}

extension ProjectViewController: ProjectServicesDelegate {
    func receiveProjects(projects: [Project]) {
        
    }
    
    func didReceiveProjectById(project: Project) {
        self.project = project
        self.setupProjectView()
    }
    
    
}

extension ProjectViewController: UINavigationControllerDelegate {

    override func willMove(toParentViewController parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = greenColor
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.setNeedsLayout()

    }
}

extension ProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Como deixar isso com autolayout?
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 350
        } else {
            return 115
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: HeaderView!
        if section == 1 {
            if let headerView = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? HeaderView {
                view = headerView
            }
            view.title.text = sections[section]
            view.seeAllButton.isHidden = true
            view.title.font = UIFont(name:"Helvetica",size:20)!
        
            return view
        }
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
           return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: UITableViewCell = UITableViewCell()
            if let cellDetails = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailTableViewCell", for: indexPath) as? ProjectDetailTableViewCell {
                guard let project = self.project else { return cellDetails}
                cellDetails.projectImageView.image = project.image
                cellDetails.projectNameLabel.text = project.name
                cellDetails.projectLocationLabel.text = "\(project.city!), \(project.state!)"
                cellDetails.projectDescriptionLabel.text = project.details
                
                    cell = cellDetails
                
                    }
             
            
            return cell
        } else {
    
             var cell: WorkerProjectTableViewCell!
                    
                    if let workerProject = tableView.dequeueReusableCell(withIdentifier: "WorkerProjectTableViewCell", for: indexPath) as? WorkerProjectTableViewCell {
                        cell = workerProject
                    }
                    
                    return cell
            //fillWorkshopCell(cell: cell, indexPath: indexPath)
            
    
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? WorkerProjectTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    
}


extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let workers = self.workers else {return 0}
        return workers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: WorkerProjectCollectionViewCell!
        
        if let cellWorkerProject = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkerProjectCollectionViewCell", for: indexPath) as? WorkerProjectCollectionViewCell {
            cell = cellWorkerProject
        }
        
        guard let workers = self.workers else { return cell}
        cell.workerName.text = workers[indexPath.row].name

         cell.workerImage.layer.borderWidth = 1
         cell.workerImage.layer.masksToBounds = false
         cell.workerImage.layer.borderColor =  UIColor.white.cgColor//UIColor.white.cgColor
//         cell.workerImage.layer.cornerRadius =  cell.workerImage.frame.height/2
         cell.workerImage.clipsToBounds = true
        cell.workerImage.layer.cornerRadius = 8
        //cell.workerImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]

        if let image = workers[indexPath.row].image {
            cell.workerImage.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
                cell.workerImage.image = image
                cell.workerImage.isHidden = false
                cell.workerImage.alpha = 1
            }, completion: { (Bool) -> Void in    }
            )


        } else {
            //Se tiver imagem de perfil, pega do banco
            cell.workerImage.image = #imageLiteral(resourceName: "rectangle")
            if let pathImage = workers[indexPath.row].pathImage {
                let ticket = (workerTicket, indexPath.row)
                self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
                //cell.imageProject.isHidden = true
                // cell.activityIndicator.startAnimating()
            } else { //Se nao tem imagem de perfil
//                cell.imageProject.image = #imageLiteral(resourceName: "guidePlaceholder")
            }
        }

        //cell.workerImage.image = workers[indexPath.row].image

        return cell
        
        
    }
   
}

//extension ProjectViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let workers = self.workers else { return 0}
//        return workers.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell: WorkerCollectionViewCell!
//
//        if let cellWorker = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkerCollectionCell", for: indexPath) as? WorkerCollectionViewCell {
//            cell = cellWorker
//        }
//        guard let workers = self.workers else { return cell}
//        cell.workerName.text = workers[indexPath.row].name
//
//         cell.workerImage.layer.borderWidth = 3
//         cell.workerImage.layer.masksToBounds = false
//         cell.workerImage.layer.borderColor = greenColor.cgColor
//         cell.workerImage.layer.cornerRadius =  cell.workerImage.frame.height/2
//         cell.workerImage.clipsToBounds = true
//
//        if let image = workers[indexPath.row].image {
//            cell.workerImage.alpha = 0
//
//            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
//                cell.workerImage.image = image
//                cell.workerImage.isHidden = false
//                cell.workerImage.alpha = 1
//            }, completion: { (Bool) -> Void in    }
//            )
//
//
//        } else {
//            //Se tiver imagem de perfil, pega do banco
//            cell.workerImage.image = #imageLiteral(resourceName: "rectangle")
//            if let pathImage = workers[indexPath.row].pathImage {
//                let ticket = (workerTicket, indexPath.row)
//                self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
//                //cell.imageProject.isHidden = true
//                // cell.activityIndicator.startAnimating()
//            } else { //Se nao tem imagem de perfil
////                cell.imageProject.image = #imageLiteral(resourceName: "guidePlaceholder")
//            }
//        }
//
//        //cell.workerImage.image = workers[indexPath.row].image
//
//        return cell
//    }
//


