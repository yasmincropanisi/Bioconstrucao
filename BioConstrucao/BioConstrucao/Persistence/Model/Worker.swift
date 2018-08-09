//
//  Worker.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

enum Specialization: String {
    case artista = "Artista"
    case construtor = "Construtor"
    case voluntario = "Voluntário"
}

class Worker: User {
    
    var specializations: [Specialization]?
    
   
}
