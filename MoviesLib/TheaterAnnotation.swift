//
//  TheaterAnnotation.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import Foundation
import MapKit

class TheaterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    //Criando construtor que solicita a coordenada da annotation
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
