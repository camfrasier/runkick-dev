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
            guard let duration = activity?.duration else { return }
            guard let pace = activity?.pace else { return }
            
            calculateStepPercentage(stepCount)
            
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
            postTimeLabel.text = convertTimeFormater("\(creationDate)")
            postDateLabel.text = convertDateFormater("\(creationDate)")
            stepCountLabel.text = "\(Int(stepCount))"
            durationLabel.text = String(duration)
            paceLabel.text = String(pace)
            
            print("DEBUG: THIS IS THE DISTANCE \(distanceLabel.text)")
            print("DEBUG: THIS IS THE TIME \(postTimeLabel.text)")
            print("DEBUG: THIS IS THE STEPS \(stepCountLabel.text)")
            print("DEBUG: THIS IS THE DURATION \(durationLabel.text)")
            print("DEBUG: THIS IS THE PACE \(paceLabel.text)")
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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        //label.font = UIFont(name: "HelveticaNeue", size: 50)
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
        label.text = "0.00"
        return label
    }()
    
    let milesLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.textColor = UIColor.rgb(red: 160, green: 160, blue: 160)
        label.font = UIFont.systemFont(ofSize: 14)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Miles"
        
        return label
    }()
    
    let stepCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        //label.font = UIFont.systemFont(ofSize: 18)
        //label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 55)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        label.text = "0"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 170, green: 170, blue: 170)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Steps"
        
        return label
    }()
    

    
    let caloriesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        //label.font = UIFont(name: "HelveticaNeue", size: 50)
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
        label.text = "560"
        return label
    }()
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.textColor = UIColor.rgb(red: 170, green: 170, blue: 170)
        label.font = UIFont.systemFont(ofSize: 14)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Calories"
        
        return label
    }()
    
    
    let averagePaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        //label.font = UIFont(name: "HelveticaNeue", size: 50)
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
        label.text = "0.00"
        return label
    }()
    
    
    let paceLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.textColor = UIColor.rgb(red: 170, green: 170, blue: 170)
        label.font = UIFont.systemFont(ofSize: 14)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Calories"
        
        return label
    }()
    
    /*
    let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Min/mi"
        return label
    }()
    */
    /*
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        return label
    }()
    
    let milesMinuteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.boldSystemFont(ofSize: 11)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Min/mi"
        
        return label
    }()
    */
    
    let pointsCountlabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        //label.font = UIFont(name: "HelveticaNeue", size: 50)
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
        label.text = "1250"
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.textColor = UIColor.rgb(red: 170, green: 170, blue: 170)
        label.font = UIFont.systemFont(ofSize: 14)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "Points"
        
        return label
    }()
    
    let postDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        label.text = "date"
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 115, green: 115, blue: 115)
        label.text = "time"
        return label
    } ()
    
    let postTimeBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        return view
    }()
    

    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        label.text = "00:00"
        return label
    } ()
    
    let tripTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 170, green: 170, blue: 170)
        label.text = "Duration"
        return label
    } ()
    
    lazy var activityHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Activity History", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        button.setTitleColor(UIColor.rgb(red: 90, green: 90, blue: 90), for: .normal)
        button.addTarget(self, action: #selector(handleActivityHistory), for: .touchUpInside)
        return button
    } ()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        
        selectionStyle = .default

        self.selectionStyle = .default
        
        configureUserAnalytics()
        
        addSubview(stepsLabel)
        stepsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 205, paddingLeft: 185, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(stepCountLabel)
        stepCountLabel.anchor(top: nil, left: nil, bottom: stepsLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 55)
        stepCountLabel.centerXAnchor.constraint(equalTo: stepsLabel.centerXAnchor).isActive = true
        
        addSubview(postTimeBackground)
        postTimeBackground.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 90, height: 60)
        postTimeBackground.layer.cornerRadius = 30
        
        
        postTimeBackground.addSubview(postDateLabel)
        postDateLabel.anchor(top: postTimeBackground.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        postDateLabel.centerXAnchor.constraint(equalTo: postTimeBackground.centerXAnchor).isActive = true
        
        postTimeBackground.addSubview(postTimeLabel)
        postTimeLabel.anchor(top: postDateLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postTimeLabel.centerXAnchor.constraint(equalTo: postDateLabel.centerXAnchor).isActive = true
        
        /*
        addSubview(durationLabel)
        durationLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        
        addSubview(tripTimeLabel)
        tripTimeLabel.anchor(top: durationLabel.bottomAnchor, left: durationLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
        addSubview(distanceLabel)
        distanceLabel.anchor(top: postTimeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 245, paddingLeft: 65, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        //distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(milesLabel)
        milesLabel.anchor(top: distanceLabel.bottomAnchor, left: distanceLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(caloriesCountLabel)
        caloriesCountLabel.anchor(top: distanceLabel.topAnchor, left: milesLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        
        addSubview(caloriesLabel)
        caloriesLabel.anchor(top: caloriesCountLabel.bottomAnchor, left: caloriesCountLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(pointsCountlabel)
        pointsCountlabel.anchor(top: distanceLabel.topAnchor, left: caloriesLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        
        addSubview(pointsLabel)
        pointsLabel.anchor(top: pointsCountlabel.bottomAnchor, left: pointsCountlabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(activityHistoryButton)
        activityHistoryButton.anchor(top: milesLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        activityHistoryButton.layer.cornerRadius = 25
        activityHistoryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityHistoryButton.layer.borderColor = UIColor.rgb(red: 120, green: 120, blue: 120).cgColor
        activityHistoryButton.layer.borderWidth = 0.5
        
        /*
        addSubview(paceLabel)
        paceLabel.anchor(top: distanceLabel.topAnchor, left: distanceLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(milesMinuteLabel)
        milesMinuteLabel.anchor(top: paceLabel.bottomAnchor, left: distanceLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
        /*
        addSubview(paceLabel)
        paceLabel.anchor(top: topAnchor, left: milesLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 70, paddingBottom: 0, paddingRight: 0, width: 0, height: 26)
        */
 
    }
 
    @objc func handleActivityHistory() {
        print("activity history is handled here")
    }

    func animateDistanceCircle() {
        
        //print("attempting to animate stroke")
        
        // the key path is the thing you want to animate on the shape layer.
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
       // basicAnimation.toValue = 1
        
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicFit")
        
    }
    
      func calculateAnalytics() {
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              
              //self.beginDownloadingDistance()
              
              self.animateDistanceCircle()
    
          }
      }
    
    private func beginDownloadingDistance() {
        print("attempting to download from firebase")
        
        
    }
    
    func calculateStepPercentage(_ stepCount: Int) {
        
        let percentage = CGFloat(stepCount) / CGFloat(10000)
        print("THIS IS YOUR PERCENTAGE VALUE \(percentage)")
        
        shapeLayer.strokeEnd = percentage
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
        //dateFormatter.dateFormat = "hh:mm a"
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        // month day and time 16hr clock
        dateFormatter.dateFormat = "d MMM"
        return  dateFormatter.string(from: date!)
    }
    
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "hh:mm a"
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        // month day and time 16hr clock
        dateFormatter.dateFormat = "h:mm a"
        return  dateFormatter.string(from: date!)
    }
    
    func configureUserAnalytics() {
        
        // this can be users on the analytics page
        
        //let center = self.center
        let center = CGPoint(x: self.center.x + 50, y: self.center.y + 160)
        
        //let center = CGPoint(x: 61, y: 48)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        //trackLayer.strokeColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        trackLayer.strokeColor = UIColor.rgb(red: 218, green: 255, blue: 205).cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.clear.cgColor
        //trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.lineCap = CAShapeLayerLineCap.square
        
        self.layer.addSublayer(trackLayer)
        
        //self.layer.insertSublayer(trackLayer, below: self.layer)
        
        

        // use the negative CGFloat value to bring start position to 12 o'clock
       // let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.statusBarGreen().cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        /*
        shapeLayer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.40).cgColor
        shapeLayer.shadowOpacity = 85 // Shadow is 30 percent opaque.
        shapeLayer.shadowRadius = 3.0
        shapeLayer.shadowOffset = CGSize(width: 1, height: 1)
        */
        
        //shapeLayer.strokeEnd = 0
        
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
