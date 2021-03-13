//
//  ViewController.swift
//  sample
//
//  Created by hossin ghelich on 3/12/21.
//

import UIKit
import Charts



class ViewController: UIViewController, ChartViewDelegate {
    

    var chartView: LineChartView!
     
    //The point on the polyline is selected and called back
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry,
                            highlight: Highlight) {
             //Display the MarkerView label of the point
        self.showMarkerView(value: "\(entry.y)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
         
             //Create a line chart component object
        chartView = LineChartView()
        chartView.frame = CGRect(x: 20, y: 80, width: self.view.bounds.width - 40,
                                 height: 250)
             chartView.delegate = self //Set up proxy
        self.view.addSubview(chartView)
         
             //Set the interactive style
             chartView.scaleXEnabled = false //Allow to cancel X axis zoom
             chartView.scaleYEnabled = false //Cancel Y-axis zoom
             chartView.doubleTapToZoomEnabled = false //Double-click to zoom
         
             //Generate 100 random data
        var dataEntries = [ChartDataEntry]()
        for i in 0..<100 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
             //These 50 data are used as all the data in a polyline
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Passenger flow (days)")
             //Currently the line chart only includes 1 line
        let chartData = LineChartData(dataSets: [chartDataSet])
         
             //Set the line chart data
        chartView.data = chartData
         
             //The chart shows up to 10 points
        chartView.setVisibleXRangeMaximum(10)
             //Display the last data by default
        chartView.moveViewToX(99)
             //Automatically select the data point in the center of the chart
        highlightCenterValue()
    }
     
     //Automatically select the data point in the center of the chart
    func highlightCenterValue() {
             //Get the midpoint coordinates
        let x = Double(chartView.bounds.width/2)
        let selectionPoint = CGPoint(x: x, y: 0)
             //Get the data point closest to the midpoint position
        let h = chartView.getHighlightByTouchPoint(selectionPoint)
             //Highlight this data point (at the same time automatically call the proxy method chartValueSelected)
        chartView.highlightValue(h, callDelegate: true)
    }
     
     //Display MarkerView label
    func showMarkerView(value:String){
             //Use bubble label
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                        font: .systemFont(ofSize: 12),
                        textColor: .white,
                        insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = self.chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
             marker.setLabel("Data:\(value)")
        self.chartView.marker = marker
    }
}
