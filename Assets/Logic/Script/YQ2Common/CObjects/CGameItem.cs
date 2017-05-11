using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace YQ2Common.CObjects
{

    public enum BOOK_NAME
    {
        None = 0, // 缺省
        Item = 1,//道具
        Hero = 2,//英雄
        Army = 3,//士兵
        HeroSuiPian = 5,//英雄碎片
        ShiBingSuiPian = 6,//士兵碎片
        JunLingBag = 7,//军令包
        TimeHeadFace = 10,// 限时头像
        TimeHeadFrame = 11, // 限时头像框
        Equip =21,//装备
        EquipMaterial=22,//装备升星材料，洗练石
    }

    public struct JLItem
    {
        /// <summary>
        /// 空项
        /// </summary>
        public static JLItem Empty
        {
            get { return new JLItem() { BookName = BOOK_NAME.None, ItemId = 0, Number = 0 }; }
        }
        /// <summary>
        /// 从字符串解析对象
        /// </summary>
        public static JLItem Parse(string str)
        {
            // 空字串
            if (string.IsNullOrEmpty(str))
                throw new Exception(String.Format("无法解析的字符串:{0}", str));

            str = str.Replace("|", ":"); // "|"
            str = str.Replace("-", ":"); // "-"
            str = str.Replace("_", ":"); // "_"

            string[] attr = str.Split(':');

            if (3 != attr.Length)
                throw new Exception(String.Format("无法解析的字符串:{0}", str));

            int b = int.Parse(attr[0]);
            int t = int.Parse(attr[1]);
            int n = int.Parse(attr[2]);

            return new JLItem() { BookName = (BOOK_NAME)b, ItemId = t, Number = n };
        }

        /// <summary>
        /// 构建新的对象
        /// </summary>
        public static JLItem Build(BOOK_NAME bookName, int itemid, int num)
        {
            return new JLItem() { BookName = bookName, ItemId = itemid, Number = num };
        }

        /// <summary>
        /// 构建新的对象
        /// </summary>
        public static JLItem Build(int bookName, int itemid, int num)
        {
            return Build((BOOK_NAME)bookName, itemid, num);
        }

        /// <summary>
        /// 转换成字符串形式(BookName:ItemId:Number)
        /// </summary>
        public override string ToString()
        {
            return String.Format("{0}:{1}:{2}", (int)BookName, ItemId, Number);
        }

        /// <summary>
        /// 检测同一种类型
        /// </summary>
        public bool SameType(JLItem item)
        {
            return BookName == item.BookName && ItemId == item.ItemId;
        }

        /// <summary>
        /// 加运算
        /// </summary>
        public static JLItem operator +(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return new JLItem()
            {
                BookName = item1.BookName,
                ItemId = item1.ItemId,
                Number = (item1.Number + item2.Number)
            };
        }

        /// <summary>
        /// 减运算
        /// </summary>
        public static JLItem operator -(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return new JLItem()
            {
                BookName = item1.BookName,
                ItemId = item1.ItemId,
                Number = (item1.Number - item2.Number)
            };
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator >(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return item1.Number > item2.Number;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator <(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return item1.Number < item2.Number;
        }

        public static bool operator >(JLItem item1, int num)
        {
            return item1.Number > num;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator <(JLItem item1, int num)
        {
            return item1.Number < num;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator ==(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return item1.Number == item2.Number;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator !=(JLItem item1, JLItem item2)
        {
            if (!item1.SameType(item2))
                throw new Exception("不同类型无法进行运算");

            return item1.Number != item2.Number;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator ==(JLItem item1, int num)
        {
            return item1.Number == num;
        }

        /// <summary>
        /// 对比
        /// </summary>
        public static bool operator !=(JLItem item1, int num)
        {
            return item1.Number != num;
        }

        /// <summary>
        /// 重载Contains相关
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {
            if (null == obj)
                return false;
            if (obj.GetType() != this.GetType())
                return false;

            return (((JLItem)obj).SameType(this));
        }
        /// <summary>
        /// 重载Contains相关
        /// </summary>
        /// <returns></returns>
        public override int GetHashCode()
        {
            return this.GetHashCode();
        }


        public BOOK_NAME BookName;
        public int ItemId;
        public int Number;
    }

    ///// <summary>
    ///// 弹出模型对象列表比较器(根据ID比较)
    ///// </summary>
    //public class PopupComparer : IEqualityComparer<JLItem>
    //{
    //    public static PopupComparer Default = new PopupComparer();
    //    #region IEqualityComparer<PopupModel> 成员
    //    public bool Equals(Model.PopupModel.PopupModel x, Model.PopupModel.PopupModel y)
    //    {
    //        return x.Id.Equals(y.Id);
    //    }
    //    public int GetHashCode(Model.PopupModel.PopupModel obj)
    //    {
    //        return obj.GetHashCode();
    //    }
    //    #endregion
    //}


}
