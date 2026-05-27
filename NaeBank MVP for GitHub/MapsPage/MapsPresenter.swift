//
//  MapsPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 23.05.26.
//

import MapKit

final class MapsPresenter: MapsPresenterProtocol {

    weak var view: MapsViewProtocol?
    private let service: MapsServiceProtocol

    init(service: MapsServiceProtocol) {
        self.service = service
    }

    func viewDidLoad() {
        view?.setRegion(makeMinskRegion(), animated: false)
        fetchBranches()
    }

    private func fetchBranches() {
        view?.showLoading()

        service.fetchBranches { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()

                switch result {
                case .success(let branches):
                    let annotations = branches.map { BranchAnnotation(item: $0) }
                    self?.view?.showAnnotations(annotations)

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    private func makeMinskRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 53.9045, longitude: 27.5615),
            latitudinalMeters: 10_000,
            longitudinalMeters: 10_000
        )
    }
}
