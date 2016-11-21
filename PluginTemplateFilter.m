//
//  PluginTemplateFilter.m
//  PluginTemplate
//
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import "PluginTemplateFilter.h"

@interface PluginTemplateFilter()

@property (strong) IBOutlet NSView *plotView;
@property (nonatomic, strong) NSWindowController *PlotWindow;
@property (nonatomic, strong) PlotViewerController *plotViewerController;

@end

@implementation PluginTemplateFilter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
    // some intializations
    NSMutableArray<NSDictionary *> *baScatterData = [NSMutableArray array];
    NSMutableArray<NSDictionary *> *meanData = [NSMutableArray array];
    NSMutableArray<NSDictionary *> *stdData = [NSMutableArray array];
    
    /* ########################## */
    /* # Windows                # */
    /* ########################## */
    
    // plugin window
    _PlotWindow = [[NSWindowController alloc] initWithWindowNibName:@"PlotWindow" owner:self];
    [_PlotWindow showWindow:self];
    
    // plot mag viewer
    _plotViewerController = [[PlotViewerController alloc] initWithNibName:@"PlotView" bundle:[NSBundle bundleForClass:[PluginTemplateFilter class]]];
    [_plotView addSubview:[_plotViewerController view]];
    [[_plotViewerController view] setFrame:[_plotView bounds]];
    
    /* ########################## */
    /* # Get data               # */
    /* ########################## */
    
    // for testing purposes
    NSInteger NDataPonts = 500;
    NSMutableArray *data1 = [self generateRandomDataArrayWithNDataPonts: NDataPonts];
    NSMutableArray *data2 = [self generateRandomDataArrayWithNDataPonts: NDataPonts];
    
    /* ########################## */
    /* # Plotting               # */
    /* ########################## */
    
    [self getBlandAltmanDataFromData1:data1 andData2:data2 andPutItInBaScatterData:baScatterData MeanData:meanData stdData:stdData];
    
    self.plotViewerController.baScatterData = baScatterData;
    self.plotViewerController.meanData = meanData;
    self.plotViewerController.stdData = stdData;
    
    [_plotViewerController.graph reloadData];
    
    return 0;
}

- (NSMutableArray *) generateRandomDataArrayWithNDataPonts: (NSInteger) NDataPonts{
    NSMutableArray *data1 = [NSMutableArray array];
    for ( NSInteger i = 0; i < NDataPonts; i++ ) {
        [data1 addObject: [NSNumber numberWithDouble: arc4random() / (double)UINT32_MAX]];
    }
    return data1;
}

-(void) getBlandAltmanDataFromData1:(NSMutableArray *)data1 andData2:(NSMutableArray *)data2 andPutItInBaScatterData: (NSMutableArray *)baScatterData MeanData: (NSMutableArray *)meanData stdData: (NSMutableArray *)stdData{

    if (data1.count != data2.count){
        [NSException raise:@"Inequal size of data1 and data2" format:@"Data1 size: %d and data2 size: %d", (int)data1.count, (int)data2.count];
    }
    
    NSMutableArray *meanData1and2 = [NSMutableArray array];
    NSMutableArray *subsData1and2 = [NSMutableArray array];
    for ( NSInteger i = 0; i < data1.count; i++ ) {
        [meanData1and2 addObject: @(([data1[i] floatValue] + [data2[i] floatValue])/2)];
        [subsData1and2 addObject: @( [data1[i] floatValue] - [data2[i] floatValue])   ];
    }
    
    NSNumber *meanSubsData1and2 = [self meanOf:subsData1and2];
    NSNumber *stdSubsData1and2 = [self standardDeviationOf:subsData1and2];
    NSNumber *stdSubsData1and2_196 = @([stdSubsData1and2 floatValue]*1.96);

    
    for ( NSInteger i = 0; i < data1.count; i++ ) {
        
        [baScatterData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): subsData1and2[i] }
         ];
        
        [meanData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): meanSubsData1and2 }
         ];
        
        [stdData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): stdSubsData1and2_196 }
         ];
    }
}

- (NSNumber *)meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

- (NSNumber *)standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    double mean = [[self meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sqrt(sumOfSquaredDifferences / [array count])];
}

@end
