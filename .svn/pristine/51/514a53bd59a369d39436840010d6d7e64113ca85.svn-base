using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


 

public class YQ2QuadTree<T>
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="world">世界</param>
    /// <param name="maxDepth">最大深度</param>
    public YQ2QuadTree(YQ2AABBBox2D world, byte maxDepth)
    {
        m_Root = new TreeNode(world.Clone(), null);
        m_MaxDepth = maxDepth;

        //创建树节点
        CreateChilds(m_Root,0);
    }

    void CreateChilds(TreeNode node, float depth)
    {
        YQ2AABBBox2D box = node.Box;
        float zsize = (box.maxz - box.minz) / 2;
        float xsize = (box.maxx - box.minx) / 2;
        float centerZ = box.minz + zsize;
        float centerX = box.minx + xsize;

        YQ2AABBBox2D lbBox = new YQ2AABBBox2D(box.minx, box.minz, centerX, centerZ);
        YQ2AABBBox2D rbBox = new YQ2AABBBox2D(centerX, box.minz, box.maxx, centerZ);
        YQ2AABBBox2D ltBox = new YQ2AABBBox2D(box.minx, centerZ, centerX, box.maxz);
        YQ2AABBBox2D rtBox = new YQ2AABBBox2D(centerX, centerZ, box.maxx, box.maxz);
        if (depth == m_MaxDepth - 1)
        {
            node.LB = new Leaf(lbBox, node);
            node.RB = new Leaf(rbBox, node);
            node.LT = new Leaf(ltBox, node);
            node.RT = new Leaf(rtBox, node);
        }
        else
        {
            node.LB = new TreeNode(lbBox, node);
            node.RB = new TreeNode(rbBox, node);
            node.LT = new TreeNode(ltBox, node);
            node.RT = new TreeNode(rtBox, node);

            depth++;
            CreateChilds((TreeNode)node.LB, depth);
            CreateChilds((TreeNode)node.RB, depth);
            CreateChilds((TreeNode)node.LT, depth);
            CreateChilds((TreeNode)node.RT, depth);
        }
    }

    /// <summary>
    /// 增加一个对象到树中
    /// </summary>
    public void Add(T item, float x, float z)
    {
        PointFixes(ref x, ref z);
        TreeItem titem = new TreeItem();
        titem.obj = item;
        titem.x = x;
        titem.z = z;
        Add(titem, m_Root, 0);
    }

    /// <summary>
    /// 一个对象移动了，更新在树中的位置
    /// </summary>
    public void Move(T item, float newx, float newz)
    {
        if (!m_TreeItems.ContainsKey(item)) //新对象
        {
            Add(item, newx, newz);
            return;
        }

        TreeItem titem = m_TreeItems[item];
        titem.x = newx; titem.z = newz;//更新坐标值
        Leaf leaf = titem.owner;
        if (leaf.Box.Contains(newx, newz)) return;//如果新位置没有跨节点，则直接返回

        leaf.Items.Remove(titem);//从树叶中删除
        //if (leaf.Items.Count == 0) RemoveNode(leaf); //叶子已经空了 这里删除会导致之后的逻辑出错，找到的可以插入的节点可能已经被删除


        //寻找一个包含新位置的父
        PointFixes(ref newx, ref newz);
        TreeNode node = leaf.Parent;
        int depth = m_MaxDepth - 1;
        do
        {
            node.ChildItemCount--;//子条目数量减少1
            if (node.Box.Contains(newx, newz))
            {
                Add(titem, node, depth);
                return;
            }
            depth--;
            node = node.Parent;
        } while (node != null);
    }

    /// <summary>
    /// 移除一个对象
    /// </summary>
    /// <param name="item"></param>
    public void Remove(T item)
    {
        if (!m_TreeItems.ContainsKey(item))
            return;

        TreeItem titem = m_TreeItems[item];
        Leaf leaf = titem.owner;
        leaf.Items.Remove(titem);//从树叶中删除
        m_TreeItems.Remove(item);//从对象索引表删除

        //处理子对象数
        TreeNode p = leaf.Parent;
        do
        {
            p.ChildItemCount--;
            p = p.Parent;
        } while (p != null);
    }


    public void Query(YQ2AABBBox2D range, Action<T> recall)
    {
        Query(range, m_Root, 0, recall);
    }

    /// <summary>
    /// 清空
    /// </summary>
    public void ClearItems()
    {
        m_TreeItems.Clear();
        ClearItems(m_Root, 0);
    }

    void ClearItems(TreeNode node, int depth)
    {
        if (depth == m_MaxDepth - 1)//已经到达树叶层级
        {
            ((Leaf)node.LB).Items.Clear();
            ((Leaf)node.RB).Items.Clear();
            ((Leaf)node.LT).Items.Clear();
            ((Leaf)node.RT).Items.Clear();
        }else
        {
            node.ChildItemCount = 0;

            depth++;
            ClearItems((TreeNode)node.LB, depth);
            ClearItems((TreeNode)node.RB, depth);
            ClearItems((TreeNode)node.LT, depth);
            ClearItems((TreeNode)node.RT, depth);
        }
    }

    void Query(YQ2AABBBox2D range, TreeNode  node, int depth, Action<T> recall)
    {
        if (node.ChildItemCount<=0) return;//无子对象

        if (!range.Intersect(node.Box)) return;//查询区域和节点无交集

        TreeNode tnode = (TreeNode)node;

        if (depth == m_MaxDepth - 1)//已经到达树叶层级
        {
            Query(range, (Leaf)tnode.LB, recall);
            Query(range, (Leaf)tnode.RB, recall);
            Query(range, (Leaf)tnode.LT, recall);
            Query(range, (Leaf)tnode.RT, recall);
        }
        else//在4个分叉中查询
        {
            depth++;
            Query(range,(TreeNode) tnode.LB, depth, recall);
            Query(range,(TreeNode) tnode.RB, depth, recall);
            Query(range,(TreeNode) tnode.LT, depth, recall);
            Query(range,(TreeNode) tnode.RT, depth, recall);
        }
    }

    void Query(YQ2AABBBox2D range, Leaf leaf, Action<T> recall)
    {
        if (!range.Intersect(leaf.Box)) return;

        foreach (TreeItem item in leaf.Items)
        {
            if (range.Contains(item.x, item.z))
                recall(item.obj);
        }
    }

    void Add(TreeItem titem, TreeNode node, float depth)
    {
        YQ2AABBBox2D box = node.Box;
        float zsize = (box.maxz - box.minz) / 2;
        float xsize = (box.maxx - box.minx) / 2;
        float centerZ = box.minz + zsize;
        float centerX = box.minx + xsize;
        float x = titem.x;
        float z = titem.z;

        node.ChildItemCount++;

        if (depth == m_MaxDepth - 1)
        {

            if (z < centerZ)
            {
                if (x < centerX) 
                    Add(titem, (Leaf)node.LB); 
                else 
                    Add(titem, (Leaf)node.RB); 
            }
            else
            {
                if (x < centerX) 
                    Add(titem, (Leaf)node.LT); 
                else 
                    Add(titem, (Leaf)node.RT); 
            }
            return;
        }
        else
        {
            if (z < centerZ)
            {
                if (x < centerX) 
                    Add(titem, (TreeNode)node.LB, depth + 1); 
                else 
                    Add(titem, (TreeNode)node.RB, depth + 1); 
            }
            else
            {
                if (x < centerX) 
                    Add(titem, (TreeNode)node.LT, depth + 1); 
                else 
                    Add(titem, (TreeNode)node.RT, depth + 1); 
            }
        }
    }

    void Add(TreeItem titem, Leaf node)
    {
        titem.owner = node;
        if (!m_TreeItems.ContainsKey(titem.obj)) //Move方法重新把对象加入到树
            m_TreeItems.Add(titem.obj, titem);
        
        node.Items.Add(titem);
    }

    void PointFixes(ref float x, ref  float z)
    {
        YQ2AABBBox2D worldbox = m_Root.Box;
        if (x < worldbox.minx)
            x = worldbox.minx;
        else if (x > worldbox.maxx)
            x = worldbox.maxx;

        if (z < worldbox.minz)
            z = worldbox.minz;
        else
            if (z > worldbox.maxz)
                z = worldbox.maxz;
    }

    class TreeNodeBase
    {
        public TreeNodeBase(YQ2AABBBox2D Box, TreeNode Parent)
        {
            this.Parent = Parent;
            this.Box = Box.Clone();
        }

        public readonly YQ2AABBBox2D Box;
        public readonly TreeNode Parent = null;
    }

    class TreeNode : TreeNodeBase
    {
        public TreeNode(YQ2AABBBox2D Box, TreeNode Parent) : base(Box, Parent) { }
        public TreeNodeBase LT = null;
        public TreeNodeBase RT = null;
        public TreeNodeBase LB = null;
        public TreeNodeBase RB = null;
        public int ChildItemCount = 0;//子节点包含的对象总数
    }

    class Leaf : TreeNodeBase
    {
        public Leaf(YQ2AABBBox2D Box, TreeNode Parent) : base(Box, Parent) { }
        public List<TreeItem> Items = new List<TreeItem>();//本节点挂接的条目
    }

    class TreeItem
    {
        public T obj;
        public Leaf owner;
        public float x;
        public float z;
    }
    Dictionary<T, TreeItem> m_TreeItems = new Dictionary<T, TreeItem>();

    TreeNode m_Root = null;
    int m_MaxDepth;
} 