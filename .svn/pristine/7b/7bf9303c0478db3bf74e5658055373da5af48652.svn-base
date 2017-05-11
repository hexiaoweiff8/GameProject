/// The modified version of this software is Copyright (C) 2013 ZHing.
/// The original version's copyright as below.

using UnityEngine;
using System.Collections;

using HTMLEngine;
using HTMLEngine.NGUI;

[AddComponentMenu("QK/UI/NGUIHtml")]
public class NGUIHTML : MonoBehaviour {

  public enum AutoScrollType {
		MANUAL,
		AUTO_TOP,
		AUTO_BOTTOM,
  }

  public UIAtlas Fillatlas = null;
  public Color LinkHoverColor = new Color(1f, 0.2666666666666667f, 0.2666666666666667f);
  public float LinkPressedFactor = 0.5f;

  public string _html = "";
  //public int maxLineWidth = 0;
  public AutoScrollType autoScroll = AutoScrollType.MANUAL;

  public UIFont[] fonts = null;//字体列表


  public UIAtlas[] imgs = null;//图集
  /// <summary>
  /// is the html content changed?
  /// </summary>
  private bool changed = false;

  /// <summary>
  /// our html compiler
  /// </summary>
  private HtCompiler compiler;

  /// <summary>
  /// setting text here will raise changed flag
  /// </summary>
  public string html {
    get { return this._html; }
    set {
      this._html = value;
      this.changed = true;
    }
  }

  static bool m_HtEngineInitd = false;

  void Awake()
  {
      //初始化html引擎

      if (m_HtEngineInitd) return;

      m_HtEngineInitd = true;

      // our logger
      HtEngine.RegisterLogger(new HTMLEngineLogger());
      // our device
      HtEngine.RegisterDevice(new NGUIDevice());

      // link function name.
      HtEngine.LinkFunctionName = "OnLinkClick";

  }

  void Start() {
    compiler = HtEngine.GetCompiler();

  
  }

  void OnEnable() { CoroutineManage.Single.RegComponentUpdate(IUpdate); }

    /*
  internal void onLinkClicked(GameObject senderGo)
  {
      var nguiLinkText = senderGo.GetComponent<NGUILinkText>();
      if (nguiLinkText != null)
      { 
          //Debug.Log("xxx " + nguiLinkText.linkText);
      }
  }*/

  void IUpdate()
  {
      if (changed && compiler != null)
      {

          // link hover color.
          HtEngine.LinkHoverColor = HtColor.RGBA(
              (byte)(LinkHoverColor.r*255),
              (byte)(LinkHoverColor.g*255),
              (byte)(LinkHoverColor.b*255),
              (byte)(LinkHoverColor.a*255)
              );
          // link pressed factor.
          HtEngine.LinkPressedFactor = LinkPressedFactor;

          //设置字体列表
          NGUIFont.FontList = fonts;

          NGUIImage.imgs = imgs;

          //设置填充图集
          NGUIDevice.Fillatlas = Fillatlas;

          UIWidget cmWidget = gameObject.GetComponent<UIWidget>();

          // we have new html text, so compile it
          compiler.Compile(html, cmWidget != null ? cmWidget.width : Screen.width);

          //根据本控件的对齐方式，进行偏移修正
          {
              switch (cmWidget.pivot)
              {
                  case UIWidget.Pivot.Center:
                      compiler.Offset(-cmWidget.width/2, -cmWidget.height / 2);
                      break;
                  case UIWidget.Pivot.Top:
                      compiler.Offset(-cmWidget.width / 2,0);
                      break;
                  case UIWidget.Pivot.Left:
                      compiler.Offset(0, -cmWidget.height / 2);
                      break; 
                  case UIWidget.Pivot.TopRight:
                      compiler.Offset(-cmWidget.width, 0);
                      break;
                  case UIWidget.Pivot.Right:
                      compiler.Offset(-cmWidget.width, -cmWidget.height / 2);
                      break;
                  case UIWidget.Pivot.BottomLeft:
                      compiler.Offset(0, -cmWidget.height );
                      break;
                  case UIWidget.Pivot.Bottom:
                      compiler.Offset(-cmWidget.width / 2, -cmWidget.height);
                      break;
                  case UIWidget.Pivot.BottomRight:
                      compiler.Offset(-cmWidget.width, -cmWidget.height);
                      break;
              }
          }
         
         

          // destroy old widgets.
          foreach (Transform childTr in transform)
              Destroy(childTr.gameObject);

          // generate the widgets.
          compiler.Draw(Time.deltaTime, transform);

          // release changed flag
          changed = false;

          if (autoScroll != AutoScrollType.MANUAL)
          {
              StartCoroutine(updateAutoScroll());
          }
      }
  }
    //  private void OnGUI(){}
    

  void OnDestroy() {
    // we need to dispose compiler to prevent GC
    if (compiler != null) {
      compiler.Dispose();
      compiler = null;
    }

    CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
  }

  private IEnumerator updateAutoScroll() {
    yield return new WaitForEndOfFrame();

    var uiDraggablePanel = NGUITools.FindInParents<UIScrollView>(gameObject);
    if (uiDraggablePanel != null) {
      
      switch (autoScroll) {
      case AutoScrollType.AUTO_TOP:
        uiDraggablePanel.SetDragAmount(0,0,true);
        break;
      case AutoScrollType.AUTO_BOTTOM:
        uiDraggablePanel.SetDragAmount(0,1,true);
        break;
      }
      uiDraggablePanel.ResetPosition();
    }
  }
}
