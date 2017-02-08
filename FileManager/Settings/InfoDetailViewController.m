//
//  InfoDetailViewController.m
//  FileManager
//
//  Created by xiaodev on Feb/7/17.
//  Copyright © 2017 xiaodev. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "XTools.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "sys/stat.h"
//infodetailcell
@interface InfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_mainArray;
    __weak IBOutlet UITableView *_mainTableView;
}
@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc]init];
    switch (self.type) {
        case InfoDetailTypeDevice:
        {
            self.title = @"设备信息";
            [self reloadDeviceInformationDetail];
        }
            break;
        case InfoDetailTypeApp:
        {
            self.title = @"应用信息";
            [self reloadAppInformationDetail];
        }
            break;
            
        default:
            break;
    }
}
- (void)reloadAppInformationDetail {
    
    NSLog(@"path == %@\n==%@\n==%@",KDocumentP,kCachesP,kTmpP);
    _mainArray = @[@[@{@"title":@"应用名称",@"detail":@"悦览播放器"}],
                   @[@{@"title":@"应用版本",@"detail":APP_CURRENT_VERSION},
                   @{@"title":@"应用作者",@"detail":@"JingYuan Xiao"},
                   @{@"title":@"应用声明",@"detail":@"如果涉及侵权行为，请联系作者"},
                   @{@"title":@"联系方式",@"detail":@"xiaodeve@163.com"}],
                   @[@{@"title":@"存储文件(可删除)",@"detail":[XTOOLS storageSpaceStringWith:[self folderSizeAtPath:KDocumentP]]},
                     @{@"title":@"应用缓存(可清除)",@"detail":[XTOOLS storageSpaceStringWith:([self folderSizeAtPath:kCachesP]+[self folderSizeAtPath:kTmpP])]}],
                   ];
    [_mainTableView reloadData];
}
- (void)reloadDeviceInformationDetail {
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *batterStr = @"--";
    switch (device.batteryState) {
        case UIDeviceBatteryStateUnplugged:
        {
            batterStr = [NSString stringWithFormat:@"未充电 %.f%%",device.batteryLevel*100];
        }
            break;
        case UIDeviceBatteryStateCharging:
        {
            batterStr = [NSString stringWithFormat:@"充电中 %.f%%",device.batteryLevel*100];
        }
            break;

        case UIDeviceBatteryStateFull:
        {
            batterStr = [NSString stringWithFormat:@"满电 %.f%%",device.batteryLevel*100];
        }
            break;

            
        default:
            break;
    }
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    _mainArray = @[@[@{@"title":@"设备名称",@"detail":device.name},],
                   @[@{@"title":@"设备类型",@"detail":device.localizedModel},
                   @{@"title":@"设备型号",@"detail":[self getCurrentDeviceModel]},
                   @{@"title":@"系统版本",@"detail":[NSString stringWithFormat:@"%@ %@",device.systemName,device.systemVersion]}],
                  @[@{@"title":@"剩余空间",@"detail":[XTOOLS storageSpaceStringWith:[XTOOLS freeStorageSpace]]},
                   @{@"title":@"设备空间",@"detail":[XTOOLS storageSpaceStringWith:[XTOOLS allStorageSpace]]},
                   @{@"title":@"电池电量",@"detail":batterStr},
                   @{@"title":@"分辨率",@"detail":[NSString stringWithFormat:@"%.f x %.f",width,height]}]
                   
                   ];
    [_mainTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mainArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _mainArray[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infodetailcell" forIndexPath:indexPath];
    NSDictionary *dict = _mainArray[indexPath.section][indexPath.row];
    if (indexPath.section == 2&&self.type == InfoDetailTypeApp) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"detail"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2&&self.type == InfoDetailTypeApp) {
        NSDictionary *dict = _mainArray[indexPath.section][indexPath.row];
        NSString *title = @"删除存储的文件";
        NSString *detail = @"您将删除应用内存储的全部文件，如果删除将无法恢复，是否继续删除？";
        if ([dict[@"title"] isEqualToString:@"存储文件(可删除)"]) {
            
        }
        else
            if ([dict[@"title"] isEqualToString:@"应用缓存(可清除)"]) {
               title = @"清楚缓存";
                detail = @"您将清楚应用内的缓存，如果清除一些文件可能需要重新加载，是否继续清除？";
            }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *unzipAction =[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([dict[@"title"] isEqualToString:@"存储文件(可删除)"]) {
                [XTOOLS showLoading:@"删除中"];
                
                NSArray *array=[kFileM contentsOfDirectoryAtPath:KDocumentP error:nil];
                
                for (int i=0; i<array.count; i++) {
                    [kFileM removeItemAtPath:[NSString stringWithFormat:@"%@/%@",KDocumentP,[array objectAtIndex:i]] error:nil];
                }
                [XTOOLS hiddenLoading];
                [self reloadAppInformationDetail];
                [XTOOLS showMessage:@"删除完毕"];
            }
            else
                if ([dict[@"title"] isEqualToString:@"应用缓存(可清除)"]) {
                    [XTOOLS showLoading:@"清除中"];
                    
                    NSArray *array=[kFileM contentsOfDirectoryAtPath:kCachesP error:nil];
                    
                    for (int i=0; i<array.count; i++) {
                        [kFileM removeItemAtPath:[NSString stringWithFormat:@"%@/%@",kCachesP,[array objectAtIndex:i]] error:nil];
                    }
                    
                    NSArray *array1=[kFileM contentsOfDirectoryAtPath:kTmpP error:nil];
                    
                    for (int i=0; i<array1.count; i++) {
                        [kFileM removeItemAtPath:[NSString stringWithFormat:@"%@/%@",kTmpP,[array objectAtIndex:i]] error:nil];
                    }
                    [XTOOLS hiddenLoading];
                    [self reloadAppInformationDetail];
                    [XTOOLS showMessage:@"清除完毕"];
                }
            
        }];
        [alert addAction:cancleAction];
        [alert addAction:unzipAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPodTouch6G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad4";
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPadAir2";
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPadmini4"; 
    if ([platform isEqualToString:@"i386"]) return @"iPhoneSimulator"; 
    if ([platform isEqualToString:@"x86_64"]) return @"iPhoneSimulator"; 
    return platform; 
}
- (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end