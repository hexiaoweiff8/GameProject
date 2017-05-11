using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.IO;
using UnityEditor;
class MFAExportCore
{

    /// <summary>
    /// 生成一个模型
    /// </summary>
    public static void GenerateOne(MFAAnimationExportInfo exportInfo)
    {
        string modelRootPath = Application.dataPath + "/Resources/model";
        DirectoryInfo modelRoot = new DirectoryInfo(modelRootPath);
        if (!modelRoot.Exists) modelRoot.Create();

        var clipsInfo = MFADatas.Single.ModelClips.Get(exportInfo.ModelClips);
        if (clipsInfo == null)
        {
            Debug.LogError("AnimationExport.ModelClips 设置有误  ID:" + exportInfo.ID.ToString());
            return;
        }

        if (clipsInfo.Clips == null || clipsInfo.Clips.Length < 1)
        {
            Debug.LogError("ModelClips未设置动画剪辑 Name:" + clipsInfo.Name);
            return;
        }
         
        foreach (var lodModeName in exportInfo.LodModes)
        {
            string gameObjName = exportInfo.Pack + "#" + lodModeName ;

            if (!string.IsNullOrEmpty(exportInfo.GameObjNameSuffix)) gameObjName += "_" + exportInfo.GameObjNameSuffix;

            var skinAnimationGameObj = GameObject.Find(gameObjName);
            if (skinAnimationGameObj == null)
            {
                Debug.LogError("未找到游戏物体 " + gameObjName);
                continue;
            }

            //添加纹理路径
            /*
            var renders = skinAnimationGameObj.GetComponentsInChildren<Renderer>();
            foreach (var render in renders)
            {
                if (render.material != null)
                    textures.Add(render.material.mainTexture);
            }*/

            MFAModel model;
            try
            {
                model = FromYQ2AnimationClips(skinAnimationGameObj, exportInfo);
            }
            catch (Exception ex)
            {
                Debug.LogError(skinAnimationGameObj.name + " " + ex.ToString());
                continue;
            }

            /*
            string[] model_lod = skinAnimationGameObj.name.Split('#');
            if (model_lod.Length != 2)
            {
                Debug.LogError("模型命名不正确！");
                return;
                //yield break;
            }
            */

            //string modelName = model_lod[0].ToLower();
            //string lodFlag = model_lod[1].ToLower();
            string modelPackPath = modelRootPath + "/@" + exportInfo.Pack;
            DirectoryInfo dirObj = new DirectoryInfo(modelPackPath);
            if (!dirObj.Exists) dirObj.Create();

            /* string FramesPackPath = modelPackPath + "/Frames";
             dirObj = new DirectoryInfo(FramesPackPath);
             if (!dirObj.Exists) dirObj.Create();
             */
            //生成模型文件
            string modelFilePath = Application.dataPath + "/Resources/model/@" + exportInfo.Pack + "/" + lodModeName + "_" + exportInfo.FileSuffix + ".bytes";// modelPackPath 
            FileInfo file = new FileInfo(modelFilePath);
            using (FileStream fs = file.Open(FileMode.Create, FileAccess.Write))
            {
                model.Serialize(fs);
                fs.Close();
            }

            Debug.Log("成功生成模型 " + exportInfo.Pack + "/" + lodModeName);
        }

        //导出纹理
        var textures = new HashSet<KeyValuePair<Texture, string>>();

        if(exportInfo.Texture!=null&&exportInfo.Texture.Length>0)
        foreach(var textureName in exportInfo.Texture)
        {
            string resTextureName;
            string exportTextureName;

            var nameArray = textureName.Split('#');
            if(nameArray.Length==1)
            {
                resTextureName = exportTextureName = textureName;
            }
            else if (nameArray.Length == 2)
            {
                resTextureName = nameArray[0];
                exportTextureName = nameArray[1];
            } else
            {
                Debug.LogError("纹理配置有误 ID:" + exportInfo.ID);
                continue;
            }

            string[] guids = AssetDatabase.FindAssets(resTextureName);
            if(guids==null||guids.Length<1)
            {
                Debug.LogError("未找到纹理 " + resTextureName);
                continue;
            }

            var path = AssetDatabase.GUIDToAssetPath(guids[0]);
            Texture2D t = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
            if(t==null)
            {
                Debug.LogError("无效纹理 " + resTextureName);
                continue;
            }
            textures.Add(new KeyValuePair<Texture, string>(t, exportTextureName));
        }

        foreach (var kv in textures)
        {
            var texutre = kv.Key;
           
            var path = AssetDatabase.GetAssetPath(texutre);
            path = Application.dataPath + path.Substring(6);

            //var fn = Path.GetFileNameWithoutExtension(path);
          
            //string fileName;

            //string[] fns = fn.Split('#');
            //if (fns.Length > 1)
            //    fileName = fns[1] + Path.GetExtension(path);
            //else
            //    fileName = fn + Path.GetExtension(path);

            var fileName = kv.Value + Path.GetExtension(path);
            //AssetDatabase

            string outFilePath = Application.dataPath + "/Resources/model/@" + exportInfo.Pack + "/" + fileName;
            File.Copy(path, outFilePath, true);

            Debug.Log("成功导出纹理 " + exportInfo.Pack + "/" + fileName);
        }

        AssetDatabase.Refresh();
    }

/*
    List<Texture> tl = new List<Texture>();
           string[] paths = AssetDatabase.FindAssets("qibing_512red");
           foreach (var p in paths)
           {
               //Debug.Log(AssetDatabase.GUIDToAssetPath(p));
               var path = AssetDatabase.GUIDToAssetPath(p);
              // path = path.Substring(7,path.Length-7);
               Texture2D t = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                   
                   // AssetDatabase.LoadAssetAtPath<Texture>(path);
               tl.Add(t);
           }
*/
    //反序列化测试
    /*
    {
        using(MemoryStream mem = new MemoryStream( FileSystem.ReadFile(file.FullName)))
        {
            model.Deserialize(mem);
        }
                
    }*/

    //保存mesh并建立关联
    /*
      string modelFilePath = "Assets/Resources/model/@" + modelName +"/" + lodFlag + ".prefab";// modelPackPath 
    YQ2MFAFrames nFrames =  model.GetComponent<YQ2MFAFrames>();
    for (int i = 0; i < nFrames.KeyFrames.Length;i++ )
    {
        Mesh kfmesh = nFrames.KeyFrames[i];
        string meshPath =
            string.Format("Assets/Resources/model/@{0}/Frames/{1}_{2:D2}.prefab",
            modelName,
            lodFlag,
            i
            );
        AssetDatabase.CreateAsset(kfmesh, meshPath);

        kfmesh = AssetDatabase.LoadAssetAtPath(meshPath, typeof(Mesh)) as Mesh;
        nFrames.KeyFrames[i] = kfmesh;
    }
            
    PrefabUtility.CreatePrefab(modelFilePath,model);
    GameObject.DestroyImmediate(model); 
     */



    /// <summary>
    /// 从骨架动画组件生成模型对象
    /// </summary>
    /// <returns></returns> 
    static MFAModel FromYQ2AnimationClips(GameObject _obj, MFAAnimationExportInfo exportInfo)
    {
        var ModelClipsInfo = MFADatas.Single.ModelClips.Get(exportInfo.ModelClips);
       

        //检查剪辑帧数正确性
        {
            foreach (var curr in ModelClipsInfo.Clips)
            {
                int fCount = -1;
                int eCount = -1;
                foreach (var curr2 in curr.FrameRanges)
                {
                    if (fCount < 0) fCount = curr2.ResFrameCount;
                    if (eCount < 0) eCount = curr2.ExportFrameCount;

                    if (curr2.ResFrameCount != fCount)
                        throw new Exception("动画剪辑资源帧数不一致 " + curr.Name);

                    if (curr2.ExportFrameCount != eCount)
                        throw new Exception("动画剪辑导出帧数不一致 " + curr.Name);
                }
            }
        }

        //YQ2ModelAnimationClip
        using (MFASkeletalModel skin_model = new MFASkeletalModel(_obj))
        {

            string ckResTag = "";

            //检查剪辑基本配置信息
            foreach (var c1 in ModelClipsInfo.Clips)
            {

                SortedDictionary<string, string> tags = new SortedDictionary<string, string>();
                foreach (var curr in c1.FrameRanges)
                {
                    // if (!skin_model.HasClipInfo(curr.ResClipName))
                    //    throw new Exception("不存在的动画剪辑 " + curr.ResClipName);

                    if (curr.ExportFrameCount < 1)
                        throw new Exception(string.Format("动画剪辑{0} 导出帧数有误 ", c1.ClipName));

                    if (curr.ResStartFrameIndex < 0)
                        throw new Exception(string.Format("动画剪辑{0} 起始帧配置错误", c1.ClipName));

                    if (curr.ResEndFrameIndex - curr.ResStartFrameIndex < 1)
                        throw new Exception(string.Format("动画剪辑{0} 帧总数错误", c1.ClipName));

                    if(tags.ContainsKey(curr.ResTag)) 
                        throw new Exception(string.Format("动画剪辑{0} 重复的组件", c1.ClipName));
                    tags.Add(curr.ResTag, curr.ResTag);
                }

                string tmpTag = "";
                foreach (var curr in tags) tmpTag += curr.Key;

                if (string.IsNullOrEmpty(ckResTag)) 
                    ckResTag = tmpTag;
                else
                    if (ckResTag != tmpTag) throw new Exception(string.Format("动画剪辑{0} 各动作组件不一致", c1.ClipName));

            }

            //统计tag队列
            /*
            HashSet<string> tags = new HashSet<string>();
            foreach (var c1 in ModelClipsInfo.Clips)
            {
                foreach (var curr in c1.FrameRanges)  tags.Add(curr.ResTag); 
            }*/

            skin_model.ClearSnapshot();

            //构建快照
            foreach (var tag in exportInfo.Tags) skin_model.BuildSnapshot(tag);
            
            //过滤快照
            List<MFASkeletalModel.MeshFrame> firstSnapshot = skin_model.FilterSnapshot(exportInfo.Tags);


            int indexCount = 0;
            int vertexCount = 0;

            //统计顶点和索引总量
            foreach (MFASkeletalModel.MeshFrame mf in firstSnapshot)
            {
                Mesh mesh = mf.mesh;
                for (int i = 0; i < mesh.subMeshCount; i++)
                {
                    indexCount += mesh.GetIndices(i).Length;
                }
                vertexCount += mesh.vertexCount;
            }



            //分配内存 
            int[] kfIndexs = new int[indexCount];
            Vector2[] kfUV = new Vector2[vertexCount];

            {
                int startUV = 0;
                int startIndex = 0;
                //填充uv和索引信息
                foreach (MFASkeletalModel.MeshFrame mf in firstSnapshot)
                {
                    Mesh mesh = mf.mesh;

                    //填充子网数据 
                    for (int i = 0; i < mesh.subMeshCount; i++)
                    {
                        int[] indexs = mesh.GetIndices(i);
                        for (int ii = 0; ii < indexs.Length; ii++)
                            kfIndexs[ii + startIndex] = (ushort)(indexs[ii] + startUV);

                        startIndex += indexs.Length;
                    }

                    //填充UV数据
                    Array.Copy(mesh.uv, 0, kfUV, startUV, mesh.uv.Length);
                    startUV += mesh.uv.Length;
                }

            }


            Dictionary<int, Mesh> KeyFramesIndexByID = new Dictionary<int, Mesh>();//根据帧id索引的帧队列
            Dictionary<long, List<KeyValuePair<Mesh, int>>> KeyFramesIndexByHash = new Dictionary<long, List<KeyValuePair<Mesh, int>>>();//根据哈希值生成的帧队列

            //GameObject reGameObject = new GameObject();

            MFAModel reModel = new MFAModel();
            reModel.m_Frames = new MFAFrames();

            //处理关键帧和动画 
            foreach (var currC in ModelClipsInfo.Clips)
            {
                string _clipName = currC.ClipName;
                var ExportFrameCount = currC.FrameRanges[0].ExportFrameCount;
                var ResFrameCount = currC.FrameRanges[0].ResFrameCount;
                float frameRate = 0;

                foreach (var currClip in currC.FrameRanges)
                {
                    if (skin_model.HasClipInfo(currClip.ResClipName))
                    { frameRate = skin_model.GetFrameRate(currClip.ResClipName); break; }
                }

                if (frameRate < 0.000001) throw new Exception("无法正确获得帧率 " + _clipName);

                MFAClip nClip = new MFAClip();
                nClip.clipName = _clipName;
                nClip.frameDelay = ((ResFrameCount - 1) * (1.0f / frameRate)) / ExportFrameCount;
                nClip.KeyFrameIndexs = new int[ExportFrameCount];
                reModel.m_ClipsIndexByName.Add(nClip.clipName, nClip);
                reModel.m_ClipsIndexByHashName.Add(nClip.clipName.GetHashCode(), nClip);

                for (int currFrame = 0; currFrame < ExportFrameCount; currFrame++)
                {
                    skin_model.ClearSnapshot();
                    foreach (var currClip in currC.FrameRanges)
                    {
                        string skinClipName = currClip.ResClipName;
                        float clipStartTime = currClip.ResStartFrameIndex * (1.0f / frameRate);//资源剪辑起始时间
                        float clipEndTime = clipStartTime + (currClip.ResFrameCount - 1) * (1.0f / frameRate);//资源剪辑终止时间

                        if (currClip.IsLoop) clipEndTime -= nClip.frameDelay;

                        float timeBfb = (float)currFrame / (float)(ExportFrameCount - 1);
                        float t = clipStartTime + (clipEndTime - clipStartTime) * timeBfb; 
                        //采样动画时间点的帧
                        skin_model.SetTime(skinClipName, t, currClip.ResTag);
                    }
                    List<MFASkeletalModel.MeshFrame> frameSnapshot = skin_model.FilterSnapshot(exportInfo.Tags);

                    long hashV;
                    Mesh kf = new Mesh();
                    Vector3[] kfvertexs = new Vector3[vertexCount];
                    {
                        double _hashv = 0;
                        //kf.possitionArray

                        int startVertex = 0;

                        //抓取当前顶点位置，并生成关键帧
                        foreach (MFASkeletalModel.MeshFrame mf in frameSnapshot)
                        {
                            Mesh mesh = mf.mesh;
                            Vector3[] vertices = mesh.vertices;
                            for (int vi = 0; vi < vertices.Length; vi++)
                            {
                                Vector3 v3 = vertices[vi];
                                kfvertexs[vi + startVertex] = mf.TransformMX.MultiplyPoint(v3);
                                _hashv += v3.x;
                                _hashv += v3.y;
                                _hashv += v3.z;
                            }

                            startVertex += vertices.Length;
                        }


                        kf.vertices = kfvertexs;
                        hashV = (long)_hashv;

                    }

                    int selectIndex = -1;

                    if (KeyFramesIndexByHash.ContainsKey(hashV)) //哈希值存在
                    {
                        //逐顶点比对
                        List<KeyValuePair<Mesh, int>> kfList = KeyFramesIndexByHash[hashV];
                        foreach (KeyValuePair<Mesh, int> currKF in kfList)
                        {
                            Vector3[] currKFVertices = currKF.Key.vertices;
                            bool isLike = true;
                            for (int i = 0; i < kfvertexs.Length; i++)
                            {
                                if (currKFVertices[i] != kfvertexs[i])
                                {
                                    isLike = false;
                                    break;
                                }
                            }
                            if (isLike)
                            {
                                selectIndex = currKF.Value;
                                break;
                            }
                        }
                    }

                    if (selectIndex < 0)
                    {
                        //生成法线信息  


                        //填充uv
                        kf.uv = kfUV;

                        //填充索引
                        kf.triangles = kfIndexs;

                        //加入到关键帧队列
                        int index = KeyFramesIndexByID.Count;
                        KeyFramesIndexByID.Add(index, kf);

                        if (!KeyFramesIndexByHash.ContainsKey(hashV))
                            KeyFramesIndexByHash.Add(hashV, new List<KeyValuePair<Mesh, int>>());


                        //加入到哈希索引
                        KeyFramesIndexByHash[hashV].Add(new KeyValuePair<Mesh, int>(kf, index));

                        //选择新生成的这个关键帧
                        selectIndex = index;
                    }

                    nClip.KeyFrameIndexs[currFrame] = selectIndex;
                }//end for(int currFrame = 0;currFrame<frameCount;currFrame++)

            }//end foreach (ModelAnimationClip currClip in clips) 

            //填充关键帧
            int keycount = KeyFramesIndexByID.Count;
            reModel.m_Frames.KeyFrames = new Mesh[keycount];
            for (int kindex = 0; kindex < keycount; kindex++)
                reModel.m_Frames.KeyFrames[kindex] = KeyFramesIndexByID[kindex];

            OptimalKeyFrames(reModel.m_Frames.KeyFrames);

            reModel.UpdateDefaultHashClipName();
            return reModel;


        }
    }

    //对关键帧序列进行优化
    static void OptimalKeyFrames(Mesh[] keyFrames)
    {
        Dictionary<int, int> needOptimalVertex = null;//需要优化的顶点
        foreach (Mesh curr in keyFrames)
        {
            Dictionary<int, int> cVIndex = BuildOptimalVertexIndex(curr);
            if (needOptimalVertex == null)
                needOptimalVertex = cVIndex;
            else
            {
                List<int> needRemove = new List<int>();
                foreach (var kv in needOptimalVertex)
                {
                    if (
                        !cVIndex.ContainsKey(kv.Key)||//不是共同的可优化顶点
                        cVIndex[kv.Key]!=kv.Value//替换的index不同
                        )
                        needRemove.Add(kv.Key);
                }
                foreach (int r in needRemove) needOptimalVertex.Remove(r);
            }
        }

        //构建旧索引转新索引表
        var vCount = keyFrames[0].vertexCount;
        Dictionary<int, int> O2NIndex = new Dictionary<int, int>();
        int newIdx = 0;
        for (int i = 0; i < vCount;i++ )
        {
            if (needOptimalVertex.ContainsKey(i)) continue;
            O2NIndex.Add(i, newIdx++);
        }

        foreach (var kv in needOptimalVertex)
        {
            O2NIndex.Add(kv.Key,O2NIndex[ kv.Value]);
        }

      
        for (int j = 0; j < keyFrames.Length; j++)
        {
            Mesh inMesh = keyFrames[j];
            Vector3[] vertices = inMesh.vertices;
            Vector2[] uv = inMesh.uv;

            int newVertexCount = vertices.Length - needOptimalVertex.Count;


            Vector3[] new_vertices = new Vector3[newVertexCount];
            Vector2[] new_uvs = new Vector2[newVertexCount];
            int vIdx = 0;
            for (int i = 0; i < vertices.Length; i++)
            {
                if (needOptimalVertex.ContainsKey(i)) continue;//需要排除的顶点
                new_vertices[vIdx] =  vertices[i];
                new_uvs[vIdx] = uv[i];
                vIdx++;
            }

            Mesh newMesh = new Mesh();
            newMesh.vertices = new_vertices;
            newMesh.uv = new_uvs;

            //重建索引
            for (int i = 0; i < inMesh.subMeshCount; i++)
            {
                int[] indexs = inMesh.GetIndices(i);
                for (int i2 = 0; i2 < indexs.Length; i2++)
                {
                    indexs[i2] = O2NIndex[indexs[i2] ];  
                }
                newMesh.SetIndices(indexs, MeshTopology.Triangles, i);
            }

            keyFrames[j] = newMesh;
        } 
        Debug.Log("优化顶点数量:" + needOptimalVertex.Count.ToString());
    }

    //构建可优化的顶点索引位置
    static Dictionary<int, int> BuildOptimalVertexIndex(Mesh inMesh)
    {
        Dictionary<int, int> reIndexs = new Dictionary<int, int>();

        Vector3[] vertices = inMesh.vertices;
        Vector2[] uv = inMesh.uv;
        Dictionary<Vector3, Dictionary<Vector2, int>> ov_f = new Dictionary<Vector3, Dictionary<Vector2, int>>();
        for (int i = 0; i < vertices.Length; i++)
        {
            Vector3 curr_vertice = vertices[i];
            Vector2 curr_uv = uv[i];

            if (ov_f.ContainsKey(curr_vertice)) //疑似重合
            {
                Dictionary<Vector2, int> kv = ov_f[curr_vertice];
                if (kv.ContainsKey(curr_uv)) //重合
                {
                    reIndexs.Add(i, kv[curr_uv]);
                    continue;
                }
            }

            if (!ov_f.ContainsKey(curr_vertice))
                ov_f.Add(curr_vertice, new Dictionary<Vector2, int>());

            if (!ov_f[curr_vertice].ContainsKey(curr_uv))
                ov_f[curr_vertice].Add(curr_uv,i);

        }
        return reIndexs;
    }

    class OVertice
    {
        public Vector3 pos;
        public Vector2 uv;
        public int index;
    }
} 