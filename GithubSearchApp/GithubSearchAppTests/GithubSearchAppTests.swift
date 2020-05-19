//
//  GithubSearchAppTests.swift
//  GithubSearchAppTests
//
//  Created by pandaman on 2020/05/18.
//  Copyright © 2020 pandaman. All rights reserved.
//

import XCTest
import Alamofire
@testable import GithubSearchApp

class GithubSearchAppTests: XCTestCase {
  
  var sut: APIManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      try super.setUpWithError()
      sut = APIManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      sut = nil
      try super.tearDownWithError()
    }
  
  func testGetRepositoryAPIMethod() {
    //given
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    //1
    let promise = expectation(description: "Request & Decoding Success")
    let param: Parameters = [
      "q" : "Ruby"
    ]
    
    //when
    AF.request(APIManager.shared.baseURL + APIManager.shared.searchURL, method: .get, parameters: param)
      .responseDecodable(of: GitHubRepository.self, queue: .global(), decoder: decoder) { (response) in
        //then
        switch response.result {
        case .success:
          promise.fulfill()
        case .failure(let error):
          XCTFail("Error: \(error.localizedDescription)")
        }
    }
    wait(for: [promise], timeout: 3)
  }


}
