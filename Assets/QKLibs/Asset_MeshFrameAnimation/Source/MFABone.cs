using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.Collections;

public class MFABone
{
    public MFABone(MFASkeletalModel model, GameObject obj, MFABone parent)
    {
        m_GameObj = obj;
        m_Parent = parent;

        MeshRenderer cmMeshRenderer = m_GameObj.GetComponent<MeshRenderer>();
        if (cmMeshRenderer != null) model.RegMesh(this);

        SkinnedMeshRenderer cmSkinnedMeshRenderer = m_GameObj.GetComponent<SkinnedMeshRenderer>();
        if (cmSkinnedMeshRenderer != null) 
            model.RegSkeletal(this);

        model.RegBone(this);

        //添加子骨骼
        int childCount = m_GameObj.transform.childCount;
        for(int i=0;i<childCount;i++)
        {
            GameObject childObj = m_GameObj.transform.GetChild(i).gameObject;
            m_Child.Add(new MFABone(model,childObj, this));
        }
    }

    public Matrix4x4 TransformMX { 
        get {  
            Matrix4x4 re = new Matrix4x4();
            Transform transform = m_GameObj.transform;
            re.SetTRS(transform.localPosition, transform.localRotation, transform.localScale);

            if (m_Parent != null)
                return m_Parent.TransformMX * re;
            else
                return re;  
        }
    }

    public MFABone Parent { get { return m_Parent; } }
    public GameObject gameObject { get { return m_GameObj; } }

    List<MFABone> m_Child = new List<MFABone>();
     
    MFABone m_Parent = null;
    GameObject m_GameObj = null;
}

public class MFASkeletalModel : IDisposable
{
    public MFASkeletalModel(GameObject obj)
    { 
        if (obj == null) return;


        //初始化骨骼 
        RootBones.Add(new MFABone(this, obj, null));


        var animators = new List<Animator>();

        //获取动画组件
        foreach (KeyValuePair<GameObject, MFABone> curr in BonesIndexByGameobj)
        {
            GameObject gameObject = curr.Key;
            var animator = gameObject.GetComponent<Animator>();
            if (animator != null) animators.Add(animator);
        }
         
        //建立动画剪辑索引
        foreach (var a in animators)
        {
            AnimatorClipInfo[] clipsInfo = a.GetCurrentAnimatorClipInfo(0);
            if(clipsInfo.Length==0) 
                throw new Exception ("模型的动作配置不正确 " + a.name);

            foreach (AnimatorClipInfo curr in clipsInfo)
            {
                if (!m_ClipsInfo.ContainsKey(curr.clip.name)) m_ClipsInfo.Add(curr.clip.name, new List<Animator>());
                m_ClipsInfo[curr.clip.name].Add(a);
            }
        }
    }

    public void Dispose()
    { 
    }
      

    public bool IsValid
    {
        get
        {
            return m_ClipsInfo.Count > 0 && Skeletals.Count > 0 && m_ClipsInfo.Count > 0;
        }
    }

    /// <summary>
    /// 注册蒙皮
    /// </summary>
    /// <param name="bone"></param>
    public void RegSkeletal(MFABone bone) { Skeletals.Add(bone); }

    /// <summary>
    /// 注册网格
    /// </summary>
    /// <param name="bone"></param>
    public void RegMesh(MFABone bone)
    {
        Meshs.Add(bone);
    }

    public void RegBone(MFABone bone)
    {
        BonesIndexByGameobj.Add(bone.gameObject, bone);
    }

    public void SetTime(string clipName, float t, string tag)
    {
      /*
        foreach (var animator in m_Animators)
        {
            bool isFind = false;
             AnimatorClipInfo[] clipsInfo =animator.GetCurrentAnimatorClipInfo(0);
            foreach (AnimatorClipInfo curr in clipsInfo)
            {
                if (curr.clip.name == clipName)
                {
                    isFind = true;
                    break;
                }
            }
            if (!isFind) continue;
             

            animator.PlayInFixedTime(clipName, 0, t);
            animator.Update(0.01f);
        }*/

        if (!m_ClipsInfo.ContainsKey(clipName)) return;

        var animators = m_ClipsInfo[clipName];
        foreach (var animator in animators)
        {
            animator.PlayInFixedTime(clipName, 0, t);
            animator.Update(0.01f);
        }

        BuildSnapshot(tag);
    }

    public void ClearSnapshot( )
    {
        FrameSnapshot.Clear( );
    }
    

    //构建帧快照
    public void BuildSnapshot(string tag)
    {
        //清除指定tag的网格
        {
            var tmp = new SortedDictionary<int, MeshFrame>();
            foreach (var curr in FrameSnapshot) if (curr.Value.tag != tag) tmp.Add(curr.Key,curr.Value);
            FrameSnapshot = tmp;
        }

        int index = 0;

        foreach (MFABone curr in Skeletals)
        {
            index++;
            string[] ns = curr.gameObject.name.Split('#');
            
            string ctag = (ns.Length > 1) ? ns[ns.Length - 1] : "";

            if (!string.IsNullOrEmpty(tag) && ctag != tag) continue;
            
            MeshFrame f = new MeshFrame();
            SkinnedMeshRenderer skMR = curr.gameObject.GetComponent<SkinnedMeshRenderer>();

            //新建一个mesh并进行蒙皮计算
            Mesh mesh = new Mesh();

            f.tag = ctag;
            skMR.BakeMesh(mesh);
            Matrix4x4 mxParent = new Matrix4x4();
            mxParent.SetTRS(
                Vector3.zero,
                RootBones[0].gameObject.transform.localRotation,
                Vector3.one
                );
            Matrix4x4 mx4 = new Matrix4x4();

            Vector3 localpos = curr.gameObject.transform.localPosition;
            Vector3 scale = RootBones[0].gameObject.transform.lossyScale;
            mx4.SetTRS(
                new Vector3(localpos.x * scale.x, localpos.y * scale.y, localpos.z * scale.z) + RootBones[0].gameObject.transform.localPosition,
                curr.gameObject.transform.localRotation,
                Vector3.one
                );
            f.TransformMX = mxParent * mx4;


            f.mesh = (mesh);
            FrameSnapshot.Add(index,f);
        }

        foreach (MFABone curr in Meshs)
        {
            index++;
            string[] ns = curr.gameObject.name.Split('#');
            string ctag =  (ns.Length > 1) ? ns[ns.Length - 1] : "";
            if (!string.IsNullOrEmpty(tag) && ctag != tag) continue;

            MeshFrame f = new MeshFrame();
            f.mesh = (curr.gameObject.GetComponent<MeshFilter>().sharedMesh);
            f.TransformMX = curr.TransformMX;

            f.tag = ctag;
            FrameSnapshot.Add(index, f);
        }
    }


    public float GetFrameRate(string clipName)
    {
        return m_ClipsInfo[clipName][0].GetCurrentAnimatorClipInfo(0)[0].clip.frameRate;
    }
     

    public bool HasClipInfo(string clipName)
    {
        return m_ClipsInfo.ContainsKey(clipName);
    }

    List<MFABone> RootBones = new List<MFABone>();//根骨队列
    List<MFABone> Skeletals = new List<MFABone>();//带蒙皮的骨骼列表
    List<MFABone> Meshs = new List<MFABone>();//带网格的骨骼列表
    Dictionary<GameObject, MFABone> BonesIndexByGameobj = new Dictionary<GameObject, MFABone>();//根据游戏物体索引的骨骼

    Dictionary<string, List<Animator>> m_ClipsInfo = new Dictionary<string, List<Animator>>();

    public class MeshFrame
    {
        public string tag;//标签
        public Mesh mesh;//网格
        public Matrix4x4 TransformMX;//变换矩阵
    }

    SortedDictionary<int, MeshFrame> FrameSnapshot = new SortedDictionary<int, MeshFrame>();//帧快照

    /// <summary>
    /// 过滤帧快照
    /// </summary>
    /// <param name="tags"></param>
    /// <returns></returns>
    public List<MeshFrame> FilterSnapshot(string[] tags)
    {
        List<MeshFrame> re = new List<MeshFrame>(); 

        foreach (var kv  in FrameSnapshot)
        {
            var curr = kv.Value;
            foreach (string tg in tags)
            {
                if (curr.tag == tg)
                {
                    re.Add(curr); 
                    break;
                }
            }
        }
        return re;
    }
}
