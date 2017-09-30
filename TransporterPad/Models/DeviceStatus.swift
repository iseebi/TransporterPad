//
// Created by Nobuhiro Ito on 2017/09/18.
// Copyright (c) 2017 Nobuhiro Ito. All rights reserved.
//

import Foundation

@objc enum DeviceStatus: Int {
    case Initializing
    case Idle
    case Waiting
    case Transporting
    case Complete
    case Error
}
