//
//  BlandAltmanDataClass.m
//  BlandAltman
//
//  Created by Konrad Werys on 11/21/16.
//
//

#import "BlandAltmanDataClass.h"

@interface BlandAltmanDataClass()

@end

@implementation BlandAltmanDataClass

- (id)init{
    NSMutableArray* data1 = [self generateRandomDataArrayWithNDataPonts:5000];
    NSMutableArray* data2 = [self generateRandomDataArrayWithNDataPonts:5000];
    return [self initWithData1:data1 andData2:data2];
}

- (id)initWithData1: (NSMutableArray*)data1 andData2:(NSMutableArray*)data2{
    self = [super init];
    if (self) {
        
        // check data size
        if (data1.count != data2.count){
            [NSException raise:@"Inequal size of data1 and data2" format:@"Data1 size: %d and data2 size: %d", (int)data1.count, (int)data2.count];
        }
        // use the input data
        _data1 = data1;
        _data2 = data2;
        _nDataPoints = data1.count;
        
        // init output data
        _baScatterData = [NSMutableArray array];
        _meanData = [NSMutableArray array];
        _stdData = [NSMutableArray array];
        
        // calc everything
        [self calcBlandAltmanData];
    }
    return self;
}

-(void) calcBlandAltmanData{
    
    if (_data1.count != _data2.count){
        [NSException raise:@"Inequal size of data1 and data2" format:@"Data1 size: %d and data2 size: %d", (int)_data1.count, (int)_data2.count];
    }
    
    NSMutableArray *meanData1and2 = [NSMutableArray array];
    NSMutableArray *subsData1and2 = [NSMutableArray array];
    for ( NSInteger i = 0; i < _nDataPoints; i++ ) {
        [meanData1and2 addObject: @(([_data1[i] floatValue] + [_data2[i] floatValue])/2)];
        [subsData1and2 addObject: @( [_data1[i] floatValue] - [_data2[i] floatValue])   ];
    }
    
    NSNumber *minX = [meanData1and2 valueForKeyPath:@"@min.self"];
    NSNumber *maxX = [meanData1and2 valueForKeyPath:@"@max.self"];
    NSNumber *minY = [subsData1and2 valueForKeyPath:@"@min.self"];
    NSNumber *maxY = [subsData1and2 valueForKeyPath:@"@max.self"];
    
    _locationX = minX;
    _locationX = @(minX.floatValue - fabs(minX.floatValue*0.1));
    _lengthX = @(maxX.floatValue - minX.floatValue);
    _lengthX = @(_lengthX.floatValue + fabs(_lengthX.floatValue*0.1));
    _locationY = minY;
    _locationY = @(minY.floatValue - fabs(minY.floatValue*0.1));
    _lengthY = @(maxY.floatValue - minY.floatValue);
    _lengthY = @(_lengthY.floatValue + fabs(_lengthY.floatValue*0.1));
    
    NSNumber *meanSubsData1and2 = [self meanOf:subsData1and2];
    NSNumber *stdSubsData1and2 = [self standardDeviationOf:subsData1and2];
    NSNumber *stdSubsData1and2_196 = @([stdSubsData1and2 floatValue]*1.96);
    
    
    for ( NSInteger i = 0; i < _nDataPoints; i++ ) {
        
        [_baScatterData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): subsData1and2[i] }
         ];
        
        [_meanData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): meanSubsData1and2 }
         ];
        
        [_stdData addObject:
         @{ @(CPTScatterPlotFieldX): meanData1and2[i],
            @(CPTScatterPlotFieldY): stdSubsData1and2_196 }
         ];
    }
}

- (NSMutableArray *) generateRandomDataArrayWithNDataPonts: (NSInteger) NDataPonts{
    NSMutableArray *data = [NSMutableArray array];
    for ( NSInteger i = 0; i < NDataPonts; i++ ) {
        [data addObject: [NSNumber numberWithFloat: 2000*(arc4random() / (double)UINT32_MAX)]];
    }
    return data;
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
