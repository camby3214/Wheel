//
//  SpinWheelViewController.swift
//  SpinnerWheel
//
//  Created by 李韋辰 on 2023/6/16.
//
import UIKit

class SpinWheelViewController: UIViewController {
    var spinWheelView: SpinWheelView!
    var rotateButton: UIButton!
    var numberOfSections = 8
    var sectionText = ["label1","label2","label3","label4","label5","label6","label7","label8"]
    
    @IBOutlet weak var myView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        createRotateButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createSpinWheel(num: numberOfSections)
    }
    
    func createSpinWheel(num: Int) {
        let numberOfSections = num // 设置转盘的格子数量
        
        let colors = generateUniqueMorandiColors(count: numberOfSections, minColorDistance: 0.2)
        let wheelFrame = myView.bounds
        spinWheelView = SpinWheelView(frame: wheelFrame, numberOfSections: numberOfSections, colors: colors, sectionText: sectionText)
        
        
        myView.addSubview(spinWheelView)
        
    }
    
    func generateUniqueMorandiColors(count: Int, minColorDistance: CGFloat) -> [UIColor] {
        var uniqueColors: [UIColor] = []
        
        while uniqueColors.count < count {
            let color = generateMorandiColor()
            
            if !uniqueColors.contains(where: { color.distance(to: $0) < minColorDistance }) {
                uniqueColors.append(color)
            }
        }
        
        return uniqueColors
    }

    func generateMorandiColor() -> UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.2...0.4)
        let brightness = CGFloat.random(in: 0.6...0.8)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

   
    func createRotateButton() {
        rotateButton = UIButton(type: .system)
        rotateButton.setTitle("Rotate", for: .normal)
        rotateButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        rotateButton.center = view.center
        rotateButton.addTarget(self, action: #selector(rotateButtonTapped), for: .touchUpInside)
        view.addSubview(rotateButton)
    }
    

    
    @objc func rotateButtonTapped() {
        var currentValue: Double = 0
        var result = ""
        let randomDouble = Double.random(in: 0..<2 * Double.pi) // 產生0~2pi隨機的Double數字,也就是0~360度。
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        CATransaction.begin()
        rotateAnimation.fromValue = currentValue
        currentValue = currentValue + 100 * Double.pi + randomDouble //開始到結束之,總共了50圈加上randomDouble度。
        let value = currentValue.truncatingRemainder(dividingBy: Double.pi * 2) //取得currentale/Doublepi*2餘數
        let degree = value * 180 / Double.pi //將弧度轉成角度
        let a = 360/Double(numberOfSections)
        var startDegree = Double(0)
        var num = 0


        while startDegree < 360 {
            if (degree > startDegree && degree < startDegree + a) {
                let reversedArray = Array(sectionText.reversed())

                result = reversedArray[num]
                break
            } else {
                startDegree += a
                num += 1
            }
        }


        print(result)

        rotateAnimation.toValue = currentValue
        rotateAnimation.isRemovedOnCompletion = false //動畫結束後仍保在結束狀態,讓轉盤不會在動畫結束時回到最初狀態。便繼再次轉動。
        rotateAnimation.fillMode = .forwards
        rotateAnimation.duration = 2 //動畫持續時間
        rotateAnimation.repeatCount = 1 // 重複幾次
        CATransaction.setCompletionBlock { //跑完動後要做的事
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){//動畫結束後暫停0.3秒

            }
        }
        rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.9, 0.4, 1.00)//用cubic Bezier curve決定動畫速率曲線
        //也可以用內建的easeOut,但我想要最後轉一點
        spinWheelView.layer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }


    
    
    
    
}

class SpinWheelView: UIView {
    let numberOfSections: Int
    let colors: [UIColor]
    var sectionText = [String]()
    
    init(frame: CGRect, numberOfSections: Int, colors: [UIColor], sectionText:[String]) {
        self.numberOfSections = numberOfSections
        self.colors = colors
        self.sectionText = sectionText
        super.init(frame: frame)
        setupSpinWheel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSpinWheel() {
        let radius = min(bounds.width, bounds.height) / 2.0
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let angle = CGFloat.pi * 2.0 / CGFloat(numberOfSections)
        
        for i in 0..<numberOfSections {
            let startAngle = angle * CGFloat(i) + CGFloat.pi * 1.5
            let endAngle = angle * CGFloat(i + 1) + CGFloat.pi * 1.5
            
            let sectionPath = UIBezierPath()
            sectionPath.move(to: center)
            sectionPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            sectionPath.close()
            
            let sectionLayer = CAShapeLayer()
            sectionLayer.path = sectionPath.cgPath
            sectionLayer.fillColor = colors[i % colors.count].cgColor
            
            let borderLayer = CAShapeLayer()
            borderLayer.path = sectionPath.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = UIColor.black.cgColor
            borderLayer.lineWidth = 1.0
            
            let label = UILabel()
            label.text = sectionText[i]
            label.textColor = UIColor.black
            
            label.sizeToFit()
            label.center = CGPoint(x: bounds.midX + cos((startAngle + endAngle) / 2) * (radius * 0.6),
                                   y: bounds.midY + sin((startAngle + endAngle) / 2) * (radius * 0.6))
            label.transform = CGAffineTransform(rotationAngle: (startAngle + endAngle) / 2 + CGFloat.pi / 2)
            
            
            layer.addSublayer(borderLayer)
            layer.addSublayer(sectionLayer)
            addSubview(label)
        }
    }
}


extension UIColor {
    func distance(to otherColor: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        otherColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let distance = sqrt(pow(r2 - r1, 2) + pow(g2 - g1, 2) + pow(b2 - b1, 2))
        return distance
    }
}
