//
//  MapsViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 23.05.26.
//

import UIKit
import SnapKit
import MapKit

final class MapsViewController: UIViewController {

    // MARK: - MVP
    var presenter: MapsPresenterProtocol?

    // MARK: - Subviews
    private let mapView = MKMapView()
    private let controlPanel = UIView()
    private let stackView = UIStackView()
    private let mapTypeSegment = UISegmentedControl(items: [
        "maps_map_type_standard".localized,
        "maps_map_type_satellite".localized,
        "maps_map_type_hybrid".localized
    ])
    private let zoomStack = UIStackView()
    private let zoomInButton = UIButton(type: .system)
    private let zoomOutButton = UIButton(type: .system)

    private let loadingOverlay = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    private var didStartInitialLoad = false

    // MARK: - Build

    static func build() -> UIViewController {
        let service = MapsNetworkService()
        let presenter = MapsPresenter(service: service)
        let vc = MapsViewController()

        presenter.view = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultBackground()
        navigationItem.title = nil
        setupSubViews()
        setupConstraintsSnapKit()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didStartInitialLoad else { return }
        didStartInitialLoad = true
        presenter?.viewDidLoad()
    }

    // MARK: - Layout

    private func setupSubViews() {
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.delegate = self

        controlPanel.backgroundColor = .systemBackground
        controlPanel.layer.cornerRadius = 18
        controlPanel.layer.masksToBounds = false
        controlPanel.layer.shadowColor = UIColor.black.cgColor
        controlPanel.layer.shadowOpacity = 0.1
        controlPanel.layer.shadowOffset = CGSize(width: 0, height: -2)
        controlPanel.layer.shadowRadius = 8

        stackView.axis = .vertical
        stackView.spacing = 10

        mapTypeSegment.selectedSegmentIndex = 0
        mapTypeSegment.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)

        zoomStack.axis = .horizontal
        zoomStack.spacing = 8
        zoomStack.distribution = .fillEqually

        configureMapButton(
            zoomInButton,
            title: "maps_zoom_in".localized,
            color: .systemMint,
            action: #selector(zoomIn)
        )
        configureMapButton(
            zoomOutButton,
            title: "maps_zoom_out".localized,
            color: .systemPurple,
            action: #selector(zoomOut)
        )
        zoomStack.addArrangedSubview(zoomInButton)
        zoomStack.addArrangedSubview(zoomOutButton)

        stackView.addArrangedSubview(mapTypeSegment)
        stackView.addArrangedSubview(zoomStack)

        loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        loadingOverlay.isHidden = true

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemPurple

        errorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        [mapView, loadingOverlay, controlPanel, errorLabel].forEach { view.addSubview($0)}
        loadingOverlay.addSubview(activityIndicator)
        controlPanel.addSubview(stackView)
    }

    private func setupConstraintsSnapKit() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        controlPanel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
        }

        mapTypeSegment.snp.makeConstraints {
            $0.height.equalTo(32)
        }

        zoomInButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        zoomOutButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        loadingOverlay.snp.makeConstraints {
            $0.edges.equalTo(mapView)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(loadingOverlay)
        }

        errorLabel.snp.makeConstraints {
            $0.center.equalTo(mapView)
            $0.leading.trailing.equalTo(mapView).inset(24)
        }
    }

    private func configureMapButton(_ button: UIButton, title: String, color: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    // MARK: - Map controls

    @objc private func mapTypeChanged() {
        switch mapTypeSegment.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: break
        }
    }

    @objc private func zoomIn() {
        var region = mapView.region
        region.span.latitudeDelta *= 0.5
        region.span.longitudeDelta *= 0.5
        mapView.setRegion(region, animated: true)
    }

    @objc private func zoomOut() {
        var region = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2, 90)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2, 180)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - MapsViewProtocol
extension MapsViewController: MapsViewProtocol {

    func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }

    func showLoading() {
        errorLabel.isHidden = true
        controlPanel.isHidden = true
        loadingOverlay.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        loadingOverlay.isHidden = true
        controlPanel.isHidden = false
    }

    func showAnnotations(_ annotations: [BranchAnnotation]) {
        errorLabel.isHidden = true

        let existing = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(existing)
        mapView.addAnnotations(annotations)
    }

    func showError(_ message: String) {
        let existing = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(existing)

        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

// MARK: - MKMapViewDelegate
extension MapsViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "BranchMarker"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)

        view.annotation = annotation
        view.canShowCallout = true
        view.glyphTintColor = .white

        guard let branch = annotation as? BranchAnnotation else { return view }

        switch branch.clientType {
        case .individual:
            view.markerTintColor = .systemBlue
            view.glyphImage = UIImage(systemName: "person.fill")
        case .business:
            view.markerTintColor = .systemOrange
            view.glyphImage = UIImage(systemName: "building.2.fill")
        }

        return view
    }
}
