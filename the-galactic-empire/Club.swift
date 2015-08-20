import SwiftyJSON

class Club {
    
    var id: Int!
    var points: Int!
    var name: String!
    var wins: Int!
    var losses: Int!
    var otl: Int!
    var division: Int!
    var teamID: Int!
    
    var recent: [Match] = []
    
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
    
    func setRecent(json: JSON){
        
        recent = []
        
        for (key,val) in json["raw"] {
            
            let m = Match(json: val, id: id)
            
            recent.append(m)
            
        }
        
        recent.sort({ $0.timestamp > $1.timestamp })
    
    }
    
}

class Match {
    
    var score: String!
    var timestamp: Int!
    var timeAgo: String!
    
    var homeName: String!
    var homeTID: Int!
    var homeID: Int!
    var homeG: Int!
    var homeGA: Int!
    var homeShots: Int!
    var homeImage: UIImage!
    var homeFaceoffs: Int!
    var homeHits: Int!
    
    var awayName: String!
    var awayTID: Int!
    var awayID: Int!
    var awayG: Int!
    var awayGA: Int!
    var awayShots: Int!
    var awayImage: UIImage!
    var awayFaceoffs: Int!
    var awayHits: Int!
    
    var body: JSON!
    
    init (
        json: JSON,id: Int
    ){
        
        body = json
        
        timestamp = json["timestamp"].intValue
        timeAgo = json["timeAgo"].stringValue
        
        for (key,val) in json["clubs"] {
            
            if id == key.toInt() {
                
                homeID = key.toInt()
                homeName = val["details"]["name"].stringValue
                homeTID = val["details"]["teamId"].intValue
                
                let s = "https://www.easports.com/iframe/nhl14proclubs/bundles/nhl/dist/images/crests/d\(homeTID).png"
                
                if let url = NSURL(string: s) {
                    if let data = NSData(contentsOfURL: url){
                        homeImage = UIImage(data: data)
                    }
                }
                
            } else {
                
                score = val["scorestring"].stringValue
                
                awayID = key.toInt()
                awayName = val["details"]["name"].stringValue
                awayTID = val["details"]["teamId"].intValue
                
                let s = "https://www.easports.com/iframe/nhl14proclubs/bundles/nhl/dist/images/crests/d\(awayTID).png"
                
                if let url = NSURL(string: s) {
                    if let data = NSData(contentsOfURL: url){
                        awayImage = UIImage(data: data)
                    }
                }
                
            }
            
        }
        
        for (key,val) in json["aggregate"] {
            
            if id == key.toInt() {
                
                homeShots = val["skshots"].intValue
                
            } else {
                
                awayShots = val["skshots"].intValue
                
            }
            
        }
        
    }
    
}