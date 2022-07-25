//
//  ListOfOfficesTableViewCell.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import UIKit
import CoreLocation

final class ListOfOfficesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ListOfOfficesTableViewCell"
    
    // MARK: - UIElements
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var officeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var shortAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private lazy var workingHoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var distanceToOfficeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        addSubview(officeNameLabel)
        //        addSubview(shortAddressLabel)
        //        addSubview(workingHoursLabel)
        //        addSubview(distanceToOfficeLabel)
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setConstrains() {
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(officeNameLabel)
        verticalStackView.addArrangedSubview(shortAddressLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(workingHoursLabel)
        horizontalStackView.addArrangedSubview(distanceToOfficeLabel)
        
        NSLayoutConstraint.activate([
            verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    /*
     override func layoutSubviews() {
     super.layoutSubviews()
     officeNameLabel.frame = CGRect(x: 20,
     y: 5,
     width: contentView.width - 20,
     height: contentView.height / 3)
     
     shortAddressLabel.frame = CGRect(x: 20,
     y: officeNameLabel.height,
     width: contentView.width - 20,
     height: contentView.height / 3)
     
     workingHoursLabel.frame = CGRect(x: 20,
     y: officeNameLabel.height + shortAddressLabel.height,
     width: (contentView.width - 20) / 6,
     height: contentView.height / 3)
     
     distanceToOfficeLabel.frame = CGRect(x: 20 + workingHoursLabel.width,
     y: officeNameLabel.height + shortAddressLabel.height,
     width: contentView.width - 20 - workingHoursLabel.width,
     height: contentView.height / 3)
     }
     */
    
    override func prepareForReuse() {
        super.prepareForReuse()
        officeNameLabel.text = nil
        shortAddressLabel.text = nil
        workingHoursLabel.text = nil
        distanceToOfficeLabel.text = nil
    }
    
    // MARK: - Cell Configuration
    
    public func configure(with office: OfficeModel, userLocation: CLLocation?, currentTime: Int, currentDay: Int) {
        officeNameLabel.text = office.officeName
        shortAddressLabel.text = office.shortAddress
        
        let officeCoordinate = CLLocation(latitude: office.latitude, longitude: office.longitude)
        distanceToOfficeLabel.text = "до офиса: \(String(format: "%.01f", officeCoordinate.distance(from: userLocation ?? officeCoordinate) / 1000)) км."
        
        
        if let officeWorkingHours = office.officeWorkingHours {
            
            for openHours in officeWorkingHours {
                
                let startTime = Int(openHours.startTime.filter { "0123456789".contains($0) }) ?? 0
                let endTime = Int(openHours.endTime.filter { "0123456789".contains($0) }) ?? 0
                
                if openHours.dayCount == currentDay - 1 {
                    
                    if currentTime >= startTime && currentTime <= endTime {
                        
                        workingHoursLabel.text = "Открыт"
                        workingHoursLabel.textColor = InterfaceColor.resoGreen
                        
                    } else {
                        
                        workingHoursLabel.text = "Закрыт"
                        workingHoursLabel.textColor = InterfaceColor.resoRed
                    }
                    
                } else if openHours.dayCount == 7 && currentDay == 1 {
                    
                    if currentTime >= startTime && currentTime <= endTime {
                        
                        workingHoursLabel.text = "Открыт"
                        workingHoursLabel.textColor = InterfaceColor.resoGreen
                        
                    } else {
                        
                        workingHoursLabel.text = "Закрыт"
                        workingHoursLabel.textColor = InterfaceColor.resoRed
                    }
                    
                } 
                
                
                
                /*
                 if openHours.dayCount == currentDay - 1 && officeWorkingHours.count == 7 {
                 
                 if currentTime >= startTime && currentTime <= endTime {
                 
                 workingHoursLabel.text = "Открыт"
                 workingHoursLabel.textColor = InterfaceColor.resoGreen
                 
                 } else {
                 
                 workingHoursLabel.text = "Закрыт"
                 workingHoursLabel.textColor = InterfaceColor.resoRed
                 }
                 
                 } else if openHours.dayCount == 7 && currentDay == 1 && officeWorkingHours.count == 7 {
                 
                 if currentTime >= startTime && currentTime <= endTime {
                 
                 workingHoursLabel.text = "Открыт"
                 workingHoursLabel.textColor = InterfaceColor.resoGreen
                 
                 } else {
                 
                 workingHoursLabel.text = "Закрыт"
                 workingHoursLabel.textColor = InterfaceColor.resoRed
                 }
                 
                 } else if openHours.dayCount == currentDay - 1 && officeWorkingHours.count == 6 {
                 
                 if currentTime >= startTime && currentTime <= endTime {
                 
                 workingHoursLabel.text = "Открыт"
                 workingHoursLabel.textColor = InterfaceColor.resoGreen
                 
                 } else {
                 
                 workingHoursLabel.text = "Закрыт"
                 workingHoursLabel.textColor = InterfaceColor.resoRed
                 }
                 
                 } else if openHours.dayCount == currentDay - 1 && officeWorkingHours.count == 5 {
                 
                 if currentTime >= startTime && currentTime <= endTime {
                 
                 workingHoursLabel.text = "Открыт"
                 workingHoursLabel.textColor = InterfaceColor.resoGreen
                 
                 } else {
                 
                 workingHoursLabel.text = "Закрыт"
                 workingHoursLabel.textColor = InterfaceColor.resoRed
                 }
                 
                 } else if openHours.dayCount != currentDay - 1 && officeWorkingHours.count == 5 {
                 
                 workingHoursLabel.text = "Закрыт"
                 workingHoursLabel.textColor = InterfaceColor.resoRed
                 
                 } else {
                 
                 workingHoursLabel.text = "См. подробнее"
                 workingHoursLabel.textColor = .systemOrange
                 }
                 */
            }
            
        } else {
            
            workingHoursLabel.text = "См. подробнее"
            workingHoursLabel.textColor = .systemOrange
        }
    }
}


