
import UIKit



class ViewController: UIViewController, SettingsDelegate{


    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    
    var brushColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    let colors: [(CGFloat,CGFloat,CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    
    func drawLineFrom(fromPoint: CGPoint, toPoint:CGPoint){
        
        UIGraphicsBeginImageContext(view.frame.size)
        
         tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        //change brush color and set it!
        brushColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
        self.brushColor.setStroke()
        
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(brushWidth)
       
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
            
        }
    }


  @IBAction func reset(_ sender: AnyObject) {
    tempImageView.image = nil
  }
  

  @IBAction func pencilPressed(_ sender: AnyObject) {
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count{
        index = 0
    }
    
    (red, green, blue) = colors[index]
    
    if index == colors.count - 1 {
        self.opacity  = 1.0
    }

  }

    
    @IBAction func tappedSetting(_ sender: Any) {
        
        //This is the version where you pass data with instantiation!
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
//        let rgb = [red,green,blue]
//        myVC.colorsPassed = rgb
//        navigationController?.pushViewController(myVC, animated: true)
        
        performSegue(withIdentifier: "Settings", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingsViewController {
            
            let rgb = [red,green,blue]
            destination.colorsPassed = rgb
            destination.opacity = self.opacity
            destination.brushSize = self.brushWidth
            
            destination.delegate = self
        }
    }
    
    func receiveColor(color: [CGFloat]) {
        (red, green, blue) = (color[0],color[1],color[2])
    }
    
    func receiveBrushSize(brushSize: CGFloat) {
        self.brushWidth = brushSize;
    }
    
    func receiveOpacity(opacity: CGFloat) {
        self.opacity = opacity
    }
    
    
}
