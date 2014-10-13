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

#import <Cocoa/Cocoa.h>
#import <NSPreferencePane.h>

@class MFDaemon, MFChartView, MFCPU_A_tempTransformer;


@interface MFPreferencePane : NSPreferencePane {

    // bindings controller
    IBOutlet NSObjectController *fileOwnerController;

    // text fields
    IBOutlet NSTextField *IntakeFanFieldCurrent;
    IBOutlet NSTextField *CPU_A_FanFieldCurrent;
    IBOutlet NSTextField *CPU_B_FanFieldCurrent;
    IBOutlet NSTextField *ExhaustFanFieldCurrent;
    
    IBOutlet NSTextField *CPU_A_temp_Field;
    IBOutlet NSTextField *CPU_A_HS_temp_Field;
    
    IBOutlet NSTextField *CPU_B_temp_Field;
    IBOutlet NSTextField *CPU_B_HS_temp_Field;
    
    IBOutlet NSTextField *Northbridge_temp_Field;
    IBOutlet NSTextField *Northbridge_HS_temp_Field;
    
    IBOutlet NSTextField *Intake_target_RPM;
    IBOutlet NSTextField *CPU_A_target_RPM;
    IBOutlet NSTextField *CPU_B_target_RPM;
    IBOutlet NSTextField *Exhaust_target_RPM;
 

    // chart view
    IBOutlet MFChartView *chartView;

    // daemon proxy
    MFDaemon *daemon;

    // CPU_A_temp transformer
    MFCPU_A_tempTransformer *transformer;

    // update timer
    NSTimer *timer;

}

// accessors
- (int)baseRpm;
- (void)setBaseRpm:(int)newBaseRpm;

- (float)lowerThreshold;
- (void)setLowerThreshold:(float)newLowerThreshold;

- (float)upperThreshold;
- (void)setUpperThreshold:(float)newUpperThreshold;

- (int)baseRpm2;
- (void)setBaseRpm2:(int)newBaseRpm2;

- (float)lowerThreshold2;
- (void)setLowerThreshold2:(float)newLowerThreshold2;

- (float)upperThreshold2;
- (void)setUpperThreshold2:(float)newUpperThreshold2;

- (BOOL)fahrenheit;
- (void)setFahrenheit:(BOOL)newFahrenheit;

@end
