using UnityEngine;
using System.Collections;


//所有的循环Item都继承这个ItemObj
[System.Serializable]
public class ItemObj : MonoBehaviour
{

    public int dataIndex = -1;//数据的索引号

    public UIWidget m_widget;

}
