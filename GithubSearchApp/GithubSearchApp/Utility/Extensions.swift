//
//  Extensions.swift
//  GithubSearchApp
//
//  Created by 정의석 on 2020/05/20.
//  Copyright © 2020 pandaman. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) -> Void {
    views.forEach {
      addSubview($0)
    }
  }
}
