﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LoopItemScrollViewWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LoopItemScrollView), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Init", Init);
		L.RegFunction("InitScrollView", InitScrollView);
		L.RegFunction("UpdateInBack", UpdateInBack);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("arrangeDirection", get_arrangeDirection, set_arrangeDirection);
		L.RegVar("itemPrefab", get_itemPrefab, set_itemPrefab);
		L.RegVar("itemsList", get_itemsList, set_itemsList);
		L.RegVar("datasList", get_datasList, set_datasList);
		L.RegVar("scrollView", get_scrollView, set_scrollView);
		L.RegVar("itemParent", get_itemParent, set_itemParent);
		L.RegVar("firstItem", get_firstItem, set_firstItem);
		L.RegVar("lastItem", get_lastItem, set_lastItem);
		L.RegVar("OnItemInit", get_OnItemInit, set_OnItemInit);
		L.RegVar("itemStartPos", get_itemStartPos, set_itemStartPos);
		L.RegVar("gapDis", get_gapDis, set_gapDis);
		L.RegVar("panelHeight", get_panelHeight, set_panelHeight);
		L.RegFunction("DelegateHandler", LoopItemScrollView_DelegateHandler);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			LoopItemScrollView obj = (LoopItemScrollView)ToLua.CheckObject(L, 1, typeof(LoopItemScrollView));
			System.Collections.Generic.List<LoopItemData> arg0 = (System.Collections.Generic.List<LoopItemData>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<LoopItemData>));
			LoopItemScrollView.DelegateHandler arg1 = null;
			LuaTypes funcType3 = LuaDLL.lua_type(L, 3);

			if (funcType3 != LuaTypes.LUA_TFUNCTION)
			{
				 arg1 = (LoopItemScrollView.DelegateHandler)ToLua.CheckObject(L, 3, typeof(LoopItemScrollView.DelegateHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 3);
				arg1 = DelegateFactory.CreateDelegate(typeof(LoopItemScrollView.DelegateHandler), func) as LoopItemScrollView.DelegateHandler;
			}

			obj.Init(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitScrollView(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)ToLua.CheckObject(L, 1, typeof(LoopItemScrollView));
			obj.InitScrollView();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateInBack(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 6);
			LoopItemScrollView obj = (LoopItemScrollView)ToLua.CheckObject(L, 1, typeof(LoopItemScrollView));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			string arg2 = ToLua.CheckString(L, 4);
			string arg3 = ToLua.CheckString(L, 5);
			int arg4 = (int)LuaDLL.luaL_checknumber(L, 6);
			obj.UpdateInBack(arg0, arg1, arg2, arg3, arg4);
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
	static int get_arrangeDirection(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemScrollView.ArrangeDirection ret = obj.arrangeDirection;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index arrangeDirection on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_itemPrefab(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.GameObject ret = obj.itemPrefab;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemPrefab on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_itemsList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			System.Collections.Generic.List<LoopItemObject> ret = obj.itemsList;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemsList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_datasList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			System.Collections.Generic.List<LoopItemData> ret = obj.datasList;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index datasList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_scrollView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UIScrollView ret = obj.scrollView;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index scrollView on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_itemParent(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.GameObject ret = obj.itemParent;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemParent on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_firstItem(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemObject ret = obj.firstItem;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index firstItem on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lastItem(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemObject ret = obj.lastItem;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index lastItem on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnItemInit(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemScrollView.DelegateHandler ret = obj.OnItemInit;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnItemInit on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_itemStartPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.Vector3 ret = obj.itemStartPos;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemStartPos on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_gapDis(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			float ret = obj.gapDis;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index gapDis on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_panelHeight(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushnumber(L, LoopItemScrollView.panelHeight);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_arrangeDirection(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemScrollView.ArrangeDirection arg0 = (LoopItemScrollView.ArrangeDirection)ToLua.CheckObject(L, 2, typeof(LoopItemScrollView.ArrangeDirection));
			obj.arrangeDirection = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index arrangeDirection on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_itemPrefab(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 2, typeof(UnityEngine.GameObject));
			obj.itemPrefab = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemPrefab on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_itemsList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			System.Collections.Generic.List<LoopItemObject> arg0 = (System.Collections.Generic.List<LoopItemObject>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<LoopItemObject>));
			obj.itemsList = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemsList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_datasList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			System.Collections.Generic.List<LoopItemData> arg0 = (System.Collections.Generic.List<LoopItemData>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<LoopItemData>));
			obj.datasList = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index datasList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_scrollView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UIScrollView arg0 = (UIScrollView)ToLua.CheckUnityObject(L, 2, typeof(UIScrollView));
			obj.scrollView = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index scrollView on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_itemParent(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 2, typeof(UnityEngine.GameObject));
			obj.itemParent = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemParent on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_firstItem(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemObject arg0 = (LoopItemObject)ToLua.CheckUnityObject(L, 2, typeof(LoopItemObject));
			obj.firstItem = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index firstItem on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lastItem(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemObject arg0 = (LoopItemObject)ToLua.CheckUnityObject(L, 2, typeof(LoopItemObject));
			obj.lastItem = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index lastItem on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnItemInit(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			LoopItemScrollView.DelegateHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (LoopItemScrollView.DelegateHandler)ToLua.CheckObject(L, 2, typeof(LoopItemScrollView.DelegateHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(LoopItemScrollView.DelegateHandler), func) as LoopItemScrollView.DelegateHandler;
			}

			obj.OnItemInit = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnItemInit on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_itemStartPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.itemStartPos = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index itemStartPos on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_gapDis(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LoopItemScrollView obj = (LoopItemScrollView)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.gapDis = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index gapDis on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_panelHeight(IntPtr L)
	{
		try
		{
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			LoopItemScrollView.panelHeight = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoopItemScrollView_DelegateHandler(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateFactory.CreateDelegate(typeof(LoopItemScrollView.DelegateHandler), func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateFactory.CreateDelegate(typeof(LoopItemScrollView.DelegateHandler), func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

