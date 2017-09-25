//
// Created by Nobuhiro Ito on 2017/09/18.
// Copyright (c) 2017 Nobuhiro Ito. All rights reserved.
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
