//
//  SocialActionServices.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

//
//  SocialActionService.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 07/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
//import FirebaseDatabase
import Firebase
import FirebaseAuth

@objc protocol SocialActionServicesDelegate {
    func receiveSocialActions(socialActions: [SocialAction])
}

@objc protocol UploadSocialActionDelegate {
    func uploadSocialActionDidFinish(_ error: Error?)
}

class SocialActionServices {
    weak var delegate: SocialActionServicesDelegate?
    private var dataBaseService: DataBaseService
    private weak var uploadSocialActionDelegate: UploadSocialActionDelegate?
    
    private var requestsCounter: Int = 0
    
    init(delegate: SocialActionServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    init() {
        self.dataBaseService = DataBaseService.instance
    }
    
    init(uploadSocialActionDelegate: UploadSocialActionDelegate) {
        self.uploadSocialActionDelegate = uploadSocialActionDelegate
        self.dataBaseService = DataBaseService.instance
    }
    
    private func instantiateSocialActionsList(socialActions: [String]?) -> [SocialAction] {
        var socialActionsList: [SocialAction] = []
        
        if let socialActions = socialActions {
            for socialAction in socialActions {
                socialActionsList.append(SocialAction(id: socialAction))
            }
        }
        
        return socialActionsList
    }
    
    private func createSocialActionList(data: [String: AnyObject]?) -> [SocialAction] {
        var result: [SocialAction] = []
        
        if let socialActions = data {
            for socialAction in socialActions {
                result.append(self.parseJsonToSocialAction(data: socialAction))
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
    
    func retrieveSocialActions(state: String, numberOfSocialActions: Int) {
        var socialActionsList: [SocialAction] = []
        var returnedSocialActionList: [SocialAction] = []
        
        self.dataBaseService.socialActionsReference.queryOrdered(byChild: "state").queryEqual(toValue: state).queryLimited(toFirst: UInt(numberOfSocialActions)).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            socialActionsList = self.createSocialActionList(data: data)
            
            //            for socialAction in socialActionsList where guide.state == state {
            //                returnedGuidesList.append(guide)
            //            }
            
            self.delegate?.receiveSocialActions(socialActions: socialActionsList)
        }
    }
    //    func retrieveVectorGuides(from location: String) {
    //        var guidesList: [Guide] = []
    //
    //        self.dataBaseService.locationsReference.child("Guides").child(location).observeSingleEvent(of: .value) { (snapshot) in
    //            if let data = snapshot.value as? [String] {
    //
    //                let numberOfRequests = data.count
    //                if numberOfRequests == 0 {
    //                    self.delegate?.receiveGuides(guides: [])
    //                }
    //                for cadastur in data {
    //                    self.dataBaseService.guidesReference.child(cadastur).observeSingleEvent(of: .value, with: { (snapshot) in
    //                        let data = snapshot.value as? [String: AnyObject]
    //                        guidesList.append(self.parseDictionaryToGuide(data: data))
    //
    //                        if numberOfRequests == guidesList.count {
    //
    //                            guidesList.sort(by: { (guide1, guide2) -> Bool in
    //                                guide1.score! > guide2.score!
    //                            })
    //                            self.delegate?.receiveGuides(guides: guidesList)
    //                        }
    //                    })
    //                }
    //            } else {
    //                self.delegate?.receiveGuides(guides: [])
    //            }
    //        }
    //    }
    //    func retrieveRioGuides() {
    //        var guidesList: [Guide] = []
    //        var returnedGuidesList: [Guide] = []
    //
    //        self.dataBaseService.guidesRioReference.observeSingleEvent(of: .value) { (snapshot) in
    //            let data = snapshot.value as? [String: AnyObject]
    //            guidesList = self.createGuideList(data: data)
    //
    //            for guide in guidesList {
    //                var guideIndex = 0
    //
    //                if returnedGuidesList.count == 0 {
    //                    returnedGuidesList.append(guide)
    //                } else {
    //                    var foundPosition = false
    //
    //                    while guideIndex < returnedGuidesList.count && !foundPosition {
    //                        if returnedGuidesList[guideIndex].score! < guide.score! {
    //                            returnedGuidesList.insert(guide, at: guideIndex)
    //                            foundPosition = true
    //                        } else {
    //                            guideIndex+=1
    //                        }
    //                    }
    //
    //                    if guideIndex == returnedGuidesList.count {
    //                        returnedGuidesList.append(guide)
    //                    }
    //                }
    //            }
    //
    //            self.delegate?.receiveGuides(guides: returnedGuidesList)
    //        }
    //    }
    //
    //    func retrieveAllGuides(city: String, state: String) {
    //        var guidesList: [Guide] = []
    //        var returnedGuidesList: [Guide] = []
    //        self.dataBaseService.guidesReference.queryOrdered(byChild: "city").queryEqual(toValue: city).observeSingleEvent(of: .value) { (snapshot) in
    //            let data = snapshot.value as? [String: AnyObject]
    //            guidesList = self.createGuideList(data: data)
    //
    //            for guide in guidesList where guide.state == state {
    //                var guideIndex = 0
    //
    //                if returnedGuidesList.count == 0 {
    //                    returnedGuidesList.append(guide)
    //                } else {
    //                    var foundPosition = false
    //
    //                    while guideIndex < returnedGuidesList.count && !foundPosition {
    //                        if returnedGuidesList[guideIndex].score! < guide.score! {
    //                            returnedGuidesList.insert(guide, at: guideIndex)
    //                            foundPosition = true
    //                        } else {
    //                            guideIndex+=1
    //                        }
    //                    }
    //
    //                    if guideIndex == returnedGuidesList.count {
    //                        returnedGuidesList.append(guide)
    //                    }
    //                }
    //            }
    //
    //            self.delegate?.receiveGuides(guides: returnedGuidesList)
    //        }
    //    }
    //    private func setTourGuideData(guide: (key: String, value: AnyObject), tour: Tour) {
    //        if let name = guide.value["name"] as? String {
    //            tour.guide.name = name
    //        }
    //        if let city = guide.value["city"] as? String {
    //            tour.guide.city = city
    //        }
    //        if let state = guide.value["state"] as? String {
    //            tour.guide.state = state
    //        }
    //        if let path = guide.value["pathImage"] as? String? {
    //            tour.guide.pathImage = path
    //        }
    //        if let tours = guide.value["tours"] as? [String] {
    //            tour.guide.tours = self.instantiateToursList(tours: tours)
    //        }
    //        if let email = guide.value["email"] as? String {
    //            tour.guide.email = email
    //        }
    //        if let phone = guide.value["phone"] as? String {
    //            tour.guide.phone = phone
    //        }
    //        if let cadasturExpirationDate = guide.value["cadasturExpirationDate"] as? String {
    //            tour.guide.cadasturExpirationDate = cadasturExpirationDate
    //        }
    //        if let categories = guide.value["categories"] as? [String] {
    //            tour.guide.categories = self.getList(categories)
    //        }
    //    }
    //    func retrieveGuideFromTour(tour: Tour) {
    //        self.dataBaseService.guidesReference.queryOrdered(byChild: "cadastur").queryEqual(toValue: tour.guide.cadastur).observeSingleEvent(of: .value) { (snapshot) in
    //            var data = snapshot.value as? [String: AnyObject]
    //
    //            if let guide = data?.popFirst() {
    //
    //                self.setTourGuideData(guide: guide, tour: tour)
    //
    //                if let tourSegments = guide.value["tourSegments"] as? [String] {
    //                    tour.guide.tourSegments = self.getList(tourSegments)
    //                }
    //                if let languages = guide.value["languages"] as? [String] {
    //                    tour.guide.languages = self.getList(languages)
    //                }
    //                if let nickname = guide.value["nickname"] as? String {
    //                    tour.guide.nickname = nickname
    //                }
    //                if let aboutMe = guide.value["aboutMe"] as? String {
    //                    tour.guide.aboutMe = aboutMe
    //                }
    //                if let enabledAccount = guide.value["enabledAccount"] as? Bool {
    //                    tour.guide.enabledAccount = enabledAccount
    //                }
    //                if let score = guide.value["score"] as? Int {
    //                    tour.guide.score = score
    //                }
    //                if let uID = guide.value["uID"] as? String {
    //                    tour.guide.uID = uID
    //                }
    //
    //                self.delegate?.didReceiveGuideFromTour(guide: tour.guide)
    //                return
    //            }
    //            self.delegate?.didReceiveGuideFromTour(guide: nil)
    //        }
    //    }
    //    private func didCompleteDataTour() {
    //        self.requestsCounter -= 1
    //        if self.requestsCounter == 0 {
    //            self.delegate?.didCompleteAllGuidesData()
    //        }
    //    }
    //
    //    func completeDataFromTourList(tours: [Tour]) {
    //        self.requestsCounter = tours.count
    //
    //        for tour in tours {
    //            self.dataBaseService.guidesReference.queryOrdered(byChild: "cadastur").queryEqual(toValue: tour.guide.cadastur).observeSingleEvent(of: .value) { (snapshot) in
    //                var data = snapshot.value as? [String: AnyObject]
    //
    //                if let guide = data?.popFirst() {
    //                    self.setTourGuideData(guide: guide, tour: tour)
    //                    if let tourSegments = guide.value["tourSegments"] as? [String] {
    //                        tour.guide.tourSegments = self.getList(tourSegments)
    //                    }
    //                    if let languages = guide.value["languages"] as? [String] {
    //                        tour.guide.languages = self.getList(languages)
    //                    }
    //                    if let nickname = guide.value["nickname"] as? String {
    //                        tour.guide.nickname = nickname
    //                    }
    //                    if let aboutMe = guide.value["aboutMe"] as? String {
    //                        tour.guide.aboutMe = aboutMe
    //                    }
    //                    if let enabledAccount = guide.value["enabledAccount"] as? Bool {
    //                        tour.guide.enabledAccount = enabledAccount
    //                    }
    //                    if let score = guide.value["score"] as? Int {
    //                        tour.guide.score = score
    //                    }
    //                    if let uID = guide.value["uID"] as? String {
    //                        tour.guide.uID = uID
    //                    }
    //
    //                    self.didCompleteDataTour()
    //                }
    //            }
    //        }
    //    }
    //
    //    func retrieveGuideByCadastur(cadastur: String) {
    //        self.dataBaseService.guidesReference.queryOrdered(byChild: "cadastur").queryEqual(toValue: cadastur).observeSingleEvent(of: .value) { (snapshot) in
    //            var data = snapshot.value as? [String: AnyObject]
    //            var guideFound: Guide?
    //            if let guide = data?.popFirst() {
    //                guideFound = self.parseJsonToGuide(data: guide)
    //            }
    //            self.delegate?.didReceiveGuideByCadastur(guide: guideFound)
    //        }
    //    }
    //    func retrieveGuideByCadasturPending(cadastur: String) {
    //        self.dataBaseService.guidesPendingReference.queryOrdered(byChild: "cadastur").queryEqual(toValue: cadastur).observeSingleEvent(of: .value) { (snapshot) in
    //            var data = snapshot.value as? [String: AnyObject]
    //            var guideFound: Guide? = nil
    //
    //            if let guide = data?.popFirst() {
    //                guideFound = self.parseJsonToGuide(data: guide)
    //            }
    //
    //            self.delegate?.didReceiveGuideByCadasturPending(guide: guideFound)
    //        }
    //    }
    //    func retrieveGuideByUID(uID: String) {
    //        self.dataBaseService.guidesReference.queryOrdered(byChild: "uID").queryEqual(toValue: uID).observeSingleEvent(of: .value) { (snapshot) in
    //            var data = snapshot.value as? [String: AnyObject]
    //            var guideFound: Guide? = nil
    //            if let guide = data?.popFirst() {
    //                guideFound = self.parseJsonToGuide(data: guide)
    //            }
    //            self.delegate?.didReceiveGuideByUID(guide: guideFound)
    //        }
    //    }
    
}
extension SocialActionServices {
    private func setJsonSocialAction(socialAction: SocialAction, json: NSMutableDictionary) {
        if let name = socialAction.name {
            json.setValue(name, forKey: "name")
        }
        if let state = socialAction.state {
            json.setValue(state, forKey: "state")
        }
        //        if let phone = guide.phone {
        //            json.setValue(phone, forKey: "phone")
        //        }
        //        if let password = guide.password {
        //            json.setValue(password, forKey: "password")
        //        }
        //        if let name = guide.name {
        //            json.setValue(name, forKey: "name")
        //        }
        //        if let city = guide.city {
        //            json.setValue(city, forKey: "city")
        //        }
        //        if let state = guide.state {
        //            json.setValue(state, forKey: "state")
        //        }
        //        if let pathImage = guide.pathImage {
        //            json.setValue(pathImage, forKey: "pathImage")
        //        }
        //        if let pathImageCadastur = guide.pathImageCadastur {
        //            json.setValue(pathImageCadastur, forKey: "pathImageCadastur")
        //        }
        //        json.setValue(guide.cadastur, forKey: "cadastur")
        //        if let cadasturExpirationDate = guide.cadasturExpirationDate {
        //            json.setValue(cadasturExpirationDate, forKey: "cadasturExpirationDate")
        //        }
    }
    func createSocialActionJson(socialAction: SocialAction) -> NSMutableDictionary {
        let json: NSMutableDictionary = NSMutableDictionary()
        
        setJsonSocialAction(socialAction: socialAction, json: json)
        if let name = socialAction.name {
            json.setValue(name, forKey: "name")
        }
        //        if let aboutMe = guide.aboutMe {
        //            json.setValue(aboutMe, forKey: "aboutMe")
        //        }
        //        if let score = guide.score {
        //            json.setValue(score, forKey: "score")
        //        }
        //        if let tours = guide.tours {
        //
        //            let tourList = NSMutableArray()
        //
        //            for tour in tours {
        //                tourList.add(tour.tourID)
        //            }
        //            json.setValue(tourList, forKey: "tours")
        //        }
        //        let categoriesList = NSMutableArray()
        //        for category in guide.categories {
        //            categoriesList.add(category)
        //        }
        //        json.setValue(categoriesList, forKey: "categories")
        //        let tourSegments = NSMutableArray()
        //        for segment in guide.tourSegments {
        //            tourSegments.add(segment)
        //        }
        //        json.setValue(tourSegments, forKey: "tourSegments")
        //        let languagesList = NSMutableArray()
        //        for language in guide.languages {
        //            languagesList.add(language)
        //        }
        //        json.setValue(languagesList, forKey: "languages")
        //        if let uID = guide.uID {
        //            json.setValue(uID, forKey: "uID")
        //        }
        return json
    }
    //    func updateGuideInDatabase(guide: Guide) {
    //        let json = self.createGuideJson(guide: guide)
    //        DataBaseService.instance.uploadJsonDelegate = self
    //        if NSDictionary(dictionary: json) is [String: AnyObject] {
    //            if let jsonDict = NSDictionary(dictionary: json) as? [String: AnyObject] {
    //                DataBaseService.instance.uploadJson(json: jsonDict, reference: DataBaseService.instance.guidesReference.child((guide.cadastur?.replacingOccurrences(of: ".", with: ""))!))
    //            }
    //        }
    //    }
    //    func updateGuideInDatabasePending(guide: Guide) {
    //        let json = self.createGuideJson(guide: guide)
    //        DataBaseService.instance.uploadJsonDelegate = self
    //        if NSDictionary(dictionary: json) is [String: AnyObject] {
    //            if let jsonDict = NSDictionary(dictionary: json) as? [String: AnyObject] {
    //                DataBaseService.instance.uploadJson(json: jsonDict, reference: DataBaseService.instance.guidesPendingReference.child((guide.cadastur?.replacingOccurrences(of: ".", with: ""))!))
    //            }
    //        }
    //    }
    private func setSocialActionData(socialAction: SocialAction, data: (key: String, value: AnyObject)?) {
        if let name = data?.value["name"] {
            socialAction.name = name as? String
        }
        if let state = data?.value["state"] {
            socialAction.state = state as? String
        }
        //        if let state = data?.value["state"] {
        //            guide.state = state as? String
        //        }
        //        if let pathImage = data?.value["pathImage"] {
        //            guide.pathImage = pathImage as? String
        //        }
        //        if let cadastur = data?.value["cadastur"] {
        //            guide.cadastur = cadastur as? String
        //        }
        //        if let tours = data?.value["tours"] as? [String]? {
        //            guide.tours = instantiateToursList(tours: tours)
        //        }
        //        if let email = data?.value["email"] {
        //            guide.email = email as? String
        //        }
        //        if let phone = data?.value["phone"] {
        //            guide.phone = phone as? String
        //        }
        //        if let cadasturExpirationDate = data?.value["cadasturExpirationDate"] as? String {
        //            guide.cadasturExpirationDate = cadasturExpirationDate
        //        }
        //        if let categories = data?.value["categories"] as? [String]? {
        //            guide.categories = getList(categories)
        //        }
    }
    
    func parseJsonToSocialAction(data: (key: String, value: AnyObject)?) -> SocialAction {
        let socialAction: SocialAction = SocialAction()
        
        setSocialActionData(socialAction: socialAction, data: data)
        
        //        if data?.value["tourSegments"] != nil {
        //            if let tourSegments = data?.value["tourSegments"] as? [String]? {
        //                guide.tourSegments = getList(tourSegments)
        //            }
        //        }
        //        if data?.value["languages"] != nil {
        //            if let languages = data?.value["languages"] as? [String]? {
        //                guide.languages =  getList(languages)
        //            }
        //        }
        if let name = data?.value["name"] {
            socialAction.name = name as? String
        }
        if let state = data?.value["state"] {
            socialAction.state = state as? String
        }
        //        if let enabledAccount = data?.value["enabledAccount"] {
        //            guide.enabledAccount = (enabledAccount as? Bool?)!
        //        }
        //        if let score = data?.value["score"] {
        //            guide.score = (score as? Int?)!
        //        }
        //        if let uID = data?.value["uID"] {
        //            guide.uID = (uID as? String?)!
        //        }
        return socialAction
    }
    
    //    private func setGuideDictionaryData(guide: Guide, data: [String: AnyObject]?) {
    //        if let name = data?["name"] {
    //            guide.name = name as? String
    //        }
    //        if let city = data?["city"] {
    //            guide.city = city as? String
    //        }
    //        if let state = data?["state"] {
    //            guide.state = state as? String
    //        }
    //        if let pathImage = data?["pathImage"] {
    //            guide.pathImage = pathImage as? String
    //        }
    //        if let cadastur = data?["cadastur"] {
    //            guide.cadastur = cadastur as? String
    //        }
    //        if let tours = data?["tours"] as? [String]? {
    //            guide.tours = instantiateToursList(tours: tours)
    //        }
    //        if let email = data?["email"] {
    //            guide.email = email as? String
    //        }
    //        if let phone = data?["phone"] {
    //            guide.phone = phone as? String
    //        }
    //        if let cadasturExpirationDate = data?["cadasturExpirationDate"] as? String {
    //            guide.cadasturExpirationDate = cadasturExpirationDate
    //        }
    //        if let categories = data?["categories"] as? [String]? {
    //            guide.categories = getList(categories)
    //        }
    //    }
    //    func parseDictionaryToGuide(data: [String: AnyObject]?) -> Guide {
    //        let guide: Guide = Guide()
    //
    //        setGuideDictionaryData(guide: guide, data: data)
    //
    //        if data?["tourSegments"] != nil {
    //            if let tourSegments = data?["tourSegments"] as? [String]? {
    //                guide.tourSegments = getList(tourSegments)
    //            }
    //        }
    //        if data?["languages"] != nil {
    //            if let languages = data?["languages"] as? [String]? {
    //                guide.languages =  getList(languages)
    //            }
    //        }
    //        if let nickname = data?["nickname"] {
    //            guide.nickname = nickname as? String
    //        }
    //        if let aboutMe = data?["aboutMe"] {
    //            guide.aboutMe = aboutMe as? String
    //        }
    //        if let enabledAccount = data?["enabledAccount"] as? Bool {
    //            guide.enabledAccount = enabledAccount
    //        }
    //        if let score = data?["score"] as? Int {
    //            guide.score = score
    //        }
    //        if let uID = data?["uID"] as? String {
    //            guide.uID = uID
    //        }
    //        return guide
    //    }
    //    private func setGuideDataByMutableJson(guide: Guide, json: NSMutableDictionary?) {
    //        if let value = json?.value(forKey: "name") {
    //            guide.name = value as? String
    //        }
    //        if let city = json?.value(forKey: "city") {
    //            guide.city = city as? String
    //        }
    //        if let state = json?.value(forKey: "state") {
    //            guide.state = state as? String
    //        }
    //        if let pathImage = json?.value(forKey: "pathImage") {
    //            guide.pathImage = pathImage as? String
    //        }
    //        if let cadastur = json?.value(forKey: "cadastur") {
    //            guide.cadastur = cadastur as? String
    //        }
    //        if json?.value(forKey: "tours") != nil {
    //            if let tours = json?.value(forKey: "tours") as? [String]? {
    //                guide.tours = instantiateToursList(tours: tours)
    //            }
    //        }
    //        if let email = json?.value(forKey: "email") {
    //            guide.email = email as? String
    //        }
    //        if let phone = json?.value(forKey: "phone") {
    //            guide.phone = phone as? String
    //        }
    //        if let cadasturExpirationDate = json?.value(forKey: "cadasturExpirationDate") {
    //            guide.cadasturExpirationDate = (cadasturExpirationDate as? String)
    //        }
    //    }
    //    func parseJsonToGuide(json: NSMutableDictionary?) -> Guide {
    //        let guide: Guide = Guide()
    //
    //        setGuideDataByMutableJson(guide: guide, json: json)
    //
    //        if let categories = json?.value(forKey: "categories") as? [String]? {
    //            guide.categories = getList(categories)
    //        }
    //        if json?.value(forKey: "tourSegments") != nil {
    //            if let tourSegments = json?.value(forKey: "tourSegments") as? [String]? {
    //                guide.tourSegments = getList(tourSegments)
    //            }
    //        }
    //        if json?.value(forKey: "languages") != nil {
    //            if let languages = json?.value(forKey: "languages") as? [String]? {
    //                guide.languages =  getList(languages)
    //            }
    //        }
    //        if let nickname = json?.value(forKey: "nickname") {
    //            guide.nickname = nickname as? String
    //        }
    //        if let aboutMe = json?.value(forKey: "aboutMe") {
    //            guide.aboutMe = aboutMe as? String
    //        }
    //        if let enabledAccount = json?.value(forKey: "enabledAccount") as? Bool {
    //            guide.enabledAccount = enabledAccount
    //        }
    //        if let score = json?.value(forKey: "score") as? Int {
    //            guide.score = score
    //        }
    //        if let uID = json?.value(forKey: "uID") as? String {
    //            guide.uID = uID
    //        }
    //        return guide
    //    }
    //
    //    func uploadImage(image: UIImage, path: String) {
    //        let imageRef = DataBaseService.instance.getStorageReference(path: path)
    //        if let imageRepresentation = UIImagePNGRepresentation(image) {
    //            let imageData = imageRepresentation
    //            imageRef.putData(imageData, metadata: nil) { (_ metadata, error) in
    //                if let error = error {
    //                    print("Erro ao dar upload na imagem! \(error.localizedDescription)")
    //                } else {
    //                    self.delegate?.imageUploadDidFinish(error)
    //                }
    //            }
    //        }
    //    }
}

