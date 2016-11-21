//
//  PluginTemplateFilter.m
//  PluginTemplate
//
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import "BlandAltmanFilter.h"

@interface BlandAltmanFilter()

@property (strong) IBOutlet NSView *plotView;
@property (nonatomic, strong) NSWindowController *PlotWindow;
@property (nonatomic, strong) PlotViewerController *plotViewerController;

@end

@implementation BlandAltmanFilter

- (void) initPlugin{
}

- (long) filterImage:(NSString*) menuName{
    
    /* ########################## */
    /* # Windows                # */
    /* ########################## */
    
    // plugin window
    _PlotWindow = [[NSWindowController alloc] initWithWindowNibName:@"PlotWindow" owner:self];
    [_PlotWindow showWindow:self];
    
    // plot mag viewer
    _plotViewerController = [[PlotViewerController alloc] initWithNibName:@"PlotView" bundle:[NSBundle bundleForClass:[BlandAltmanFilter class]]];
    [_plotView addSubview:[_plotViewerController view]];
    [[_plotViewerController view] setFrame:[_plotView bounds]];
    
    /* ########################## */
    /* # Get data               # */
    /* ########################## */
    
    // for testing purposes
    //BlandAltmanDataClass *baData = [[BlandAltmanDataClass alloc] init];
    
    // viewerController data
    NSMutableArray *data1 = [self getDataFromViewerController: viewerController];
    NSMutableArray *data2 = [self getDataFromViewerController: viewerController.blendedWindow];
    
    BlandAltmanDataClass *baData = [[BlandAltmanDataClass alloc] initWithData1:data1 andData2:data2];
    
    /* ########################## */
    /* # Plotting               # */
    /* ########################## */
    
    self.plotViewerController.baScatterData = baData.baScatterData;
    self.plotViewerController.meanData = baData.meanData;
    self.plotViewerController.stdData = baData.stdData;
    
    self.plotViewerController.plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:baData.locationX length:baData.lengthX];
    self.plotViewerController.plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:baData.locationY length:baData.lengthY];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.plotViewerController.graph.axisSet;
    axisSet.xAxis.majorIntervalLength = @((float)(baData.lengthX.floatValue/11));
    axisSet.yAxis.majorIntervalLength = @((float)(baData.lengthY.floatValue/11));
    
    [self.plotViewerController.graph reloadData];
    
    return 0;
}

- (NSMutableArray *) getDataFromViewerController: (ViewerController*) vc{
    NSMutableArray *data1 = [NSMutableArray array];
    DCMPix *curPix = [[vc pixList:0] objectAtIndex:[[vc imageView] curImage]];
    float* fImage = [curPix fImage];
    int pixSize = [curPix pheight] * [curPix pwidth];
    
    for ( NSInteger i = 0; i < pixSize; i++ ) {
        [data1 addObject: [NSNumber numberWithFloat: fImage[i]]];
    }
    return data1;
}

@end
