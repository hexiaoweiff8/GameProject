#if DEBUG
using UnityEngine;

public class ConsoleToggler : MonoBehaviour
{
    private bool                 consoleEnabled;
    private ConsoleOpenAction    consoleOpenAction;
    private ConsoleCloseAction   consoleCloseAction;

    private void Awake()
    {
        var mConsole = Instantiate(Resources.Load<GameObject>("UI_Console/ui_console"),GameObject.Find("UIRoot").transform) as GameObject;
            mConsole.AddComponent<ConsoleGUI>();
            mConsole.transform.localScale = Vector3.one;
            mConsole.name = "ui_console";
            mConsole.gameObject.SetActive(false);

        consoleOpenAction = new ConsoleOpenAction();
        consoleCloseAction = new ConsoleCloseAction();

        consoleEnabled = mConsole.activeInHierarchy;
    }
    /* 监听触发按键 */
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.BackQuote))
        {
            ToggleConsole();
        }
    }
    /* 激活或隐藏开发者控制台 */
    private void ToggleConsole()
    {
        consoleEnabled = !consoleEnabled;

        if (consoleEnabled)
        {
            consoleOpenAction.Activate();
        }
        else
        {
            consoleCloseAction.Activate();
        }
    }
}
#endif