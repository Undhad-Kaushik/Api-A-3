//
//  ViewController.swift
//  Api(A)
//
//  Created by undhad kaushik on 01/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var myTabelView: UITableView!
    
    var arr : MainData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nibregister()
        apiCall()
    }
    
    private func nibregister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        myTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        myTabelView.separatorStyle = .none
    }

    
    private func apiCall(){
        AF.request("https://datausa.io/api/data?drilldowns=Nation&measures=Population", method: .get).responseData{ [self] response in
            debugPrint(response)
            
            if response.response?.statusCode == 200 {
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(MainData.self, from: apiData)
                    print(result)
                    arr = result
                    myTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("sumthing went rong")
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.dataSourceNameLabel.text = "\(arr.data[indexPath.row].idNation)"
        cell.descriptionLabel.text = "\(arr.data[indexPath.row].idYear)"
        cell.datasetNameLabel.text = "\(arr.data[indexPath.row].nation)"
        cell.datasetLinkLabel.text = "\(arr.data[indexPath.row].idNation)"
        cell.tabelIdLabel.text = "\(arr.data[indexPath.row].population)"
        cell.topicLabel.text = "\(arr.data[indexPath.row].slugNation)"
        cell.subTopicLabel.text = "\(arr.data[indexPath.row].year)"

        return cell
    }
    
    
}

struct MainData: Decodable{
    var data: [Data]
    var source: [Source]
    
    
   private enum CodingKeys: String, CodingKey{
       case data = "data"
       case source = "source"
       
    }
}

struct Data: Decodable{
    var idNation: String
    var nation: String
    var idYear: Int
    var year: String
    var population: Int
    var slugNation: String
    private enum CodingKeys: String, CodingKey{
        case idNation = "ID Nation"
        case idYear = "ID Year"
        case slugNation = "Slug Nation"
        case nation = "Nation"
        case year = "Year"
        case population = "Population"
    }
}


struct Source: Decodable{
    var measures: [String]
    var annotations: Annotations
    var name: String
    var substitutions: [Substitutions]
    private enum CodingKeys: String, CodingKey{
        case measures = "measures"
        case annotations = "annotations"
        case name = "name"
        case substitutions = "substitutions"
        
    }
}

struct Annotations: Decodable{
    var sourceName: String
    var sourceDescription: String
    var datasetName: String
    var datasetLink: String
    var tableId: String
    var topic: String
    var subtopic: String
    
    private enum CodingKeys: String, CodingKey{
        case sourceName = "source_name"
        case sourceDescription = "source_description"
        case datasetName = "dataset_name"
        case datasetLink = "dataset_link"
        case tableId = "table_id"
        case topic = "topic"
        case subtopic = "subtopic"
    }
}

struct Substitutions: Decodable{

}
