using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using LuaInterface;
//using UniLua;
using UnityEngine;
using UnityEngine.SceneManagement;
public class SDataUtils
{
    /// <summary>
    /// 根据从lua传来的head和body表构建c#中的字典，两处数据永远一致
    /// <param name="index">构建的序号</param>
    /// <param name="table1">head表</param>
    /// <param name="table2">body表</param>
    /// </summary>
    public static void setData(string index, LuaTable table1, LuaTable table2)
    {

        switch (index)
        {
            case "mapData":
                {
                    SData_mapdata.AutoInstance();
                    SData_mapdata.Single.setData(table1, table2);
                }
                break;
            case "constant":
                {
                    SData_Constant.AutoInstance();
                    SData_Constant.Single.setData(table1, table2);
                }
                break;
            case "armyaim_c":
                {
                    SData_armyaim_c.AutoInstance();
                    SData_armyaim_c.Single.setData(table1, table2);
                }
                break;
            case "armyaoe_c":
                {
                    SData_armyaoe_c.AutoInstance();
                    SData_armyaoe_c.Single.setData(table1, table2);
                }
                break;
            case "effect_c":
                {
                    SData_effect_c.AutoInstance();
                    SData_effect_c.Single.setData(table1, table2);
                }
                break;
            case"unitfight_c":
                {
                    SData_UnitFightData_c.AutoInstance();
                    SData_UnitFightData_c.Single.setData(table1, table2);
                }
                break;
            case "armybase_c":
                {
                    SData_armybase_c.AutoInstance();
                    SData_armybase_c.Single.setData(table1, table2);
                }
                break;
            case "armycardbase_c":
                {
                    SData_armycardbase_c.AutoInstance();
                    SData_armycardbase_c.Single.setData(table1, table2);
                }
                break;
            case "array_c":
                {
                    SData_array_c.AutoInstance();
                    SData_array_c.Single.setData(table1, table2);
                }
                break;
            case "soldierRender":
                {
                    SData_soldierRender_data.AutoInstance();
                    SData_soldierRender_data.Single.setData(table1, table2);
                }
                break;
            case "kezhi_c":
            {
                SData_kezhi_c.AutoInstance();
                SData_kezhi_c.Single.setData(table1, table2);
            }
                break;
        }
    }

    /// <summary>
    /// 遍历lua表
    /// <param name="table">需要遍历的表</param>
    /// <param name="ac">对表数据的操作委托</param>
    /// </summary>
    public static void dealTable(LuaTable table, Action<object, object> ac)
    {
        LuaDictTable dict = table.ToDictTable();
        table.Dispose();
        var iter2 = dict.GetEnumerator();

        while (iter2.MoveNext())
        {
            ac(iter2.Current.Key, iter2.Current.Value);
        }

        iter2.Dispose();
        dict.Dispose();
    }
}