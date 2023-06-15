//
//  MultiActionButton.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation
import UIKit

enum ButtonAction : String {
    case start = "Start"
    case pause = "Pause"
    case resume = "Resume"
    case finished = "Finished"
}

class MultiActionButton : UIButton {
    var action : ButtonAction = .start
}
