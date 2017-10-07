//
//  Created by Nobuhiro Ito on 2017/09/18.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Foundation

enum Platform: Int {
    case iOS
    case Android
}

extension Platform {
    var fileExtension: String {
        get {
            if self == .iOS {
                return ".ipa"
            }
            else {
                return ".apk"
            }
        }
    }
}
