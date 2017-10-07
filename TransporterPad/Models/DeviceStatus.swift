//
//  Created by Nobuhiro Ito on 2017/09/18.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
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
