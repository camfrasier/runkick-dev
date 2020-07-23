//
//  RightMenuOptionCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/18/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class RightMenuOptionCell: UITableViewCell {

    // MARK: - Properties
    
    let shapeLayer = CAShapeLayer()
    // Mark: - Properties
    
    var activity: Activity? {
        
        didSet {
            guard let tripId = activity?.tripId else { return }
            guard let distance = activity?.distance else { return }
            guard let creationDate = activity?.creationDate else { return }
            guard let stepCount = activity?.stepCount else { return }
            //guard let duration = activity?.duration else { return }
            //guard let pace = activity?.pace else { return }
            
            /*
            
            guard let averagePace = activity?.averagePace else { return }
            guard let pace = activity?.pace else { return }
           //
            self.timeElapsed += self.timerInterval
            //let duration = self.timeIntervalFormat(interval: self.timeElapsed)
            */
            Database.fetchActivity(with: tripId) { (activity) in
            
               
            }
            
            distanceLabel.text = String(format:"%02.02f", (distance))
            postTimeLabel.text = convertDateFormater("\(creationDate)")
            self.stepCountLabel.text = "\(Int(stepCount))"
            
            print("DEBUG: THIS IS THE DISTANCE \(distanceLabel.text)")
            print("DEBUG: THIS IS THE TIME \(postTimeLabel.text)")
            print("DEBUG: THIS IS THE STEPS \(stepCountLabel.text)")
            
            /*
            
            self.averagePaceLabel.text = "\(Double(averagePace))"
             //pace wasn't initially in the results will need to add them to this user.
            //self.postTimeLabel.text = activity?.creationDate.description(with: .current)
            */
            
        }
    }
    let timerInterval = 1.0
    var timeElapsed: TimeInterval = 0.0
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        
        return label
    }()
    
    let milesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Miles"
        
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        return label
    }()
    
    let stepCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        //label.font = UIFont.systemFont(ofSize: 18)
        label.font = UIFont(name: "HelveticaNeue", size: 24)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Steps"
        
        return label
    }()
    
    let averagePaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        return label
    }()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.text = "date"
        return label
    } ()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white

        selectionStyle = .default

        self.selectionStyle = .default
        
        configureUserAnalytics()
        
        addSubview(distanceLabel)
        distanceLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 140, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(milesLabel)
        milesLabel.anchor(top: distanceLabel.bottomAnchor, left: distanceLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(stepsLabel)
        stepsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 46, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(stepCountLabel)
        stepCountLabel.anchor(top: nil, left: nil, bottom: stepsLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        stepCountLabel.centerXAnchor.constraint(equalTo: stepsLabel.centerXAnchor).isActive = true
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: distanceLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 0, height: 0)
        
        //addSubview(paceLabel)
        //paceLabel.anchor(top: topAnchor, left: milesLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 70, paddingBottom: 0, paddingRight: 0, width: 0, height: 26)
        
        //addSubview(durationLabel)
        //durationLabel.anchor(top: postTimeLabel.bottomAnchor, left: nil, bottom: nil, right: postTimeLabel.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
       
        
    }
 

    func animateDistanceCircle() {
        
        print("attempting to animate stroke")
        
        // the key path is the thing you want to animate on the shape layer.
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicFit")
        
    }
    
      func calculateAnalytics() {
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              
              self.beginDownloadingDistance()
              
              self.animateDistanceCircle()
    
          }
      }
    
    private func beginDownloadingDistance() {
        print("attempting to download from firebase")
        
        // basically in this function we want to divide the total distance covered by the total distance expected
    }
    
    func timeIntervalFormat(interval: TimeInterval)-> String {
        var seconds = Int(interval + 0.5) // round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd MMM"
        return  dateFormatter.string(from: date!)
    }
    
    func configureUserAnalytics() {
        
        // this can be users on the analytics page
        
        //let center = self.center
        //let center = CGPoint(x: self.center.x - 100, y: self.center.y - 90)
        
        let center = CGPoint(x: 66, y: 65)
        let circularPath = UIBezierPath(arcCenter: center, radius: 45, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        self.layer.addSublayer(trackLayer)
        
        //self.layer.insertSublayer(trackLayer, below: self.layer)
        
        

        // use the negative CGFloat value to bring start position to 12 o'clock
       // let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.statusBarGreen().cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
        //self.layer.insertSublayer(shapeLayer, below: self.layer)
        
        // we can coment this out and just add the handle function to let it animate later
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        calculateAnalytics()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
