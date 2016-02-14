//
//  Connection-Header.h
//  BasicSDK
//
//  Created by Rafael Moris on 21/07/15.
//  Copyright (c) 2015 Interacton. All rights reserved.
//

#import "DeviceInfo.h"

#define appName @""
#define appGroup @""

// Definir ambiente de uso
#define DEV

#ifdef DEV
    #define hostURL @""
#endif

#ifdef PRD
    #define hostURL @""

#endif

