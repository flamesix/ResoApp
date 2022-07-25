//
//  InfoOfficeViewController.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import UIKit
import MapKit
import CoreLocation

final class InfoOfficeViewController: UIViewController {
    
    var office: OfficeModel?
    
    // MARK: - UIElements
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var officeNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var fullAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var phonesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private lazy var workingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private lazy var workingHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 77/255, green: 137/255, blue: 66/255, alpha: 1)
        return button
    }()
    
    // MARK: - Layout of Elements
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = CGRect(x: 0,
                               y: 0,
                               width: view.width,
                               height: (view.height - 70) / 2)
        
        infoLabel.frame = CGRect(x: 0,
                                 y: mapView.height,
                                 width: view.width,
                                 height: (view.height - 70) / 2)
        
        officeNameLabel.frame = CGRect(x: 20,
                                       y: 10,
                                       width: view.width - 40,
                                       height: 30)
        
        fullAddressLabel.frame = CGRect(x: 20,
                                        y: 45,
                                        width: view.width - 40,
                                        height: 30)
        
        phonesLabel.frame = CGRect(x: 20,
                                   y: 75,
                                   width: view.width - 40,
                                   height: 60)
        
        workingLabel.frame = CGRect(x: 20,
                                    y: 135,
                                    width: view.width - 40,
                                    height: 20)
        
        workingHoursLabel.frame = CGRect(x: 20,
                                         y: 155,
                                         width: view.width - 40,
                                         height: 70)
      
        callButton.frame = CGRect(x: 0,
                                  y: view.height - (view.height / 10),
                                  width: view.width,
                                  height: 70)
        
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = InterfaceColor.resoGreen
        view.addSubview(mapView)
        view.addSubview(infoLabel)
        infoLabel.addSubview(officeNameLabel)
        infoLabel.addSubview(fullAddressLabel)
        infoLabel.addSubview(phonesLabel)
        infoLabel.addSubview(workingLabel)
        infoLabel.addSubview(workingHoursLabel)
        view.addSubview(callButton)
        
        navigationController?.navigationBar.backgroundColor = .clear
        callButton.addTarget(self,
                             action: #selector(didTapCallButton),
                             for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
        configureInfoView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMapViewOfficeLocation()
    }
    
    
    // MARK: - Methods
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapCallButton() {
        guard let office = office else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for phones in office.contactPhones {
            let phoneNumber = URL(string: "tel://\(phones.contactPhone)")!
            
            if UIApplication.shared.canOpenURL(phoneNumber) {
                
                let action = UIAlertAction(title: "\(phones.contactPhone)", style: .default, handler: { _ in
                    UIApplication.shared.open(phoneNumber)
                })
                alert.addAction(action)
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func configureInfoView() {
        guard let office = office else { return }
        
        officeNameLabel.text = office.officeName
        fullAddressLabel.text = office.fullAddress
        phonesLabel.text = office.phones
        workingLabel.text = "Режим работы"
        workingHoursLabel.text = office.openHours
    }
    
    ///Show office location on a map
    private func setMapViewOfficeLocation() {
        guard let office = office else { return }
        
        let location = CLLocationCoordinate2D(latitude: office.latitude, longitude: office.longitude)
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: CLLocationDistance(exactly: 1000)!,
                                        longitudinalMeters: CLLocationDistance(exactly: 1000)!)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = office.officeName
        mapView.addAnnotation(annotation)
    }
}
