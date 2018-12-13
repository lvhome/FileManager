//
//  ViewController.m
//  FileManager
//
//  Created by MAC on 2018/12/11.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*本demo实现了文件/目录的创建、删除、拷贝、移动、判断文件是否存在、文件的读和写、文件的属性查看、遍历目录下的内容、NSFileHandle的使用*/
    //创建文件管理器单例对象
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //文件或目录操作
    //1 创建文件夹或文件
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    //创建app文件夹或文件
    documents = [documents stringByAppendingPathComponent:@"appText"];
    
    //是否存在文件夹或文件
    if (![fileManager fileExistsAtPath:documents]) {
        [fileManager createDirectoryAtPath:documents withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //2 删除文件夹或文件
    //先创建一个test
    NSString *documentsTest = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    //创建test文件夹或文件
    documentsTest = [documentsTest stringByAppendingPathComponent:@"test"];
    if (![fileManager fileExistsAtPath:documentsTest]) {
        [fileManager createDirectoryAtPath:documentsTest withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //是否存在文件夹或文件
    if ([fileManager fileExistsAtPath:documentsTest]) {
        BOOL isS = [fileManager removeItemAtPath:documentsTest error:nil];
        if (isS) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }
    
    //3移动文件夹或文件
    NSString *documentsMove = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    //创建app文件夹
    documentsMove = [documentsMove stringByAppendingPathComponent:@"text"];
    NSString * t = [documentsMove stringByAppendingPathComponent:@"text"];

    if (![fileManager fileExistsAtPath:documentsMove]) {
        [fileManager createDirectoryAtPath:documentsMove withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:t]) {
        [fileManager createDirectoryAtPath:t withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //是否存在文件夹或文件
    if ([fileManager fileExistsAtPath:documentsMove]) {
        NSError * error;
        BOOL isS = [fileManager moveItemAtPath:documentsMove toPath:[documents stringByAppendingPathComponent:@"text"] error:&error];
        
        if (isS) {
            NSLog(@"移动成功");
        }
        else {
            NSLog(@"移动失败");
        }
    }
    
    //4、拷贝文件   如果目标文件中存在则会直接失败
    
    //目录与目录拷贝
    NSString * documentsCopy = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    //创建app文件夹
    documentsCopy = [documentsCopy stringByAppendingPathComponent:@"textCopy"];
    if (![fileManager fileExistsAtPath:documentsCopy]) {
        [fileManager createDirectoryAtPath:documentsCopy withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL isD = [fileManager copyItemAtPath:documentsCopy toPath:[documents stringByAppendingPathComponent:@"textCopy"] error:nil];
    
    if (isD) {
        NSLog(@"拷贝成功");
    }
    else {
        NSLog(@"拷贝失败");
    }
    
    
    
    //写数据到文件
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * testPath = [documentsPath stringByAppendingPathComponent:@"test.plist"];
//    if (![fileManager fileExistsAtPath:testPath]) {
//        [fileManager createDirectoryAtPath:testPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    NSString * content = @"qqqqqqqqqq111111111122222222223333333333";
    NSError * err ;
    BOOL res = [content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (res) {
        NSLog(@"文件写入成功");
    }else {
        NSLog(@"文件写入失败");
    }
    
    //读文件数据
    //NSData *data = [NSData dataWithContentsOfFile:testPath];
    //NSLog(@"文件读取成功: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString * contentRead = [NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",contentRead);
    
    //文件属性
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:testPath error:nil];
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [fileAttributes objectForKey: key];
//        NSLog (@"Key: %@ for value: %@", key, value);
    }
    //
    NSLog(@"%@",documents);
    
//   遍历目录下的内容
    
    //浅度遍历当前目录下的文件
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:documents error:nil];
    NSLog(@"array-%@",array);
      
    //深度遍历
   NSArray * arr = [fileManager subpathsOfDirectoryAtPath:documents error:nil];
    NSLog(@"arr-%@",arr);

    
    //NSFileHandle（文件句柄类）
    
    //对文件进行读写首先需要NSFileHandle打开文件,
    
    //NSFileHandle对文件进行读写都是NSData类型的二进制数据.
    ///<1>打开文件方法
    
    //只读的句柄
    
    NSFileHandle *readOnlyHandle = [NSFileHandle fileHandleForReadingAtPath:testPath];

    //只写的句柄

    NSFileHandle *writeOnlyHandle  = [NSFileHandle fileHandleForWritingAtPath:testPath];

    //读写句柄

    NSFileHandle *readAndWriteHandle = [NSFileHandle fileHandleForUpdatingAtPath:testPath];


    ///<2>读指定长度的数据（单位为字节)读取10个字节数据

    NSData * data = [readAndWriteHandle readDataOfLength:10];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);


    ///<3>从当前偏移量读到文件尾

    NSData * readAndWriteEndData = [readAndWriteHandle readDataToEndOfFile];
    NSLog(@"%@",[[NSString alloc] initWithData:readAndWriteEndData encoding:NSUTF8StringEncoding]);


    ///<4>设置文件偏移量（单位为字节)

    [readAndWriteHandle seekToFileOffset:5];
    ///<5>将文件偏移量定位到文件尾
    [readAndWriteHandle seekToEndOfFile];



    ///<6>写文件(不覆盖的时候需要设置偏移量)

    //1.先把偏移量指到文件尾部

    [readAndWriteHandle seekToEndOfFile];

    //2.写入到指定路径

    [readAndWriteHandle writeData:[@"1111111111" dataUsingEncoding:NSUTF8StringEncoding]];
    [readAndWriteHandle seekToFileOffset:0];
    NSData * readAndWriteEndData1 = [readAndWriteHandle readDataToEndOfFile];
    NSLog(@"%@",[[NSString alloc] initWithData:readAndWriteEndData1 encoding:NSUTF8StringEncoding]);
    ///<7>关闭文件句柄
    //关闭文件句柄,关闭后(不需要)就不能再操作文件了
    [readAndWriteHandle closeFile];
    [readOnlyHandle closeFile];
    [writeOnlyHandle closeFile];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
