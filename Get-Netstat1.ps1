function get-netstat{
    Param(
        $SortBy="LocalAddress"
    )
    Write-Host "Working..."
    $connections = Get-NetTCPConnection -State Listen
    $final = @()
    foreach ($conn in $connections){
        # get the process details and parentage
        $proc = Get-WmiObject win32_Process | Where-Object -Property processid -eq $conn.OwningProcess
        $parentproc = Get-WmiObject win32_Process | Where-Object -Property processid -eq $proc.parentprocessid
        if ($parentproc)
            {
                # construct a custom object that contains all the bits we want
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Value $conn.LocalAddress -Name LocalAddress
                $obj | Add-Member -MemberType NoteProperty -Value $conn.LocalPort -Name LocalPort
                $obj | Add-Member -MemberType NoteProperty -Value $conn.OwningProcess -Name OwningProcess
                $obj | Add-Member -MemberType NoteProperty -Value $proc.getowner().User -Name Owner
                $obj | Add-Member -MemberType NoteProperty -Value $proc.Name -Name ProcName
                $obj | Add-Member -MemberType NoteProperty -Value $proc.processid -Name ProcessID
                $obj | Add-Member -MemberType NoteProperty -Value $parentproc.getowner().User -Name ParentProcOwner
                $obj | Add-Member -MemberType NoteProperty -Value $parentproc.Name -Name ParentProcName
                $obj | Add-Member -MemberType NoteProperty -Value $parentproc.ProcessID -Name ParentProcID
                # print it all pretty like
               $final += $obj
            }
        else
            {
                $procerror = "Dead"
                # construct a custom object that contains all the bits we want
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Value $conn.LocalAddress -Name LocalAddress
                $obj | Add-Member -MemberType NoteProperty -Value $conn.LocalPort -Name LocalPort
                $obj | Add-Member -MemberType NoteProperty -Value $conn.OwningProcess -Name OwningProcess
                $obj | Add-Member -MemberType NoteProperty -Value $proc.getowner().User -Name Owner
                $obj | Add-Member -MemberType NoteProperty -Value $proc.Name -Name ProcName
                $obj | Add-Member -MemberType NoteProperty -Value $proc.processid -Name ProcessID
                $obj | Add-Member -MemberType NoteProperty -Value $procerror -Name ParentProcOwner
                $obj | Add-Member -MemberType NoteProperty -Value $procerror -Name ParentProcName
                $obj | Add-Member -MemberType NoteProperty -Value $proc.parentprocessid -Name ParentProcID
                # print it all pretty like
                $final += $obj
            }
    }
    $final | Sort-Object -Property $SortBy | Format-Table -AutoSize
}

get-netstat