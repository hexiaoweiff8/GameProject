using UnityEngine;
using System.Collections;

public class ConsoleOpenAction : ConsoleAction {
    public override void Activate() {
        ConsoleGUI._ins.gameObject.SetActive(true);
    }
}
