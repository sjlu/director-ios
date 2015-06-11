//
//  Created by Jonathan Grana on 6/10/15.
//  Copyright (c) 2015 Steven Lu. All rights reserved.
//

import Foundation

struct Movie {
    var poster_url: String?
    var status: String
    var title: String
    var tmdb_id: NSNumber
    var type: String?
    var date: String?

    init(title:String, tmdb_id:NSNumber) {
        self.title = title
        self.tmdb_id = tmdb_id
        self.status = ""
    }
}
