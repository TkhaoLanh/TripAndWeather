//
//  Service.swift
//  TripAndWeather
//
//  Created by user248619 on 10/12/23.
//

import Foundation

class Service{
    private init(){}
    static var shared = Service()
    
    func getDataFrom(urlStr : String, completion : @escaping (Result<Data,Error>)->()){
        guard let url = URL(string: urlStr) else {return}
        
        
        
       URLSession.shared.dataTask(with: url) { data, resonse, error in
            if let error = error {
                //do something with error
                completion(.failure(error))
                
            }
            else if let data = data {
                // do something with data
                 completion(.success(data))
            }
       }.resume()
        
        
    }}
