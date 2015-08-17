import SwiftyJSON

class Club {
    
    var id: Int!
    var points: Int!
    var name: String!
    var wins: Int!
    var losses: Int!
    var otl: Int!
    var division: Int!
    
    init(
        json _club: JSON
    ){
        
        id = _club["clubId"].stringValue.toInt()
        points = _club["currentPoints"].stringValue.toInt()
        name = _club["name"].stringValue
        wins = _club["wins"].intValue
        losses = _club["losses"].intValue
        otl = _club["otl"].intValue
        division = _club["curDivision"].stringValue.toInt()
        
    }
    
}