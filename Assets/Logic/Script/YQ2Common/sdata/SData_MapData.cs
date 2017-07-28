using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_mapdata : MonoEX.Singleton<SData_mapdata>
{
    public void setData(LuaTable table1, LuaTable table2)
    {
        var head = new string[table1.Length];
        SDataUtils.dealTable(table1, (Object o1, Object o2) =>
        {
            head[(int)(double)o1 - 1] = (string)o2;
        });
        SDataUtils.dealTable(table2, (Object o1, Object o2) =>
        {
            mapdataInfo dif = new mapdataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "MapMaxRow": dif.MapMaxRow = (short)(double)o22; break;
					case "MapMaxColumn": dif.MapMaxColumn = (short)(double)o22; break;
					case "terrain_cell_bianchang": dif.terrain_cell_bianchang = (short)(double)o22; break;
					case "Camera_XOffsetMin": dif.Camera_XOffsetMin = (float)(double)o22; break;
					case "Camera_XOffsetMax": dif.Camera_XOffsetMax = (float)(double)o22; break;
					case "Camera_YOffsetMin": dif.Camera_YOffsetMin = (float)(double)o22; break;
					case "Camera_YOffsetMax": dif.Camera_YOffsetMax = (float)(double)o22; break;
					case "Camera_ZOffsetMin": dif.Camera_ZOffsetMin = (float)(double)o22; break;
					case "Camera_ZOffsetMax": dif.Camera_ZOffsetMax = (float)(double)o22; break;
					case "Camera_RotationMin": dif.Camera_RotationMin = (float)(double)o22; break;
					case "Camera_RotationMax": dif.Camera_RotationMax = (float)(double)o22; break;
					case "FreeCamera_Scale": dif.FreeCamera_Scale = (float)(double)o22; break;
					case "FreeCamera_Scale_End": dif.FreeCamera_Scale_End = (float)(double)o22; break;
					case "CameraY_Xuanzhuan_Start": dif.CameraY_Xuanzhuan_Start = (float)(double)o22; break;
					case "CameraY_Xuanzhuan_End": dif.CameraY_Xuanzhuan_End = (float)(double)o22; break;
					case "FreeCamera_Scale_StopRange_Min": dif.FreeCamera_Scale_StopRange_Min = (float)(double)o22; break;
					case "FreeCamera_Scale_StopRange_Max": dif.FreeCamera_Scale_StopRange_Max = (float)(double)o22; break;
					case "CameraY_Xuanzhuan_StopRange_Min": dif.CameraY_Xuanzhuan_StopRange_Min = (float)(double)o22; break;
					case "CameraY_Xuanzhuan_StopRange_Max": dif.CameraY_Xuanzhuan_StopRange_Max = (float)(double)o22; break;
					case "FreeCamera_Scale_Speed": dif.FreeCamera_Scale_Speed = (float)(double)o22; break;
					case "FreeCameraXmin": dif.FreeCameraXmin = (float)(double)o22; break;
					case "FreeCameraXmax": dif.FreeCameraXmax = (float)(double)o22; break;
					case "FreeCameraZmin": dif.FreeCameraZmin = (float)(double)o22; break;
					case "FreeCameraZmax": dif.FreeCameraZmax = (float)(double)o22; break;
					case "CameraY_XuanzhuanMin": dif.CameraY_XuanzhuanMin = (float)(double)o22; break;
					case "CameraY_XuanzhuanMax": dif.CameraY_XuanzhuanMax = (float)(double)o22; break;
					case "CameraY_XuanzhuanSpeed": dif.CameraY_XuanzhuanSpeed = (float)(double)o22; break;
					case "Camera_ZhuanshenTime": dif.Camera_ZhuanshenTime = (short)(double)o22; break;
					case "Camera_Rotate_Radius": dif.Camera_Rotate_Radius = (float)(double)o22; break;
					case "Camera_Rotate_Yoffset": dif.Camera_Rotate_Yoffset = (float)(double)o22; break;
					case "Camera_Rotate_Speed": dif.Camera_Rotate_Speed = (float)(double)o22; break;
					case "Camera_ZhuanshenCD": dif.Camera_ZhuanshenCD = (short)(double)o22; break;
					case "Camera_Overall_Yoffset": dif.Camera_Overall_Yoffset = (float)(double)o22; break;
					case "Camera_Overall_Zoffset": dif.Camera_Overall_Zoffset = (float)(double)o22; break;
					case "Camera_Overall_Yrotate": dif.Camera_Overall_Yrotate = (float)(double)o22; break;
					case "Camera_Overall_Xrotate": dif.Camera_Overall_Xrotate = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public mapdataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("mapdataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, mapdataInfo> Data = new Dictionary<int, mapdataInfo>();
}


public struct mapdataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///
	 /// </summary>
	public short MapMaxRow;
	 /// <summary>
	 ///
	 /// </summary>
	public short MapMaxColumn;
	 /// <summary>
	 ///
	 /// </summary>
	public short terrain_cell_bianchang;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_XOffsetMin;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_XOffsetMax;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_YOffsetMin;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_YOffsetMax;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_ZOffsetMin;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_ZOffsetMax;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_RotationMin;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_RotationMax;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCamera_Scale;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCamera_Scale_End;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_Xuanzhuan_Start;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_Xuanzhuan_End;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCamera_Scale_StopRange_Min;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCamera_Scale_StopRange_Max;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_Xuanzhuan_StopRange_Min;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_Xuanzhuan_StopRange_Max;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCamera_Scale_Speed;
	 /// <summary>
	 ///相机左侧最大值
	 /// </summary>
	public float FreeCameraXmin;
	 /// <summary>
	 ///相机右侧最大值
	 /// </summary>
	public float FreeCameraXmax;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCameraZmin;
	 /// <summary>
	 ///
	 /// </summary>
	public float FreeCameraZmax;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_XuanzhuanMin;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_XuanzhuanMax;
	 /// <summary>
	 ///
	 /// </summary>
	public float CameraY_XuanzhuanSpeed;
	 /// <summary>
	 ///
	 /// </summary>
	public short Camera_ZhuanshenTime;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_Rotate_Radius;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_Rotate_Yoffset;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_Rotate_Speed;
	 /// <summary>
	 ///
	 /// </summary>
	public short Camera_ZhuanshenCD;
	 /// <summary>
	 ///相机高度
	 /// </summary>
	public float Camera_Overall_Yoffset;
	 /// <summary>
	 ///相机Z轴偏移
	 /// </summary>
	public float Camera_Overall_Zoffset;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_Overall_Yrotate;
	 /// <summary>
	 ///
	 /// </summary>
	public float Camera_Overall_Xrotate;
}
