//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2015 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using UnityEditor;

[CanEditMultipleObjects]
[CustomEditor(typeof(UIGrabTexture))]
public class UIGrabTextureInspector : UITextureInspector
{ 
    
     public override void OnInspectorGUI ()
     {
         base.OnInspectorGUI();
         base.DrawDefaultInspector();
         UIGrabTexture obj = target as UIGrabTexture;
         obj.RenderLayer = EditorGUILayout.LayerField("渲染层", obj.RenderLayer);

         if(GUILayout.Button("Reposition"))
         {
             obj.Reposition();
         }
         
         /*
         //serializedObject.Update();

         //NGUIEditorTools.SetLabelWidth(100f);
         UIGrabTexture obj = target as UIGrabTexture;
         base.DrawDefaultInspector(); 
         GUILayout.Space(6f);
         GUI.changed = false;

         GUILayout.BeginHorizontal();
         SerializedProperty sp = NGUIEditorTools.DrawProperty("Group", serializedObject, "group", GUILayout.Width(120f));
         GUILayout.Label(" - zero means 'none'");
         GUILayout.EndHorizontal();

         EditorGUI.BeginDisabledGroup(sp.intValue == 0);
         NGUIEditorTools.DrawProperty("  State of 'None'", serializedObject, "optionCanBeNone");
         EditorGUI.EndDisabledGroup();

         NGUIEditorTools.DrawProperty("Starting State", serializedObject, "startsActive");
         NGUIEditorTools.SetLabelWidth(80f);

         if (NGUIEditorTools.DrawMinimalisticHeader("State Transition"))
         {
             NGUIEditorTools.BeginContents(true);
             NGUIEditorTools.DrawProperty("Sprite", serializedObject, "activeSprite");

             SerializedProperty animator = serializedObject.FindProperty("animator");
             SerializedProperty animation = serializedObject.FindProperty("activeAnimation");

             if (animator.objectReferenceValue != null)
             {
                 NGUIEditorTools.DrawProperty("Animator", animator, false);
             }
             else if (animation.objectReferenceValue != null)
             {
                 NGUIEditorTools.DrawProperty("Animation", animation, false);
             }
             else
             {
                 NGUIEditorTools.DrawProperty("Animator", animator, false);
                 NGUIEditorTools.DrawProperty("Animation", animation, false);
             }

             if (serializedObject.isEditingMultipleObjects)
             {
                 NGUIEditorTools.DrawProperty("Instant", serializedObject, "instantTween");
             }
             else
             {
                 GUI.changed = false;
                 Transition tr = toggle.instantTween ? Transition.Instant : Transition.Smooth;
                 GUILayout.BeginHorizontal();
                 tr = (Transition)EditorGUILayout.EnumPopup("Transition", tr);
                 NGUIEditorTools.DrawPadding();
                 GUILayout.EndHorizontal();

                 if (GUI.changed)
                 {
                     NGUIEditorTools.RegisterUndo("Toggle Change", toggle);
                     toggle.instantTween = (tr == Transition.Instant);
                     NGUITools.SetDirty(toggle);
                 }
             }
             NGUIEditorTools.EndContents();
         }

         NGUIEditorTools.DrawEvents("On Value Change", toggle, toggle.onChange);
         serializedObject.ApplyModifiedProperties(); */
     } 
    /*
    protected override void DrawCustomProperties()
    { 
        GUILayout.Space(6f);

        SerializedProperty sp = NGUIEditorTools.DrawProperty("Type", serializedObject, "mType", GUILayout.MinWidth(20f));

        UISprite.Type type = (UISprite.Type)sp.intValue;

        if (type == UISprite.Type.Simple)
        {
            NGUIEditorTools.DrawProperty("Flip", serializedObject, "mFlip");
        }
        else if (type == UISprite.Type.Tiled)
        {
            NGUIEditorTools.DrawBorderProperty("Trim", serializedObject, "mBorder");
            NGUIEditorTools.DrawProperty("Flip", serializedObject, "mFlip");
        }
        else if (type == UISprite.Type.Sliced)
        {
            NGUIEditorTools.DrawBorderProperty("Border", serializedObject, "mBorder");
            NGUIEditorTools.DrawProperty("Flip", serializedObject, "mFlip");

            EditorGUI.BeginDisabledGroup(sp.hasMultipleDifferentValues);
            {
                sp = serializedObject.FindProperty("centerType");
                bool val = (sp.intValue != (int)UISprite.AdvancedType.Invisible);

                if (val != EditorGUILayout.Toggle("Fill Center", val))
                {
                    sp.intValue = val ? (int)UISprite.AdvancedType.Invisible : (int)UISprite.AdvancedType.Sliced;
                }
            }
            EditorGUI.EndDisabledGroup();
        }
        else if (type == UISprite.Type.Filled)
        {
            NGUIEditorTools.DrawProperty("Flip", serializedObject, "mFlip");
            NGUIEditorTools.DrawProperty("Fill Dir", serializedObject, "mFillDirection", GUILayout.MinWidth(20f));
            GUILayout.BeginHorizontal();
            GUILayout.Space(4f);
            NGUIEditorTools.DrawProperty("Fill Amount", serializedObject, "mFillAmount", GUILayout.MinWidth(20f));
            GUILayout.Space(4f);
            GUILayout.EndHorizontal();
            NGUIEditorTools.DrawProperty("Invert Fill", serializedObject, "mInvert", GUILayout.MinWidth(20f));
        }
        else if (type == UISprite.Type.Advanced)
        {
            NGUIEditorTools.DrawBorderProperty("Border", serializedObject, "mBorder");
            NGUIEditorTools.DrawProperty("  Left", serializedObject, "leftType");
            NGUIEditorTools.DrawProperty("  Right", serializedObject, "rightType");
            NGUIEditorTools.DrawProperty("  Top", serializedObject, "topType");
            NGUIEditorTools.DrawProperty("  Bottom", serializedObject, "bottomType");
            NGUIEditorTools.DrawProperty("  Center", serializedObject, "centerType");
            NGUIEditorTools.DrawProperty("Flip", serializedObject, "mFlip");
        } 

        //NGUIEditorTools.DrawProperty("_Textures", serializedObject, "Textures");
       GUILayout.Space(26f);
        UIGrabTexture obj = target as UIGrabTexture;
        if(obj.OutTextures==null) obj.OutTextures = new UITexture[3];
        //NGUIEditorTools.DrawProperty("OutTextures", serializedObject, "OutTextures");
///serializedObject
        //Editor.DrawPropertiesExcluding(serializedObject, "OutTextures");
       // EditorGUILayout.PropertyField(serializedObject);

        GUILayout.Space(26f); 
//        base.DrawCustomProperties();

        //base.DrawDefaultInspector();
      //  SerializedProperty OutTextures = serializedObject.FindProperty("OutTextures");
     //   EditorGUILayout.PropertyField(OutTextures);

      //  serializedObject.ApplyModifiedProperties();
        //EditorGUILayout.InspectorTitlebar(obj.OutTextures);
        //EditorGUI
            //base.DrawDefaultInspector();
        //
     //   Editor xx = base.CreateEditor((Object)obj.Textures[0]);
    }*/
}
