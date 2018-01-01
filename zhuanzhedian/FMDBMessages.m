//
//  FMDBMessages.m
//  zhuanzhedian
//
//  Created by Gaara on 15/12/15.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "FMDBMessages.h"
#import "FMDB.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "MyMessage.h"
#import "MyConversation.h"
#import "AVOSCloud/AVOSCloud.h"
#import "NotificationMessage.h"
@implementation FMDBMessages
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (MyMessage *)messageTranToModel:(AVIMTypedMessage *)message WithSid:(NSString *)sid rid:(NSString *)rid
{
    NSDictionary *attributes = message.attributes;
    MyMessage *myMessage = [[MyMessage alloc]init];
    myMessage.bossOrWorker = [[attributes objectForKey:@"bossOrWorker"]integerValue];
    myMessage.jdId = [[attributes objectForKey:@"jdId"]integerValue];
    myMessage.rsId = [[attributes objectForKey:@"rsId"]integerValue];
    myMessage.type = [[attributes objectForKey:@"type"]integerValue];
    //如果是音频，文字数据字段用于保存时间
    myMessage.text = [FMDBMessages getMessageContnet:message];
    myMessage.url = message.file.url;
    myMessage.mediaType = message.mediaType;
    myMessage.sendId = sid;
    myMessage.receiveId = rid;
    myMessage.timeStamp = message.sendTimestamp;
    myMessage.status = message.status;
    if ([attributes objectForKey:@"sendType"]) {
        myMessage.sendType = [attributes objectForKey:@"sendType"];
    };
    
    
    return myMessage;
}
+ (NSMutableArray *)getHeaderJDMessagejd:(NSString *)jdId rsId:(NSString *)rsId
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    if ([db open]) {
        //        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE \"jdId\" = %@ AND \"rsId\" = %@  AND \"type\" = 0 order by %@ desc",@"MESSAGES",jdId,rsId,@"timestamp"];
        FMResultSet * rs = [db executeQuery:sql];
    
        while ([rs next]) {
            
            int bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            int jdId = [rs intForColumn:@"jdId"];
            int rsId = [rs intForColumn:@"rsId"];
            int type = [rs intForColumn:@"type"];
            NSString * text = [rs stringForColumn:@"text"];
            int mediaType = [rs intForColumn:@"mediaType"];
            NSString *url = [rs stringForColumn:@"url"];
            NSString *sendId = [rs stringForColumn:@"sendId"];
            NSString *receiveId = [rs stringForColumn:@"receiveId"];
            double timestamp = [rs doubleForColumn:@"timestamp"];
            int status = [rs intForColumn:@"status"];
            
            MyMessage *message = [[MyMessage alloc]init];
            message.bossOrWorker = bossOrWorker;
            message.jdId = jdId;
            message.rsId = rsId;
            message.type = type;
            message.text = text;
            message.mediaType = mediaType;
            message.url = url;
            message.sendId = sendId;
            message.receiveId = receiveId;
            message.timeStamp = timestamp;
            message.status = status;
            NSLog(@"%ld-%ld-%ld-%ld-%@-%ld-%@-%@-%@-%f",(long)message.bossOrWorker,(long)message.jdId,(long)message.rsId,(long)message.type,message.text,(long)message.mediaType,message.url,message.sendId,message.receiveId,message.timeStamp);
            [array addObject:message];
   
           
        }
        [db close];
    }
    return array;
}
+ (NSMutableArray *)getMessageFromDB:(NSString *)sid rid:(NSString *)rid jd:(NSString *)jdId count:(NSInteger)count sendType:(NSString *)sendType
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    if ([db open]) {
//                NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ((\"sendId\" = \"%@\" AND \"receiveId\" = \"%@\") OR (\"receiveId\" = \"%@\" AND \"sendId\" = \"%@\")) AND \"jdId\" = %@ AND not \"type\" = 0 AND not \"sendType\" = \"%@\" order by %@ desc",@"MESSAGES",sid,rid,sid,rid,jdId,sendType,@"timestamp"];
        FMResultSet * rs = [db executeQuery:sql];
        NSInteger a = 0;
        while ([rs next]) {
            
            int bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            int jdId = [rs intForColumn:@"jdId"];
            int rsId = [rs intForColumn:@"rsId"];
            int type = [rs intForColumn:@"type"];
            NSString * text = [rs stringForColumn:@"text"];
            int mediaType = [rs intForColumn:@"mediaType"];
            NSString *url = [rs stringForColumn:@"url"];
            NSString *sendId = [rs stringForColumn:@"sendId"];
            NSString *receiveId = [rs stringForColumn:@"receiveId"];
            double timestamp = [rs doubleForColumn:@"timestamp"];
            int status = [rs intForColumn:@"status"];
            NSString *sendType = [rs stringForColumn:@"sendType"];
            MyMessage *message = [[MyMessage alloc]init];
            message.bossOrWorker = bossOrWorker;
            message.jdId = jdId;
            message.rsId = rsId;
            message.type = type;
            message.text = text;
            message.mediaType = mediaType;
            message.url = url;
            message.sendId = sendId;
            message.receiveId = receiveId;
            message.timeStamp = timestamp;
            message.status = status;
            message.sendType = sendType;
            NSLog(@"%ld-%ld-%ld-%ld-%@-%ld-%@-%@-%@-%f",(long)message.bossOrWorker,(long)message.jdId,(long)message.rsId,(long)message.type,message.text,(long)message.mediaType,message.url,message.sendId,message.receiveId,message.timeStamp);
            [array addObject:message];
            a++;
            if (a > count - 1) {
                break;
            }
        }
        [db close];
    }
    return array;
    
}

+ (BOOL)deleteOneConversation:(NSInteger)jdId rsId:(NSInteger)rsId
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"conversation"]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE rsId = %ld AND jdId = %ld",@"CONV",(long)rsId,(long)jdId];
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库删除成功");
        }else{
            NSLog(@"数据库删除失败");
        }
    }
    
    return YES;
}
+ (NSMutableArray *)selectAllConversation
{
    
    NSMutableArray *conArr = [NSMutableArray array];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSLog(@"%@",path);
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"conversation"]];
    if ([db open]) {
        //        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (\"bossOrWorker\" = %@ OR \"bossOrWorker\" = 3) AND \"myId\" = \"%@\" order by \"rowId\" desc ",@"CONV",[[NSUserDefaults standardUserDefaults]objectForKey:@"state"],[AVUser currentUser].objectId];
        NSLog(@"sql====5====%@",sql);
        FMResultSet * rs = [db executeQuery:sql];
    
         while ([rs next]) {
             NSLog(@"selectAllConversation");
               //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
             NSString *yourId = [rs stringForColumn:@"yourId"];
             NSString *myId = [rs stringForColumn:@"myId"];
             
             NSLog(@"myId----------6---%@", myId);
             
             NSInteger jdId = [rs intForColumn:@"jdId"];
             NSInteger rsId = [rs intForColumn:@"rsId"];
             NSString *lastText = [rs stringForColumn:@"lastText"];
             double lastTime = [rs doubleForColumn:@"lastTime"];
             NSString *name = [rs stringForColumn:@"name"];
             NSString *header = [rs stringForColumn:@"header"];
             NSInteger bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            
             MyConversation *myConversation = [[MyConversation alloc]init];
             myConversation.yourId = yourId;
             myConversation.myId = myId;
             NSLog(@"myId--------8-----%@", myConversation.myId);
             myConversation.jdId = jdId;
             myConversation.rsId = rsId;
             myConversation.lastText = lastText;
             myConversation.lastTime = lastTime;
             myConversation.name = name;
             myConversation.header = header;
             myConversation.bossOrWorker = bossOrWorker;
             
             [conArr addObject:myConversation];
             
         }
        
        [db close];
    }
    return conArr;
}
+ (BOOL)judgeServiceConversationExist:(NSMutableDictionary *)dic
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"conversation"]];
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TIMESTAMP, '%@' TEXT, '%@' TEXT, '%@' INTEGER)",@"CONV",@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header",@"bossOrWorker"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
        
    }
    if ([db open]) {
        //        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE \"yourId\" = '%@' AND \"myId\" = '%@'",@"CONV",[dic objectForKey:@"yourId"],[dic objectForKey:@"myId"]];
        FMResultSet * rs = [db executeQuery:sql];
        NSInteger a = 0;
        NSLog(@"select sql:%@", sql);
        while ([rs next]) {
            NSString *yourId = [rs stringForColumn:@"yourId"];
            NSString *myId = [rs stringForColumn:@"myId"];
            
            NSLog(@"myId--------9-----%@", myId);
            NSInteger jdId = [rs intForColumn:@"jdId"];
            NSInteger rsId = [rs intForColumn:@"rsId"];
            NSString *lastText = [rs stringForColumn:@"lastText"];
            double lastTime = [rs doubleForColumn:@"lastTime"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *header = [rs stringForColumn:@"header"];
            NSInteger bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            
            MyConversation *myConversation = [[MyConversation alloc]init];
            myConversation.yourId = yourId;
            myConversation.myId = myId;
            
            NSLog(@"myId--------10----%@", myConversation.myId);
            myConversation.jdId = jdId;
            myConversation.rsId = rsId;
            myConversation.lastText = lastText;
            myConversation.lastTime = lastTime;
            myConversation.name = name;
            myConversation.header = header;
            myConversation.bossOrWorker = bossOrWorker;
            NSLog(@"select dic: %@", myId);
            a++;
            
        }
        [db close];
        NSLog(@"%ld",a);
        if (a == 0) {
            if ([db open]) {
                NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",@"CONV",@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header",@"bossOrWorker",[dic objectForKey:@"yourId"],[dic objectForKey:@"myId"],[dic objectForKey:@"jdId"],[dic objectForKey:@"rsId"],[dic objectForKey:@"lastText"],[dic objectForKey:@"lastTime"],[dic objectForKey:@"name"],[dic objectForKey:@"header"],[dic objectForKey:@"bossOrWorker"]];
                
                BOOL res = [db executeUpdate:insertSql1];
                if (res) {
                    NSLog(@"sql:%@", insertSql1);
                    NSLog(@"插入数据库成功");
                }
                [db close];
                
            }
            
        }else{
            if ([db open]) {
                NSString *insertSql2 = [NSString stringWithFormat:@"UPDATE '%@' SET \"%@\" = \"%@\", \"%@\" = \"%@\", \"%@\" = \"%@\",\"%@\" = \"%@\", \"%@\" = \"%@\", \"%@\" = \"%@\" WHERE \"jdId\" = %@ AND \"rsId\" = %@",@"CONV",@"lastText",[dic objectForKey:@"lastText"],@"lastTime",[dic objectForKey:@"lastTime"],@"name",[dic objectForKey:@"name"],@"header",[dic objectForKey:@"header"],@"bossOrWorker",[dic objectForKey:@"bossOrWorker"], @"myId",[dic objectForKey:@"myId"],[dic objectForKey:@"jdId"],[dic objectForKey:@"rsId"]];
                BOOL res = [db executeUpdate:insertSql2];
                if (res) {
                    NSLog(@"sql:%@", insertSql2);
                    NSLog(@"数据库修改成功");
                }
                [db close];
            }
        }
    }

    return YES;
}


+ (BOOL)judgeConversationExist:(NSMutableDictionary *)dic
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"conversation"]];
    NSLog(@"%@",path);
    
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TIMESTAMP, '%@' TEXT, '%@' TEXT, '%@' INTEGER)",@"CONV",@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header",@"bossOrWorker"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
        
    }
    
    if ([db open]) {
        //        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE \"jdId\" = %@ AND \"rsId\" = %@",@"CONV",[dic objectForKey:@"jdId"],[dic objectForKey:@"rsId"]];
        FMResultSet * rs = [db executeQuery:sql];
        NSInteger a = 0;
        NSLog(@"select sql:%@", sql);
        while ([rs next]) {
            NSString *yourId = [rs stringForColumn:@"yourId"];
            NSString *myId = [rs stringForColumn:@"myId"];
            
             NSLog(@"myId--------9-----%@", myId);
            NSInteger jdId = [rs intForColumn:@"jdId"];
            NSInteger rsId = [rs intForColumn:@"rsId"];
            NSString *lastText = [rs stringForColumn:@"lastText"];
            double lastTime = [rs doubleForColumn:@"lastTime"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *header = [rs stringForColumn:@"header"];
            NSInteger bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            
            MyConversation *myConversation = [[MyConversation alloc]init];
            myConversation.yourId = yourId;
            myConversation.myId = myId;
            
             NSLog(@"myId--------10----%@", myConversation.myId);
            myConversation.jdId = jdId;
            myConversation.rsId = rsId;
            myConversation.lastText = lastText;
            myConversation.lastTime = lastTime;
            myConversation.name = name;
            myConversation.header = header;
            myConversation.bossOrWorker = bossOrWorker;
            NSLog(@"select dic: %@", myId);
            a++;
     
        }
        [db close];
        NSLog(@"%ld",a);
        if (a == 0) {
            if ([db open]) {
                NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",@"CONV",@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header",@"bossOrWorker",[dic objectForKey:@"yourId"],[dic objectForKey:@"myId"],[dic objectForKey:@"jdId"],[dic objectForKey:@"rsId"],[dic objectForKey:@"lastText"],[dic objectForKey:@"lastTime"],[dic objectForKey:@"name"],[dic objectForKey:@"header"],[dic objectForKey:@"bossOrWorker"]];
                
                BOOL res = [db executeUpdate:insertSql1];
                if (res) {
                    NSLog(@"sql:%@", insertSql1);
                    NSLog(@"插入数据库成功");
                }
                [db close];
                
            }

        }else{
            if ([db open]) {
                NSString *insertSql2 = [NSString stringWithFormat:@"UPDATE '%@' SET \"%@\" = \"%@\", \"%@\" = \"%@\", \"%@\" = \"%@\",\"%@\" = \"%@\", \"%@\" = \"%@\", \"%@\" = \"%@\" WHERE \"jdId\" = %@ AND \"rsId\" = %@",@"CONV",@"lastText",[dic objectForKey:@"lastText"],@"lastTime",[dic objectForKey:@"lastTime"],@"name",[dic objectForKey:@"name"],@"header",[dic objectForKey:@"header"],@"bossOrWorker",[dic objectForKey:@"bossOrWorker"], @"myId",[dic objectForKey:@"myId"],[dic objectForKey:@"jdId"],[dic objectForKey:@"rsId"]];
                BOOL res = [db executeUpdate:insertSql2];
                if (res) {
                    NSLog(@"sql:%@", insertSql2);
                    NSLog(@"数据库修改成功");
                }
                [db close];
            }
        }
    }

    
    NSLog(@"%@",[dic objectForKey:@"lastText"]);

    return YES;
}
+ (NSMutableArray *)selectAllNotifiMessage
{
    
    NSMutableArray *noTiFiArr = [NSMutableArray array];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSLog(@"%@",path);
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"notification"]];
    if ([db open]) {
        //        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@" ,@"MESSAGES"];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE \"bossOrWorker\" = %@  AND \"receiveId\" = \"%@\" order by \"rowId\" desc ",@"NOTIFI",[[NSUserDefaults standardUserDefaults]objectForKey:@"state"],[AVUser currentUser].objectId];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            
            NSInteger jdId = [rs intForColumn:@"jdId"];
            NSInteger rsId = [rs intForColumn:@"rsId"];
            NSString *text = [rs stringForColumn:@"text"];
            double timestamp = [rs doubleForColumn:@"timestamp"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *subType = [rs stringForColumn:@"subType"];
            NSInteger bossOrWorker = [rs intForColumn:@"bossOrWorker"];
            NSString *title = [rs stringForColumn:@"title"];
            NSString *detail = [rs stringForColumn:@"detail"];
            NSString *receiveId = [rs stringForColumn:@"receiveId"];
            NSString *jdCount = [rs stringForColumn:@"jdCount"];
            NSString *avatar = [rs stringForColumn:@"avatar"];
            NSString *jdTitle = [rs stringForColumn:@"jdTitle"];
            NSString *sendId = [rs stringForColumn:@"sendId"];
            NSString *uid = [rs stringForColumn:@"uid"];
            NSString *token = [rs stringForColumn:@"token"];
            NotificationMessage *notiMessage = [[NotificationMessage alloc]init];
            notiMessage.jdId = jdId;
            notiMessage.rsId = rsId;
            notiMessage.text = text;
            notiMessage.timestamps = timestamp;
            notiMessage.name = name;
            notiMessage.subType = subType;
            notiMessage.bossOrWorker = bossOrWorker;
            notiMessage.title = title;
            notiMessage.detail = detail;
            notiMessage.receiveId = receiveId;
            notiMessage.jdCount = jdCount;
            notiMessage.avatar = avatar;
            notiMessage.jdTitle = jdTitle;
            notiMessage.sendId = sendId;
            notiMessage.uid = uid;
            notiMessage.token = token;
            [noTiFiArr addObject:notiMessage];
            
        }
        
        [db close];
    }
    return noTiFiArr;

    
    
  
}
+ (BOOL)saveNotificationMessage:(AVIMTypedMessage *)message text:(NSString *)text
{
    NSDictionary *attributes = message.attributes;
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"notification"]];
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TIMESTAMP, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT ,'%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT)",@"NOTIFI",@"bossOrWorker",@"jdId",@"rsId",@"type",@"text",@"mediaType",@"name",@"sendId",@"receiveId",@"timestamp",@"status",@"subType",@"jdCount",@"title",@"detail",@"avatar",@"jdTitle",@"uid",@"token"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
    }
    if ([db open]) {
        NSString *title = @"";
        if ([[attributes objectForKey:@"bossOrWorker"]isEqualToString:@"1"]) {
            title = [[attributes objectForKey:@"user"]objectForKey:@"cp_sub_name"];
            
        }else if([[attributes objectForKey:@"bossOrWorker"]isEqualToString:@"2"])
        {
            title = [[attributes objectForKey:@"rs"]objectForKey:@"title"];
        }
        
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@' , '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%lld','%d', '%@', '%@' , '%@', '%@', '%@', '%@','%@', '%@')",@"NOTIFI", @"bossOrWorker", @"jdId", @"rsId", @"type", @"text",@"mediaType",@"name",@"sendId",@"receiveId",@"timestamp",@"status", @"subType",@"jdCount",@"title",@"detail",@"avatar",@"jdTitle",@"uid",@"token",[attributes objectForKey:@"bossOrWorker"],[[attributes objectForKey:@"jd"]objectForKey:@"id"],[[attributes objectForKey:@"rs"]objectForKey:@"id"],[attributes objectForKey:@"type"],[FMDBMessages getMessageContnet:message],[NSString stringWithFormat:@"%hhd",message.mediaType],[[attributes objectForKey:@"user"]objectForKey:@"name"],message.clientId,[AVUser currentUser].objectId,message.sendTimestamp,message.status,[attributes objectForKey:@"sub_type"],[attributes objectForKey:@"jdCount"],title,text,[[attributes objectForKey:@"user"]objectForKey:@"avatar"],[[attributes objectForKey:@"jd"]objectForKey:@"title"],[[attributes objectForKey:@"user"]objectForKey:@"uid"],[[attributes objectForKey:@"user"]objectForKey:@"token"]];
        
        BOOL res = [db executeUpdate:insertSql1];
        if (res) {
            NSLog(@"插入数据库成功");
        }
        [db close];
        
    }

    
    
    return YES;
}

+ (BOOL)saveMessage:(AVIMTypedMessage *)message
{
    NSLog(@"%@",message.attributes);
    NSDictionary *attributes = message.attributes;
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    NSLog(@"%@",path);
    
        if ([db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TIMESTAMP, '%@' INTEGER)",@"MESSAGES",@"sendType",@"bossOrWorker",@"jdId",@"rsId",@"type",@"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status"];
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
            
        }
    
        if ([db open]) {
            NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%lld','%d')",@"MESSAGES", @"sendType",@"bossOrWorker", @"jdId", @"rsId", @"type", @"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status",[attributes objectForKey:@"sendType"], [attributes objectForKey:@"bossOrWorker"],[attributes objectForKey:@"jdId"],[attributes objectForKey:@"rsId"],[attributes objectForKey:@"type"],[FMDBMessages getMessageContnet:message],[NSString stringWithFormat:@"%hhd",message.mediaType],message.file.url,message.clientId,[AVUser currentUser].objectId,message.sendTimestamp,message.status ];
            
            BOOL res = [db executeUpdate:insertSql1];
            if (res) {
                NSLog(@"插入数据库成功");
            }
                       [db close];
            
        }
    
    
    
    
    return YES;
}
+ (BOOL)saveModelWhenSend:(MyMessage *)message
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    NSLog(@"%@",path);
    
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TIMESTAMP, '%@' INTEGER)",@"MESSAGES",@"bossOrWorker",@"jdId",@"rsId",@"type",@"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
        
    }
    
    
    
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%ld', '%ld', '%ld', '%ld', '%@', '%ld', '%@', '%@', '%@', '%f', '%ld')",@"MESSAGES", @"bossOrWorker", @"jdId", @"rsId", @"type", @"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status", (long)message.bossOrWorker,(long)message.jdId,(long)message.rsId,(long)message.type,message.text,(long)message.mediaType,message.url,[AVUser currentUser].objectId,message.receiveId,message.timeStamp ,(long)message.status];
        
        BOOL res = [db executeUpdate:insertSql1];
        if (res) {
            NSLog(@"插入数据库成功");
        }
        [db close];
        
    }

    
    return YES;
}
+ (BOOL)saveMessageWhenSend:(AVIMTypedMessage *)message Rid:(NSString *)receiveId
{
    
    NSLog(@"%@",message.attributes);
    NSDictionary *attributes = message.attributes;
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    NSLog(@"%@",path);
    
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT,'%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TIMESTAMP, '%@' INTEGER)",@"MESSAGES",@"sendType",@"bossOrWorker",@"jdId",@"rsId",@"type",@"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
        
    }
    
    
    
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%lld', '%hhd')",@"MESSAGES", @"sendType",@"bossOrWorker", @"jdId", @"rsId", @"type", @"text",@"mediaType",@"url",@"sendId",@"receiveId",@"timestamp",@"status", [attributes objectForKey:@"sendType"],[attributes objectForKey:@"bossOrWorker"],[attributes objectForKey:@"jdId"],[attributes objectForKey:@"rsId"],[attributes objectForKey:@"type"],[FMDBMessages getMessageContnet:message],[NSString stringWithFormat:@"%hhd",message.mediaType],message.file.url,[AVUser currentUser].objectId,receiveId,message.sendTimestamp,message.status ];
        
        BOOL res = [db executeUpdate:insertSql1];
        if (res) {
            NSLog(@"插入数据库成功");
        }
        [db close];
        
    }
    
    
    
    
    return YES;

}
+(NSString*)getMessageContnet:(AVIMTypedMessage *)message{
    NSString *text = @"";
    if (message.mediaType == kAVIMMessageMediaTypeAudio) {
        text = [message.file.metaData objectForKey:@"duration"];
    }else if(message.mediaType == kAVIMMessageMediaTypeText){
        text = message.text;
    }
    return text;
}
+(BOOL)deleteAllConversation
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"conversation"]];
    if (db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM CONV"];
            BOOL res = [db executeUpdate:sql];
            if (res) {
                NSLog(@"数据库删除成功");
            }else{
                NSLog(@"数据库删除失败");
            }
        }
    }
    return YES;
    }
+ (BOOL)updateEmailMessageState:(MyMessage *)message
{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",path,@"message"]];
    if ([db open]) {
        NSString *insertSql = [NSString stringWithFormat:@"UPDATE '%@' SET \"%@\" = \"%@\"  WHERE \"timestamp\" = %.0lf",@"MESSAGES",@"url",@"1",message.timeStamp];
        BOOL res = [db executeUpdate:insertSql];
        if (res) {
            NSLog(@"sql:%@", insertSql);
            NSLog(@"数据库修改成功");
        }
        [db close];
    }

    
    return YES;
}
@end
