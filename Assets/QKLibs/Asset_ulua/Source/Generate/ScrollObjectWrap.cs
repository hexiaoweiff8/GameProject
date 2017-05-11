﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ScrollObjectWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(ScrollObject), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("JumpTo", JumpTo);
		L.RegFunction("JumpOffset", JumpOffset);
		L.RegFunction("MoveTo", MoveTo);
		L.RegFunction("MoveOffset", MoveOffset);
		L.RegFunction("MoveEnd", MoveEnd);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("GizmosCubeColor", get_GizmosCubeColor, set_GizmosCubeColor);
		L.RegVar("Owner", get_Owner, set_Owner);
		L.RegVar("m_MoveRecord", get_m_MoveRecord, set_m_MoveRecord);
		L.RegVar("bounds", get_bounds, null);
		L.RegVar("ScrollViewPosition", get_ScrollViewPosition, null);
		L.RegVar("ScrollLogicPosition", get_ScrollLogicPosition, null);
		L.RegVar("showHandles", get_showHandles, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int JumpTo(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ScrollObject obj = (ScrollObject)ToLua.CheckObject(L, 1, typeof(ScrollObject));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.JumpTo(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int JumpOffset(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ScrollObject obj = (ScrollObject)ToLua.CheckObject(L, 1, typeof(ScrollObject));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.JumpOffset(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveTo(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ScrollObject obj = (ScrollObject)ToLua.CheckObject(L, 1, typeof(ScrollObject));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.MoveTo(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveOffset(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ScrollObject obj = (ScrollObject)ToLua.CheckObject(L, 1, typeof(ScrollObject));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.MoveOffset(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveEnd(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			ScrollObject obj = (ScrollObject)ToLua.CheckObject(L, 1, typeof(ScrollObject));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
			bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
			obj.MoveEnd(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GizmosCubeColor(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			UnityEngine.Color ret = obj.GizmosCubeColor;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index GizmosCubeColor on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Owner(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			ScrollAreaLimiter ret = obj.Owner;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Owner on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_MoveRecord(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			MoveRecord ret = obj.m_MoveRecord;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_MoveRecord on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bounds(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			UnityEngine.Bounds ret = obj.bounds;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index bounds on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ScrollViewPosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			UnityEngine.Vector3 ret = obj.ScrollViewPosition;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ScrollViewPosition on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ScrollLogicPosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			UnityEngine.Vector3 ret = obj.ScrollLogicPosition;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ScrollLogicPosition on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_showHandles(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			bool ret = obj.showHandles;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index showHandles on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GizmosCubeColor(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			UnityEngine.Color arg0 = ToLua.ToColor(L, 2);
			obj.GizmosCubeColor = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index GizmosCubeColor on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Owner(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			ScrollAreaLimiter arg0 = (ScrollAreaLimiter)ToLua.CheckUnityObject(L, 2, typeof(ScrollAreaLimiter));
			obj.Owner = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Owner on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_MoveRecord(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ScrollObject obj = (ScrollObject)o;
			MoveRecord arg0 = (MoveRecord)ToLua.CheckObject(L, 2, typeof(MoveRecord));
			obj.m_MoveRecord = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_MoveRecord on a nil value" : e.Message);
		}
	}
}

