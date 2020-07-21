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
    
    
    var activity: Activity? {
        
        didSet {
            guard let tripId = activity?.tripId else { return }
            guard let distance = activity?.distance else { return }
            guard let stepCount = activity?.stepCount else { return }
            guard let averagePace = activity?.averagePace else { return }
            guard let pace = activity?.pace else { return }
           // guard let duration = activity?.duration else { return }
            self.timeElapsed += self.timerInterval
            //let duration = self.timeIntervalFormat(interval: self.timeElapsed)
            
            Database.fetchActivity(with: tripId) { (activity) in
                
                    
                    
                    guard let stepCount = activity.stepCount else { return }
                    guard let pace = activity.pace else { return }
                    guard let averagePace = activity.averagePace else { return }
                    guard let creationDate = activity.creationDate else { return }
               
            }     
            self.distanceLabel.text = String(format:"%02.02f", (distance))
            //self.durationLabel.text = "\(Double(duration) ?? 0)"
            self.stepCountLabel.text = "\(Int(stepCount)) steps"
            self.averagePaceLabel.text = "\(Double(averagePace))"
            self.paceLabel.text = "\(Double(pace))" //pace wasn't initially in the results will need to add them to this user.
            self.postTimeLabel.text = activity?.creationDate.timeAgoToDisplay()
            //self.postTimeLabel.text = activity?.creationDate.description(with: .current)
            
            
        }
    }
    let timerInterval = 1.0
    var timeElapsed: TimeInterval = 0.0
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 26)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0.00"
        
        return label
    }()
    
    let milesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "mi"
        
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.text = "0"
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        addSubview(distanceLabel)
        distanceLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 26)
        
        addSubview(milesLabel)
        milesLabel.anchor(top: nil, left: distanceLabel.rightAnchor, bottom: distanceLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 2, paddingRight: 0, width: 0, height: 0)
        
        addSubview(stepCountLabel)
        stepCountLabel.anchor(top: distanceLabel.bottomAnchor, left: distanceLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)

    }
    
    func timeIntervalFormat(interval: TimeInterval)-> String {
        var seconds = Int(interval + 0.5) // round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
