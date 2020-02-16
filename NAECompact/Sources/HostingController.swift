//
//  HostingController.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 16/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class HostingController<T: View>: UIHostingController<T> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
