using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


public class GameObjectExtensionRecall : MonoBehaviour
{
    public void OnFadeHideEnd()
    {
        gameObject.SetActive(false);
    }
}


public static class GameObjectExtension
{


    public static void EnableCollider(this GameObject obj, bool enable)
    {
        //获得物体上的所有碰检盒
        Collider[] solliderList = obj.GetComponentsInChildren<Collider>(true);
        foreach (Collider curr in solliderList) curr.enabled = enable;
    }

    public static void EnableComponent<T>(this GameObject obj, bool enable)
        where T : Behaviour
    {
        Behaviour[] cmList = obj.GetComponentsInChildren<T>(true);
        foreach (Behaviour curr in cmList) curr.enabled = enable;
    }


    public static void RemoveComponents(this GameObject obj, Type type)
    {
        Component[] cms = obj.GetComponents(type);

        foreach (Component curr in cms)
        {
            GameObject.Destroy(curr);
        }
    }

    public static T AutoInstance<T>(this GameObject gameObj) where T : Component
    {
        T cm = gameObj.GetComponent<T>();
        if (cm == null) cm = gameObj.AddComponent<T>();
        return cm;
    }


    public static Transform FindChild(Transform obj, string[] name_path)
    {
        string lastName = name_path[name_path.Length - 1];

        int count = obj.childCount;
        for (int i = 0; i < count; i++)
        {
            Transform tf = obj.GetChild(i);
            if (tf.gameObject.name == lastName)//初步判定ok
            {
                bool isCmpOK = true;
                Transform parentTransform = tf.gameObject.transform.parent;
                for (int p = name_path.Length - 2; p >= 0; p--)
                {
                    if (parentTransform == null) { isCmpOK = false; break; }

                    if (parentTransform.gameObject.name != name_path[p]) { isCmpOK = false; break; }

                    parentTransform = parentTransform.parent;
                }

                if (isCmpOK) return tf;
            }

            tf = FindChild(tf, name_path);
            if (tf != null) return tf;
        }
        return null;
    }

    public static Transform FindChild(Transform obj, string objName)
    {
        string[] name_path = objName.Split('/');
        return FindChild(obj, name_path);
    }


    public static GameObject InstantiateFromPreobj(UnityEngine.Object preObj, GameObject parent)
    {
        GameObject gameObject = GameObject.Instantiate((UnityEngine.Object)preObj) as GameObject;
        Transform transform = gameObject.transform;
        Vector3 oldScale = transform.localScale;
        Vector3 oldPos = transform.localPosition;
        Quaternion oldQ = transform.localRotation;
        if (parent != null)
        {
            transform.parent = parent.transform;
        }

        transform.localScale = oldScale;
        transform.localPosition = oldPos;
        transform.localRotation = oldQ;

        return gameObject;
    }

    public static GameObject InstantiateFromPacket(string packName, string preObjName, GameObject parent)
    {
        PacketRouting corePack = PacketManage.Single.GetPacket(packName);
        if (corePack == null)
        {
            Debug.LogError(string.Format("_InstantiateFromPacket 包尚未就绪:{0}", packName));
        }

        UnityEngine.Object preObj = corePack.Load(preObjName);
        if (preObj == null)
            Debug.LogError(String.Format("实例化对象错误， packet:{0} preObjName:{1}", packName, preObjName));

        return InstantiateFromPreobj(preObj, parent);
    }



    //public static INGui NGui = null;

}
