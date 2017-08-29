//----------------------------------------------
//        NGUI: UIPopupList扩展工具
//  在popup控件弹出列表中逐项添加图标和删除按钮
//  使用对应操作时执行注册回调方法与外部数据逻辑交互
//----------------------------------------------
using System;
using System.Reflection;
using UnityEngine;

[RequireComponent(typeof(UIPopupList))]
public class UIPopupListExtended : MonoBehaviour
{
    private UIPopupList popuplist;
    private UIAtlas atlas;

    public delegate void OnDeleteItem(string item);
    /// <summary>
    /// 点击删除按钮时触发回调
    /// </summary>
    public OnDeleteItem HandleOnDeleteItem;
    public delegate void OnLoadIcon(string item,UISprite sprite);
    /// <summary>
    /// 加载item图标时触发回调
    /// </summary>
    /// <param name="item">item标识符</param>
    /// <param name="sprite">精灵</param>
    public OnLoadIcon HandleOnLoadIcon;

    void Start()
    {
        popuplist = GetComponent<UIPopupList>();
        //图集使用界面精灵的图集
        atlas = GetComponent<UISprite>().atlas;
    }
    void OnClick()
    {
        GameObject obj = GetItemChildren(popuplist, "mChild") as GameObject;
        if (obj != null)
        {
            UILabel[] labels = obj.GetComponentsInChildren<UILabel>();
            addDelButton(labels);
            addIcon(labels);
        }
    }
    //反射获取popuplist组件中非公有静态字段mChild下拉选项中所有的孩子UILabel
    private object GetItemChildren(object obj, string name)
    {
        Type type = obj.GetType();
        FieldInfo fieldinfo = type.GetField(name, BindingFlags.Static | BindingFlags.NonPublic);
        return fieldinfo.GetValue(obj);
    }
    //为每一个选项添加删除按钮
    private void addDelButton(UILabel[] labels)
    {
        float f = -0.038f;
        foreach (UILabel label in labels)
        {
            f = f - 0.01f;
            UISprite sprite = NGUITools.AddSprite(label.gameObject, atlas, "tongyong_anniu_cha");
            sprite.depth = label.depth + 1;
            sprite.transform.localScale = new Vector3(0.25f, 0.25f, 0);
            sprite.transform.localPosition = new Vector3(415, -13.32f, 0);
            BoxCollider collider = sprite.gameObject.AddComponent<BoxCollider>();
            collider.size = sprite.localSize;
            UIEventListener listener = sprite.gameObject.AddComponent<UIEventListener>();
            listener.onPress += (a, b) =>
            {
                UILabel current = a.GetComponentInParent<UILabel>();
                DeleteItems(current.text);
            };
        }
    }
    //为每一个选项添加指示图标
    private void addIcon(UILabel[] labels)
    {
        float f = -0.038f;
        foreach (UILabel label in labels)
        {
            f = f - 0.01f;
            UISprite sprite = NGUITools.AddSprite(label.gameObject, atlas, "Emoticon - Annoyed");
            sprite.depth = label.depth + 1;
            sprite.transform.localScale = new Vector3(0.25f, 0.25f, 0);
            sprite.transform.localPosition = new Vector3(15, -13.32f, 0);
            HandleOnLoadIcon(label.text,sprite);
            sprite.MakePixelPerfect();
        }
    }
    //删除选项
    private void DeleteItems(string username)
    {
        HandleOnDeleteItem(username);
        popuplist.items.Remove(username);
        if (popuplist.items.Count == 0)
            popuplist.value = "";
        else popuplist.value = popuplist.items[0];
    }
}
