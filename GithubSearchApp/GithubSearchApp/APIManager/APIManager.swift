//
//  APIManager.swift
//  GithubSearchApp
//
//  Created by 정의석 on 2020/05/20.
//  Copyright © 2020 pandaman. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager {

  static let shared = APIManager()
  
  let baseURL = "https://api.github.com/"
  let searchURL = "search/repositories"
  
  
  //Get
  func getRepository(keyword: String, completion: @escaping (Result<GitHubRepository, Error>) -> Void) {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let param: Parameters = [
      "q" : keyword
    ]
    AF.request(baseURL + searchURL, method: .get, parameters: param)
      .responseDecodable(of: GitHubRepository.self, queue: .global(), decoder: decoder) { (response) in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  //Post
  
  //Create
  
  //Delete
  
}
