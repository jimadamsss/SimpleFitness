//
//  HistoryGraphViewController.m
//  
//
//  Created by James Adams on 5/7/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import "HistoryGraphViewController.h"


@implementation HistoryGraphViewController
@synthesize currentEquipment;
@synthesize graphHost;
@synthesize plotNumbers;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentEquipment release];
    [graphHost release];
    [plotNumbers release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSArray *entries = [currentEquipment sortedEntries];
    NSMutableArray *numbers = [[NSMutableArray array] retain];
    for (EquipmentEntry*eq in entries) {
        [numbers addObject:eq.weight];
    }
    self.plotNumbers = numbers;
    
    if(!graph)
    {
    	graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
        CPTheme *theme = [CPTheme themeNamed:@"Dark Gradients"];
        [graph applyTheme:theme];
        graph.paddingTop = 30.0;
        graph.paddingBottom = 30.0;
        graph.paddingLeft = 50.0;
        graph.paddingRight = 50.0;
        
        CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
        dataSourceLinePlot.identifier = @"Data Source Plot";
        dataSourceLinePlot.dataLineStyle.lineWidth = 1.f;
        dataSourceLinePlot.dataLineStyle.lineColor = [CPColor redColor];
        dataSourceLinePlot.dataSource = self;
        [graph addPlot:dataSourceLinePlot];
    }
    
    if([[self.graphHost.layer sublayers] indexOfObject:graph] == NSNotFound)
        [self.graphHost.layer addSublayer:graph];
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    
    NSDecimalNumber *high = [currentEquipment overallHigh];
    NSDecimalNumber *low = [currentEquipment overallLow];
    NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
    
    //NSLog(@"high = %@, low = %@, length = %@", high, low, length);
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0.0) length:CPDecimalFromUnsignedInteger([entries count])];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:[low decimalValue] length:[length decimalValue]];
    // Axes
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromDouble(10.0);
    x.orthogonalCoordinateDecimal = CPDecimalFromInteger(0);
    x.minorTicksPerInterval = 1;
    
    CPXYAxis *y = axisSet.yAxis;
    NSDecimal six = CPDecimalFromInteger(6);
    y.majorIntervalLength = CPDecimalDivide([length decimalValue], six);
	y.majorTickLineStyle = nil;
    y.minorTicksPerInterval = 4;
	y.minorTickLineStyle = nil;
    y.orthogonalCoordinateDecimal = CPDecimalFromInteger(0);
	y.alternatingBandFills = [NSArray arrayWithObjects:[[CPColor whiteColor] colorWithAlphaComponent:0.1], [NSNull null], nil];
	
    [graph reloadData];
    
    [[self navigationItem] setTitle:currentEquipment.name];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{
    return [currentEquipment.entries count];
}
-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSDecimalNumber *num = [NSDecimalNumber zero];
    if (fieldEnum == CPScatterPlotFieldX) 
    {
        num = (NSDecimalNumber *) [NSDecimalNumber numberWithInt:index + 1];
    }
    else if (fieldEnum == CPScatterPlotFieldY)
    {
        [plotNumbers objectAtIndex:index];
    }
    return num;
}



@end
