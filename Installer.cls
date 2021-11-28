Class App.Installer
{

XData setup
{
<Manifest>
	<Default Name="Namespace" Value="USER"/>
	<Default Name="SourceDir" Value="/opt/irisapp/src/Oliver"/>
	<Namespace Name="${Namespace}" Create="no">
		<Import File="${SourceDir}" Flags="ck" Recurse="1"/>
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
