//
//  BlandAltmanDataClass.h
//  BlandAltman
//
//  Created by Konrad Werys on 11/21/16.
//
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface BlandAltmanDataClass : NSObject

@property (strong) NSMutableArray *data1;
@property (strong) NSMutableArray *data2;

@property (strong, readonly) NSMutableArray<NSDictionary *> *baScatterData;
@property (strong, readonly) NSMutableArray<NSDictionary *> *meanData;
@property (strong, readonly) NSMutableArray<NSDictionary *> *stdData;

@property (assign, readonly) NSInteger nDataPoints;
@property (strong, readonly) NSNumber *locationX;
@property (strong, readonly) NSNumber *lengthX;
@property (strong, readonly) NSNumber *locationY;
@property (strong, readonly) NSNumber *lengthY;

-(id) initWithData1: (NSMutableArray*)data1 andData2:(NSMutableArray*)data2;
-(void) calcBlandAltmanData;

@end
