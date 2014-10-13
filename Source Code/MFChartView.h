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


@interface MFChartView : NSView {

    // attributes
    int baseRpm;
    float lowerThreshold;
    float upperThreshold;
    
    int baseRpm2;
    float lowerThreshold2;
    float upperThreshold2;
    
    float Current_Temp_CPU_A;
    float Current_Temp_CPU_B;
    float Current_Temp_CPU_A_HS;
}

// accessors
- (void)setBaseRpm:(int)newBaseRpm;
- (void)setLowerThreshold:(float)newLowerThreshold;
- (void)setUpperThreshold:(float)newUpperThreshold;

- (void)setBaseRpm2:(int)newBaseRpm2;
- (void)setLowerThreshold2:(float)newLowerThreshold2;
- (void)setUpperThreshold2:(float)newUpperThreshold2;

- (void)setCurrent_Temp_CPU_A:(float)newCurrent_Temp_CPU_A;
- (void)setCurrent_Temp_CPU_B:(float)newCurrent_Temp_CPU_B;
- (void)setCurrent_Temp_CPU_A_HS:(float)newCurrent_Temp_CPU_A_HS;

@end
