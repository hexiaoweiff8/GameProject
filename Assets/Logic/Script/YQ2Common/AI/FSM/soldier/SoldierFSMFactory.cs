using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SoldierFSMFactory
{
    public static void GetTrigger(SoldierTriggerID stateName, List<SoldierFSMTrigger> _fsmTrriggerList)
    {
        switch(stateName){
            case SoldierTriggerID.RuChang:
                {
                    var xingjin = new XingjinTrigger();
                    _fsmTrriggerList.Add(xingjin);
                    break;
                }
            case SoldierTriggerID.Xingjin:
                {
                    var zhunbeizhandou = new ZhunbeizhandouTrigger();
                    _fsmTrriggerList.Add(zhunbeizhandou);
                    var zhuiji = new ZhuiJiTrigger();
                    _fsmTrriggerList.Add(zhuiji);
                    break;
                }
            case SoldierTriggerID.Zhunbeizhandou:
                {
                    var putong = new PutongGongjiTrigger();
                    _fsmTrriggerList.Add(putong);
                    var jineng = new JinengGongjiTrigger();
                    _fsmTrriggerList.Add(jineng);
                    var zhuiji = new ZhuiJiTrigger();
                    _fsmTrriggerList.Add(zhuiji);
                    break;
                }
            case SoldierTriggerID.SiWang:
                {
                    return;
                }
            case SoldierTriggerID.PutongGongji:
                {
                    var putongToXingjin = new XingjinTrigger();
                    _fsmTrriggerList.Add(putongToXingjin);
                    var zhuiji = new ZhuiJiTrigger();
                    _fsmTrriggerList.Add(zhuiji);
                    //var putongToJineng = new JinengGongjiTrigger();
                    //_fsmTrriggerList.Add(putongToJineng);
                    //var putongToZhunbeizhandou = new ZhunbeizhandouTrigger();
                    //_fsmTrriggerList.Add(putongToZhunbeizhandou);
                }
                break;
            case SoldierTriggerID.JinengGongji:
                {
                    var jinengToXingjin = new XingjinTrigger();
                    _fsmTrriggerList.Add(jinengToXingjin);
                    //var jinengToPutong = new PutongGongjiTrigger();
                    //_fsmTrriggerList.Add(jinengToPutong);
                    //var jinengGongjiToZhunbeizhandou = new ZhunbeizhandouTrigger();
                    //_fsmTrriggerList.Add(jinengGongjiToZhunbeizhandou);
                    break;
                }
            case SoldierTriggerID.ZhuiJi:
                {
                    var zhuijiToXingjin = new XingjinTrigger();
                    _fsmTrriggerList.Add(zhuijiToXingjin);
                    var putong = new PutongGongjiTrigger();
                    _fsmTrriggerList.Add(putong);
                    var jineng = new JinengGongjiTrigger();
                    _fsmTrriggerList.Add(jineng);
                    break;
                }
        }
        //除死亡状态以外的任何状态都可以切死亡
        var siwang = new SiwangTrigger();
        _fsmTrriggerList.Add(siwang);
    }

    public static SoldierStateID GetStateIDByTrigger(SoldierTriggerID id)
    {
        switch (id)
        {
            case SoldierTriggerID.Xingjin:
                return SoldierStateID.Xingjin;
            case SoldierTriggerID.Zhunbeizhandou:
                return SoldierStateID.Zhunbeizhandou;
            case SoldierTriggerID.PutongGongji:
                return SoldierStateID.PutongGongji;
            case SoldierTriggerID.JinengGongji:
                return SoldierStateID.JinengGongji;
            case SoldierTriggerID.SiWang:
                return SoldierStateID.SiWang;
            case SoldierTriggerID.ZhuiJi:
                return SoldierStateID.ZhuiJi;
        }
        return SoldierStateID.NullState;
    }
}
