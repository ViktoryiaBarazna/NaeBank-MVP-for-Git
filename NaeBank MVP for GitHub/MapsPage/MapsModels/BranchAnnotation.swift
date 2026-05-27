//
//  BranchAnnotation.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 24.05.26.
//

import MapKit

final class BranchAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let clientType: BranchClientType

    init(item: BranchMapItem) {
        coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        title = item.name
        clientType = item.clientType
        subtitle = item.clientType.localizedSubtitle
    }
}
