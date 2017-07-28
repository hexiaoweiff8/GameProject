using UnityEngine;
using System.Collections;

public class ConsoleCloseAction : ConsoleAction {
    public override void Activate() {
        ConsoleGUI._ins.gameObject.SetActive(false);
    }
}
