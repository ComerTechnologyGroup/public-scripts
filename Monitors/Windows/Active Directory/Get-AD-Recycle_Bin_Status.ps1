Function Get-ADRecycleBinStatus {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    .NOTES
        General notes
    #>
    [CmdletBinding(SupportsShouldProcess, PositionalBinding, ConfirmImpact = 'Low')]
    [OutputType([String])]
    Param ()
    Begin {
            $StartTime = (Get-Date)
            Write-Verbose "[$($StartTime) BEGIN] Starting $($mycommand.myinvocation)"
    }
    Process {
        $Processtime = (Get-Date)
        Write-Verbose "[$($Processtime) PROCESS]"
        try{
        $RecycleBinScope = Get-ADOptionalFeature -Identity 'Recycle Bin Feature' -erroraction stop| Select-Object -ExpandProperty EnabledScopes
        } catch {
            Write-Output "WARNING: Could not determine status. $($_.Exception.message)"
            $exitcode = 1
            return
        }
        If ($PSCmdlet.ShouldProcess('Target', 'Operation')) {
            if ($null -eq $RecycleBinScope) {
                Write-Output 'ERROR: Recycle bin is disabled'
                $exitcode = 1
                return
            } else {
                Write-Output 'SUCCESS: Recycle bin is enabled'
                $exitcode = 0
                return
            }
        }
    }
    End {
        $EndTime = (Get-Date)
        $TotalTime = New-TimeSpan -Start $StartTime -End $EndTime
        Write-Verbose "[$($EndTime) END] Ending $($mycommand.myinvocation). Ran for $($TotalTime.TotalSeconds) seconds"
        exit $exitcode
    }
}

Get-ADRecycleBinStatus