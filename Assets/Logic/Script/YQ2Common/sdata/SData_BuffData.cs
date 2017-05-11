using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public enum XGICO
{
    NONE = 0,
    a_wl = 1000,//增加武力 
    a_tl = 1001,//增加体力 
    a_fyl = 1002,//增加防御? 
    a_nu = 1003,//增加怒 
    a_bsjgl = 1004,//增加必杀技使用几? 
    a_speed = 1005,//增加移动速度 

    av_wl = 1006,//百分比方式增加武力 
    av_tl = 1007,//百分比方式增加体力 
    av_fyl = 1008,//百分比方式增加防御? 
    av_nu = 1009,//百分比方式增加怒 
    av_bsjgl = 1010,//百分比方式增加必杀技使用几? 
    av_speed = 1011,//百分比方式增加移动速度 

    d_wl = 1012,//减少武力 
    d_tl = 1013,//减少体力 
    d_fyl = 1014,//减少防御? 
    d_nu = 1015,//减少怒 
    d_bsjgl = 1016,//减少必杀技使用几? 
    d_speed = 1017,//减少移动速度 

    dv_wl = 1018,//百分比方式减少武力 
    dv_tl = 1019,//百分比方式减少体力 
    dv_fyl = 1020,//百分比方式减少防御? 
    dv_nu = 1,//百分比方式减少怒 
    dv_bsjgl = 1021,//百分比方式减少必杀技使用几? 
    dv_speed = 1022,//百分比方式减少移动速度 

    a_hp = 1023,
    av_hp = 1024,
    d_hp = 1025,
    dv_hp = 1026,

    tx_dingsheng = 2,//定身 
    tx_zhongdu = 4,//中毒 
    tx_yun = 3,//昏迷 
    tx_Fengji = 5,//封技 
    tx_MissFengji = 6,//免疫封 
    tx_MissDingshen = 7,//免疫定身 
    tx_MissYun = 8,//免疫晕 
    tx_MissZhongdu = 9,//免中毒 
    tx_MissZhuangtai = 10,//免一切负面 
    tx_ShuaXin = 11,//立即刷新手动技状态 

    tx_AddHPFZ = 12,//加hp反转 
    tx_HitFZ = 13,//攻击反转 
    //tx_HitFZ_Miss=14,//攻击反转免疫 
    tx_WD = 15,//无敌 
    tx_ArmyWD = 16,//士兵无敌 
    tx_WD_Meng = 17,//猛无敌 
    tx_WD_Yong = 18,//勇无敌 
    tx_WD_Gong = 19,//弓无敌 
    tx_XiXue = 20,//吸血 
    tx_MissAddHPFZ = 21,//免疫反转 
    tx_MengHitFZ = 22,
    tx_YongHitFZ = 23,
    tx_GongHitFZ = 24,
    tx_FT_Wei = 25,
    tx_FT_Shu = 26,
    tx_FT_Wu = 27,
    tx_FT_Qx = 28,
    tx_FT_Man = 29,
    tx_FT_Woman = 30,
    tx_FT_LuUp = 31,
    tx_FT_LuMid = 32,
    tx_FT_LuDown = 33,
    tx_FT_Lun1 = 34,
    tx_FT_Lun2 = 35,
    tx_FT_Lun3 = 36,
    tx_WD_Wei = 37,
    tx_WD_Shu = 38,
    tx_WD_Wu = 39,
    tx_WD_Qx = 40,
    tx_WD_Man = 41,
    tx_WD_Woman = 42,
    tx_WD_LuUp = 43,
    tx_WD_LuMid = 44,
    tx_WD_LuDown = 45,
    tx_WD_Lun1 = 46,
    tx_WD_Lun2 = 47,
    tx_WD_Lun3 = 48,
    tx_WD_ArmyMissMS = 49,
    tx_ADDCD = 50,
    tx_UPBSQZ = 51,
}; 

public class SData_BuffData
{
    public SData_BuffData()
    { 
        Single = this;
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 BuffData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "BuffData");
            
           short IID = reader.ColumnName2Index("ID");
           short Ixgs = reader.ColumnName2Index("xgs");


            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                short id = reader.GetI16(IID,row);
                string xgs = reader.GetS(Ixgs, row);
                string[] xgsArrar = xgs.Split(';');
                int len = xgsArrar.Length;
                int[] xgidList = new int[len];
                for (int i = 0; i < len; i++)
                    xgidList[i] = int.Parse(xgsArrar[i]);

                Data.Add(id, xgidList);
            }
        }
    }

    public int[] Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }
     

    Dictionary<int, int[]> Data = new Dictionary<int, int[]>();
    public static SData_BuffData Single;
}