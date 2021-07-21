//
//  PokemonStore.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//
import SystemConfiguration
import Foundation

let kBaseMessageKey: String = "message"
let kBaseStatusKey: String = "status"
let kBaseResponseKey: String = "response"
let kBaseDataKey: String = "data"

class ServiceManager: NSObject {
    
    let defaultError: String = "Some error has been occured."
    
    public static let sharedInstance = ServiceManager()
    
    var showProgress: Bool = true
    var retry: Int = 0
    var showError = true
    
}
extension ServiceManager {
    
    // Public function to request apis
    func requestApi<T:Codable>(_ url: String,showLoader:Bool = true,completion:@escaping (_ success:Bool,_ result:T?) -> Void) {
        requestAPI(url,showLoader: showLoader) { (result:ApiResult<T?,APIError>) in
            switch result{
            case .success(let result):
                completion(true, result ?? nil)
            case.failure(let error):
                AlertFactory.showAlert(message: error.localizedDescription)
                print(error.customDescription)
                completion(false, nil)
            }
        }
    }
    
    // private function to request apis
    private func requestAPI<T:Codable>(_ url: String,showLoader:Bool = true, completion: @escaping (ApiResult<T,APIError>) -> Void) {
        let url = URL(string: url)
        print("URL ",url?.absoluteString ?? "")
        //  if !HUD.isVisible {
        //   HUD.show(.progress)
        //   }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let usableUrl = url {
            let task = session.dataTask(with: usableUrl, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    //   HUD.hide()
                    if let error = error {
                        print("--------- Error -------",error.localizedDescription)
                        switch URLError.Code(rawValue: error._code) {
                        case .notConnectedToInternet:
                            print("NotConnectedToInternet")
                            AlertFactory.showAlert(message: "No internet connection")
                        default:
                            AlertFactory.showAlert(message: "There was an error in the response. Please try again.")
                            break
                        }
                        completion(.failure(.jsonDecodingFailure))
                    }
                    else if let responseData = data{
                        let responseString = String(data: responseData, encoding: String.Encoding.utf8) as String?
                        print("Response: ",responseString ?? "No response")
                    }
                }
            })
            task.resume()
        }
    }
}



enum ApiResult<T, U> where U: Error , T:Codable  {
    case success(T?)
    case failure(U)
}

enum APIError: Error {
    
    case invalidData
    case jsonDecodingFailure
    case responseUnsuccessful(description: String)
    case decodingTaskFailure(description: String)
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case postParametersEncodingFalure(description: String)
    
    var customDescription: String {
        switch self {
        case .requestFailed(let description): return "\(description)"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful(let description): return "\(description)"
        case .jsonDecodingFailure: return "APIError - JSON decoding Failure"
        case .jsonConversionFailure(let description): return "\(description)"
        case .decodingTaskFailure(let description): return "\(description)"
        case .postParametersEncodingFalure(let description): return "\(description)"
        }
    }
}
