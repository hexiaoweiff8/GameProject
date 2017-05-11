/// The modified version of this software is Copyright (C) 2013 ZHing.
/// The original version's copyright as below.

using UnityEngine;
using System.Collections;

using HTMLEngine; 
using HTMLEngine.NGUI;

public class NGUIDemoLight : MonoBehaviour
{

  public UILabel lastLinkText;

  public UIScrollBar scrollBar;

  private const string demo0 =
      @"<p align=center><font face=0 size=24>Picture12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 <img src='0/power_' fps=10 id='anim'> <font color=yellow>HTMLEngine</font>for<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p><br>" +
      @"<a href='plaintextlink' id='simple'><img src='1/unity' >" +
      @"Simple plain text link.</a>";

  private const string demo1 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<p align=left>Without effect:</p>
<p align=center>Normal text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></p>
<p align=center><b>Bold text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></b></p>
<p align=center><i>Italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></p>
<p align=center><b><i>Bold and italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></b></p>
<p align=left>Shadow effect:</p>
<effect name=shadow color=black>
<p align=center>Normal text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></p>
<p align=center><b>Bold text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></b></p>
<p align=center><i>Italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></p>
<p align=center><b><i>Bold and italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></b></p>
</effect>
<p align=left>Outline effect:</p>
<effect name=outline color=black>
<p align=center>Normal text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></p>
<p align=center><b>Bold text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></b></p>
<p align=center><i>Italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></p>
<p align=center><b><i>Bold and italic text&nbsp;<u>underlined</u>&nbsp;<s>striked</s></i></b></p>
</effect>
";

  private const string demo2 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<font size=24>
<br><spin id='outlined' align=center><effect name=outline color=#FFFFFF80><font color=black>Outlined text</font></effect></spin>
<p align=center><effect name=outline color=yellow><font color=black>Outlined yellow text</font></effect></p>
<p align=center><effect name=outline color=#FFFFFF80 amount=2>Some stuppid effect i got</effect></p>
<p align=center><effect name=shadow>Default shadowed text</effect></p>
<p align=center><effect name=shadow color=black>Strong-shadowed text</effect></p>
<p align=center><effect name=shadow color=#FFFFFF80 amount=2>Some shadowed text</effect></p>
</font>
    ";

  private const string demo3 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<br><p align=justify>Justify aligned text. Justify aligned text. Justify aligned text. Justify aligned text. Justify aligned text. Justify aligned text. Justify aligned text. Justify aligned text.</p>
<br><p align=center><font color=gray>Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text. Centered text.</font></p>
<br><p align=right>Right aligned text. Right aligned text. Right aligned text. Right aligned text. Right aligned text. Right aligned text. Right aligned text. Right aligned text. Right aligned text.</p>
<br><p align=left><font color=gray>Left aligned text. Left aligned text. Left aligned text. Left aligned text. Left aligned text. Left aligned text. Left aligned text. Left aligned text. Left aligned text.</font></p>
        ";

  private const string demo4 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<br><p align=center valign=top>Picture <img src='smiles/sad'> with &lt;p valign=top&gt;</p>
<br><p align=center valign=middle>Picture <img src='smiles/smile'> with &lt;p valign=middle&gt; much better than others in this case <img src='smiles/cool'></p>
<br><p align=center valign=bottom>Picture <img src='smiles/sad'> with &lt;p valign=bottom&gt;</p>
<br><p align=center valign=bottom>Picture <img src='faces/power_' fps=10 id='anim'> with &lt;img fps=10&gt;</p>
<br><p align=justify valign=bottom><img src='logos/unity'> is a feature rich, fully integrated development engine for the creation of interactive 3D content. It provides complete, out-of-the-box functionality to assemble high-quality, high-performing content and publish to multiple platforms.</p>
<br><p align=center><img src='logos/unity2'></p>
        ";

  private const string demo5 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<br><p align=center>Now we try to make something dynamic inside text markup...</p>
<br><p align=center valign=middle>Due to performance we can not parse text every frame <img src='smiles/sad'>, but we can reserve some place to draw things inside compiled html! <img src='smiles/cool'></p>
<br><p align=center>It's possible with img tag. Look at source.</p>
<br><p align=center><img src='#time'></p>
<br><p align=center>With same technique we can render animated pictures and even results from render targets.</p>
";

  private const string demo6 =
      @"<p align=center><font face=title size=24><font color=yellow>HTMLEngine</font>&nbsp;for&nbsp;<font color=lime>Unity3D.GUI</font>&nbsp;and&nbsp;<font color=lime>NGUI</font></font></p>
<br>
<br><p align=center>Links support</p>
<br><p align=left valign=middle>1)&nbsp;<a href='plaintextlink' id='simple'>Simple plain text link.</a></p>
<br><p align=left valign=middle>2)&nbsp;<a href='textandimage'>Simple text and <img src='smiles/smile'> image link.</a></p>
<br><p align=left valign=middle>3)&nbsp;<a href='biglink1'>Multiline link <img src='smiles/smile'>.</a>&nbsp;<a href='biglink2'>Multiline link <img src='smiles/smile'>. Multiline link <img src='smiles/smile'>. Multiline link <img src='smiles/smile'>. Multiline link <img src='smiles/smile'>. Multiline link <img src='smiles/smile'>.</a></p>
<br><br><p align=center>Try to click around and see to left-bottom corner for results</p>
<br><br><p align=center>At last we have some basic stuff to interact with player</p>
";

  private NGUIHTML html;

  private bool updateTime = false;

  public void Awake() {  
    html = GetComponent<NGUIHTML>();
    html.html = demo0;
  }

  public void FixedUpdate() {
    if (updateTime) {
      foreach (Transform childTr in transform) {
        if (childTr.name == "time") {
          var lab = childTr.GetComponent<UILabel>();
          if (lab != null) {
            var now = System.DateTime.Now;
            lab.text = string.Format("{0:D2}:{1:D2}:{2:D2}.{3:D3}", now.Hour, now.Minute, now.Second, now.Millisecond);
          }
        }
			}
    }
  }

  internal void onBtnDemoClicked(GameObject senderGo) {
    updateTime = false;

    switch (senderGo.name) {
    case "BtnDemo1":
      html.html = demo0;
      break;
    case "BtnDemo2":
      html.html = demo1;
      break;
    case "BtnDemo3":
      html.html = demo2;
      break;
    case "BtnDemo4":
      html.html = demo3;
      break;
    case "BtnDemo5":
      html.html = demo4;
      break;
    case "BtnDemo6":
      html.html = demo5;
      updateTime = true;
      break;
    case "BtnDemo7":
      html.html = demo6;
      break;
    }

    //scrollBar.scrollValue = 0f;
  }

  internal void onLinkClicked(GameObject senderGo) {
    var nguiLinkText = senderGo.GetComponent<NGUILinkText>();
    if (nguiLinkText != null) {
      Debug.Log(nguiLinkText.linkText);
      if (lastLinkText != null) lastLinkText.text = "Last Link Text: [FFFF00]" + nguiLinkText.linkText + "[-]";
    }
  }
}
