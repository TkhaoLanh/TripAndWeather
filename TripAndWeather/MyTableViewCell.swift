
import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func configureCell(item : City)  {
        textLabel?.text = item.name
        detailTextLabel?.text = "Tempture..."
        imageView?.image = UIImage(systemName: "photo")
       
        
        
        if let cityName = item.name{
            let query = [ "q" : cityName , "appid" : api_key_Value]
        var url = "https://api.openweathermap.org/data/2.5/weather?&"
        Service.shared.getData(url: url,query: query) { (result) in
            switch result {
            case .failure(let error ):
                print("\(error)")
            case .success(let data):
                if let weather = try? JSONDecoder().decode(weatherResults.self, from: data){
                    if let icon = weather.weather?[0].icon {
                        url = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                        Service.shared.getData(url: url, query: nil) { result in
                            switch result {
                            case .success(let imgdata):
                                let img = UIImage(data: imgdata)
                                DispatchQueue.main.async {
                                    self.imageView?.image = img
                                }
                             
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.detailTextLabel?.text = weather.main.temp.description
                    }
                    
                  //  detailTextLabel?.text = weather.main.temp
                  //  weather.weather?[0].icon
                }
                print("\(data)")
            }
        }
        }
 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
