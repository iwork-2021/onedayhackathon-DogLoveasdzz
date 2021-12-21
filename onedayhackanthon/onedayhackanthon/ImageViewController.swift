//
//  ImageViewController.swift
//  onedayhackanthon
//
//  Created by nju on 2021/12/21.
//

import UIKit

class ImageViewController: UIViewController {

    var inputImage:UIImage = UIImage()
    @IBOutlet weak var images: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        images.image = inputImage
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
