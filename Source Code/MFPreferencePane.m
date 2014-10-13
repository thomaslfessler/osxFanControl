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

#import "MFPreferencePane.h"
#import "MFProtocol.h"
#import "MFTemperatureTransformer.h"
#import "MFChartView.h"


@implementation MFPreferencePane


- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super initWithBundle:bundle]) {
        transformer = [MFTemperatureTransformer new];
        [NSValueTransformer setValueTransformer:transformer forName:@"MFTemperatureTransformer"];
    }
    return self;
}

- (void)dealloc
{
    [transformer release];
    [super dealloc];
}

- (void)updateOutput:(NSTimer *)aTimer
{
    float CPU_A_temp;
    float CPU_A_HS_temp;
    float CPU_B_temp;
    float CPU_B_HS_temp;
    float Northbridge_temp;
    float Northbridge_HS_temp;
    int IntakeFanRpm;
    int CPU_A_Fan_RPM;
    int CPU_B_Fan_RPM;
    int ExhaustFanRpm;
    int Intake_Min_Fan_Speed;
    int CPU_A_Fan_Min_Speed;
    int CPU_B_Fan_Min_Speed;
    
    [daemon CPU_A_temp:&CPU_A_temp
         CPU_A_HS_temp:&CPU_A_HS_temp
            CPU_B_temp:&CPU_B_temp
         CPU_B_HS_temp:&CPU_B_HS_temp
      Northbridge_temp:&Northbridge_temp
   Northbridge_HS_temp:&Northbridge_HS_temp
          IntakeFanRpm:&IntakeFanRpm
         CPU_A_Fan_RPM:&CPU_A_Fan_RPM
         CPU_B_Fan_RPM:&CPU_B_Fan_RPM
         ExhaustFanRpm:&ExhaustFanRpm
  Intake_Min_Fan_Speed:&Intake_Min_Fan_Speed
   CPU_A_Fan_Min_Speed:&CPU_A_Fan_Min_Speed
   CPU_B_Fan_Min_Speed:&CPU_B_Fan_Min_Speed];
    
    
    [Northbridge_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:Northbridge_temp]]];
    [Northbridge_HS_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:Northbridge_HS_temp]]];
    
    //***** Intake and Exhaust Stuff *****/
    [IntakeFanFieldCurrent setIntValue:IntakeFanRpm];
    [ExhaustFanFieldCurrent setIntValue:ExhaustFanRpm];
    [Intake_target_RPM setIntValue:Intake_Min_Fan_Speed];
    [Exhaust_target_RPM setIntValue:Intake_Min_Fan_Speed];

    //***** CPU A Stuff *****/
    [CPU_A_FanFieldCurrent setIntValue:CPU_A_Fan_RPM];
    [CPU_A_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:CPU_A_temp]]];    
    [CPU_A_HS_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:CPU_A_HS_temp]]];
    [CPU_A_target_RPM setIntValue:CPU_A_Fan_Min_Speed];
    [chartView setCurrent_Temp_CPU_A:CPU_A_temp];
    [chartView setCurrent_Temp_CPU_A_HS:CPU_A_HS_temp];
    
    //***** CPU B Stuff *****/
    if (CPU_B_temp>5) {
        [CPU_B_FanFieldCurrent setIntValue:CPU_B_Fan_RPM];
        [CPU_B_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:CPU_B_temp]]];
        
        [CPU_B_HS_temp_Field setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:CPU_B_HS_temp]]];
        
        [chartView setCurrent_Temp_CPU_B:CPU_B_temp];
        [CPU_B_target_RPM setIntValue:CPU_B_Fan_Min_Speed];
    }
    
    
}

- (void)awakeFromNib
{
    // connect to daemon
    NSConnection *connection = [NSConnection connectionWithRegisteredName:MFDaemonRegisteredName host:nil];
    daemon = [[connection rootProxy] retain];
    [(id)daemon setProtocolForProxy:@protocol(MFProtocol)];
    
    // set transformer mode
    [transformer setFahrenheit:[self fahrenheit]];
    
    // connect to object controller
    [fileOwnerController setContent:self];
}

// sent before preference pane is displayed
- (void)willSelect
{
    // update chart
    [chartView setBaseRpm:[self baseRpm]];
    [chartView setLowerThreshold:[self lowerThreshold]];
    [chartView setUpperThreshold:[self upperThreshold]];
    
    // update chart
    [chartView setBaseRpm2:[self baseRpm2]];
    [chartView setLowerThreshold2:[self lowerThreshold2]];
    [chartView setUpperThreshold2:[self upperThreshold2]];
    
    // update output immediatly, then every 5 seconds
    [self updateOutput:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateOutput:)
                                           userInfo:nil repeats:YES];
}

// sent after preference pane is ordered out
- (void)didUnselect
{
    // stop updates
    [timer invalidate];
    timer = nil;
}

// accessors (via daemon)
- (int)baseRpm
{
    return [daemon baseRpm];
}

- (void)setBaseRpm:(int)newBaseRpm
{
    if(newBaseRpm>2800){
        newBaseRpm=2800;
    }
    
    if(newBaseRpm<300){
        newBaseRpm=300;
    }
    
    [daemon setBaseRpm:newBaseRpm];
    [chartView setBaseRpm:newBaseRpm];
}

- (float)lowerThreshold
{
    return [daemon lowerThreshold];
}

- (void)setLowerThreshold:(float)newLowerThreshold
{
    [daemon setLowerThreshold:newLowerThreshold];
    [chartView setLowerThreshold:newLowerThreshold];
}

- (float)upperThreshold
{
    return [daemon upperThreshold];
}

- (void)setUpperThreshold:(float)newUpperThreshold
{
    [daemon setUpperThreshold:newUpperThreshold];
    [chartView setUpperThreshold:newUpperThreshold];
}


//Second set of things for CPU fan.
- (int)baseRpm2
{
    return [daemon baseRpm2];
}

- (void)setBaseRpm2:(int)newBaseRpm2
{
    if(newBaseRpm2>4000){
        newBaseRpm2=4000;
    }
    
    if(newBaseRpm2<600){
        newBaseRpm2=600;
    }
    
    [daemon setBaseRpm2:newBaseRpm2];
    [chartView setBaseRpm2:newBaseRpm2];
}

- (float)lowerThreshold2
{
    return [daemon lowerThreshold2];
}

- (void)setLowerThreshold2:(float)newLowerThreshold2
{
    [daemon setLowerThreshold2:newLowerThreshold2];
    [chartView setLowerThreshold2:newLowerThreshold2];
}

- (float)upperThreshold2
{
    return [daemon upperThreshold2];
}

- (void)setUpperThreshold2:(float)newUpperThreshold2
{
    [daemon setUpperThreshold2:newUpperThreshold2];
    [chartView setUpperThreshold2:newUpperThreshold2];
}



- (BOOL)fahrenheit
{
    return [daemon fahrenheit];
}

- (void)setFahrenheit:(BOOL)newFahrenheit
{
    [daemon setFahrenheit:newFahrenheit];
    [transformer setFahrenheit:newFahrenheit];
    // force display update
    [self updateOutput:nil];
    [fileOwnerController setContent:nil];
    [fileOwnerController setContent:self];
}

@end
