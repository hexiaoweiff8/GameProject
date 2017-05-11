local data ={
	info={key="ID",keytype=keytype.int},
	head={"ID","Type","Skin","Note","AtlasName","PackageName"},
	body={
		[1]={1,1,"h1","帝门传人","hero1Atlas","hero"},
		[2]={2,1,"h2","雪国圣女","hero1Atlas","hero"},
		[3]={3,3,"face_1","达到无尽之域第70关解锁","hero2Atlas","hero"},
		[4]={4,3,"face_2","达到vip1解锁","hero2Atlas","hero"},
		[5]={5,3,"face_3","荣登国家君主解锁","hero2Atlas","hero"},
		[6]={6,3,"face_4","竞技场前5名解锁","hero2Atlas","hero"},
		[7]={7,3,"face_5","王者竞技前5名解锁","hero2Atlas","hero"},
		[8]={8,3,"face_6","达到凛冬之征第10关解锁","hero2Atlas","hero"},
		[9]={9,3,"face_7","中秋节活动获得","hero2Atlas","hero"},
		[10]={10,2,"h14","吕布头像","hero1Atlas","hero"},
		[11]={11,2,"h21","张辽头像","hero1Atlas","hero"},
		[12]={12,2,"h22","赵云头像","hero1Atlas","hero"},
		[13]={13,2,"h17","太史慈头像","hero1Atlas","hero"},
		[14]={14,2,"h34","孟获头像","hero1Atlas","hero"},
		[15]={15,2,"h26","李典头像","hero1Atlas","hero"},
		[16]={16,2,"h27","庞德头像","hero1Atlas","hero"},
		[17]={17,2,"h29","夏侯惇头像","hero1Atlas","hero"},
		[18]={18,2,"h25","姜维头像","hero1Atlas","hero"},
		[19]={19,2,"h23","高顺头像","hero1Atlas","hero"},
		[20]={20,2,"h20","张飞头像","hero1Atlas","hero"},
		[21]={21,2,"h70","蒋钦头像","hero1Atlas","hero"},
		[22]={22,2,"h16","孙策头像","hero1Atlas","hero"},
		[23]={23,2,"h10","关羽头像","hero1Atlas","hero"},
		[24]={24,2,"h15","马超头像","hero1Atlas","hero"},
		[25]={25,2,"h31","许褚头像","hero1Atlas","hero"},
		[26]={26,2,"h4","马云禄头像","hero1Atlas","hero"},
		[27]={27,2,"h24","黄月英头像","hero1Atlas","hero"},
		[28]={28,2,"h13","黄忠头像","hero1Atlas","hero"},
		[29]={29,2,"h32","甄姬头像","hero1Atlas","hero"},
		[30]={30,2,"h6","大乔头像","hero1Atlas","hero"},
		[31]={31,2,"h28","孙尚香头像","hero1Atlas","hero"},
		[32]={32,2,"h30","夏侯渊头像","hero1Atlas","hero"},
		[33]={33,2,"h8","貂蝉头像","hero1Atlas","hero"},
		[34]={34,2,"h9","甘宁头像","hero1Atlas","hero"},
		[35]={35,2,"h5","蔡琰头像","hero1Atlas","hero"},
		[36]={36,2,"h11","华雄头像","hero1Atlas","hero"},
		[37]={37,2,"h12","黄盖头像","hero1Atlas","hero"},
		[38]={38,2,"h19","小乔头像","hero1Atlas","hero"},
		[39]={39,2,"h18","童渊头像","hero1Atlas","hero"},
		[40]={40,2,"h7","典韦头像","hero1Atlas","hero"},
		[41]={41,2,"h35","祝融头像","hero1Atlas","hero"},
		[42]={42,2,"h3","刑天头像","hero1Atlas","hero"},
		[43]={43,2,"h33","周泰头像","hero1Atlas","hero"},
		[44]={44,2,"h59","颜良头像","hero1Atlas","hero"},
		[45]={45,2,"h52","曹仁头像","hero1Atlas","hero"},
		[46]={46,2,"h72","步练师头像","hero1Atlas","hero"},
		[47]={47,2,"h62","徐晃头像","hero1Atlas","hero"},
		[48]={48,2,"h61","张郃头像","hero1Atlas","hero"},
		[49]={49,2,"h73","彭政闵头像","hero1Atlas","hero"},
		[50]={50,2,"h77","吕蒙头像","hero1Atlas","hero"},
		[51]={51,2,"h63","于禁头像","hero1Atlas","hero"},
		[52]={52,2,"h76","曹洪头像","hero1Atlas","hero"},
		[53]={53,2,"h74","马岱头像","hero1Atlas","hero"},
		[54]={54,2,"h78","韩当头像","hero1Atlas","hero"},
		[55]={55,2,"h55","管亥头像","hero1Atlas","hero"},
		[56]={56,2,"h79","左慈头像","hero1Atlas","hero"},
		[57]={57,2,"h75","廖化头像","hero1Atlas","hero"},
		[58]={58,2,"h60","文丑头像","hero1Atlas","hero"},
		[59]={59,2,"h64","魏延头像","hero1Atlas","hero"},
		[60]={60,2,"h80","关平头像","hero1Atlas","hero"},
		[61]={61,2,"h86","孙坚头像","hero2Atlas","hero"},
		[62]={62,2,"h87","曹彰头像","hero2Atlas","hero"},
		[63]={63,2,"h88","潘璋头像","hero2Atlas","hero"},
		[64]={64,2,"h92","文鸯头像","hero2Atlas","hero"},
		[65]={65,2,"h85","乐进头像","hero2Atlas","hero"},
		[66]={66,2,"h58","袁绍头像","hero1Atlas","hero"},
		[67]={67,2,"h49","曹操头像","hero1Atlas","hero"},
		[68]={68,2,"h48","刘备头像","hero1Atlas","hero"},
		[69]={69,2,"h50","孙权头像","hero1Atlas","hero"},
		[70]={70,2,"h96","吕玲绮头像","hero2Atlas","hero"},
		[71]={71,2,"h97","关凤头像","hero2Atlas","hero"},
		[72]={72,2,"h98","张星彩头像","hero2Atlas","hero"},
		[73]={73,2,"h47","张角头像","hero1Atlas","hero"},
		[74]={74,2,"h46","张梁头像","hero1Atlas","hero"},
		[75]={75,3,"face_8","跨海战第一赛季冠军头像","hero2Atlas","hero"},
		[76]={76,3,"face_9","跨海战第一赛季亚军头像","hero2Atlas","hero"},
		[77]={77,3,"face_10","跨海战第一赛纪念头像","hero2Atlas","hero"},
		[78]={78,2,"h103","夏侯霸头像","hero1Atlas","hero"},
		[79]={79,3,"face_11","万圣节活动获得","hero2Atlas","hero"},
		[80]={80,3,"face_12","2015第二赛季冠军头像","hero2Atlas","hero"},
		[81]={81,3,"face_13","2015第二赛季亚军头像","hero2Atlas","hero"},
		[82]={82,3,"face_14","2015第二赛季季军头像","hero2Atlas","hero"},
		[83]={83,3,"face_15","2015第二赛季纪念头像","hero2Atlas","hero"},
		[84]={84,3,"face_16","圣诞节头像","hero2Atlas","hero"},
		[85]={85,3,"face_17","猴年头像","hero2Atlas","hero"},
		[86]={86,3,"face_18","春节纪念头像","hero2Atlas","hero"},
		[87]={87,3,"face_19","卧龙诸葛","hero2Atlas","hero"},
		[88]={88,3,"face_20","冢虎司马","hero2Atlas","hero"},
		[89]={89,3,"face_21","江东都督","hero2Atlas","hero"},
	}
}
return data
