//
//  HistoryGraphViewController.h
//  
//
//  Created by James Adams on 5/7/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "EquipmentEntry.h"
#import "CPGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"



@interface HistoryGraphViewController : UIViewController<CPPlotDataSource> {
    Equipment *currentEquipment;
    IBOutlet CPGraphHostingView *graphHost;
    
    CPXYGraph *graph;
    NSArray* plotNumbers;
}

@property (nonatomic, retain) Equipment *currentEquipment;
@property (nonatomic, retain) CPGraphHostingView *graphHost;
@property (nonatomic, retain) NSArray *plotNumbers;

@end
