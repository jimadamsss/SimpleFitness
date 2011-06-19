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
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentEquipment release];
    [graphHost release];
    [plotNumbers release];
    [graph release];
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
    self.plotNumbers = [currentEquipment sortedEntries];
//    NSMutableArray *numbers = [[NSMutableArray array] retain];
//    for (EquipmentEntry*eq in entries) {
//        [numbers addObject:eq.weight];
//    }
//    self.plotNumbers = numbers;
    
    if(!graph)
    {
    	graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
 //       graph.plotAreaFrame = [[[CPPlotAreaFrame alloc] initWithFrame:self.view.bounds] autorelease];
//        CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
//        CPTheme *theme = [CPTheme themeNamed:kCPPlainWhiteTheme];
//        CPTheme *theme = [CPTheme themeNamed:kCPPlainBlackTheme];
        CPTheme *theme = [CPTheme themeNamed:kCPSlateTheme];
//        CPTheme *theme = [CPTheme themeNamed:kCPStocksTheme];
        [graph applyTheme:theme];
        graph.paddingTop = 10.0;
        graph.paddingBottom = 10.0;
        graph.paddingLeft = 10.0;
        graph.paddingRight = 10.0;
        
        
//        CPBarPlot *barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor blueColor] horizontalBars:NO];
//        barPlot.baseValue = CPDecimalFromString(@"0");
//        barPlot.dataSource = self;
//        barPlot.barOffset = -0.25f;
//        barPlot.identifier = @"Bar Plot 1";
//        [graph addPlot:barPlot toPlotSpace:plotSpace];

        
    }
    
    if([[self.graphHost.layer sublayers] indexOfObject:graph] == NSNotFound)
        [self.graphHost.layer addSublayer:graph];
    
    graphHost.collapsesLayers = YES;
    graphHost.hostedGraph = graph;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    
    NSDecimalNumber *high = nil;
    NSDecimalNumber *low = [NSDecimalNumber zero];
    if ([currentEquipment.Type isEqualToString:@"Weights"])
    {
        high = [currentEquipment overallHighByName:@"weight" plusPercent:0.50];
//        low = [currentEquipment overallLowByName:@"weight"];
    }
    else if ([currentEquipment.Type isEqualToString:@"Cardio"])
    {
        high = [currentEquipment overallHighByName:@"duration" plusPercent:0.50];
        //        low = [currentEquipment overallLowByName:@"duration"];
    }
    else if ([currentEquipment.Type isEqualToString:@"Body Weight"])
    {
        high = [currentEquipment overallHighByName:@"weight" plusPercent:0.50];
        //        low = [currentEquipment overallLowByName:@"duration"];
    }

    NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
    
//    NSLog(@"high = %@, low = %@, length = %@, count=%d", high, low, length, [plotNumbers count]);
//    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(1.0) length:CPDecimalFromUnsignedInteger([plotNumbers count]-1)];
//    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(1.0) length:CPDecimalFromUnsignedInteger([plotNumbers count])];
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0) length:CPDecimalFromDouble([plotNumbers count]+0.5)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:[low decimalValue] length:[length decimalValue]];
//    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(-10) length:[length decimalValue]];
    // Axes
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromDouble(10.0);
    x.orthogonalCoordinateDecimal = CPDecimalFromInteger(0);
    x.minorTicksPerInterval = 1;
    
    CPXYAxis *y = axisSet.yAxis;

    // Tick marks every 10 with minor ticks at every 2
    y.majorIntervalLength = CPDecimalFromInteger(10); 
    y.minorTicksPerInterval = 5;
//    y.majorTickLineStyle.lineColor = [CPColor whiteColor];
//    y.minorTickLineStyle.lineColor = [CPColor whiteColor];
//    y.labelTextStyle.color = [CPColor whiteColor];
    
    // place the Y axis in the graph field on the left side
    y.orthogonalCoordinateDecimal = CPDecimalFromDouble(0.5); //Integer(0);
//    y.title = @"Pounds";
//    y.titleTextStyle.color = [CPColor whiteColor];
//    y.titleOffset = 10.0;
    y.tickDirection = CPSignNegative; //Positive;
    
    NSArray *exclusionRanges = [NSArray arrayWithObjects:
                       [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0) length:CPDecimalFromFloat(1.0)], 
                       [CPPlotRange plotRangeWithLocation:CPDecimalSubtract([high decimalValue], CPDecimalFromFloat(1.0)) length:CPDecimalFromFloat(1.0)],
                       nil];
	y.labelExclusionRanges = exclusionRanges;
    
    CPBarPlot *barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor blueColor] horizontalBars:NO];
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.barOffset = 0; //0.5f;
    barPlot.identifier = @"Bar Plot 1";
    barPlot.barWidth = 40;
    [graph addPlot:barPlot toPlotSpace:plotSpace];
    
    barPlot = [[CPBarPlot alloc] init];
    CPLineStyle *barLineStyle = [[CPLineStyle alloc] init];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPColor blackColor];
    barPlot.lineStyle = barLineStyle;
    [barLineStyle release];
    barPlot.barsAreHorizontal = NO;
    barPlot.barWidth = 10.0;
    barPlot.cornerRadius = 2.0;
    CPGradient *fillGradient = [CPGradient gradientWithBeginningColor:[CPColor blackColor] endingColor:[CPColor redColor]];
    fillGradient.angle = 0.0; //(horizontal ? -90.0 : 0.0);
    barPlot.fill = [CPFill fillWithGradient:fillGradient];
    
    //    barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor redColor] horizontalBars:NO];
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.barOffset = 0;//1.0f;
    barPlot.identifier = @"Bar Plot 2";
    barPlot.barWidth = 20;
    [graph addPlot:barPlot toPlotSpace:plotSpace];
    
    CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
    dataSourceLinePlot.identifier = @"Data Source Plot";
    dataSourceLinePlot.dataLineStyle.lineWidth = 1.f;
    dataSourceLinePlot.dataLineStyle.lineColor = [CPColor redColor];
    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
    areaGradient.angle = -90.0f;
    CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"1.75");
    
    [graph addPlot:dataSourceLinePlot];
    

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
//    NSLog(@"%@ %d", plot.identifier, fieldEnum);
    if (fieldEnum == CPScatterPlotFieldX) 
    {
        num = (NSDecimalNumber *) [NSDecimalNumber numberWithInt:index + 1];
        return num;
    }
    if ([plot.identifier isEqual:@"Bar Plot 2"]) // inner overlay bar
    {
        if (fieldEnum == CPBarPlotFieldBarLength)
        {
            if ([currentEquipment.Type isEqualToString:@"Weights"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).reps decimalValue]];
            else if ([currentEquipment.Type isEqualToString:@"Cardio"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).speed decimalValue]];
        }
        else if (fieldEnum == CPBarPlotFieldBarLocation)
        {
            num = (NSDecimalNumber *) [NSDecimalNumber numberWithInt:index + 1];
        }
        return num;
    }
    else if ([plot.identifier isEqual:@"Bar Plot 1"])
    {
        if (fieldEnum == CPBarPlotFieldBarLength)
        {
            if ([currentEquipment.Type isEqualToString:@"Weights"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).weight decimalValue]];
            else if ([currentEquipment.Type isEqualToString:@"Cardio"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).duration decimalValue]];
            else if ([currentEquipment.Type isEqualToString:@"Body Weight"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).weight decimalValue]];
        }
        else if (fieldEnum == CPBarPlotFieldBarLocation)
        {
            num = (NSDecimalNumber *) [NSDecimalNumber numberWithInt:index + 1];
        }
        return num;
        
    }
    else if ([plot.identifier isEqual:@"Data Source Plot"])
    {
        if (fieldEnum == CPScatterPlotFieldY)
        {
            if ([currentEquipment.Type isEqualToString:@"Weights"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).weight decimalValue]];
            else if ([currentEquipment.Type isEqualToString:@"Cardio"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).duration decimalValue]];
            else if ([currentEquipment.Type isEqualToString:@"Body Weight"])
                num = [NSDecimalNumber decimalNumberWithDecimal:[((EquipmentEntry*)[plotNumbers objectAtIndex:index]).weight decimalValue]];

        }
        else if (fieldEnum == CPBarPlotFieldBarLocation)
        {
            num = (NSDecimalNumber *) [NSDecimalNumber numberWithInt:index + 1];
        }
        return num;
        
    }
    else
        NSLog(@"unknown identifies %@", plot.identifier);
    
        
    return num;
}



@end
