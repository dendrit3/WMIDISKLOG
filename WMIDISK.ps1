# Written by Trent Schake


function wmidisk
{
    $triger = New-ScheduledTaskTrigger -Daily -At 7am
    $action = New-ScheduledTaskAction -Execute 'WMIDISK.ps1'


    New-Item C:\Windows\WMIDISK -type directory
    New-Item C:\Windows\WMIDISK\LOGS -type directory
    New-Item C:\WIndows\WMIDSIK\TASK -type directory

    $drive_ok = wmic diskdrive get status, model | select-string "OK"
    
    Set-ScheduledTask -Trigger $triger -Action $action -TaskName "WMIDISK"

    New-EventLog -LogName System -Source "WMIDISK"

    $drive_ok
    if ($drive_ok = "bad")
    {
        Write-EventLog -LogName System -EventId "6969" -Message "One or more of your drives are failing, you can see the log file in C:\Windows\WMIDISK\LOGS" -source "WMIDISK"

        $drive_ok | Out-File C:\Windows\WMIDISK\LOGS\MAJOR.txt

        
    }
    
    if ($drive_ok = "Unknown")
    {
        Write-EventLog -LogName System -EventId "4242" -Message "One or more of your drives has an unknown error, you can see the log file in C:\Windows\WMIDISK\LOGS" -Source "WMIDISK"
        $drive_ok | Out-File C:\Windows\LOGS\UNKNOW.txt

    }

    if ($drive_ok = "caution")
    {
        Write-EventLog -LogName System -EventID "9999" -Message "One or more of your drives has a caution error, you can see the log file in C:\Windows\WMIDISK\LOGS\CAUTIONERR.txt" -Source "WMIDISK"
        $drive_ok | Out-File C:\Windows\WMIDISK\LOGS\CAUTIONERR.txt


    }

}



wmidisk