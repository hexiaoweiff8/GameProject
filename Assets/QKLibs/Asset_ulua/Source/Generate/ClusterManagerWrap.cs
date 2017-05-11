﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ClusterManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(ClusterManager), typeof(System.Object));
		L.RegFunction("Do", Do);
		L.RegFunction("IsEnd", IsEnd);
		L.RegFunction("OnDestroy", OnDestroy);
		L.RegFunction("Add", Add);
		L.RegFunction("Init", Init);
		L.RegFunction("ClearAllGroup", ClearAllGroup);
		L.RegFunction("Pause", Pause);
		L.RegFunction("GoOn", GoOn);
		L.RegFunction("ClearAll", ClearAll);
		L.RegFunction("GetGroupById", GetGroupById);
		L.RegFunction("New", _CreateClusterManager);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("MovementPlanePosition", get_MovementPlanePosition, set_MovementPlanePosition);
		L.RegVar("MovementWidth", get_MovementWidth, set_MovementWidth);
		L.RegVar("MovementHeight", get_MovementHeight, set_MovementHeight);
		L.RegVar("ForwardAngle", get_ForwardAngle, set_ForwardAngle);
		L.RegVar("CollisionWeight", get_CollisionWeight, set_CollisionWeight);
		L.RegVar("CollisionThrough", get_CollisionThrough, set_CollisionThrough);
		L.RegVar("Friction", get_Friction, set_Friction);
		L.RegVar("GroupList", get_GroupList, set_GroupList);
		L.RegVar("Single", get_Single, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateClusterManager(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				ClusterManager obj = new ClusterManager();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: ClusterManager.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Do(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			obj.Do();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsEnd(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			bool o = obj.IsEnd();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnDestroy(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			obj.OnDestroy();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Add(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			PositionObject arg0 = (PositionObject)ToLua.CheckUnityObject(L, 2, typeof(PositionObject));
			obj.Add(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 7);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 5);
			int arg4 = (int)LuaDLL.luaL_checknumber(L, 6);
			int[][] arg5 = ToLua.CheckObjectArray<int[]>(L, 7);
			obj.Init(arg0, arg1, arg2, arg3, arg4, arg5);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearAllGroup(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ClusterManager.ClearAllGroup();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			obj.Pause();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GoOn(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			obj.GoOn();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearAll(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ClusterManager obj = (ClusterManager)ToLua.CheckObject(L, 1, typeof(ClusterManager));
			obj.ClearAll();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGroupById(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			ClusterGroup o = ClusterManager.GetGroupById(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MovementPlanePosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			UnityEngine.Vector3 ret = obj.MovementPlanePosition;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementPlanePosition on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MovementWidth(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.MovementWidth;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementWidth on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MovementHeight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.MovementHeight;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementHeight on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ForwardAngle(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.ForwardAngle;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ForwardAngle on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CollisionWeight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.CollisionWeight;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index CollisionWeight on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CollisionThrough(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.CollisionThrough;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index CollisionThrough on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Friction(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float ret = obj.Friction;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Friction on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GroupList(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, ClusterManager.GroupList);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Single(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, ClusterManager.Single);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MovementPlanePosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.MovementPlanePosition = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementPlanePosition on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MovementWidth(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.MovementWidth = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementWidth on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MovementHeight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.MovementHeight = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index MovementHeight on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ForwardAngle(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.ForwardAngle = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ForwardAngle on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CollisionWeight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.CollisionWeight = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index CollisionWeight on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CollisionThrough(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.CollisionThrough = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index CollisionThrough on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Friction(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ClusterManager obj = (ClusterManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.Friction = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Friction on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GroupList(IntPtr L)
	{
		try
		{
			System.Collections.Generic.List<ClusterGroup> arg0 = (System.Collections.Generic.List<ClusterGroup>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<ClusterGroup>));
			ClusterManager.GroupList = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

