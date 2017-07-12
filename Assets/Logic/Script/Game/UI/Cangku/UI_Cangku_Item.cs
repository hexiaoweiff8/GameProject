using UnityEngine;

public class UI_Cangku_Item : UIScrollViewItemBase
{
    public int _ItemID;//对应道具的ID
    public int _EquipID;//对应装备的ID
    //   public int _UseType;

    //   public string _RelationID;
    //   public string _Name;
    //   public string _Des;
    //   public string _FunctionDes;
    //   public string _Icon;
    //   public string _AvatarMode;

    //   public int _Quality;
    //   public int _OverlapUse;
    //   public int _OverlapLimit;
    //   public int _SaleGold;
    //   public int _ComposeNum;
    //   public int _SelfUse;


    public UISprite sIcon;//显示在列表中的Item的Icon
    public UISprite sIconLayer;//Item品质底图
    public UISprite sIconFrame;//列表项边框，用于表现道具/装备的'品质'
    public UISprite sIconSelectFrame;//列表项选择框，用于表示Item是否被选中

    public UISprite sCompositeMark;//可合成标记
    public UISprite sSelected;//被选中标记
    public UILabel tItemCount;//数量

    public UILabel tEquipmentLevel;//装备等级
    public UISprite sEquipped;//已装备标记
    public UISprite sLocked;//装备锁定标记

    private GameObject _cItem;//道具样式
    private GameObject _cEquipment;//装备样式
    /// <summary>
    /// 根据prefab定义，自动确定子组件
    /// </summary>
    public GameObject cItem {
        get { return _cItem; }
        set {
            _cItem = value;

            sIcon = _cItem.transform.parent.GetChild(0).GetComponent<UISprite>();
            sIconLayer = _cItem.transform.parent.GetChild(1).GetComponent<UISprite>();
            sIconFrame = _cItem.transform.parent.GetChild(2).GetComponent<UISprite>();
            sIconSelectFrame = _cItem.transform.parent.GetChild(3).GetComponent<UISprite>();

            sCompositeMark = _cItem.transform.GetChild(0).GetComponent<UISprite>();
            tItemCount = _cItem.transform.GetChild(1).GetComponent<UILabel>();
        }
    }
    public GameObject cEquipment
    {
        get { return _cEquipment; }
        set
        {
            _cEquipment = value;
            tEquipmentLevel = _cEquipment.transform.GetChild(0).GetChild(0).GetComponent<UILabel>();
            sEquipped = _cEquipment.transform.GetChild(1).GetComponent<UISprite>();
            sLocked = _cEquipment.transform.GetChild(2).GetComponent<UISprite>();
            sSelected = _cEquipment.transform.GetChild(3).GetComponent<UISprite>();
        }
    }

    #region SpriteName
    private const string KE_PIN_HE_SUI_PIAN = "cangku_tubiao_suipian_kehecheng";
    private const string BU_KE_PIN_HE_SUI_PIAN = "cangku_tubiao_suipian_bukehecheng";

    private const string SELECTED = "cangku_tubiao_gou";
    private const string SELECTED_ITEM = "zhuangbei_zhuangbeikuang_xuanzhong";

    private const string EQUIPPED = "cangku_tubiao_yizhuangbei";
    private const string LOCKED = "cangku_tubiao_zhuangbeisuoding";
    #endregion

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
    public void setIconLayer(string spriteName)
    {
        sIconLayer.spriteName = spriteName;
    }
    public void setIconLayer(UIAtlas atlas, string spriteName)
    {
        if (atlas != null)
            sIconLayer.atlas = atlas;
        sIconLayer.spriteName = spriteName;
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

    public void setCompositeMark(bool show,bool KePinHe)
    {
        if (!show)
        {
            sCompositeMark.spriteName = null;
        }
        else
        {
            if (KePinHe)
                sCompositeMark.spriteName = UI_Cangku_Item.KE_PIN_HE_SUI_PIAN;
            else sCompositeMark.spriteName = UI_Cangku_Item.BU_KE_PIN_HE_SUI_PIAN;
        }
            
    }
    public void setItemSelect(bool selected)
    {
        if (selected)
            sSelected.spriteName = UI_Cangku_Item.SELECTED;
        else sSelected.spriteName = null;
    }
    public void setItemCount(int count)
    {
        if (!tItemCount.gameObject.activeInHierarchy)
            tItemCount.gameObject.SetActive(false);
        tItemCount.text = "x"+count.ToString();
    }
    /// <summary>
    /// 当可堆叠属性为1时，需要调用此函数，不显示Count组件
    /// </summary>
    /// <param name="shouldBeHide"></param>
    public void setItemCountHide(bool shouldBeHide)
    {
        tItemCount.gameObject.SetActive(shouldBeHide ? false : true);
    }

    public void setEquipmentLevel(int level)
    {
        tEquipmentLevel.text = level.ToString();
    }
    public void setEquipped(bool Equipped)
    {
        if (Equipped)
            sEquipped.spriteName = UI_Cangku_Item.EQUIPPED;
        else sEquipped.spriteName = null;
    }
    public void setEquipmentLock(bool Locked)
    {
        if (Locked)
            sLocked.spriteName = UI_Cangku_Item.LOCKED;
        else sLocked.spriteName = null;
    }

}
