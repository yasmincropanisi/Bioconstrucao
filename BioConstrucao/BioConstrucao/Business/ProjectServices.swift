//
//  ProjectService.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 07/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
//import FirebaseDatabase
import Firebase
import FirebaseAuth

@objc protocol ProjectServicesDelegate {
    func receiveProjects(projects: [Project])
    func didReceiveProjectById(project: Project)
}


@objc protocol UploadProjectDelegate {
    func uploadProjectDidFinish(_ error: Error?)
}

class ProjectServices {
    weak var delegate: ProjectServicesDelegate?
    private var dataBaseService: DataBaseService
    private weak var uploadProjectDelegate: UploadProjectDelegate?
    
    private var requestsCounter: Int = 0
    
    init(delegate: ProjectServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    init() {
        self.dataBaseService = DataBaseService.instance
    }
    
    init(uploadProjectDelegate: UploadProjectDelegate) {
        self.uploadProjectDelegate = uploadProjectDelegate
        self.dataBaseService = DataBaseService.instance
    }
    
    private func instantiateProjectsList(projects: [String]?) -> [Project] {
        var projectList: [Project] = []
        
        if let projects = projects {
            for project in projects {
                projectList.append(Project(id: project))
            }
        }
        
        return projectList
    }
    
    private func createProjectList(data: [String: AnyObject]?) -> [Project] {
        var result: [Project] = []
        
        if let projects = data {
            for project in projects {
                result.append(self.parseJsonToProject(data: project))
            }
        }
        
        return result
    }
    
    private func getList(_ list: [String]?) -> [String] {
        if let list = list {
            return list
        }
        return []
    }
    
    func retrieveProjectByID(id: String) {
        self.dataBaseService.projectsReference.queryOrdered(byChild: "id").queryEqual(toValue: id).observeSingleEvent(of: .value) { (snapshot) in
            var data = snapshot.value as? [String: AnyObject]
            var projectFound: Project?
            if let project = data?.popFirst() {
                projectFound = self.parseJsonToProject(data: project)
            }
            guard let project = projectFound else {return}
            self.delegate?.didReceiveProjectById(project: project)
        }
    }
    
    func retrieveProjects(state: String, numberOfProjects: Int) {
        var projectList: [Project] = []
        
        self.dataBaseService.projectsReference.child("Projects").queryOrdered(byChild: "state").queryEqual(toValue: state).queryLimited(toFirst: UInt(numberOfProjects)).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            projectList = self.createProjectList(data: data)

            self.delegate?.receiveProjects(projects: projectList)
        }
    }

    func retrieveAllProjects(city: String, state: String) {
        var projectsList: [Project] = []
        self.dataBaseService.projectsReference.queryOrdered(byChild: "state").queryEqual(toValue: state).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            projectsList = self.createProjectList(data: data)
            self.delegate?.receiveProjects(projects: projectsList)
        }
    }
    
    func retrieveAllProjects(numberOfProjects: Int) {
        var projectsList: [Project] = []
        self.dataBaseService.projectsReference.child("Projects").queryLimited(toFirst: UInt(numberOfProjects)).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            projectsList = self.createProjectList(data: data)
            self.delegate?.receiveProjects(projects: projectsList)
        })
    }
    

}
extension ProjectServices {
    private func setJsonProject(project: Project, json: NSMutableDictionary) {
        if let id = project.id {
            json.setValue(id, forKey: "id")
        }
        if let name = project.name {
            json.setValue(name, forKey: "name")
        }
        if let state = project.state {
            json.setValue(state, forKey: "state")
        }
        if let details = project.details {
            json.setValue(details, forKey: "details")
        }

        if let pathImage = project.pathImage {
            json.setValue(pathImage, forKey: "pathImage")
        }

    }
    func createProjectJson(project: Project) -> NSMutableDictionary {
        let json: NSMutableDictionary = NSMutableDictionary()
        
        setJsonProject(project: project, json: json)
        if let name = project.name {
            json.setValue(name, forKey: "name")
        }
        return json
    }

    
    private func setProjectData(project: Project, data: (key: String, value: AnyObject)?) {
        if let id = data?.value["id"] {
            project.id = id as? String
        }
        if let name = data?.value["name"] {
            project.name = name as? String
        }
        if let city = data?.value["city"] {
            project.city = city as? String
        }
        if let details = data?.value["details"] {
            project.details = details as? String
        }

        if let state = data?.value["state"] {
            project.state = state as? String
        }

        if let pathImage = data?.value["pathImage"] {
            project.pathImage = pathImage as? String
        }
        
        if let workers = data?.value["workers"] as? [String] {
            project.workers = self.getWorkersList(workers)
        }
    }
    
    private func getWorkersList(_ list: [String]?) -> [Worker] {
        if let list = list {
            var workers = [Worker]()

            for id in list {
            
                let worker = Worker(id: id)
                workers.append(worker)
                
            }
            
            return workers
        }
        return []
    }
    
    func parseJsonToProject(data: (key: String, value: AnyObject)?) -> Project {
        let project: Project = Project()
        
        setProjectData(project: project, data: data)

        if let name = data?.value["name"] {
            project.name = name as? String
        }
        if let state = data?.value["state"] {
            project.state = state as? String
        }
        if let pathImage = data?.value["pathImage"] {
            project.pathImage = pathImage as? String
        }
        
        
        if let workers = data?.value["workers"] as? [NSDictionary] {
            project.workers = self.createWorkerList(workers: workers)
        }

        return project
    }
    
    private func createWorkerList(workers: [NSDictionary]) -> [Worker] {
        var workersList: [Worker] = []
        
        for worker in workers {
            if let pathImage = worker["pathImage"] as? String {
                if let name = worker["name"] as? String {
                    if let id = worker["id"] as? String {
                        workersList.append(Worker(id: id, name: name, pathImage: pathImage))
                    }
                }
            }
        }
        
        return workersList
    }
}
