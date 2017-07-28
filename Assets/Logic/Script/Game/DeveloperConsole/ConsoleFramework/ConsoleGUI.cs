using UnityEngine;
using DeveloperConsole.CommandFramework;

public class ConsoleGUI : MonoBehaviour
{
    public static ConsoleGUI        _ins;

    //Action
    private ConsoleSubmitAction     submitAction;
    private ConsoleCloseAction      escapeAction;
    //Variable
    public UIInput                  input;
    public UITextList               output;
    //View
    private UITextList              _logCat;
    private UIInput                 _inputField;

    private void Awake()
    {
        _ins = this;
        CommandRegister._ins.Register(typeof(CommandBase).Assembly);

        InitView();
        input = _inputField;
        output = _logCat;

        submitAction = new ConsoleSubmitAction();
        escapeAction = new ConsoleCloseAction();
    }

    void Update()
    {
        HandleSubmit();
        HandleEscape();
    }

    private void InitView()
    {
        _logCat = transform.Find("Logger/LogCat").GetComponent<UITextList>();
        _inputField = transform.Find("InputField").GetComponent<UIInput>();
    }

    private void HandleSubmit()
    {
        if (Input.GetKeyDown(KeyCode.KeypadEnter) || Input.GetKeyDown(KeyCode.Return))
        {
                submitAction.Activate();
        }
    }

    private void HandleEscape()
    {
        if (Input.GetKeyDown(KeyCode.Escape) || Input.GetKeyDown(KeyCode.BackQuote))
        {
            escapeAction.Activate();
        }
    }
}