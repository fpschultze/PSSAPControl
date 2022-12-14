<#
.SYNOPSIS
    Connect to the SAPControl web service interface.

.DESCRIPTION
    Returns a sapstartsrv web service proxy object for the given SAP host and instance number.
    Optionally, authenticates with user and password.

.EXAMPLE
    $sap = Connect-PSSAPControl -ComputerName saphost1 -InstanceNumber 01
    Connects without authentication in order to call a simple WebMethod like GetProcessList.

.EXAMPLE
    $sap = Connect-PSSAPControl -ComputerName saphost1 -InstanceNumber 01 -Credential (Get-Credential)
    Authenticates with credential in order to call a protected WebMethod like ABAPGetWPTable.

.OUTPUTS
    <AutogeneratedType>.SAPControl
#>
function Connect-PSSAPControl {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^([0-8]\d{1}|9[0-7])$')]
        [string]
        $InstanceNumber,

        # Required to call a protected WebMethod.
        [Parameter()]
        [PSCredential]
        $Credential,

        # Switch has no effect.
        [Parameter()]
        [bool]
        $LegacyApi = $false
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters

    $urlTemplate = 'http://{0}:5{1}13/SAPHostAgent/?wsdl'
    $simpleIpRegEx = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

    $ErrorActionPreference = 'Stop'

    try {
			
        if ($ComputerName -match $simpleIpRegEx) {

            $fqdnOrIp = [ipaddress]$ComputerName  | Select-Object -ExpandProperty IPAddressToString
        }
        else {

            $fqdnOrIp = [System.Net.Dns]::GetHostByName($ComputerName) | Select-Object -ExpandProperty HostName
        }

        $wsdlUrl = $urlTemplate -f $fqdnOrIp, $InstanceNumber

        Write-Verbose ('WSDL Url: {0}' -f $wsdlUrl)


        # Connect

        if ($PSBoundParameters.ContainsKey('Credential')) {

            $Result = New-WebServiceProxy -Uri $wsdlUrl -Credential $Credential
        }
        else {

            $Result = New-WebServiceProxy -Uri $wsdlUrl
        }


#        New-Variable -Name PSSAPControlLegacyApi -Value $LegacyApi -Scope Script -Force

        New-Variable -Name PSSAPControlEvent -Value ($Result | Get-Member -MemberType Event | Select-Object -ExpandProperty Name) -Scope Script -Force

        # The variables below are a workaround because we had trouble with New-WebServiceProxy's Namespace parameter
        # when we used to connect to multiple SAP hosts successively within a single powershell runspace.
        # Each call of New-WebServiceProxy creates a new autogenerated class. We use these classes now.

        New-Variable -Name PSSAPControlNamespace -Value ($Result.GetType().Namespace) -Scope Script -Force

#        Get-Type -Namespace $PSSAPControlNamespace -IsEnum | ForEach-Object {
        $PSSAPControlNamespace | Get-EnumType | ForEach-Object {

            New-Variable -Name ('PSSAPControl{0}' -f $_.Name) -Value $_ -Scope Global -Force
        }


        #HACK: Set legacy API flag

        try {

            $null = New-Object -TypeName ('{0}.GetVersionInfo' -f $Script:PSSAPControlNamespace)

            $LegacyApi = $false
        }
        catch [System.Management.Automation.PSArgumentException] {

            $LegacyApi = $true
        }
        finally {

            New-Variable -Name PSSAPControlLegacyApi -Value $LegacyApi -Scope Script -Force
        }

        $returnValue = $Result
    }
    catch {

        Write-Error $_

        $returnValue = $null
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
