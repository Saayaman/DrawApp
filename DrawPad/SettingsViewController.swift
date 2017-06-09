import UIKit



protocol SettingsDelegate {
    func receiveColor(color:[CGFloat])
    func receiveBrushSize(brushSize:CGFloat)
    func receiveOpacity(opacity:CGFloat)
}

class SettingsViewController: UIViewController{
    
    var delegate:SettingsDelegate?
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!

    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!

    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    @IBOutlet weak var imageViewOpacity: UIImageView!
    
    var circle: UIView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    var brushSize: CGFloat = 10
    var opacity: CGFloat?
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var colorsPassed: Array<CGFloat> = []


  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //this red,blue,green color is for circle
    red = colorsPassed[0] 
    green = colorsPassed[1] 
    blue = colorsPassed[2] 

    print("\(red), \(green), \(blue)")

    //change colors to slidercolors from 0~255
    let sColorR = Float(colorsPassed[0]*255)
    let sColorG = Float(colorsPassed[1]*255)
    let sColorB = Float(colorsPassed[2]*255)

    //format to string for Label
    labelRed.text = NSString(format: "%.f", sColorR) as String
    labelGreen.text = NSString(format: "%.f", sColorG) as String
    labelBlue.text = NSString(format: "%.f", sColorB) as String
    
    //set color to the slider
    sliderRed.setValue(sColorR, animated: true)
    sliderGreen.setValue(sColorG, animated: true)
    sliderBlue.setValue(sColorB, animated: true)


    imageViewBrush.backgroundColor = UIColor.gray
    
    //put circle in middle of imageView, set Default value
    circle.frame.size.width = brushSize
    circle.frame.size.height = brushSize
    circle.layer.cornerRadius = brushSize/2
    circle.center = CGPoint(x: imageViewBrush.bounds.size.width/2, y: imageViewBrush.bounds.size.height/2)
    
    circle.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha:opacity!)
    circle.clipsToBounds = true
    
    //labels
    labelOpacity.text = NSString(format: "%.2f", opacity!) as String
    labelBrush.text = NSString(format: "%.f", brushSize) as String

    sliderOpacity.setValue(Float(opacity!), animated: true)
    sliderBrush.setValue(Float(brushSize), animated: true)
    
    imageViewBrush.addSubview(circle)
    
    drawPreview()
  }
    
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }

    
  @IBAction func close(_ sender: AnyObject) {

    
    dismiss(animated: true, completion: nil)
  }

  @IBAction func colorChanged(_ sender: UISlider) {
    
    
    labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
    labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
    labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
    
    //format sliderColor 0~255 to cirleColor 0~1.0
    red = CGFloat(sliderRed.value / 255.0)
    green = CGFloat(sliderGreen.value / 255.0)
    blue = CGFloat(sliderBlue.value / 255.0)

    print("sliderred: \(Int(sliderRed.value)) red: \(red)")
    print("slidergreen: \(Int(sliderGreen.value)), green: \(green)")
    print("sliderblue: \(Int(sliderBlue.value)), blue: \(blue)")
    
    circle.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: opacity!)
    
    //Send this color info back to ViewController:
    let secondVCColor:[CGFloat] = [red, green, blue]
    delegate?.receiveColor(color: secondVCColor)

    drawPreview()
  }

  @IBAction func sliderChanged(_ sender: UISlider) {
    if sender == sliderBrush {
        
        brushSize = CGFloat(sliderBrush.value)
        
        labelBrush.text = NSString(format: "%.f", brushSize) as String
        
        circle.frame.size.width = brushSize
        circle.frame.size.height = brushSize
        circle.layer.cornerRadius = brushSize/2
        circle.center = CGPoint(x: imageViewBrush.bounds.size.width/2, y: imageViewBrush.bounds.size.height/2)
        
        //send
        delegate?.receiveBrushSize(brushSize: brushSize)
    }
    
    if sender == sliderOpacity{
        
        opacity = CGFloat(sliderOpacity.value)
        circle.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: opacity!)
        labelOpacity.text = NSString(format: "%.2f", opacity!) as String
        
        delegate?.receiveOpacity(opacity: opacity!)
        
    }
    drawPreview()
  }
    
    
    func drawPreview(){
        
        //draw inside imageViewBrush!
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        var context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)

        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        
        context?.setStrokeColor(UIColor.blue.cgColor);

        
        context?.strokePath()
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     
        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        
        context?.setStrokeColor(UIColor.blue.cgColor);
        
        //draw inside opacityView!!
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(20)
        
        
        context?.strokePath()
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
}
