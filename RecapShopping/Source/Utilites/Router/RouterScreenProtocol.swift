//
//  RouterScreenProtocol.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/11.
//

protocol RouterScreenProtocol: RouterNavigationViewScreenProtocol & RouterNavigationStackScreenProtocol & RouterSheetScreenProtocol {
    var routeType: RouterScreenPresentationType { get }
}

enum RouterScreenPresentationType {
    case sheet
    case fullScreenCover
    case navigationLink

    // To make it work, you have to use NavigationStack
    case navigationDestination
}

