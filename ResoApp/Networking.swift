//
//  Networking.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import Foundation
import UIKit

final class Networking {
    
    public func getOfficesInfo(_ viewController: UIViewController, completion: @escaping([OfficeModel]) -> Void) {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "mobile.reso.ru"
        urlConstructor.path = "/free/v2/agencies/77"
        
        let url = urlConstructor.url
        guard let url = url else { return }
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil else {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Ошибка", message: error?.localizedDescription, preferredStyle: .alert)
                                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(action)
                
                                    viewController.present(alert, animated: true, completion: nil)
                                }
                
                return }
            
            
            let offices = try? JSONDecoder().decode([OfficeModel].self, from: data)
            guard let offices = offices else { return }
            completion(offices)
            
        }
        task.resume()
    }
}
