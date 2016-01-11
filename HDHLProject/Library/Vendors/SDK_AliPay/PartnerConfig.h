//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088411326427213"
//收款支付宝账号
#define SellerID  @"service@hdcai.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"qrwerwe456we45t7y8ui3er6ytr76y54"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANscKjsNv+ruX6d6qAjtqioyfbNdU4C2Qg86dJBee5qpnZuALZqDGXtq5Jf/W2b5RqELJ+COUkz9qBYfmQZR/W26InLbYevUGO2nr1WhP+uBVerssWCFCfUZLVdVWn7gzbOnNZ9yLiqboz9gjOeG2MJ4mEKiIyD7SmjSX2PUtXkvAgMBAAECgYEAhOEq1096YX6Y8hfXyjpgJWEjjGB/4KIno9aelGNIcL6Gv6RXg8oX7RohcfDCPMvWQppiX7PQQ7LdejVFd2jH2OFODQHx86kfUftrLOlx/DFgeWmsFQ7gOpU5Mj4XCuTJWhT37md0WZHeLW7C2xZFafU+eQynsJ0NRVTJlQXfA1ECQQD0YpPphvkYL4Je4Evv8oCwBQBrpZVFM1Nw6z7SoJLFvIXCHOwuPSPERvA9hEyBoPSDgGOdB+0QtdHxYmzkatq5AkEA5YYRGEoSaSNI75ezWJ24ZdyrSmJP4KaKIAmfu4JCPJkCXTjiQ2o4udLQ+EAOwKf2FLqdlz/K8QqjgMJdc5/fJwJASJpYsxIkQqkqpCEirkBvNtvlihWBSTO8YFmjKlQGBrTBUC/jgsErNQ6WJNB/Iiu9OKwV6/sE1OgPXRUOoLWWEQJAW6YqA1HoghT11b30fkkUTZBM0XnqPWEivGI7Zws/WaUbXZAOQS8UEZdNnCMwANvQljxiGvf9GDzQRuTVngrTdwJBAKV0cHM/lCZzTu9LqFcxTEv+Bkr6iJkZJWY+3Jwal9+2WxBAt0vdkRCBE1jWwQAmRaHKptvpsW5rvtIKJvtxPbI="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
