function Get-DefaultComputerOU {
	$a = [adsisearcher]'(&(objectclass=domain))'
	$a.SearchScope = 'base'
	$a.FindOne().properties.wellknownobjects | ForEach-Object {
		if ($_ -match '^B:32:AA312825768811D1ADED00C04FD8D5CD:(.*)$') {
			'[Computers]{0}' -f $matches[1]
		}
	}
}

Function Get-DefaultUserOU {
	$a = [adsisearcher]'(&(objectclass=domain))'
	$a.SearchScope = 'base'
	$a.FindOne().properties.wellknownobjects | ForEach-Object {
		if ($_ -match '^B:32:A9D1CA15768811D1ADED00C04FD8D5CD:(.*)$') {
			'[Users]{0}' -f $matches[1]
		}
	}
}

#endregion Functions
try {
	$defaultOUs = New-Object -TypeName System.Collections.Generic
	if (Get-DefaultUserOU | Where-Object { $_ -match 'CN=' }) {
		$defaultous.add($(Get-DefaultUserOU)) | Out-Null
	}
	if (Get-DefaultComputerOU | Where-Object { $_ -match 'CN=' }) {
		$defaultous.add($(Get-DefaultComputerOU)) | Out-Null
	}
	if ($defaultous.count -gt 0) {
		Write-Output "ERROR: $($defaultous -join '; ')"
	} else {
		Write-Output "SUCCESS: $($defaultous -join '; ')"
	}
} catch {
	Write-Output "WARNING: $($_.exception.message)"
	exit 1
}
