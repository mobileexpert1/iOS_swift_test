//
//  KadamaVnextTests.swift
//  KadamaVnextTests
//
//  Created by mobile on 21/07/21.
//

import XCTest
@testable import KadamaVnext

class KadamaVnextTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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
                           // AlertFactory.showAlert(message: error.localizedDescription)
                            break
                        }
                        completion(.failure(.jsonDecodingFailure))
                    }
                    else if let responseData = data{
                       // let responseString = String(data: responseData, encoding: String.Encoding.utf8) as String?
                       // print("Response: ",responseString ?? "No response")
                      //  self.parseResponseData(data: responseData, completion: completion)
                    }
                }
            })
            task.resume()
        }
    }
    
}
