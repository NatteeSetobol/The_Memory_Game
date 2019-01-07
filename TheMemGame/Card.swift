//
//  Card.swift
//  TheMemGame
//
//  Created by Nattee Setobol on 2018/03/10.
//  Copyright © 2018年 Nattee Setobol. All rights reserved.
//

import Foundation
import UIKit

enum card_type
{
    case NO_TYPE,PANDA,PENGUIN,DOG
}

struct card
{
    var id: Int = -1
    var min : CGPoint = CGPoint(x: 0, y: 0)
    var max : CGPoint = CGPoint(x: 0,y: 0)
    var flipped : Bool
    var matched : Bool = false
    var  type : card_type = card_type.NO_TYPE
    var index = -1
    
    init()
    {
        flipped = Bool.init()
        flipped = false
    }

}
