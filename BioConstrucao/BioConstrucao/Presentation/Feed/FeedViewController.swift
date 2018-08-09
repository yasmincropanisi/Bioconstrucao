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
    let projectsString = "Projetos sociais ticket"
    var sections = ["Projetos", "Ações sociais"]
    let socialActionsTicket: String = "Açoes sociais ticket"
    let projectsTicket: String = "Projetos sociais ticket"


    
    var socialActionServices: SocialActionServices!
    var socialActions: [SocialAction] = []
    var socialAction: SocialAction!
    
    var projectServices: ProjectServices!
    var projects: [Project] = []
    var project: Project!
    
    private var didGetProjectsFromDatabase: Bool = false
    private var didGetSocialActionsFromDatabase: Bool = false
    
    private var didCalledProjectImages: Bool = false
    private var didCalledSocialActionsImages: Bool = false
    
    var imageServices: ImageServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result =  Location(state: "SP", city: "Campinas")
        
        // titulo da nav bar
        self.city = self.result.city!
        self.state = self.result.state!
        self.title = self.city + ", " + self.state
        
        self.imageServices = ImageServices(delegate: self)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        self.socialActionServices = SocialActionServices(delegate: self)
        
        self.socialActionServices.retrieveSocialActions(state: self.result.state!, numberOfSocialActions: 5)

        self.projectServices = ProjectServices(delegate: self)
        self.projectServices.retrieveProjects(state: self.result.state!, numberOfProjects: 5)
        
        // retira as células vazias da table view
        self.feedTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destiny = segue.destination as? ProjectDetailsViewController {
//            destiny.project = self.project
//        }
//
//        if let destiny = segue.destination as? SocialActionDetailsViewController {
//            destiny.socialAction = self.socialAction
//        }
//
//        if let destiny = segue.destination as? AllSocialActionsViewController {
//            destiny.result = self.result
//        }
//
//        if let destiny = segue.destination as? AllProjectsViewController {
//            // segue vem da tela de search. logo filtra somente por Location, não por SocialAction
//            destiny.resultLocation = self.result
//            destiny.resultSocialAction = nil
//        }
    }
    
    @objc func action(sender: UIButton!) {
        if sender.tag == 0 {
            performSegue(withIdentifier: "AllProjects", sender: self)
        } else {
            performSegue(withIdentifier: "AllSocialActions", sender: self)
        }
    }
}

extension FeedViewController: ProjectServicesDelegate {
    func didReceiveProjectByProjectID(project: Project) {
    }
    
    func receiveProjects(projects: [Project]) {
        self.didGetProjectsFromDatabase = true
        self.projects = projects
        self.feedTableView.reloadData()
    }
}

extension FeedViewController: SocialActionServicesDelegate {

    
    func imageUploadDidFinish(_ error: Error?) {
    }
    
    func didUpdateSocialActionInDatabase(_ error: Error?) {
    }
    
    func didUpdateSocialActionInDatabasePending(_ error: Error?) {
    }
    
    func didCompleteAllSocialActionsData() {
        self.feedTableView.reloadData()
    }
    
    func receiveSocialActions(socialActions: [SocialAction]) {
        self.didGetSocialActionsFromDatabase = true
        self.socialActions = socialActions
        self.feedTableView.separatorStyle = .singleLine
        self.feedTableView.reloadData()
    }

}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: UIView!
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
            if didGetSocialActionsFromDatabase {
                if self.socialActions.count > 0 {
                    if self.socialActions.count <= 5 {
                        return socialActions.count
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
    
    private func fillSocialActionCell(cell: FeedSocialActionTableViewCell, indexPath: IndexPath) -> FeedSocialActionTableViewCell {
        cell.nameLabel.text = socialActions[indexPath.row].name

        
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
        } else { // socialActions section
            if self.didGetSocialActionsFromDatabase {
                if self.socialActions.count > 0 {
                    var cell: FeedSocialActionTableViewCell!
                    
                    if let searchResultSocialAction = tableView.dequeueReusableCell(withIdentifier: "SocialActionCell", for: indexPath) as? FeedSocialActionTableViewCell {
                        cell = searchResultSocialAction
                    }
                    
                    return fillSocialActionCell(cell: cell, indexPath: indexPath)
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
                    return 320
                } else {
                    return 50
                }
            } else {
                return 50
            }
        } else {
            if self.didGetSocialActionsFromDatabase {
                return 85
            } else {
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.socialActions.count > 0 {
            self.socialAction = socialActions[indexPath.row]
            performSegue(withIdentifier: "SegueSocialActionDetails", sender: self)
        }
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
        
        
        if let image = projects[indexPath.row].image {
            cell.imageProject.image = image
            cell.imageProject.isHidden = false
        } else {
            //Se tiver imagem de perfil, pega do banco
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
        if ticket.0 == projectsString {
            self.projects[ticket.1].image = image
        }
//        } else if ticket.0 == socialActionsTicket {
//            self.socialActions[ticket.1].image = image
//        } else {
//            self.projects[ticket.1].socialAction.image = image
        
        self.feedTableView.reloadData()
    }
}

