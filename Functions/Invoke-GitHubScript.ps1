function Invoke-GithubScript {
    <#
    .SYNOPSIS
    Calls Github Script from RMM Script
    #>
    param (
        # Sets the URL of the script to download the script
        [Parameter(mandatory = $false, position = 1, ValueFromPipeline = $false)]
        [string]
        $ScriptURL,
        [Parameter(mandatory = $false, position = 2, ValueFromPipeline = $false)]
        [string]
        $Function
    )
    try {
        Add-Type -AssemblyName System.Web
        foreach ($paramName in $MyInvocation.MyCommand.Parameters.keys) {
            $paramValue = Get-Variable -Scope Local -Name $paramName -ValueOnly -ErrorAction SilentlyContinue
            if ($paramName -in ('ScriptURL', 'Function') -and $null -eq $paramValue) {
                Write-Output "ERROR: Parameter $paramName is not set"
                exit 1
            }
        }
        $url                                        = [System.Web.HttpUtility]::UrlDecode($ScriptURL)
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wc                                         = New-Object System.Net.WebClient
        $url = "$ScriptURL"
        $url = $url.replace('/blob', '').replace('github.com', 'raw.githubusercontent.com').replace('[A-Za-z0-9]{40}\/', '')
        $wc.Headers.Add('Accept', 'application/vnd.github.v3.raw')
        $wc.Headers.Add('X-GitHub-Api-Version', '2022-11-28')
        $wc.Headers.Add('Content-Type', 'application/json;charset=UTF-8')
        $wc.DownloadString("$URL") | Invoke-Expression
        $Function
    } catch {
        Write-Output "ERROR: $($_.Exception.message)"
    }
}
Invoke-GithubScript -ScriptURL 'https://github.com/ComerTechnologyGroup/public-scripts/blob/main/Scripts/Get-Services.ps1'
