Class App.Installer
{

XData setup
{
<Manifest>
	<Default Name="Namespace" Value="USER"/>
	<Default Name="SourceDir" Value="/opt/irisapp/src/Oliver"/>
	<Default Name="SYS" Value="%SYS"/>
	<Default Name="SysDir" Value="/opt/irisapp/src/OAuth2"/>
	<Default Name="ZAUTH" Value="/opt/irisapp/src/Web/OAUTH2/ZAUTHENTICATE.mac"/>
	<Namespace Name="${Namespace}" Create="no">
		<Import File="${SourceDir}" Flags="ck" Recurse="1"/>
	</Namespace>
	<Namespace Name="${SYS}" Create="no">
		<Import File="${SysDir}" Flags="ck" Recurse="1"/>
		<Import File="${ZAUTH}" Flags="ck" IgnoreErrors="0"/>
	</Namespace>
	
</Manifest>
}

ClassMethod setup(
	ByRef pVars,
	pLogLevel As %Integer = 3,
	pInstaller As %Installer.Installer,
	pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
