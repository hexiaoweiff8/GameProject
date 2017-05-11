local data ={
	info={key="id",keytype=keytype.int},
	head={"_beizhu","id","str"},
	body={
		[1]={"",1,"更新资源…"},
		[2]={"",2,"解压资源…"},
		[3]={"",3,"检查网络是否通畅"},
		[4]={"",4,"选择服务器"},
		[5]={"",5,"进入游戏"},
		[6]={"",6,"注销"},
		[7]={"",7,"加载中…"},
		[8]={"",8,"历史登录"},
		[9]={"",9,"{0}-{1}服"},
		[10]={"",10,"登录服务器"},
		[11]={"",11,"上次登录："},
		[12]={"",12,"新服推荐："},
		[13]={"",13,"{0}服 {1}"},
		[14]={"",14,"繁忙"},
		[15]={"",15,"正常"},
		[16]={"",16,"推荐"},
		[17]={"",17,"LV.{0}"},
		[18]={"",18,"将军，请为您的部队取个名字："},
		[19]={"",19,"取消"},
		[20]={"",20,"确定"},
		[21]={"",21,"最多输入6个汉字"},
		[22]={"",22,"改名需要花费{0}金币，是否继续？"},
		[23]={"",23,"关卡信息"},
		[24]={"",24,"第{0}关  {1}"},
		[25]={"",25,"建议战斗力：{0}"},
		[26]={"",26,"我方战斗力：{0}"},
		[27]={"",27,"关卡产出："},
		[28]={"",28,"通关几率掉落"},
		[29]={"",29,"称号：{0}"},
		[30]={"",30,"更换头像"},
		[31]={"",31,"修改昵称"},
		[32]={"",32,"游戏设置"},
		[33]={"",33,"退出登录"},
		[34]={"",34,"服务条款"},
		[35]={"",35,"用户协议"},
		[36]={"",36,"隐私政策"},
		[37]={"",37,"公告"},
		[38]={"",38,"客服"},
		[39]={"",39,"游戏设置"},
		[40]={"",40,"声音"},
		[41]={"",41,"主音量"},
		[42]={"",42,"音效"},
		[43]={"",43,"偏好设定"},
		[44]={"",44,"画质"},
		[45]={"",45,"低"},
		[46]={"",46,"中"},
		[47]={"",47,"高"},
		[48]={"",48,"体力已满"},
		[49]={"",49,"动画欣赏"},
		[50]={"",50,"其他"},
		[51]={"",51,"{0}/{1}"},
		[52]={"",52,"战斗力：{0}"},
		[53]={"",53,"名将技能"},
		[54]={"",54,"武将{0}星开启"},
		[55]={"",55,"详细属性"},
		[56]={"",56,"技能"},
		[57]={"",57,"士兵"},
		[58]={"",58,"获取"},
		[59]={"",59,"武力：{0}"},
		[60]={"",60,"气血：{0}"},
		[61]={"",61,"体力：{0}"},
		[62]={"",62,"怒气：{0}"},
		[63]={"",63,"移动力：{0}"},
		[64]={"",64,"攻击距离：{0}"},
		[65]={"",65,"所属国家：{0}"},
		[66]={"",66,"简介"},
		[67]={"",67,"获取途径"},
		[68]={"",68,"前往"},
		[69]={"",69,"出战军团"},
		[70]={"",70,"即将出场"},
		[71]={"",71,"完成"},
		[72]={"",72,"战斗"},
		[73]={"",73,"布阵"},
		[74]={"",74,"名将"},
		[75]={"",75,"卡库"},
		[76]={"",76,"阵法"},
		[77]={"",77,"变阵"},
		[78]={"",78,"查看敌方"},
		[79]={"",79,"阵法描述：
{0}"},
		[80]={"",80,"点击空白处关闭界面"},
		[81]={"",81,"您暂时没有收到邮件"},
		[82]={"",82,"您暂时没有收到系统邮件"},
		[83]={"",83,"您暂时没有邮件领取日志"},
		[84]={"",84,"收件箱"},
		[85]={"",85,"系统收件箱"},
		[86]={"",86,"日志"},
		[87]={"",87,"一键领取"},
		[88]={"",88,"一键删除"},
		[89]={"",89,"来自：{0}"},
		[90]={"",90,"附件："},
		[91]={"",91,"排行榜"},
		[92]={"",92,"积分规则说明：
{0}"},
		[93]={"",93,"免费倒计时：{0}"},
		[94]={"",94,"折扣倒计时：{0}"},
		[95]={"",95,"免费"},
		[96]={"",96,"奖励一览"},
		[97]={"",97,"求一次"},
		[98]={"",98,"求十次"},
		[99]={"",99,"确定"},
		[100]={"",100,"取消"},
		[101]={"",101,"免费次数：{0}/{1}"},
		[102]={"",102,"奖励预览"},
		[103]={"",103,"名将展示"},
		[104]={"",104,"道具展示"},
		[105]={"",105,"充值"},
		[106]={"",106,"{0} 元宝"},
		[107]={"",107,"￥ {0}"},
		[108]={"",108,"购买"},
		[109]={"",109,"奖励说明：
首次购买任意奖励，均可获得双倍奖励"},
		[110]={"",110,"查看敌方"},
		[111]={"",111,"伤害"},
		[112]={"",112,"治疗"},
		[113]={"",113,"兵力"},
		[114]={"",114,"数据统计"},
		[115]={"",115,"  我方
击杀伤害"},
		[116]={"",116,"  敌方
击杀伤害"},
		[117]={"",117,"装备属性"},
		[118]={"",118,"产出关卡"},
		[119]={"",119,"其他产出方式"},
		[120]={"",120,"出售"},
		[121]={"",121,"卸下"},
		[122]={"",122,"穿戴"},
		[123]={"",123,"拥有{0}件"},
		[124]={"",124,"穿戴等级"},
		[125]={"",125,"洗练"},
		[126]={"",126,"武器列表"},
		[127]={"",127,"确认出售"},
		[128]={"",128,"单价：{0}铜币"},
		[129]={"",129,"数量："},
		[130]={"",130,"洗练"},
		[131]={"",131,"更换"},
		[1000]={"通用",1000,""},
		[1001]={"",1001,""},
		[1002]={"",1002,""},
		[1003]={"",1003,""},
		[1004]={"",1004,""},
		[1005]={"",1005,""},
		[1006]={"",1006,""},
		[1007]={"",1007,""},
		[1008]={"",1008,""},
		[1009]={"",1009,""},
		[1010]={"",1010,""},
		[1011]={"",1011,""},
		[1012]={"",1012,""},
		[1013]={"",1013,""},
		[1014]={"",1014,""},
		[1015]={"",1015,""},
		[1016]={"",1016,""},
		[1017]={"",1017,""},
		[1018]={"",1018,""},
		[1019]={"",1019,""},
		[1020]={"",1020,""},
		[1021]={"",1021,""},
		[1022]={"",1022,""},
		[1023]={"",1023,""},
		[1024]={"",1024,""},
		[1025]={"",1025,""},
		[1026]={"",1026,""},
		[1027]={"",1027,""},
		[1028]={"",1028,""},
		[1029]={"",1029,""},
		[1030]={"",1030,""},
		[1031]={"",1031,""},
		[1032]={"",1032,""},
		[1033]={"",1033,""},
		[1034]={"",1034,""},
		[1035]={"",1035,""},
		[1036]={"",1036,""},
		[1037]={"",1037,""},
		[1038]={"",1038,""},
		[1039]={"",1039,""},
		[1040]={"",1040,""},
		[1041]={"",1041,""},
		[1042]={"",1042,""},
		[1043]={"",1043,""},
		[1044]={"",1044,""},
		[1045]={"",1045,""},
		[1046]={"",1046,""},
		[1047]={"",1047,""},
		[1048]={"",1048,""},
		[1049]={"",1049,""},
		[1050]={"",1050,""},
		[2000]={"吕文川",2000,""},
		[2001]={"",2001,""},
		[2002]={"",2002,""},
		[2003]={"",2003,""},
		[2004]={"",2004,""},
		[2005]={"",2005,""},
		[2006]={"",2006,""},
		[2007]={"",2007,""},
		[2008]={"",2008,""},
		[2009]={"",2009,""},
		[2010]={"",2010,""},
		[2011]={"",2011,""},
		[2012]={"",2012,""},
		[2013]={"",2013,""},
		[2014]={"",2014,""},
		[2015]={"",2015,""},
		[2016]={"",2016,""},
		[2017]={"",2017,""},
		[2018]={"",2018,""},
		[2019]={"",2019,""},
		[2020]={"",2020,""},
		[2021]={"",2021,""},
		[2022]={"",2022,""},
		[2023]={"",2023,""},
		[2024]={"",2024,""},
		[2025]={"",2025,""},
		[2026]={"",2026,""},
		[2027]={"",2027,""},
		[2028]={"",2028,""},
		[2029]={"",2029,""},
		[2030]={"",2030,""},
		[2031]={"",2031,""},
		[2032]={"",2032,""},
		[2033]={"",2033,""},
		[2034]={"",2034,""},
		[2035]={"",2035,""},
		[2036]={"",2036,""},
		[2037]={"",2037,""},
		[2038]={"",2038,""},
		[2039]={"",2039,""},
		[2040]={"",2040,""},
		[2041]={"",2041,""},
		[2042]={"",2042,""},
		[2043]={"",2043,""},
		[2044]={"",2044,""},
		[2045]={"",2045,""},
		[2046]={"",2046,""},
		[2047]={"",2047,""},
		[2048]={"",2048,""},
		[2049]={"",2049,""},
		[2050]={"",2050,""},
		[3000]={"许超",3000,""},
		[3001]={"",3001,""},
		[3002]={"",3002,""},
		[3003]={"",3003,""},
		[3004]={"",3004,""},
		[3005]={"",3005,""},
		[3006]={"",3006,""},
		[3007]={"",3007,""},
		[3008]={"",3008,""},
		[3009]={"",3009,""},
		[3010]={"",3010,""},
		[3011]={"",3011,""},
		[3012]={"",3012,""},
		[3013]={"",3013,""},
		[3014]={"",3014,""},
		[3015]={"",3015,""},
		[3016]={"",3016,""},
		[3017]={"",3017,""},
		[3018]={"",3018,""},
		[3019]={"",3019,""},
		[3020]={"",3020,""},
		[3021]={"",3021,""},
		[3022]={"",3022,""},
		[3023]={"",3023,""},
		[3024]={"",3024,""},
		[3025]={"",3025,""},
		[3026]={"",3026,""},
		[3027]={"",3027,""},
		[3028]={"",3028,""},
		[3029]={"",3029,""},
		[3030]={"",3030,""},
		[3031]={"",3031,""},
		[3032]={"",3032,""},
		[3033]={"",3033,""},
		[3034]={"",3034,""},
		[3035]={"",3035,""},
		[3036]={"",3036,""},
		[3037]={"",3037,""},
		[3038]={"",3038,""},
		[3039]={"",3039,""},
		[3040]={"",3040,""},
		[3041]={"",3041,""},
		[3042]={"",3042,""},
		[3043]={"",3043,""},
		[3044]={"",3044,""},
		[3045]={"",3045,""},
		[3046]={"",3046,""},
		[3047]={"",3047,""},
		[3048]={"",3048,""},
		[3049]={"",3049,""},
		[3050]={"",3050,""},
		[4000]={"史峰",4000,""},
		[4001]={"",4001,""},
		[4002]={"",4002,""},
		[4003]={"",4003,""},
		[4004]={"",4004,""},
		[4005]={"",4005,""},
		[4006]={"",4006,""},
		[4007]={"",4007,""},
		[4008]={"",4008,""},
		[4009]={"",4009,""},
		[4010]={"",4010,""},
		[4011]={"",4011,""},
		[4012]={"",4012,""},
		[4013]={"",4013,""},
		[4014]={"",4014,""},
		[4015]={"",4015,""},
		[4016]={"",4016,""},
		[4017]={"",4017,""},
		[4018]={"",4018,""},
		[4019]={"",4019,""},
		[4020]={"",4020,""},
		[4021]={"",4021,""},
		[4022]={"",4022,""},
		[4023]={"",4023,""},
		[4024]={"",4024,""},
		[4025]={"",4025,""},
		[4026]={"",4026,""},
		[4027]={"",4027,""},
		[4028]={"",4028,""},
		[4029]={"",4029,""},
		[4030]={"",4030,""},
		[4031]={"",4031,""},
		[4032]={"",4032,""},
		[4033]={"",4033,""},
		[4034]={"",4034,""},
		[4035]={"",4035,""},
		[4036]={"",4036,""},
		[4037]={"",4037,""},
		[4038]={"",4038,""},
		[4039]={"",4039,""},
		[4040]={"",4040,""},
		[4041]={"",4041,""},
		[4042]={"",4042,""},
		[4043]={"",4043,""},
		[4044]={"",4044,""},
		[4045]={"",4045,""},
		[4046]={"",4046,""},
		[4047]={"",4047,""},
		[4048]={"",4048,""},
		[4049]={"",4049,""},
		[4050]={"",4050,""},
		[5000]={"贾申",5000,""},
		[5001]={"",5001,""},
		[5002]={"",5002,""},
		[5003]={"",5003,""},
		[5004]={"",5004,""},
		[5005]={"",5005,""},
		[5006]={"",5006,""},
		[5007]={"",5007,""},
		[5008]={"",5008,""},
		[5009]={"",5009,""},
		[5010]={"",5010,""},
		[5011]={"",5011,""},
		[5012]={"",5012,""},
		[5013]={"",5013,""},
		[5014]={"",5014,""},
		[5015]={"",5015,""},
		[5016]={"",5016,""},
		[5017]={"",5017,""},
		[5018]={"",5018,""},
		[5019]={"",5019,""},
		[5020]={"",5020,""},
		[5021]={"",5021,""},
		[5022]={"",5022,""},
		[5023]={"",5023,""},
		[5024]={"",5024,""},
		[5025]={"",5025,""},
		[5026]={"",5026,""},
		[5027]={"",5027,""},
		[5028]={"",5028,""},
		[5029]={"",5029,""},
		[5030]={"",5030,""},
		[5031]={"",5031,""},
		[5032]={"",5032,""},
		[5033]={"",5033,""},
		[5034]={"",5034,""},
		[5035]={"",5035,""},
		[5036]={"",5036,""},
		[5037]={"",5037,""},
		[5038]={"",5038,""},
		[5039]={"",5039,""},
		[5040]={"",5040,""},
		[5041]={"",5041,""},
		[5042]={"",5042,""},
		[5043]={"",5043,""},
		[5044]={"",5044,""},
		[5045]={"",5045,""},
		[5046]={"",5046,""},
		[5047]={"",5047,""},
		[5048]={"",5048,""},
		[5049]={"",5049,""},
		[5050]={"",5050,""},
		[6000]={"杨松涛",6000,""},
		[6001]={"",6001,""},
		[6002]={"",6002,""},
		[6003]={"",6003,""},
		[6004]={"",6004,""},
		[6005]={"",6005,""},
		[6006]={"",6006,""},
		[6007]={"",6007,""},
		[6008]={"",6008,""},
		[6009]={"",6009,""},
		[6010]={"",6010,""},
		[6011]={"",6011,""},
		[6012]={"",6012,""},
		[6013]={"",6013,""},
		[6014]={"",6014,""},
		[6015]={"",6015,""},
		[6016]={"",6016,""},
		[6017]={"",6017,""},
		[6018]={"",6018,""},
		[6019]={"",6019,""},
		[6020]={"",6020,""},
		[6021]={"",6021,""},
		[6022]={"",6022,""},
		[6023]={"",6023,""},
		[6024]={"",6024,""},
		[6025]={"",6025,""},
		[6026]={"",6026,""},
		[6027]={"",6027,""},
		[6028]={"",6028,""},
		[6029]={"",6029,""},
		[6030]={"",6030,""},
		[6031]={"",6031,""},
		[6032]={"",6032,""},
		[6033]={"",6033,""},
		[6034]={"",6034,""},
		[6035]={"",6035,""},
		[6036]={"",6036,""},
		[6037]={"",6037,""},
		[6038]={"",6038,""},
		[6039]={"",6039,""},
		[6040]={"",6040,""},
		[6041]={"",6041,""},
		[6042]={"",6042,""},
		[6043]={"",6043,""},
		[6044]={"",6044,""},
		[6045]={"",6045,""},
		[6046]={"",6046,""},
		[6047]={"",6047,""},
		[6048]={"",6048,""},
		[6049]={"",6049,""},
		[6050]={"",6050,""},
		[7000]={"",7000,""},
		[8000]={"",8000,""},
		[9000]={"",9000,""},
		[10000]={"繁体",10000,""},
		[20000]={"英文",20000,""},
		[30000]={"越南",30000,""},
	}
}
return data
