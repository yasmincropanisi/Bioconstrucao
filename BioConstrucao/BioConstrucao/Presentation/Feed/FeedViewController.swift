//
//  ViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 06/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

protocol SearchResultDelegate: class {
    var result: Location! {get set}
}

class FeedViewController:  UIViewController, SearchResultDelegate {
   
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var result: Location!
    var city: String!
    var state: String!
    var sections = ["Projetos", "Oficinas"]
    
    var workshopServices: WorkshopServices!
    var workshops: [Workshop] = []
    var workshop: Workshop!
    
    var projectServices: ProjectServices!
    var projects: [Project] = []
    var project: Project!
    
    private var didGetProjectsFromDatabase: Bool = false
    private var didGetWorkshopsFromDatabase: Bool = false
    
    private var didCalledProjectImages: Bool = false
    private var didCalledWorkshopsImages: Bool = false
    
    var imageServices: ImageServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result =  Location(state: "SP", city: "Campinas")
        // titulo da nav bar
        self.city = self.result.city!
        self.state = self.result.state!
        self.imageServices = ImageServices(delegate: self)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        self.workshopServices = WorkshopServices(delegate: self)
        
        self.workshopServices.retrieveWorkshops(state: self.result.state!, numberOfWorkshops: 5)

        self.projectServices = ProjectServices(delegate: self)
        self.projectServices.retrieveAllProjects(numberOfProjects: 5)
        
        // retira as células vazias da table view
        self.feedTableView.tableFooterView = UIView(frame: .zero)
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? ProjectViewController {
            destiny.project = self.project
        }
//
//        if let destiny = segue.destination as? WorkshopDetailsViewController {
//            destiny.workshop = self.workshop
//        }
//
        if let destiny = segue.destination as? AllWorkshopsViewController {
            destiny.location = self.result
        }
//
        if let destiny = segue.destination as? AllProjectsViewController {
            destiny.location = self.result
        }
    }
    
    @objc func action(sender: UIButton!) {
        if sender.tag == 0 {
            performSegue(withIdentifier: "AllProjects", sender: self)
        } else {
            performSegue(withIdentifier: "AllWorkshops", sender: self)
         }
    }
}

extension FeedViewController: ProjectServicesDelegate {
    func didReceiveProjectById(project: Project) {
        
    }
    
    func receiveProjects(projects: [Project]) {
        self.didGetProjectsFromDatabase = true
        self.projects = projects
        self.feedTableView.reloadData()
    }
}

extension FeedViewController: WorkshopServicesDelegate {

    
    func imageUploadDidFinish(_ error: Error?) {
    }
    
    func didUpdateWorkshopInDatabase(_ error: Error?) {
    }
    
    func didUpdateWorkshopInDatabasePending(_ error: Error?) {
    }
    
    func didCompleteAllWorkshopsData() {
        self.feedTableView.reloadData()
    }
    
    func receiveWorkshops(workshops: [Workshop]) {
        self.didGetWorkshopsFromDatabase = true
        self.workshops = workshops
        self.feedTableView.separatorStyle = .singleLine
        self.feedTableView.reloadData()
    }

}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: HeaderView!
        
        if let headerView = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? HeaderView {
            view = headerView
        }
        
        view.title.text = sections[section]
        view.seeAllButton.tag = section
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    /// ESSES ELSEs ESTAO ESTRANHOS. MELHORAR
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if didGetWorkshopsFromDatabase {
                if self.workshops.count > 0 {
                    if self.workshops.count <= 5 {
                        return workshops.count
                    }
                    return 5
                } else {
                    return 1
                }
            } else {
                return 1
            }
        }
    }
    
    private func createEmptyLabel() -> UILabel {
        //Cria uma Label alegando que não há Projects nessa cidade
        let lbl = UILabel(frame: CGRect(x: 20, y: 10, width: self.view.layer.frame.width/3*2, height: 21))
        lbl.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        lbl.text = "Nenhum resultado encontrado"
        lbl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return lbl
    }
    
    private func concatProjectSegments(projectSegments: [String]) -> String {
        var segments: String = ""
        var index: Int = 0
        
        for seg in projectSegments {
            if index < projectSegments.count - 1 {
                segments += "\(seg), "
            } else {
                segments += "\(seg)"
            }
            index += 1
        }
        
        return segments
    }
    
    private func fillWorkshopCell(cell: FeedWorkshopTableViewCell, indexPath: IndexPath) -> FeedWorkshopTableViewCell {
        cell.nameLabel.text = workshops[indexPath.row].name
        cell.descriptionLabel.text = workshops[indexPath.row].details
        cell.locationLabel.text = "Campinas, SP"
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: UITableViewCell = UITableViewCell()
            
            //Verifica se os Projects já chegaram do BD
            if self.didGetProjectsFromDatabase {
                //Verifica se há projects nesta cidade
                if self.projects.count > 0 {
                    //Cria uma célula com a Colection do Project
                    if let searchResultProject = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? FeedProjectTableViewCell {
                        cell = searchResultProject
                    }
                } else {
                    let emptyProjectLabel = createEmptyLabel()
                    cell.isUserInteractionEnabled = false
                    cell.addSubview(emptyProjectLabel)
                }
            } else {
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                activityIndicator.frame = CGRect(x: self.view.layer.frame.width/2, y: 20, width: 0, height: 0)
                activityIndicator.startAnimating()
                cell.selectionStyle = .none
                cell.addSubview(activityIndicator)
            }
            return cell
        } else { // workshops section
            if self.didGetWorkshopsFromDatabase {
                if self.workshops.count > 0 {
                    var cell: FeedWorkshopTableViewCell!
                    
                    if let searchResultWorkshop = tableView.dequeueReusableCell(withIdentifier: "WorkshopCell", for: indexPath) as? FeedWorkshopTableViewCell {
                        cell = searchResultWorkshop
                    }
                    
                    return fillWorkshopCell(cell: cell, indexPath: indexPath)
                } else {
                    let cell = UITableViewCell()
                    let emptyProjectLabel = createEmptyLabel()
                    cell.addSubview(emptyProjectLabel)
                    cell.isUserInteractionEnabled = false
                    self.feedTableView.separatorStyle = .none
                    return cell
                }
            } else {
                let cell = UITableViewCell()
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                activityIndicator.frame = CGRect(x: self.view.layer.frame.width/2, y: 20, width: 0, height: 0)
                activityIndicator.startAnimating()
                cell.selectionStyle = .none
                cell.addSubview(activityIndicator)
                self.feedTableView.separatorStyle = .none
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FeedProjectTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    /// Como deixar isso com autolayout?
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.didGetProjectsFromDatabase {
                if self.projects.count > 0 {
                    return 360
                } else {
                    return 50
                }
            } else {
                return 50
            }
        } else {
            if self.didGetWorkshopsFromDatabase {
                return 85
            } else {
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.workshops.count > 0 {
//            self.workshop = workshops[indexPath.row]
//            performSegue(withIdentifier: "SegueWorkshopDetails", sender: self)
//        }
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: FeedProjectCollectionViewCell!
        
        if let searchResultProject = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FeedProjectCollectionViewCell {
            cell = searchResultProject
        }
        
        // seta imagem para placeholder porque como estamos reusando celulas, aparece imagem que nao é daquela celula propriamente
        //cell.imageProject.image = #imageLiteral(resourceName: "imagePlaceholder")
        
        cell.projectLabel.text = projects[indexPath.row].name
        cell.projectLocationLabel.text = "\(projects[indexPath.row].city!) , \(projects[indexPath.row].state!)"
        
        cell.projectDescriptionLabel.text = projects[indexPath.row].details
        
    
        if let image = projects[indexPath.row].image {
            cell.imageProject.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
                cell.imageProject.image = image
                cell.imageProject.isHidden = false
                cell.blurImage.isHidden = false
                cell.imageProject.alpha = 1
            }, completion: { (Bool) -> Void in    }
            )
            
            
        } else {
            //Se tiver imagem de perfil, pega do banco
            cell.imageProject.image = #imageLiteral(resourceName: "rectangle")
            cell.blurImage.isHidden = true
            if let pathImage = projects[indexPath.row].pathImage {
                let ticket = (projectsTicket, indexPath.row)
                self.imageServices.getImageFromDatabase(path: pathImage, ticket: ticket)
                //cell.imageProject.isHidden = true
               // cell.activityIndicator.startAnimating()
            } else { //Se nao tem imagem de perfil
                cell.imageProject.image = #imageLiteral(resourceName: "guidePlaceholder")
            }
        }
  
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.projects.count > 0 {
            self.project = projects[indexPath.row]
            performSegue(withIdentifier: "SegueProjectDetails", sender: self)
        }
    }
}

extension FeedViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == projectString {
            self.projects[ticket.1].image = image
        }
        self.feedTableView.reloadData()
    }
}

extension FeedViewController: HeaderViewDelegate {
    func seeAllTapped(_ view: HeaderView) {
        self.action(sender: view.seeAllButton)
    }
}
