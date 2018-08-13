//
//  DataBaseService.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 07/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Firebase


protocol LoginDelegate: class {
    func loginDidEnded(_ error: Error?)
}

protocol CreateUserDelegate: class {
    func userCreationDidEnded(_ error: Error?)
}

protocol UploadImageDelegate: class {
    func imageUploadDidFinish(_ error: Error?)
}

protocol UploadJsonDelegate: class {
    func jsonUploadDidEnded(_ error: Error?)
    func jsonUploadDidEndedPending(_ error: Error?)
}

class DataBaseService {
    let urlStorage = "https://firebasestorage.googleapis.com/v0/b/bioconstrucao-8d52d.appspot.com/o/"
    var storageReference: StorageReference?
    let projectsReference = Database.database().reference(withPath: "Projects")
    let workshopsReference = Database.database().reference(fromURL: "https://bioconstrucao-8d52d.firebaseio.com/Social_actions")
    let workerReference = Database.database().reference(fromURL: "https://bioconstrucao-8d52d.firebaseio.com/Owners")
//    var userID: Firebase.User?
    static let instance = DataBaseService()
    weak var loginDelegate: LoginDelegate?
    weak var createUserDelegate: CreateUserDelegate?
    weak var uploadImageDelegate: UploadImageDelegate?
    weak var uploadJsonDelegate: UploadJsonDelegate?
    private var logged: Bool = false
    var userID: Firebase.User?

    private init() {
        let storage = Storage.storage()
        self.storageReference = storage.reference(forURL: self.urlStorage)
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if user != nil {
                self?.logged = true
            } else {
                self?.login(email: "yasminnoguera@gmail.com", password: "123456")
                self?.logged = false
            }
        }
    }
    func getStorageReference(path: String) -> StorageReference {
        while !logged {
        }
        return self.storageReference!.child(path)
    }
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.loginDelegate?.loginDidEnded(error)
            } else {
                print("Login Success")
                self.userID = user?.user
                self.logged = true
                self.loginDelegate?.loginDidEnded(error)
            }
        }
    }
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("Sucess! User created!!")
               // self.userID = user?.user
            }
            self.createUserDelegate?.userCreationDidEnded(error)
        })
    }
    func uploadImage(image: UIImage, path: String) {
        let imageRef = DataBaseService.instance.getStorageReference(path: path)
        imageRef.putData(UIImagePNGRepresentation(image)! as Data, metadata: nil) { (_, error) in
            if let error = error {
                print("Erro ao dar upload na imagem! \(error.localizedDescription)")
            } else {
                DataBaseService.instance.uploadImageDelegate?.imageUploadDidFinish(error)
            }
        }
    }
    func uploadJson(json: [String: AnyObject], reference: DatabaseReference) {
        reference.setValue(json) { (error, _) in
            if let error = error {
                print("Erro ao dar upload de Json: \(error)")
            }
            DataBaseService.instance.uploadJsonDelegate?.jsonUploadDidEnded(error)
        }
    }
    func uploadJsonPending(json: [String: AnyObject], reference: DatabaseReference) {
        reference.setValue(json) { (error, _) in
            if let error = error {
                print("Erro ao dar upload de Json: \(error)")
            }
            DataBaseService.instance.uploadJsonDelegate?.jsonUploadDidEndedPending(error)
        }
    }
}
