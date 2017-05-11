using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
//通路
public interface I_PathNode
{
    /// <summary>
    /// 获取相邻节点
    /// </summary>
    I_PathNode[] Adjacent { get; }

    //int GetID();

    /// <summary>
    /// 是否是一个障碍物
    /// </summary>
    bool IsObstacle { get; }
}

//地图
public interface I_Map
{
    /// <summary>
    /// 相邻的两个路点，计算距离
    /// </summary>
    float AdjacentDistance(I_PathNode a, I_PathNode b);

    /// <summary>
    /// 估算距离，非相邻路点
    /// </summary>
    float DstimateDistance(I_PathNode a, I_PathNode b);
}

public class PathFinding
{
    public PathFinding()
    {
        Single = this;
    }


    /// <summary>
    /// 寻路
    /// </summary>
    /// <param name="map"></param>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <param name="limitG">限定寻路最大移动消耗</param>
    /// <param name="limitOutCount">限定寻路结果节点输出数量</param>
    /// <returns></returns>
    public I_PathNode[] FindWay(I_Map map, I_PathNode start, I_PathNode end, float limitG, int limitOutCount)
    {
        Clear();

        m_Map = map;
        m_Start = start;//起点
        m_End = end;//终点
        m_limitG = limitG;
        m_limitOutCount = limitOutCount;
        AddToOpenList(start,null);//将起点加入开启列表 
 
        do{
            DoLoop();
        }while(!CheckResult());

        return m_Result;
    }


    //检查是否获得了结果,返回true表示已经获得了输出结果
    bool CheckResult()
    {
        if (m_CloseList.ContainsKey(m_End))
        {
            Node node = m_CloseList[m_End];
            

            /*List<I_PathNode> nodeList = new List<I_PathNode>();
            nodeList.Add(node.node);
            while(node.Parent!=null)
            {
                node = node.Parent;
                nodeList.Add(node.node); 
            }

            int outResultCount = Math.Min(nodeList.Count,m_limitOutCount);
            m_Result = new I_PathNode[outResultCount];

            int listIndex = outResultCount - 1;
            for (int index = 0; index < outResultCount; index++, listIndex--)
            {
                m_Result[index] = nodeList[listIndex];
            } */

              m_FillResultIndex = 0;
              m_FillResultCount = 0;
              FillResult(node);

            return true;//找到了结果
        }

        if (m_OpenListIndexByF.Count <= 0)
        {
            m_Result = null;
            return true;//死路一条
        }

        return false;
    }

    void FillResult(Node node)
    {
        if (node == null||node.Parent==null) return;
        m_FillResultCount++;
        FillResult(node.Parent);
        if (m_FillResultIndex >= m_FillResultCount) return;

        if(m_FillResultIndex==0)
        {
            m_FillResultCount = Math.Min(m_FillResultCount,m_limitOutCount);
            m_Result = new I_PathNode[m_FillResultCount];
        }
        m_Result[m_FillResultIndex++] = node.node;
    }

    int m_FillResultIndex = 0;
    int m_FillResultCount = 0;

    void DoLoop()
    {
        SortedDictionary<float, List<Node>>.Enumerator it = m_OpenListIndexByF.GetEnumerator();
        it.MoveNext();
        Node currNode = it.Current.Value[0];

    
        m_CloseList.Add(currNode.node, currNode);
        RemoveFromOpenList(currNode);

        I_PathNode[] adjacentNodes = currNode.node.Adjacent;
        int adjacentNodeCount = adjacentNodes.Length;

        for (int i = 0; i < adjacentNodeCount; i++)
        {
            I_PathNode aNode = adjacentNodes[i];
            if (
                m_CloseList.ContainsKey(aNode)||//已经在关闭列表中
                aNode.IsObstacle//路点是一个障碍物
                ) continue;

            if (m_OpenListIndexByNode.ContainsKey(aNode))//已经在开启列表中
            {
                Node nodeObj = m_OpenListIndexByNode[aNode];
                Node backParent = nodeObj.Parent;
                nodeObj.Parent = currNode;
                float newG = CountG(nodeObj);
                if (newG >= nodeObj.G)//新的移动消耗大于旧的
                    nodeObj.Parent = backParent;//还原旧的移动策略
                else
                {
                    //从原有F索引中删除
                    _RemoveFromOpenListIndexByF(nodeObj);

                    //应用新的G值
                    nodeObj.G = newG;

                    //重新添加到F索引
                    _AddToOpenListIndexByF(nodeObj);
                }
            }
            else//不在开启队列
            {
                AddToOpenList(aNode, currNode);
            }
        }
    }


    float CountG(Node node)
    {
        float G = 0; 
        while (node.Parent != null)
        {
            Node p = node.Parent;
            G+=m_Map.AdjacentDistance(p.node, node.node);
            node = p;
        }
        return G;
    }

    class Node
    {
        public I_PathNode node;
        public float G;//移动消耗
        public float H;//距离目标的消耗估算
        public float F { get { return G + H; } }//用于评估路径价值
        public Node Parent;
           
    }

    void AddToOpenList(I_PathNode a, Node parent)
    {
        Node aa = new Node();
        aa.node = a;
        aa.Parent = parent;
        aa.H = m_Map.DstimateDistance(a, m_End);
        aa.G = CountG(aa);

        if (aa.G > m_limitG) return;//移动消耗超出限制
             
        _AddToOpenListIndexByF(aa);
        m_OpenListIndexByNode.Add(aa.node, aa);
 
    }

      
    void RemoveFromOpenList(Node aa)
    {
        _RemoveFromOpenListIndexByF(aa);
        m_OpenListIndexByNode.Remove(aa.node);
    }


    void _AddToOpenListIndexByF(Node aa)
    {
        float f = aa.F;

        if (!m_OpenListIndexByF.ContainsKey(f))
            m_OpenListIndexByF.Add(f, new List<Node>());

        m_OpenListIndexByF[f].Add(aa);
    }

    void _RemoveFromOpenListIndexByF(Node aa)
    {
        float f = aa.F;
        List<Node> list = m_OpenListIndexByF[aa.F];
        list.Remove(aa);
        if (list.Count <= 0) m_OpenListIndexByF.Remove(aa.F);
    }


    void Clear()
    {
        m_CloseList.Clear();
        m_OpenListIndexByF.Clear();
        m_OpenListIndexByNode.Clear();
    }

    Dictionary<I_PathNode, Node> m_CloseList = new Dictionary<I_PathNode, Node>();
    SortedDictionary<float, List<Node>> m_OpenListIndexByF = new SortedDictionary<float, List<Node>>();
    Dictionary<I_PathNode, Node> m_OpenListIndexByNode = new Dictionary<I_PathNode, Node>();


    float m_limitG;
    int m_limitOutCount;
    I_PathNode[] m_Result = null;
    //I_PathNode[] m_AdjacentNode = new I_PathNode[20];
    I_Map m_Map = null;
    I_PathNode m_End = null;//终点
    I_PathNode m_Start = null;//起点
    public static PathFinding Single = null;
} 