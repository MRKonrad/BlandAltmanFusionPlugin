//
//  PlotViewerController.m
//  PluginTemplate
//
//  Created by Konrad Werys on 11/21/16.
//
//

#import "PlotViewerController.h"

static NSString *const baScatterIdentifier = @"baScatter";
static NSString *const meanIdentifier      = @"meanLine";
static NSString *const stdPlusIdentifier   = @"stdPlusLine";
static NSString *const stdMinusIdentifier  = @"stdMinusLine";


@interface PlotViewerController()
@end

@implementation PlotViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    // Create graph from theme
    CPTXYGraph *newGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme      = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [newGraph applyTheme:theme];
    
    newGraph.paddingLeft   = 0.0;
    newGraph.paddingTop    = 0.0;
    newGraph.paddingRight  = 0.0;
    newGraph.paddingBottom = 0.0;
    
    newGraph.plotAreaFrame.paddingLeft   = 70.0;
    newGraph.plotAreaFrame.paddingTop    = 10.0;
    newGraph.plotAreaFrame.paddingRight  = 10.0;
    newGraph.plotAreaFrame.paddingBottom = 10.0;
    
    newGraph.plotAreaFrame.borderLineStyle = nil;
    newGraph.plotAreaFrame.cornerRadius    = 0.0;
    newGraph.plotAreaFrame.masksToBorder   = NO;
    
    
    self.graph = newGraph;
    
    self.hostView.hostedGraph = newGraph;
    
    // Setup scatter plot space
    self.plotSpace = (CPTXYPlotSpace *)newGraph.defaultPlotSpace;
    //self.plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@0.0 length:@1.0];
    //self.plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@(-1.0) length:@2.0];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)newGraph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    //x.majorIntervalLength   = @1000.0;
    x.orthogonalPosition    = @0.0;
    //x.minorTicksPerInterval = 0;
    x.title = @"Average of the two measures";
    
    CPTXYAxis *y          = axisSet.yAxis;
    //y.majorIntervalLength   = @25.0;
    y.orthogonalPosition    = @0.0;
    //y.minorTicksPerInterval = 0;
    y.title = @"difference between the two measures";
    y.labelOffset = 0;
    y.titleOffset = 40;
    
    NSNumberFormatter *zeroFracDigFormatter = [[NSNumberFormatter alloc] init];
    [zeroFracDigFormatter setMaximumFractionDigits:0];
    x.labelFormatter = zeroFracDigFormatter;
    y.labelFormatter = zeroFracDigFormatter;
    
    CPTMutableLineStyle *elipseLineStyle = [CPTMutableLineStyle lineStyle];
    elipseLineStyle.lineWidth              = 0.0;
    CPTPlotSymbol *elipsePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    elipsePlotSymbol.fill           = [CPTFill fillWithColor:[[CPTColor blueColor] colorWithAlphaComponent:0.5]];
    elipsePlotSymbol.lineStyle      = elipseLineStyle;
    elipsePlotSymbol.size           = CGSizeMake(5.0, 5.0);
    
    CPTMutableLineStyle *dataLineStyle = [CPTMutableLineStyle lineStyle];
    dataLineStyle.lineWidth              = .5;
    dataLineStyle.lineColor              = [CPTColor greenColor];
    
    /* ########################## */
    /* # Bkand Altman Scatter   # */
    /* ########################## */
    
    CPTScatterPlot *baScatter = [[CPTScatterPlot alloc] init];
    baScatter.identifier = baScatterIdentifier;
    baScatter.dataLineStyle = elipseLineStyle;
    baScatter.plotSymbol = elipsePlotSymbol;
    baScatter.dataSource = self;
    
    /* ########################## */
    /* # Mean                   # */
    /* ########################## */
    CPTScatterPlot *meanLine = [[CPTScatterPlot alloc] init];
    meanLine.identifier = meanIdentifier;
    meanLine.dataLineStyle = dataLineStyle;
    meanLine.dataSource = self;
    
    /* ########################## */
    /* # Std Plus               # */
    /* ########################## */
    
    CPTScatterPlot *stdPlusLine = [[CPTScatterPlot alloc] init];
    stdPlusLine.identifier = stdPlusIdentifier;
    dataLineStyle.lineColor = [CPTColor redColor];
    stdPlusLine.dataLineStyle = dataLineStyle;
    stdPlusLine.dataSource = self;
    
    /* ########################## */
    /* # Std Minus              # */
    /* ########################## */
    
    CPTScatterPlot *stdMinusLine = [[CPTScatterPlot alloc] init];
    stdMinusLine.identifier = stdMinusIdentifier;
    dataLineStyle.lineColor = [CPTColor redColor];
    stdMinusLine.dataLineStyle = dataLineStyle;
    stdMinusLine.dataSource = self;
    
    [newGraph addPlot:baScatter];
    [newGraph addPlot:meanLine];
    [newGraph addPlot:stdPlusLine];
    [newGraph addPlot:stdMinusLine];
    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(nonnull CPTPlot *)plot
{
    // same number of data points for each plot
    return self.baScatterData.count;
}

-(nullable id)numberForPlot:(nonnull CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *identifier = (NSString *)plot.identifier;
    NSNumber *valueBA       = self.baScatterData [index][@(fieldEnum)];
    NSNumber *valueMean     = self.meanData      [index][@(fieldEnum)];
    NSNumber *valueStd      = self.stdData       [index][@(fieldEnum)];
    
    if ( fieldEnum == CPTScatterPlotFieldX ) { //x
        return valueBA; // any will do, they have the same x
    } else { //y
        NSNumber *baseY = [NSNumber numberWithInt:0];
        
        if ( [identifier isEqualToString:baScatterIdentifier] ) {
            baseY = valueBA;
        }
        else if ( [identifier isEqualToString:meanIdentifier] ) {
            baseY = valueMean;
        }
        else if ( [identifier isEqualToString:stdPlusIdentifier] ) {
            baseY = @(valueMean.floatValue + valueStd.floatValue);
        }
        else if ( [identifier isEqualToString:stdMinusIdentifier] ) {
            baseY = @(valueMean.floatValue - valueStd.floatValue);
        }
        return baseY;
    }
}

@end
