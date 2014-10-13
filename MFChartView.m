//
// Fan Control
// Copyright 2006 Lobotomo Software 
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//

#import "MFChartView.h"
#import "MFDefinitions.h"
#import "MFDaemon.h"

// definitions depending on view size and labels - adjust when changing graph view
#define MFPixelPerDegree    2.5
#define MFPixelPerRpm       0.0405
#define MFGraphMinTemp      25.0
#define MFGraphMaxTemp      95.0
#define MFGraphMinRpm       0
#define MFGraphMaxRpm       4500


@implementation MFChartView

- (id)initWithFrame:(NSRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
    }
    return self;
}

- (NSPoint)coordinateForTemp:(float)temp andRpm:(int)rpm
{
    NSPoint coordinate = [self bounds].origin;
    coordinate.x += roundf((temp - MFGraphMinTemp) * MFPixelPerDegree);
    coordinate.y += roundf((rpm - MFGraphMinRpm) * MFPixelPerRpm);
    return coordinate;
}

- (void)drawRect:(NSRect)rect
{
    int targetRpm;
    int CPU_A_target_RPM;
    int CPU_B_target_RPM;
    
    // draw background and border
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
    [[NSColor blackColor] set];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:[self bounds]];
    [path stroke];
    
    
    
    
    //****** Intake and Exhaust Fan Graph ******//
    //CPU A Heatsink Temperature Line
    [[NSColor redColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:Current_Temp_CPU_A_HS andRpm:MFGraphMinRpm]];
    [path lineToPoint:[self coordinateForTemp:Current_Temp_CPU_A_HS andRpm:MFGraphMaxRpm]];
    [path stroke];
    
    //Intake and Exhaust Path Line
    [[NSColor redColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:baseRpm]];
    [path lineToPoint:[self coordinateForTemp:lowerThreshold andRpm:baseRpm]];
    [path lineToPoint:[self coordinateForTemp:upperThreshold andRpm:MFMaxRpm]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:MFMaxRpm]];
    [path setLineWidth:2.0];
    [path stroke];
    
    
    //Calculate RPM line for Intake and Exhaust Fans
    if (Current_Temp_CPU_A_HS < lowerThreshold) {
        targetRpm = baseRpm;
    } else if (Current_Temp_CPU_A_HS > upperThreshold) {
        targetRpm = MFMaxRpm;
    } else {
        targetRpm = baseRpm + (Current_Temp_CPU_A_HS - lowerThreshold) / (upperThreshold - lowerThreshold) * (MFMaxRpm - baseRpm);
    }
    
    //Target RPM line
    [[NSColor redColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:targetRpm]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:targetRpm]];
    [path stroke];
    
    //Point
    [[NSColor redColor] set];
    // [[NSColor colorWithDeviceRed:1 green:0.0 blue:0.0 alpha:1.0] set];
    path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:[self coordinateForTemp:Current_Temp_CPU_A_HS andRpm:targetRpm]
                                     radius:2.5 startAngle:0.0 endAngle:360.0];
    [path setLineWidth:4.0];
    [path stroke];
    
    
    
    
    
    //****** CPU A Fan Graph ******//
    //CPU A Temperature Line
    [[NSColor blueColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:Current_Temp_CPU_A andRpm:MFGraphMinRpm]];
    [path lineToPoint:[self coordinateForTemp:Current_Temp_CPU_A andRpm:MFGraphMaxRpm]];
    [path stroke];
    
    //CPU A Path Line
    [[NSColor blueColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:baseRpm2]];
    [path lineToPoint:[self coordinateForTemp:lowerThreshold2 andRpm:baseRpm2]];
    [path lineToPoint:[self coordinateForTemp:upperThreshold2 andRpm:MFMaxRpm2]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:MFMaxRpm2]];
    [path setLineWidth:2.0];
    [path stroke];
    
    //Calculate RPM line for CPU Fan
    if (Current_Temp_CPU_A < lowerThreshold2) {
        CPU_A_target_RPM = baseRpm2;
    } else if (Current_Temp_CPU_A > upperThreshold2) {
        CPU_A_target_RPM = MFMaxRpm2;
    } else {
        CPU_A_target_RPM = baseRpm2 + (Current_Temp_CPU_A - lowerThreshold2) / (upperThreshold2 - lowerThreshold2) * (MFMaxRpm2 - baseRpm2);
    }
    
    //Target RPM line
    [[NSColor blueColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:CPU_A_target_RPM]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:CPU_A_target_RPM]];
    [path stroke];
    
    //Point
    [[NSColor blueColor] set];
    path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:[self coordinateForTemp:Current_Temp_CPU_A andRpm:CPU_A_target_RPM]
                                     radius:2.5 startAngle:0.0 endAngle:360.0];
    [path setLineWidth:4.0];
    [path stroke];
    
    
    
    
    if(Current_Temp_CPU_B>5){
        //****** CPU B Fan Graph ******//
        //CPU B Temperature Line
        [[NSColor greenColor] set];
        path = [NSBezierPath bezierPath];
        [path moveToPoint:[self coordinateForTemp:Current_Temp_CPU_B andRpm:MFGraphMinRpm]];
        [path lineToPoint:[self coordinateForTemp:Current_Temp_CPU_B andRpm:MFGraphMaxRpm]];
        [path stroke];
        
        //CPU B Path Line
        [[NSColor greenColor] set];
        path = [NSBezierPath bezierPath];
        [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:baseRpm2]];
        [path lineToPoint:[self coordinateForTemp:lowerThreshold2 andRpm:baseRpm2]];
        [path lineToPoint:[self coordinateForTemp:upperThreshold2 andRpm:MFMaxRpm2]];
        [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:MFMaxRpm2]];
        [path setLineWidth:2.0];
        [path stroke];
        
        //Calculate RPM line for CPU Fan
        if (Current_Temp_CPU_B < lowerThreshold2) {
            CPU_B_target_RPM = baseRpm2;
        } else if (Current_Temp_CPU_B > upperThreshold2) {
            CPU_B_target_RPM = MFMaxRpm2;
        } else {
            CPU_B_target_RPM = baseRpm2 + (Current_Temp_CPU_B - lowerThreshold2) / (upperThreshold2 - lowerThreshold2) * (MFMaxRpm2 - baseRpm2);
        }
        
        //Target RPM line
        [[NSColor greenColor] set];
        path = [NSBezierPath bezierPath];
        [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:CPU_B_target_RPM]];
        [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:CPU_B_target_RPM]];
        [path stroke];
        
        //Point
        [[NSColor greenColor] set];
        path = [NSBezierPath bezierPath];
        [path appendBezierPathWithArcWithCenter:[self coordinateForTemp:Current_Temp_CPU_B andRpm:CPU_B_target_RPM]
                                         radius:2.5 startAngle:0.0 endAngle:360.0];
        [path setLineWidth:4.0];
        [path stroke];
    }
    
    
}

// accessors
- (void)setBaseRpm:(int)newBaseRpm
{
	baseRpm = newBaseRpm;
    [self setNeedsDisplay:YES];
}

- (void)setLowerThreshold:(float)newLowerThreshold
{
	lowerThreshold = newLowerThreshold;
    [self setNeedsDisplay:YES];
}

- (void)setUpperThreshold:(float)newUpperThreshold
{
	upperThreshold = newUpperThreshold;
    [self setNeedsDisplay:YES];
}


- (void)setBaseRpm2:(int)newBaseRpm2
{
	baseRpm2 = newBaseRpm2;
    [self setNeedsDisplay:YES];
}

- (void)setLowerThreshold2:(float)newLowerThreshold2
{
	lowerThreshold2 = newLowerThreshold2;
    [self setNeedsDisplay:YES];
}

- (void)setUpperThreshold2:(float)newUpperThreshold2
{
	upperThreshold2 = newUpperThreshold2;
    [self setNeedsDisplay:YES];
}


- (void)setCurrent_Temp_CPU_A:(float)newCurrent_Temp_CPU_A
{
    Current_Temp_CPU_A = newCurrent_Temp_CPU_A;
    [self setNeedsDisplay:YES];
}

- (void)setCurrent_Temp_CPU_B:(float)newCurrent_Temp_CPU_B
{
    Current_Temp_CPU_B = newCurrent_Temp_CPU_B;
    [self setNeedsDisplay:YES];
}

- (void)setCurrent_Temp_CPU_A_HS:(float)newCurrent_Temp_CPU_A_HS
{
    Current_Temp_CPU_A_HS = newCurrent_Temp_CPU_A_HS;
    [self setNeedsDisplay:YES];
}

@end
