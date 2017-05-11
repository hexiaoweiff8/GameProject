using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using UnityEngine;
public class MFAModelManage
{
    public static MFAModelManage Single
    {
        get
        {
            if (_Single == null) _Single = new MFAModelManage();
            return _Single;
        }
    }
    static MFAModelManage _Single = null;

    public Material GetMaterial(Shader shader, Texture texture
        //, Color flagColor
        )
    {
        /*
        if (!m_Mats.ContainsKey(shader))
            return NewMat(shader, texture, flagColor);

        Dictionary<Texture, Dictionary<Color, Material> > k2 = m_Mats[shader];
        if(!k2.ContainsKey(texture))
            return NewMat(shader, texture, flagColor);

        Dictionary<Color, Material> k3 = k2[texture];
        if (!k3.ContainsKey(flagColor))
            */
            return NewMat(shader, texture
                //, flagColor
                );

        //return k3[flagColor];
    }

    Material NewMat(
        Shader shader, Texture texture
        //, Color flagColor
        )
    {
        /*
        if (!m_Mats.ContainsKey(shader))
            m_Mats.Add(shader, new Dictionary<Texture, Dictionary<Color, Material>>());

        Dictionary<Texture, Dictionary<Color, Material>> k2 = m_Mats[shader];
        if (!k2.ContainsKey(texture))
            k2.Add(texture, new Dictionary<Color, Material>());
        */
        Material n = new Material(shader); 
        n.mainTexture = texture;
        //n.SetColor("_FlagColor", flagColor);
        //m_Mats[shader][texture].Add(flagColor, n);
        return n;
    }

    //Dictionary<Shader, Dictionary<Texture, Dictionary<Color, Material>>> m_Mats = new Dictionary<Shader, Dictionary<Texture, Dictionary<Color, Material>>>();
   
    public MFAModel GetModel(string packName,string modelName)
    {
        /*
        if (!m_Models.ContainsKey(packName))
        {
            //装载包
            if (!m_NeedLoadPacks.Contains(packName))
            {
                m_NeedLoadPacks.Add(packName);
                AutoStartLoadCo();
            }
            return null;
        }*/
        if(!m_Models.ContainsKey(packName))
        {
            m_Models.Add(packName, new Dictionary<string, MFAModel>());
            ResourceRefManage.Single.AddRef(packName);
        }

         Dictionary<string, MFAModel> models = m_Models[packName];
        if(!models.ContainsKey(modelName))
        {
            PacketRouting pack = PacketManage.Single.GetPacket(packName);
            if (pack == null) 
                Debug.LogError(string.Format("YQ2ModelManage 无法装载包 {0}", packName));
            byte[] modelData = pack.LoadBytes(modelName+".bytes");

            if (modelData == null)
                return null;

            MFAModel new_model = new MFAModel();
            using (MemoryStream stream = new MemoryStream(modelData))
            {
                new_model.Deserialize(stream);
            }
            //YQ2Model new_model = new YQ2Model( pack.Load(modelName) as GameObject);
            models.Add(modelName,new_model);
            return new_model;
        }
        return models[modelName];
    }
    /*
    public void LoadPack(List<string> packNames)
    {
        foreach(string pkName in packNames)
        {
            if (!m_NeedLoadPacks.Contains(pkName))
                m_NeedLoadPacks.Add(pkName);
        }
        AutoStartLoadCo();
    }*/
    /*
    void AutoStartLoadCo()
    {
        if (m_CoRuning) return;
        m_CoRuning = true;
        CoroutineManage.Single.StartCoroutine(coLoad());
    }*/

    /*
    IEnumerator coLoad()
    {
        while (m_NeedLoadPacks.Count > 0)
        {
            List<string> loadList = new List<string>();
            foreach (string packName in m_NeedLoadPacks)
            {
                if (!m_Models.ContainsKey(packName))
                    loadList.Add(packName);
            }
            m_NeedLoadPacks.Clear();

            PacketLoader loader = new PacketLoader(loadList);
            loader.Start(PackType.Res);
            IEnumerator it = loader.Wait();
            while (it.MoveNext()) yield return null;
            if (loader.Result != PacketLoader.ResultEnum.Done)
            {
                string panames = "";
                foreach (string pkName in loadList)
                    panames += pkName + " ";

                Debug.LogError(string.Format("装载资源包遇到错误 {0}", panames));
            }
            else
            {
                foreach (string pkName in loadList)
                {
                    m_Models.Add(pkName, new Dictionary<string, YQ2Model>());
                    ResourceRefManage.Single.AddRef(pkName);
                }
            }
        }
        m_CoRuning = false;
    }*/

    public void Clean()
    {
        foreach (KeyValuePair<string, Dictionary<string, MFAModel>> curr in m_Models)
        {
            ResourceRefManage.Single.SubRef(curr.Key);

            foreach(var mfaModelKV in curr.Value)   mfaModelKV.Value.Dispose(); 
        }
        m_Models.Clear();
    }

    //public bool IsLoding { get { return m_CoRuning; } }

    //bool m_CoRuning = false;

  //  HashSet<string> m_NeedLoadPacks = new HashSet<string>();
    Dictionary<string, Dictionary<string, MFAModel>> m_Models = new Dictionary<string, Dictionary<string, MFAModel>>();
} 
