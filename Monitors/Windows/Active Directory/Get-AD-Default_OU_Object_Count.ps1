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
	$defaultOUs = @()
	if (Get-DefaultUserOU | Where-Object { $_ -match 'CN=' }) {
		$defaultous += $(Get-DefaultUserOU)
	}
	if (Get-DefaultComputerOU | Where-Object { $_ -match 'CN=' }) {
		$defaultous += $(Get-DefaultComputerOU)
	}
	if ($defaultous.count -gt 0) {
		Write-Output "ERROR: $($defaultous -join '; ')"
		exit 1
	} else {
		Write-Output "SUCCESS: $($defaultous -join '; ')"
		exit 0
	}
} catch {
	Write-Output "WARNING: $($_.exception.message)"
	exit 1
}
