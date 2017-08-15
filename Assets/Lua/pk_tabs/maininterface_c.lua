local data ={
	info={key="ID",keytype=keytype.int},
	head={"ID","Name","Type","UnlockLevel","UnlockEvent","Prompt","UIDefine","RedDotRefreshAPI","Icon"},
	body={
		[101]={101,"指挥官",1,1,"-1",1,"ui_equip2","","zhujiemian_tubiao_zhihuiguan"},
		[102]={102,"部队",1,1,"-1",1,"ui_cardyc","require('uiscripts/cardyc/redDotControl'):mainCall()","zhujiemian_tubiao_budui"},
		[103]={103,"军团",1,5,"-1",1,"","","zhujiemian_tubiao_juntuan"},
		[104]={104,"仓库",1,1,"-1",-1,"ui_cangku","require('uiscripts/main/ui_main_model'):testReadRedDot()","zhujiemian_tubiao_cangku"},
		[105]={105,"好友",1,5,"-1",1,"","","zhujiemian_tubiao_haoyou"},
		[106]={106,"商店",1,5,"-1",-1,"ui_shop","ui_main_model.testReadRedDotNoRequire()","zhujiemian_tubaio_shangdian"},
		[107]={107,"兑换",1,5,"-1",-1,"ui_cardshop","",""},
		[108]={108,"抽奖",1,5,"-1",-1,"","",""},
		[109]={109,"科技",1,5,"-1",1,"","",""},
		[110]={110,"任务",1,5,"-1",1,"","",""},
		[201]={201,"邮件",2,1,"-1",2,"ui_mail","require('uiscripts/mail/mail_model'):GetNewNum()",""},
		[203]={203,"首充",2,1,"-1",1,"","",""},
		[204]={204,"签到",2,1,"-1",1,"ui_qiandao","","zhujiemian_tubiao_qiandao"},
		[205]={205,"活动",2,1,"-1",1,"","",""},
		[206]={206,"福利",2,1,"-1",1,"","",""},
		[207]={207,"充值",2,1,"-1",1,"","",""},
	}
}
return data
