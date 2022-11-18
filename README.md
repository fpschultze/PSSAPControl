# PSSAPControl

Windows PowerShell Module. Exposes wrapper functions for several SAPControl SOAP WebMethods:

*Connect-PSSAPControl*
Connects to the SAPControl web service interface.
Returns a sapstartsrv web service proxy object for the given SAP host and instance number.

*Get-PSSAPInstance*
Calls SAPControl's GetSystemInstanceList WebMethod.
Returns a list of all instances on a SAP host.

*Get-PSSAPInstanceAsync*
Calls SAPControl's GetSystemInstanceListAsync WebMethod.
Returns a list of all instances on a SAP host.

*Get-PSSAPInstanceFeature*
Queries the features of a SAP instance.

*Get-PSSAPParameterValue*
Calls SAPControl's ParameterValue WebMethod.
Returns a SAP profile parameter value for a given profile parameter, or it returns all known parameter value pairs.

*Get-PSSAPProcessList*
Calls SAPControl's GetProcessList WebMethod.
Returns a list of all processes directly started by the SAPControl web service according to the SAP start profile.

*Get-PSSAPVersionInfo*
Calls SAPControl's GetVersionInfo WebMethod.

*Invoke-PSSAPOSCommand*
Calls SAPControl's OSExecute WebMethod.
Executes a command line, waits, and returns Exitcode, PID, and output lines.

*Restart-PSSAPControl*
Uses SAPControl's RestartService WebMethod to restart a sapstartsrv Web service.

*Set-PSSAPControlCredential*
Sets or changes the Credential property of an existing SAPControl web service connection.

*Set-PSSAPControlUrl*
Connects to a different SAPControl using the an existing SAPControl web service connection by changing the URL.

*Start-PSSAPInstance*
Uses SAPControl's Start WebMethod to start a SAP instance. Start triggers an instance start.

*Start-PSSAPSystem*
Uses SAPControl's StartSystem WebMethod to trigger the start of a complete SAP system or parts of it.

*Stop-PSSAPControl*
Uses SAPControl's StopService WebMethod to stop a SAPControl web service.

*Stop-PSSAPInstance*
Uses SAPControl's Stop WebMethod to stop a SAP instance. Stop triggers an instance stop.

*Stop-PSSAPSystem*
Uses SAPControl's StopSystem WebMethod to trigger the stop of a complete SAP system or parts of it.

*Test-PSSAPInstance*
Queries the status of a SAP instance and returns $true when the status is 'GREEN'.
