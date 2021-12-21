//
//  MyClaassifyTableViewController.swift
//  onedayhackanthon
//
//  Created by nju on 2021/12/21.
//

import UIKit
import CoreML
import CoreMedia
import Vision

class MyClaassifyTableViewController: UITableViewController {
    var types:[Type] = []
    var tempResult: String = ""
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try snacks(configuration: MLModelConfiguration())
            
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
            
            
        } catch {
            fatalError("Failed to create request")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return types.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeTableViewCell

        // Configure the cell...
        cell.title.text! = types[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let targetController = segue.destination as! CollectionViewController
            let cell = sender as! TypeTableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            targetController.images = self.types[indexPath!.row].images
        }
    }
    
    func classify(image: UIImage) {
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        do{
            try handler.perform([self.classificationRequest])
        } catch {
            print("Failed to perform classification: \(error)")
        }
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

    @IBAction func choosePicture(_ sender: Any) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        presentPhotoPicker(sourceType: .camera)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyClaassifyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.originalImage] as! UIImage
        classify(image: image)
        if self.tempResult != "" {
            var flag: Bool = false
            for type in self.types {
                if type.name == self.tempResult {
                    type.images.append(image.cgImage!)
                    flag = true
                    break
                }
            }
            if flag == false {
                let type = Type()
                type.name = self.tempResult
                type.images.append(image.cgImage!)
                self.types.append(type)
            }
            self.tableView.reloadData()
        }
    }
}

extension MyClaassifyTableViewController {
    func processObservations(for request: VNRequest, error: Error?){
        if let results = request.results as? [VNClassificationObservation] {
            if results.isEmpty {
                self.tempResult = ""
            } else {
                let result = results[0].identifier
                self.tempResult = result
            }
        } else if error != nil {
            self.tempResult =  ""
        } else {
            self.tempResult = ""
        }
    }
}
