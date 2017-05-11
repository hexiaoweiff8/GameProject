/// The modified version of this software is Copyright (C) 2013 ZHing.
/// The original version's copyright as below.

/* Copyright (C) 2012 Ruslan A. Abdrashitov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
and associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions 
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE. */

using UnityEngine;

namespace HTMLEngine.NGUI
{
    /// <summary>
    /// Provides font for use with HTMLEngine. Implements abstract class.
    /// </summary>
    public class NGUIFont : HtFont
    {
        /// <summary>
        /// style to draw
        /// </summary>
        //public readonly GUIStyle style = new GUIStyle();
        UIFont m_font;
        
        /// <summary>
        /// content to draw
        /// </summary>
        public readonly GUIContent content = new GUIContent();
        /// <summary>
        /// Width of whitespace
        /// </summary>
        //private readonly int whiteSize;

        public static UIFont[] FontList = null;

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="face">Font name</param>
        /// <param name="size">Font size</param>
        /// <param name="bold">Bold flag</param>
        /// <param name="italic">Italic flag</param>
        public NGUIFont(string face, int size, bool bold, bool italic)
            : base(face, size, bold, italic)
        { 
            // creating key to load from resources
            //string key = string.Format("{0}{1}{2}{3}", face, size, bold ? "b" : "", italic ? "i" : "");
            int fontIndex;
            if(!int.TryParse(face,out fontIndex))
            {
                Debug.LogError(string.Format("NGUIFont 错误的字体id:{0}", face));
            }

            if(FontList==null)
            {
                Debug.LogError(string.Format("NGUIFont 字体列表为空" ));
            }

            if(fontIndex<0||fontIndex>FontList.Length)
            {
                Debug.LogError(string.Format("NGUIFont 字体索引号超界"));
            }

            m_font = FontList[fontIndex];

         
            if (m_font == null)
            {
                Debug.LogError("Could not load font: " + fontIndex.ToString());
            }
             
        }

        /// <summary>
        /// Space between text lines in pixels
        /// </summary>
        public override int LineSpacing
        {
            get
            { 
                return this.Size;
        } }

        /// <summary>
        /// Space between words
        /// </summary>
        public override int WhiteSize { get { 
            return this.Size;
        } }

        /// <summary>
        /// Measuring text width and height
        /// </summary>
        /// <param name="text">text to measure</param>
        /// <returns>width and height of measured text</returns>
        public override HtSize Measure(string text)
        {
            this.content.text = text; 
            Vector2 r;
            {
                if (m_font.isDynamic)
                {
                   NGUIText.dynamicFont = m_font.dynamicFont;
                   NGUIText.fontStyle = m_font.dynamicFontStyle;
                }
                else
                {
                    NGUIText.bitmapFont = m_font;
                }
                NGUIText.fontSize = this.Size; //m_font.size; 

                 
                r = NGUIText.CalculatePrintedSize(text);
                NGUIText.fontSize = 16;
                NGUIText.bitmapFont = null;
                NGUIText.dynamicFont = null;
            }  
            return new HtSize((int)r.x, (int)r.y);
        }

        /// <summary>
        /// Draw method.
        /// </summary>
        /// <param name="rect">Where to draw</param>
        /// <param name="color">Text color</param>
        /// <param name="text">Text</param>
        /// <param name="isEffect">Is effect</param>
        /// <param name="effect">Effect</param>
        /// <param name="effectColor">Effect color</param>
        /// <param name="effectAmount">Effect amount</param>
        /// <param name="linkText">Link text</param>
        /// <param name="userData">User data</param>
        public override void Draw(string id, HtRect rect, HtColor color, string text, bool isEffect, Core.DrawTextEffect effect, HtColor effectColor, int effectAmount, string linkText, object userData)
        { 
            if (isEffect) return;

            var root = userData as Transform;
            if (root != null)
            {
                var go = new GameObject(string.IsNullOrEmpty(id) ? "label" : id, typeof(UILabel));
                go.layer = root.gameObject.layer;
                go.transform.parent = root;
                go.transform.localPosition = new Vector3(rect.X + rect.Width / 2, -rect.Y - rect.Height / 2, 0f);
                go.transform.localScale = Vector3.one;//Vector3.zero; //new Vector3(this.style.font.fontSize, this.style.font.fontSize, 1f);
                var lab = go.GetComponent<UILabel>();
                lab.pivot = UIWidget.Pivot.Center;
                lab.supportEncoding = false;
                 
                    lab.bitmapFont = m_font; 
                lab.fontSize = this.Size; 
                lab.text = text;
                lab.color = new Color32(color.R, color.G, color.B, color.A);
                switch (effect)
                {
                    case Core.DrawTextEffect.Outline:
                        lab.effectStyle = UILabel.Effect.Outline;
                        break;
                    case Core.DrawTextEffect.Shadow:
                        lab.effectStyle = UILabel.Effect.Shadow;
                        break;
                }

                if (this.Bold && this.Italic)
                    lab.fontStyle = FontStyle.BoldAndItalic;
                else if (this.Bold)
                    lab.fontStyle = FontStyle.Bold;
                else if (this.Italic)
                    lab.fontStyle = FontStyle.Italic;

                   
                lab.effectColor = new Color32(effectColor.R, effectColor.G, effectColor.B, effectColor.A);
                lab.effectDistance = new Vector2(effectAmount, effectAmount);
                lab.MakePixelPerfect();
   
                lab.width = rect.Width+1;
                lab.height = rect.Height+1;
                // build link.
                if (!string.IsNullOrEmpty(linkText))
                {
                    var collider = go.AddComponent<BoxCollider>();
                    collider.isTrigger = true;
                    
                    lab.autoResizeBoxCollider = true;
                    lab.ResizeCollider();

                    var nguiLinkText = go.AddComponent<NGUILinkText>();
                    nguiLinkText.linkText = linkText;

                    var uiButtonColor = go.AddComponent<UIButtonColor>();
                    uiButtonColor.tweenTarget = go;
                    uiButtonColor.hover = new Color32(
                      HtEngine.LinkHoverColor.R,
                      HtEngine.LinkHoverColor.G,
                      HtEngine.LinkHoverColor.B,
                      HtEngine.LinkHoverColor.A);
                    uiButtonColor.pressed = new Color(
                      lab.color.r * HtEngine.LinkPressedFactor,
                      lab.color.g * HtEngine.LinkPressedFactor,
                      lab.color.b * HtEngine.LinkPressedFactor, lab.color.a);
                    uiButtonColor.duration = 0f;

                    var uiButtonMessage = go.AddComponent<UIButtonMessage>();
                    uiButtonMessage.target = root.gameObject;
                    uiButtonMessage.functionName = HtEngine.LinkFunctionName;
                }
            }
            else
            {
                HtEngine.Log(HtLogLevel.Error, "Can't draw without root.");
            }
        }
    }
}