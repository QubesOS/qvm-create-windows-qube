' Confirm reboot after xenvif driver installation, based on allow-drivers.vbs
' This is called by qvm-create-windows-qube directly, after QWT gets detected by dom0

Set wshShell = WScript.CreateObject("WScript.Shell")
timeout = 60

Do
    ' Set focus to window with given window title
    isFocused = wshShell.AppActivate("Xen", 0)

    ' If focus is successful
    If isFocused = True Then
        ' WScript.Echo "Found 'Xen' prompt, confirming it"
        ' Press "i" (ALT key) to install device software
        wshShell.SendKeys "{ENTER}"
        Exit Do
    End If

    WScript.Sleep 1000
    timeout = timeout - 1
    If timeout <= 0 Then
        'WScript.Echo "Timeout waiting for 'Xen' prompt"
        Exit Do
    End If
Loop
