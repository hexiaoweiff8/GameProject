using UnityEngine;
using System.Collections;


public class UI_Equip_Item : UIScrollViewItemBase {

    public int _EquipID;

    #region SpriteName
    private const string EQUIPPED = "cangku_tubiao_yizhuangbei";
    private const string LOCKED = "cangku_tubiao_zhuangbeisuoding";
    #endregion

    public UISprite sIcon;//显示在列表中的Item的Icon
    public UISprite sIconFrame;//列表项边框，用于表现道具/装备的'品质'
    public UISprite sIconSelectFrame;//列表项选择框，用于表示Item是否被选中

    public UILabel tEquipmentLevel;//装备等级
    public UISprite sEquipped;//已装备标记
    public UISprite sLocked;//装备锁定标记

    private GameObject _cEquipment;//装备样式
    public GameObject cEquipment
    {
        get { return _cEquipment; }
        set
        {
            _cEquipment = value;
            sIcon = _cEquipment.transform.parent.GetChild(0).GetComponent<UISprite>();
            sIconFrame = _cEquipment.transform.parent.GetChild(1).GetComponent<UISprite>();
            sIconSelectFrame = _cEquipment.transform.parent.GetChild(2).GetComponent<UISprite>();

            tEquipmentLevel = _cEquipment.transform.GetChild(0).GetChild(0).GetComponent<UILabel>();
            sEquipped = _cEquipment.transform.GetChild(1).GetComponent<UISprite>();
            sLocked = _cEquipment.transform.GetChild(2).GetComponent<UISprite>();
        }
    }

    public void setIcon(string spriteName)
    {
        sIcon.spriteName = spriteName;
    }
    public void setIcon(UIAtlas atlas, string spriteName)
    {
        if (atlas != null)
            sIcon.atlas = atlas;
        sIcon.spriteName = spriteName;
    }

    public void setIconFrame(string spriteName)
    {
        sIconFrame.spriteName = spriteName;
    }
    public void setIconFrame(UIAtlas atlas, string spriteName)
    {
        if (atlas != null)
            sIconFrame.atlas = atlas;

        sIconFrame.spriteName = spriteName;
    }
    public void setIconSelectFrame(string spriteName)
    {
        if (sIconSelectFrame.atlas == null)
            sIconSelectFrame.atlas = sIconFrame.atlas;
        sIconSelectFrame.spriteName = spriteName;
    }

    public void setEquipmentLevel(int level)
    {
        _cEquipment.SetActive(true);
        tEquipmentLevel.text = level.ToString();
    }
    public void setEquipped(bool Equipped)
    {
        _cEquipment.SetActive(true );
        if (Equipped)
            sEquipped.spriteName = UI_Equip_Item.EQUIPPED;
        else sEquipped.spriteName = null;
    }
    public void setEquipmentLock(bool Locked)
    {
        _cEquipment.SetActive(true);
        if (Locked)
            sLocked.spriteName = UI_Equip_Item.LOCKED;
        else sLocked.spriteName = null;
    }

    public void setEmpty()
    {
        sIconSelectFrame.spriteName = "null";
        sIcon.spriteName = "null";
        sIconFrame.spriteName = "null";
        _cEquipment.SetActive(false);
    }

}
