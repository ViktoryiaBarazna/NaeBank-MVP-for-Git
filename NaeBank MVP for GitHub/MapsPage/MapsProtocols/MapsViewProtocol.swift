//
//  MapsViewProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 23.05.26.
//

import MapKit

protocol MapsViewProtocol: AnyObject {
    func setRegion(_ region: MKCoordinateRegion, animated: Bool)
    func showLoading()
    func hideLoading()
    func showAnnotations(_ annotations: [BranchAnnotation])
    func showError(_ message: String)
}
