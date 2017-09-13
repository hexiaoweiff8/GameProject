using UnityEngine;

public class ConsoleInput : UIInput {

#if UNITY_EDITOR
    /*在InputField拥有焦点时监听键盘按键事件*/
    public override bool ProcessEvent(Event ev)
    {
        base.ProcessEvent(ev);

        var shift = (ev.modifiers & EventModifiers.Shift) != 0;
        var alt = (ev.modifiers & EventModifiers.Alt) != 0;

        switch (ev.keyCode)
        {
            /* @TODO: 完成自动补全功能 */
            case KeyCode.Tab:
                print("Precess Tab");
                break;
            /* @DONE: 添加追溯历史命令功能 */
            case KeyCode.UpArrow:
                value = ConsoleCommandHistory.previousCommand;
                break;
            case KeyCode.DownArrow:
                value = ConsoleCommandHistory.nextCommand;
                break;
            default:
                /* shift + alt = 全选 */
                if (shift && alt)
                {
                    ev.Use();
                    mSelectionStart = 0;
                    mSelectionEnd = mValue.Length;
                    UpdateLabel();
                }
                break;
        }

        return true;
    }
#endif

    //protected override void Update()
    //{
    //    base.Update();

    //    print("mSelectMe " + mSelectMe);
    //    print("mSelectionStart" + mSelectionStart);
    //    print("mSelectionEnd" + mSelectionEnd);
    //}
}
