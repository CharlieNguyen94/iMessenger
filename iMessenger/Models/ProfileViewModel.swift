//
//  ProfileViewModel.swift
//  iMessenger
//
//  Created by Charlie Nguyen on 17/08/2021.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
