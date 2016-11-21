//
//  PluginTemplateFilter.h
//  PluginTemplate
//
//  Copyright (c) 11.2016 Konrad Werys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import <CorePlot/CorePlot.h>

#import "PlotViewerController.h"
#import "BlandAltmanDataClass.h"

@interface BlandAltmanFilter : PluginFilter {
}

- (long) filterImage:(NSString*) menuName;

@end
