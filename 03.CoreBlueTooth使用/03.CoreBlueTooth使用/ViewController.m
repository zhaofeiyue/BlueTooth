//
//  ViewController.m
//  03.CoreBlueTooth使用
//
//  Created by xiaozhao on 15/10/31.
//  Copyright © 2015年 xiaozhao. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong)NSMutableArray *peripherals;
@property(nonatomic,strong)CBCentralManager *cmgr;
@end

@implementation ViewController

- (NSMutableArray *)peripherals
{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 创建中心管家,并且设置代理
    self.cmgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    // 2. 扫描外部设备
    /**
     *  scanForPeripheralsWithServices ：如果传入指定的数组，那么就只会扫描数组中对应ID的设备
     *                                   如果传入nil，那么就是扫描所有可以发现的设备
     *  扫描完外部设备就会通知CBCentralManager的代理
     */
    if ([self.cmgr state]== CBCentralManagerStatePoweredOn) {
        [self.cmgr scanForPeripheralsWithServices:nil options:0];
    }
//    [self.cmgr scanForPeripheralsWithServices:nil options:0];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([self.cmgr state]== CBCentralManagerStatePoweredOn) {
        [self.cmgr scanForPeripheralsWithServices:nil options:0];
    }
    NSLog(@"%s %d",__func__,__LINE__);
}

#pragma mark - CBCentralManagerDelegate
/**
 *  发现外部设备，每发现一个就会调用这个方法
 *  所以可以使用一个数组来存储每次扫描完成的数组
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSLog(@"%s %d",__func__,__LINE__);
   
    // 有可能会导致重复添加扫描到的外设
    // 所以需要先判断数组中是否包含这个外设
    if(![self.peripherals containsObject:peripheral]){
        [self.peripherals addObject:peripheral];
    }
    [self start];
}

/**
 *  连接外设成功调用
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s %d",__func__,__LINE__);
    // 查找外设服务
    [peripheral discoverServices:nil];
    peripheral.delegate = self;
}

/**
 *  模拟开始连接方法
 */
- (void)start
{
    NSLog(@"%s %d",__func__,__LINE__);
    // 3. 连接外设
    for (CBPeripheral *ppl in self.peripherals) {
        // 扫描外设的服务
        // 这个操作应该交给外设的代理方法来做
        // 设置代理
        ppl.delegate = self;
        [self.cmgr connectPeripheral:ppl options:nil];
    }
}

#pragma mark - CBPeripheralDelegate
/**
 *  发现服务就会调用代理方法
 *
 *  @param peripheral 外设
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s %d",__func__,__LINE__);
    // 扫描到设备的所有服务
    NSArray *services = peripheral.services;
    // 根据服务再次扫描每个服务对应的特征
    for (CBService *ses in services) {
        [peripheral discoverCharacteristics:nil forService:ses];
    }
}

/**
 *  发现服务对应的特征 在这个里面 可以获取一系列硬件的特征
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s %d",__func__,__LINE__);
    
    // 服务对应的特征
    NSArray *ctcs = service.characteristics;
    NSLog(@" -- servvice 的characteriistics -- %@",service.characteristics);
    // 遍历所有的特征
    for (CBCharacteristic *character in ctcs) {
        // 根据特征的唯一标示过滤
        if ([character.UUID.UUIDString isEqualToString:@"AF0BADB1-5B99-43CD-917A-A77BC549E3CC"]) {//这是我当时  随便找了一个uuid  你们可以替换
            NSLog(@"可以吃饭了");
        }
    }
}

/**
 *  断开连接
 */
- (void)stop
{
    NSLog(@"%s %d",__func__,__LINE__);
    // 断开所有连接上的外设
    for (CBPeripheral *per in self.peripherals) {
        [self.cmgr cancelPeripheralConnection:per];
    }
}

- (void)ayouwocao{
   // 。。。。。。
}
@end
