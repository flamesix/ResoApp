//
//  ListOfOfficesViewController.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import UIKit
import CoreLocation
import Foundation
import MapKit


final class ListOfOfficesViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    var isFiltered = true
    
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else { return }
            searchedOffices = offices.sorted(by: { $0.distance.distance(from: userLocation) < $1.distance.distance(from: userLocation) })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var offices: [OfficeModel] = [] {
        didSet {
            searchedOffices = offices
        }
    }
    
    var searchedOffices: [OfficeModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UIElements
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Списком", "На карте"])
        control.backgroundColor = InterfaceColor.resoGreen
        return control
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListOfOfficesTableViewCell.self, forCellReuseIdentifier: ListOfOfficesTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var topbarHeight: CGFloat {
            
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            
        }
        
        segmentedControl.frame = CGRect(x: 5,
                                        y: topbarHeight + 10 ,
                                        width: view.width - 10,
                                        height: 30)
        
        searchBar.frame = CGRect(x: 0,
                                 y: topbarHeight + 20 + segmentedControl.frame.height,
                                 width: view.width,
                                 height: 30)
        
        tableView.frame = CGRect(x: 0,
                                 y: topbarHeight + 20 + segmentedControl.frame.height + searchBar.height + 5,
                                 width: view.width,
                                 height: view.height - 30 - 30 - topbarHeight - 20)
        
        mapView.frame = CGRect(x: 0,
                               y: topbarHeight + 20 + segmentedControl.frame.height + searchBar.height + 5,
                               width: view.width,
                               height: view.height - 30 - 30 - topbarHeight - 20)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        view.backgroundColor = InterfaceColor.resoGreen
        
        configureNavigationController()
        
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangedSegment), for: .valueChanged)
        
        networking.getOfficesInfo(self) { [weak self] offices in
            DispatchQueue.main.async {
                self?.offices = offices
            }
        }
    }
    
    
    // MARK: - Methods
    
    private func configureNavigationController() {
        
        navigationItem.title = "Офисы РЕСО-Гарантия"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.backgroundColor = InterfaceColor.resoGreen
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(didTapFilterButton))
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    @objc private func didTapFilterButton() {
        let currentTimeAndDay = settingCurrentTime()
        var filteredOffices: [OfficeModel] = []
        
        if isFiltered {
            
            isFiltered.toggle()
            
            for office in offices {
                
                //All days except Sunday
                if currentTimeAndDay.currentDay != 1 {
                    let filteredOffice = office.officeWorkingHours?.filter {
                        Int($0.dayCount) == currentTimeAndDay.currentDay - 1 &&
                        Int($0.startTime.filter { "0123456789".contains($0) }) ?? 0 < currentTimeAndDay.currentTime &&
                        Int($0.endTime.filter { "0123456789".contains($0) } ) ?? 0 > currentTimeAndDay.currentTime }
                    
                    if !(filteredOffice?.isEmpty ?? true) {
                        
                        filteredOffices.append(office)
                        
                    }
                    
                    guard let userLocation = userLocation else { return }
                    searchedOffices = filteredOffices.sorted(by: { $0.distance.distance(from: userLocation) < $1.distance.distance(from: userLocation) })
                    
                    //Sunday case
                } else {
                    
                    let filteredOffice = office.officeWorkingHours?.filter {
                        Int($0.dayCount) == 7 &&
                        Int($0.startTime.filter { "0123456789".contains($0) }) ?? 0 < currentTimeAndDay.currentTime &&
                        Int($0.endTime.filter { "0123456789".contains($0) } ) ?? 0 > currentTimeAndDay.currentTime }
                    
                    if !(filteredOffice?.isEmpty ?? true) {
                        
                        filteredOffices.append(office)
                        
                    }
                    guard let userLocation = userLocation else { return }
                    searchedOffices = filteredOffices.sorted(by: { $0.distance.distance(from: userLocation) < $1.distance.distance(from: userLocation) })
                }
            }
            
        } else {
            
            isFiltered.toggle()
            
            guard let userLocation = userLocation else { return }
            searchedOffices = offices.sorted(by: { $0.distance.distance(from: userLocation) < $1.distance.distance(from: userLocation) })
        }
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didChangedSegment() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.removeFromSuperview()
            view.addSubview(tableView)
            tableView.reloadData()
        case 1:
            tableView.removeFromSuperview()
            view.addSubview(mapView)
            setMapViewOfficesLocation()
        default:
            break
        }
    }
    
    
    ///Setting currentTime and currentDay
    private func settingCurrentTime() -> (currentTime: Int, currentDay: Int) {
        let currentDay = Calendar.current.component(.weekday, from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        dateFormatter.timeZone = .init(abbreviation: "UTC+3")
        let currentTime = Int(dateFormatter.string(from: Date()).filter { $0 != "."}) ?? 0
        return (currentTime: currentTime, currentDay: currentDay)
    }
    
    
    ///Show offices locations on a map
    private func setMapViewOfficesLocation() {
        let allAnotations = mapView.annotations
        mapView.removeAnnotations(allAnotations)
        
        for office in searchedOffices {
            
            let location = CLLocationCoordinate2D(latitude: office.latitude, longitude: office.longitude)
            let moscowLocation = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.62)
            let region = MKCoordinateRegion(center: moscowLocation,
                                            latitudinalMeters: CLLocationDistance(exactly: 50000)!,
                                            longitudinalMeters: CLLocationDistance(exactly: 50000)!)
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = office.officeName
            mapView.addAnnotation(annotation)
            
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension ListOfOfficesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedOffices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListOfOfficesTableViewCell.reuseIdentifier, for: indexPath) as? ListOfOfficesTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        
        let office = searchedOffices[indexPath.row]
        let currentTimeAndDay = settingCurrentTime()
        
        cell.configure(with: office, userLocation: userLocation, currentTime: currentTimeAndDay.currentTime, currentDay: currentTimeAndDay.currentDay)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = InfoOfficeViewController()
        vc.office = searchedOffices[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - UISearchBarDelegate

extension ListOfOfficesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            guard let userLocation = userLocation else { return }
            searchedOffices = offices.sorted(by: { $0.distance.distance(from: userLocation) < $1.distance.distance(from: userLocation) })
        } else {
            searchedOffices = offices.filter { $0.officeName.localizedCaseInsensitiveContains(searchText) }
        }
        tableView.reloadData()
        
    }
}

// MARK: - CLLocationDelegate

extension ListOfOfficesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
