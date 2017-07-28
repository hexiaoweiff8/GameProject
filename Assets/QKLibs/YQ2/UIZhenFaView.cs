using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UIZhenFaView : MonoBehaviour {

    public GameObject HeroTemplate = null;
    public GameObject ArmyTemplate = null;
    public GameObject Constrict = null;

    public int xOffset = 0;
    public int yOffset = 0;


    private short ZhenFaID = 0;//阵法ID
    private float Magnification = 0;   //放大倍数

    private List<GameObject> HeroList = new List<GameObject>();
    private List<GameObject> ArmyList = new List<GameObject>();
 
    void Start()
    {
        //在界面编辑的时候，是无法读取SData_Zhenfa的，所以不执行
        //if (SData_Zhenfa.Single != null)
        UpdateUI();
        //ResetZhenFa(ZhenFaID);
    } 
    void ClearUI() 
    {
        for (int nIndex = 0; nIndex < HeroList.Count; nIndex++)
        {
            GameObject.Destroy(HeroList[nIndex]);
        }
        HeroList.Clear();
        for (int nIndex = 0; nIndex < ArmyList.Count; nIndex++)
        {
            GameObject.Destroy(ArmyList[nIndex]);
        }
        ArmyList.Clear();
    }
    void AutoScale()
    {
        //UIWidget ConstrictTemp = HeroTemplate.transform.parent.GetComponent<UIWidget>();
        UIWidget ConstrictTemp = Constrict.GetComponent<UIWidget>();


        var zfInfo = SData_Zhenfa.Single.Get(ZhenFaID);
        if (zfInfo == null) zfInfo = SData_Zhenfa.Single.Get(1);//当无法获得阵的时候，用1号阵，防止崩溃
        int xCenter = 23;
        int yCenter = 41;

        int MaxX = -99999;
        int MinX = 99999;
        int MaxZ = -99999;
        int MinZ = 99999;
        
        int nCount = 0;
        int ResutleX = MaxX - MinX;
        int ResutleZ = MaxZ - MinZ;

        float fx = (float)ConstrictTemp.width / ResutleX;
        float fz = (float)ConstrictTemp.height / ResutleZ;
        Magnification = fz < fx ? fz : fx;
    }
    public void ResetZhenFa(short _ID = -1)
    {
        if (_ID == -1)
        { }
        else
            ZhenFaID = _ID;
            
        UpdateUI();
    }
    public void SetTemplate(GameObject _HeroT,GameObject _ArmyT)
    {
        ArmyTemplate = _ArmyT;
        HeroTemplate = _HeroT;
        //HeroTemplate = _ArmyT;
        //HeroTemplate.transform.localScale = _ArmyT.transform.localScale * 1.2f;
    }

   
    Vector3 CalculateUnitPoint(UnitsInfo unit)
    {
        const int xCenter = 3;//23;
        const int yCenter =61;//41;


        float x,z;
        DiamondGridMap.Grid2World(SData_mapdata.Single.GetDataOfID(1).MapMaxRow + DiamondGridMap.SideSize * 2, unit.x, unit.z, out   x, out   z);
        if (unit.indent) x += SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang * DiamondGridMap.wxs / 2f;

        x /= DiamondGridMap.VerticalSpacingFactor;
        z /= DiamondGridMap.VerticalSpacingFactor;

        x -= xCenter;
        z -=yCenter;

        return new Vector3(x * Magnification - xOffset, z * Magnification - yOffset + Magnification, 0);
    }
    FightFormation GetFightFormationByIndex(Dictionary<byte, FightFormation> formations, int _Index)
    {
        foreach (var tempFF in formations)
        {
            if (tempFF.Value.id == _Index)
                return tempFF.Value;
        }
        return null;
    }
    void UpdateUI()
    {
        AutoScale();
        var zfInfo = SData_Zhenfa.Single.Get(ZhenFaID);
        if (zfInfo == null) zfInfo = SData_Zhenfa.Single.Get(1);//当无法获得阵的时候，用1号阵，防止崩溃
       
        TacticalDeployment tempZhenFa = zfInfo.ZhenInfo; //SData_TacticalDeployment.Single.Get(zfInfo.ZhenfaBuzhi);
        int nCount = 0;
        int nHeroCount = 0;
        for (int nLoop = 1; nLoop <= tempZhenFa.formations.Count; nLoop++)
        {
            FightFormation temp = GetFightFormationByIndex(tempZhenFa.formations, nLoop);
            if (ArmyTemplate != null)
            {
                for (int nIndex = 1; nIndex < temp.units.Length; nIndex++)
                {
                    UnitsInfo tempI = temp.units[nIndex];

                    if (ArmyList.Count <= nCount)
                    {
                        ArmyList.Add(GameObject.Instantiate<GameObject>(ArmyTemplate));
                    }

                    GameObject tempImage = ArmyList[nCount];

                    UIWidget tempwid = tempImage.GetComponent<UIWidget>();
                    tempwid.width = (int)Magnification;
                    tempwid.height = (int)Magnification;

                    tempImage.SetActive(true);
                    tempImage.transform.parent = ArmyTemplate.transform.parent;
                    tempImage.transform.localScale = Vector3.one;

                    tempImage.transform.localPosition = CalculateUnitPoint(tempI);
                    nCount++;
                }
            }
            if (HeroTemplate != null)
            {
                UnitsInfo tempH = temp.units[0];

                if (HeroList.Count <= nHeroCount)
                {
                    GameObject TempHero = GameObject.Instantiate<GameObject>(HeroTemplate);
                    TempHero.transform.parent = HeroTemplate.transform.parent;
                    TempHero.transform.localEulerAngles = HeroTemplate.transform.localEulerAngles;
                    HeroList.Add(TempHero);
                }
                GameObject tempImage = HeroList[nHeroCount];
                int HeroName = temp.id;// nHeroCount + 1;

                tempImage.name = "pic_zw" + HeroName.ToString();
                tempImage.SetActive(true);

                tempImage.transform.localScale = Vector3.one;

                tempImage.transform.localPosition = CalculateUnitPoint(tempH);
                nHeroCount++;
            }
        }
    }
    public void SetSize(int _Magnification, int _Xoffset, int _Yoffset)
    {
        Magnification = _Magnification;
        xOffset = _Xoffset;
        yOffset = _Yoffset;
    }

    public GameObject GetObj(string ObjName)
    {
        return GameObject.Find(ObjName);
    }
}
