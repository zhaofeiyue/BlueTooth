//
//  PeripheralModel.h
//  03.CoreBlueTooth使用
//
//  Created by 赵飞跃 on 17/5/24.
//  Copyright © 2017年 zfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface PeripheralModel : NSObject
@property (nonatomic,assign) CBPeripheralState *connectState;
@property (nonatomic,strong) NSString *peripheralName;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) NSNumber *pRSSI;

@end
