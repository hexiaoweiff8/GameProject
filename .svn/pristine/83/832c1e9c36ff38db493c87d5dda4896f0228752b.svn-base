using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;


    public class CJItemInfo
    {
        public BOOK_NAME BookName =BOOK_NAME.Item;
        public int SubType=4;
        public int NumMin=1;
        public int NumMax=1;
        public int ID=1;

        Random rank = new Random();

        /// <summary>
        /// 获取奖励物品数量
        /// </summary>
        /// <returns></returns>
        public int GetRandNum()
        {
            if (NumMin < NumMax)
            {
                return rank.Next(NumMin, NumMax);
            }
            else if (NumMin == NumMax)
            {
                return NumMax;
            }
            else
                return 0;
        }
    }

    public class SData_ChoujiangItem : MonoEX.Singleton<SData_ChoujiangItem>
    {
        //public static SData_CJItem Single
        //{
        //    get
        //    {
        //        if (null == mSingle)
        //        {
        //            mSingle = new SData_CJItem();
        //        }
        //        return mSingle;
        //    }
        //}

        public SData_ChoujiangItem()
        {
            try
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ChoujiangItem");
                using (ITabReader reader = TabReaderManage.Single.CreateInstance())
                {
                    reader.Load("bsv", "ChoujiangItem");
                    short Iid = reader.ColumnName2Index("ID");
                    short ISubType = reader.ColumnName2Index("SubType");
                    short IBookName = reader.ColumnName2Index("BookName");
                    short INumMin = reader.ColumnName2Index("NumMin");
                    short INumMax = reader.ColumnName2Index("NumMax");

                    int rowCount = reader.GetRowCount();
                    for (int row = 0; row < rowCount; row++)
                    {
                        CJItemInfo item = new CJItemInfo();
                        item.ID = reader.GetI16(Iid, row);
                        item.SubType = reader.GetI32(ISubType, row);
                        item.BookName = (BOOK_NAME)reader.GetI16(IBookName, row);
                        item.NumMin = reader.GetI32(INumMin, row);
                        item.NumMax = reader.GetI32(INumMax, row);

                        DataList.Add(item.ID, item);
                    }
                }
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ChoujiangItem 完毕!");
            }
            catch (System.Exception ex)
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "ChoujiangItem初始化失败!");
                throw ex;
            }
        }
        readonly Dictionary<int, CJItemInfo> DataList = new Dictionary<int, CJItemInfo>();

        public CJItemInfo Get(int id)
        {
            if(DataList.ContainsKey(id))
            {
                return DataList[id];
            }
            else
            {
                return null;
            }
        }
    }
