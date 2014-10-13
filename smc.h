/*
 * Apple System Management Control (SMC) Tool
 * Copyright (C) 2006 devnull 
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef __SMC_H__
#define __SMC_H__
#endif

#define VERSION               "0.01"

#define OP_NONE               0
#define OP_LIST               1 
#define OP_READ               2
#define OP_READ_FAN           3
#define OP_WRITE              4

#define KERNEL_INDEX_SMC      2

#define SMC_CMD_READ_BYTES    5
#define SMC_CMD_WRITE_BYTES   6
#define SMC_CMD_READ_INDEX    8
#define SMC_CMD_READ_KEYINFO  9
#define SMC_CMD_READ_PLIMIT   11
#define SMC_CMD_READ_VERS     12

#define DATATYPE_FPE2         "fpe2"
#define DATATYPE_UINT8        "ui8 "
#define DATATYPE_UINT16       "ui16"
#define DATATYPE_UINT32       "ui32"
#define DATATYPE_SP78         "sp78"

/***** Temperature key values *****/
#define SMC_KEY_CPU_A_TEMP      "TCAD" //CPU A Temperature
#define SMC_KEY_CPU_A_HS_TEMP     "TCAH" //CPU A Heatsink Temperature

#define SMC_KEY_CPU_B_TEMP      "TCBD" //CPU B Temperature
#define SMC_KEY_CPU_B_HS_TEMP     "TCBH" //CPU B Heatsink Temperature

#define SMC_KEY_Northbridge_TEMP      "TN0D" //Northbridge Temperature
#define SMC_KEY_Northbridge_HS_TEMP     "TN0H" //Northbridge Heatsink Temperature

/***** Intake Fan key values *****/
#define SMC_KEY_INTAKE_RPM_MIN  "F2Mn"
#define SMC_KEY_INTAKE_RPM_CUR  "F2Ac"

/***** CPU Fan key values *****/
#define SMC_KEY_CPU_A_RPM_MIN  "F4Mn"
#define SMC_KEY_CPU_A_RPM_CUR  "F4Ac"

/***** CPU Fan key values *****/
#define SMC_KEY_CPU_B_RPM_MIN  "F5Mn"
#define SMC_KEY_CPU_B_RPM_CUR  "F5Ac"

/***** Exhaust Fan key values *****/
#define SMC_KEY_EXHAUST_RPM_MIN  "F3Mn"
#define SMC_KEY_EXHAUST_RPM_CUR  "F3Ac"





typedef struct {
    char                  major;
    char                  minor;
    char                  build;
    char                  reserved[1]; 
    UInt16                release;
} SMCKeyData_vers_t;

typedef struct {
    UInt16                version;
    UInt16                length;
    UInt32                cpuPLimit;
    UInt32                gpuPLimit;
    UInt32                memPLimit;
} SMCKeyData_pLimitData_t;

typedef struct {
    UInt32                dataSize;
    UInt32                dataType;
    char                  dataAttributes;
} SMCKeyData_keyInfo_t;

typedef char              SMCBytes_t[32]; 

typedef struct {
  UInt32                  key; 
  SMCKeyData_vers_t       vers; 
  SMCKeyData_pLimitData_t pLimitData;
  SMCKeyData_keyInfo_t    keyInfo;
  char                    result;
  char                    status;
  char                    data8;
  UInt32                  data32;
  SMCBytes_t              bytes;
} SMCKeyData_t;

typedef char              UInt32Char_t[5];

typedef struct {
  UInt32Char_t            key;
  UInt32                  dataSize;
  UInt32Char_t            dataType;
  SMCBytes_t              bytes;
} SMCVal_t;


// prototypes
double SMCGetTemperature(char *key);
kern_return_t SMCSetFanRpm(char *key, int rpm);
int SMCGetFanRpm(char *key);

