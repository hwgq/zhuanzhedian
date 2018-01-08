//
//  UrlDefine.h
//  zhuanzhedian
//
//  Created by GuoQing Huang on 2018/1/5.
//  Copyright © 2018年 Gaara. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

#define TIMESTAMP @"http://api.zzd.hidna.cn/v1/comm/timestamp"
#define ipd api.zzd.hidna.cn;
// 分享
#define SHARE_URL @"https://api.zzd.hidna.cn/v1/"

/*
 个人信息
 */
// 上传附件简历
#define UPLOAD_NOUNRESUME_URL @"http://izhuanzhe.com/api/upload" // uid doc formdata形式上传， 加签名

// 预览附件简历
#define PREVIEWRESUME_URL @"http://izhuanzhe.com/api/preview"   // 加签名

// 获取个人信息简历
#define GET_RESUME_INFO @"http://api.zzd.hidna.cn/v1/rs/browser"    // 加签名

// 删除附件简历
#define DELETE_RESUME_URL @"http://izhuanzhe.com/api/delete"   // 加签名

#endif /* UrlDefine_h */
