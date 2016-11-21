//
//  PlotViewerController.h
//  PluginTemplate
//
//  Created by Konrad Werys on 11/21/16.
//
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface PlotViewerController : NSViewController<CPTPlotDataSource>

@property (nonatomic, readwrite, strong, nullable) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, readwrite, strong, nonnull) CPTXYGraph *graph;
@property (nonatomic, readwrite, strong, nonnull) NSArray<NSDictionary *> *baScatterData;
@property (nonatomic, readwrite, strong, nonnull) NSArray<NSDictionary *> *meanData;
@property (nonatomic, readwrite, strong, nonnull) NSArray<NSDictionary *> *stdData;
@property (nonatomic, readwrite, strong, nonnull) CPTXYPlotSpace *plotSpace;

@end
