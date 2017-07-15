//
//  APIStringMacros.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#ifndef APIStringMacros_h
#define APIStringMacros_h
#define DOMAIN_NAME @"http://api.uubaoku.com"
#define LG_DOMAIN_NAME @"http://uu.dev.loongcrown.com/index.php?g=UUApi"
/**
 *提现接口
 */
#define GET_WITHDRAW_LOG @"/My/GetWithDrawLog"
/**
 *提现类型接口
 */
#define GET_WITHDRAW_TYPE @"/My/GetWithDrawType"
/**
 *库币类型接口
 */
#define GET_KUBI_TYPE @"/My/GetKuBiType"
#define GET_KUBI_LOG @"/My/GetKuBiLog"
/**
 *佣金类型接口
 */
#define GET_COMMISSION_TYPE @"/My/GetCommissionType"
/**
 *囤货地址借口
 */
#define GET_RECHARGE_DETAIL @"/My/GetRechargeDetail"
/**
 *收货地址获取地址接口
 */
#define GET_ADDRESS_LIST @"/My/GetAddressList"
/**
 *收货地址删除接口
 */
#define DEL_ADDRESS @"/My/DelAddress"

#define GET_REGION_INFO @"/Order/GetRegionInfo"

/**
 *修改个人信息
 */
#define UPDATE_USER_INFO @"/User/UpdateUserInfo"
/**
 *上传图片
 *Type:1 头像 2 身份证 3朋友圈背景图片 4退款 5评论
 */
#define UP_IMG @"/UploadImage/UpImg"

#define GET_MY_INTRESTING @"/My/GetMyIntresting"


#define GET_BANK_LIST @"/My/GetBankList"


#define SEND_MESSAGE @"/User/SendMessage"


#define BANK_BIND @"/My/BankBind"


#define REAL_NAME_AUTHENTICATION @"/My/RealNameAuthentication"

#define SETING_PASSWORD_PROTECTION @"/My/SettingPasswordProtection"

#define GET_USER_PASSWORD_PROTECTION_QUESTION_LIST @"/My/GetUserPasswordProtectionQuestionList"


#define GET_PASSWORD_PROTECTION_QUESTION_LIST @"/My/GetPasswordProtectionQuestionList"

#define MODIFY_PAY_PASSWORD @"/My/ModifyPayPassWord"

#define MODIFY_LOGIN_PWD @"/My/ModifyLoginPassWord"

#define MODIFY_MOBILE @"/My/ModifyMobile"

#define GET_MONEY_TYPE @"/My/GetMoneyType"

#define ADD_ADDRESS @"/My/AddAddress"

#define MODIFY_ADDRESS @"/My/ModifyAddress"
#define GET_FINANCE_DETAIL @"/My/GetFinanceDetail"

#define GET_MY_BROWSE @"/My/GetMyBrowse"

#define GET_MY_FAVORITES @"/My/GetMyFavorites"

#define DEL_ALL_MYBROWSE @"/My/DelAllMyBrowse"

#define DEL_MY_BROWSE @"/My/DelMyBrowse"
#define DEL_FAVORITE @"/My/DelFavorite"

#define GET_COMMENT_LIST @"/My/GetCommentList"

#define GET_COMMENT_COUNT @"/My/GetCommentCount"

#define GET_MY_ORDER_STATICS @"/My/GetMyOrderStatics"

#define GET_ORDER_LIST @"/My/GetOrderList"

#define GET_ORDER_DETAIL @"/My/GetOrderDetail"

#define CANCEL_ORDER @"/My/CancelOrder"

#define FINISH_ORDER @"/My/FinishOrder"

#define GET_LOGISTICS @"/My/GetLogistics"

#define GET_LOGISTICS_BY_NO @"/My/GetLogisticsByNo"

#define HOT_RECOMMEND_GOODS @"/Goods/HotRecommendGoods"

#define GET_REFOUND_ORDER_LIST @"/my/GetRefoundOrderList"

#define GET_REFOUND_DETAIL @"/OrderRefound/GetRefoundDetail"

#define GET_REFOUND_REASON @"/Order/GetRefoundReason"

#define REFOUND_APPLY @"/OrderRefound/RefoundApply"

#define REFOUND_CANCEL @"/OrderRefound/RefoundCancel"

#define ADD_LOGISTIC_INFO @"/OrderRefound/AddLogisticInfo"

#define GET_SPECIAL_CHOICE_ORDER_LIST @"/TeamBuyOrder/GetSpecialChoiceOrderList"

#define GET_RUSH_ORDER_LIST @"/TeamBuyOrder/GetRushOrderList"

#define GET_LUCKY_ORDER_LIST @"/TeamBuyOrder/GetLuckyOrderList"

#define GET_INTRESTING_ORDER_LIST @"/TeamBuyOrder/GetIntrestingOrderList"

#define GET_RUSH_PRIZE_LIST @"/TeamBuyOrder/GetRushPrizeList"

#define GET_LUCKY_PRIZE_LIST @"/TeamBuyOrder/GetLuckyPrizeList"

#define CONFIRM_LUCKY_FINISH @"/TeamBuyOrder/ConfirmLuckyFinish"

#define CONFIRM_RUSH_FINISH @"/TeamBuyOrder/ConfirmRushFinish"

#define APPLY_DISTRIBUTOR @"/Distrbutor/ApplyDistributor"

#define GET_WITHDRAW_FEE @"/My/GetWithDrawFee"

#define WITHDRAW_APP @"/My/WithDrawApp"

#define MALL_INDEX @"/MallIndex"

#define GET_TOP_CLASSFY @"/Classify/GetTopClassfy"

#define GET_ALL_CHILDREN_CLASSFY @"/Classify/GetAllChildrenClassfy"

#define GOODS_SEARCH @"/Goods/GoodsSearch"

#define GOODS_DETAIL @"/Goods/GoodsDetail"

#define GOODS_ACTIVE_DETAIL @"/Goods/GoodsActiveDetail"
#define GUESS_YOUR_LIKE_FOR_GOODS_DETAIL @"/Goods/GuessYourLikeForGoodsDetail"

#define CHANGE_SKUID_INFO @"/Goods/ChangeSKUIDInfo"

#define CHANGE_ACTIVE_SKUID_INFO @"/Goods/ChangeActiveSKUIDInfo"

#define GET_POSTAGE @"/Goods/GetPostage"

#define ADD_MY_FAVOURITE @"/My/AddMyFavorite"

#define DEL_FAVORITE @"/My/DelFavorite"

#define GET_GROUP_GOODS_DETAIL @"/GroupBuy/GetGroupGoodsDetail"

#define ADD_TO_CART @"/cart/addtocart"

#define BARGAIN_HELP @"/Promotion/BargainHelp"

#define GET_SPREAD_USER_INFO_BY_USER_ID @"/UserRelation/GetSpreadUserInfoByUserID"

#define GET_USER_INFO_BY_UID @"/User/GetUserInfoByUID"

#define WEIXIN_PAY @"/PayMent/WeiXinPay"

#define APPLY_SUPPLIER @"/Supply/ApplySupplier"

#define GET_COMMODITY_SHELVES @"/Supply/GetCommodityShelves"

#define GET_GOODS_LIST @"/Supply/GetGoodsList"

#define PUBLISH_SUPPLIER_GOODS @"/Supply/PublishSupplierGoods"

#define WANTED_SHARE @"/MyShare/WantedShare"
#define BEE_LIST @"/MyShare/BeeList"
#define SHARE_KUBI_LIST @"/MyShare/ShareKubiList"
#define SHARE_COMMISSION_LIST @"/MyShare/ShareCommissionList"

#define GET_GOODS_ATTR @"/Supply/GetGoodsAttr"

#define GET_SKU_SPECS_BY_CLASS_ID @"/Supply/GetSKUSpecsByClassId"

#define ADD_COMMENT @"/My/AddComment"

#define GET_CAN_USE_MAX_INTEGRAL @"/User/GetCanUseMaxIntegral"

#define IS_WEIXIN_PAY_SUCCESS @"/PayMent/IsWeiXinPaySuccess"

#define WEIXIN_RECHARGE @"/PayMent/WeiXinRecharge"

#define GET_DISTRIBUTOR_DEGREE @"/Supply/GetDistributorDegree"
#define GET_NORMAL_SHARE_INFO @"/MyShare/GetNormalShareInfo"
#define GET_LUCKY_GROUP_GOODS_DETAIL @"/GroupBuy/GetLuckyGroupGoodsDetail"
#define GET_RUSH_GROUP_GOODS_DETAIL @"/GroupBuy/GetRushGroupGoodsDetail"
#define GET_COMMISSION_LOG @"/My/GetCommissionLog"
#define kSign @""

/*
 *投票事项接口
 */
#define ZONE_VOTE @"&m=Zone&a=vote"

/*
 *分享圈数据
 */
#define SHARE_ZONE @"&m=Zone&a=myShareZone"

/*
 *热销圈数据
 */
#define GET_HOT_ZONE @"&m=Zone&a=getHotZone"

/*
 *优物空间
 */
#define GET_GOODS_ZONE_BY_ID @"&m=Zone&a=getGoodsZoneById"

/*
 *推荐详情
 */
#define GET_ARTICLE_DETAIL @"&m=Zone&a=getArticleDetail"

/*
 **推荐详情发表评论
 */
#define  COMMENT_ARTICLE @"&m=Zone&a=commentArticle"

/**
 *推荐评论点赞
 */
#define LIKE_COMMENT @"&m=Zone&a=likeComment"

/**
 *关注推荐
 */
#define  COLLECT @"&m=Moment&a=collect"

/**
 *点赞推荐
 */
#define LIKE_ARTICLE @"&m=Zone&a=likeArticle"

/**
 *通过三方链接添加商品
 */
#define GET_GOODS_BY_URL @"/SharingCircle/GetGoodsByUrl"

/**
 *获取我关注的商品
 */
#define GET_COLLECTED_GOODS @"&m=Shop&a=getCollectedGoods"

/**
 *获取我购买的商品
 */
#define GET_MY_ORDER_GOODS @"/My/GetMyOrderGoods"

/**
 *获取圈子公告
 */
#define GET_BULLETIN_LIST @"&m=Bulletin&a=getBulletinList"

/**
 *获取未读消息
 */
#define GET_UNREAD @"&m=Moment&a=getUnread"

/**
 *清空未读消息
 */
#define CLEAR_UNREAD @"&m=Moment&a=clearUnread"
#endif /* APIStringMacros_h */
