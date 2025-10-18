Class ZIRIS.DevHub.Admin.Config.Dashboard Extends ZIRIS.DevHub.Portal.Template
{
Parameter APPLICATION = "IRIS Configuration Dashboard";

Parameter CATEGORY = "Monitoring";

Parameter Title As STRING [ Final ] = "IRIS Configuration Dashboard";

Parameter Sections As COSEXPRESSION = "$LB(""System"",""Configuration"",""Namespaces"",""Databases"",""RemoteDataBase"",""Journals"",""Memory"",""License"",""Task"",""Introperability"",""Security"",""LDAP"",""X509"",""SSLConfig"",""WebApps"",""Audit"",""Monitoring"",""SQLAndObject"",""Sharding"",""Mirror"",""WebGateway"",""ECP"",""DocDB"",""FHIR"",""ExternalGateway"",""WQM"",""Python"",""ZPM"")";

Property Sections [ MultiDimensional ];

Property SystemProps [ MultiDimensional ];

ClassMethod OnPage() As %Status
{
	Do ..OnPageCSPROOT()
	Return $$$OK
}

Method %OnNew() As %Status
{
	Do ..InitilizeSystemProps()
	Return $$$OK
}

ClassMethod RenderHTML()
{
	Set obj = ..%New()
	Do obj.CollectInfo()
	Do obj.GenerateHTML()
	Quit $$$OK
}

Method CollectInfo()
{
	New $NAMESPACE
	Set $NAMESPACE="%SYS"
	Set ptr = 0
	While $ListNext(..#Sections, ptr, method) {
		Do $Method(, $ZCVT(method,"W"))
	}
	Quit
}

Method GenerateHTML()
{
	Write "<Header>"
	Write "<div class=""header-content"">"
	Write "<h1><i class=""fas fa-server""></i> "_..#Title_"</h1>"
	Write " <div class=""header-actions"">"
    Set systemType = ##class(%SYSTEM.Version).SystemMode()
    If systemType'="" {
	    Write "<p class=""system-badge system-"_$ZCVT(systemType,"L")_""" title="""_..GetVersion()_""">"_$ZCVT(systemType,"W")_" System</p>"
    }
	Write "<button class=""toggle-btn"" id=""toggleAllBtn"" onclick=""toggleAll()"">"
	Write "<i class=""fas fa-compress-alt""></i> Collapse All"
	Write "</button>"
	Write "<button class=""export-btn"" onclick=""exportToHTML()"">"
	Write "<i class=""fas fa-download""></i> Export to HTML"
	Write "</button>"
	Write "<button class=""export-btn"" onclick=""location.reload()"">Refresh </button>"
	Write "<button class=""export-btn"" id=""themeToggle"" onclick=""toggleTheme()"">"
	Write "<i class=""fas fa-moon""> </i>"
	Write "</button>"
	Write "</div>"
	Write "</div>"
	Write "</header>"
	#; header ends
	#; Container starts
	Write "<div class=""container"">"
	#; menu button
	Write "<div class=""button-row"">"
	Set ptr=0
	While $ListNext(..#Sections, ptr, section) {
		Set val1 = $ZCVT(section,"l")
		Continue:..HealthRelevantMenu(val1)
		Write "<button class=""section-btn active"" onclick=""toggleSection('"_val1_"')"">"
		Write "<i class=""fas "_..Icons(val1)_"""></i>"
		Write section
		Write "</button>"
	}
	Write " </div>"
	While $ListNext(..#Sections, ptr, val) {
		Do ..PrintContainer(val)
	}
	Write "</div>"
	#; ScrollTop arrow
	Write "<div>"
	Write "<button class=""fab1"" onclick=""scrollToTop()"">"
	Write "<i class=""fas fa-arrow-up""></i>"
	Write "</button>"
	Write "</div>"
	Do ..Scripts()
	Quit
}

Method Namespaces() [ Internal ]
{
 	Set tResult = ##Class(Config.Namespaces).ListFunc()
 	Do ..CreateDataFromSQL(tResult,.table)
 	Set ..Sections($$$CurrentMethod,"Namespaces")=table
}

Method Configuration() [ Internal ]
{
	Merge Properties = ..SystemProps("Compatibility")
	Set ..Sections($$$CurrentMethod,"Compatibility") = ..DrawHTMLTable(.Properties)
	Kill Properties
	Merge Properties = ..SystemProps("AdvancedMemory")
	Set ..Sections($$$CurrentMethod,"Advanced Memory") = ..DrawHTMLTable(.Properties)
	Kill Properties
	Merge Properties = ..SystemProps("Startup")
	Set ..Sections($$$CurrentMethod,"Startup") = ..DrawHTMLTable(.Properties)
}

Method Memory() [ Internal ]
{
	Set fields=$LB("bbsiz","globals8kb","globals16kb","globals32kb","globals64kb","routines","globals4kb","gmheap","jrnbufs")
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th><th>Recommanded</th></thead>"
	Set table = table_"<tbody>"
	Set ptr=0
	While $ListNext(fields, ptr, field) {
		Set fullName = ..FullName(field)
		Set table=table_"<tr><td>"_fullName_"</td><td>"_..SystemProps("AdvancedMemory",field)_"</td><td>"_$G(recommanded)_"</td><tr>"
	}
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	Set ..Sections($$$CurrentMethod,"Startup Memory")=table
}

Method Webapps() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(Security.Applications).ListFunc(),.table)
	Set ..Sections($$$CurrentMethod)=table
}

Method System() [ Internal ]
{
	Set section = $NA(..Sections($$$CurrentMethod))
	Set tSC = ##class(%CSP.UI.Portal.API).GetSystemInfo(.pObject)
	Set @section@("TableHeader")=$LB("Name","Value")
	Set @section@(1,"System")=$Piece($SYSTEM,":")_", Instance: "_$P($SYSTEM,":",2)
	Set @section@(2,"Version")=pObject.CacheVerStr_" ["_pObject.ComponentVersionList_"]"
	Set @section@(3,"OS")=##class(%SYSTEM.Version).GetOS()
	Set @section@(4,"Installed Dir")=$System.Util.InstallDirectory()
	Set @section@(5,"IP Address")=pObject.IPAddress
	Set @section@(6,"Web port")=pObject.WebPort
	Set @section@(7,"Licensed to")=pObject.LicenseTo
	Set @section@(8,"Superserver Port ")=pObject.SuperserverPort
	Set @section@(9,"System Mode")=##class(%SYSTEM.Version).SystemMode()
	Set cpuObj = ##class(%SYSTEM.CPU).%New()
	Set @section@(10,"Architecture")=cpuObj.Arch
	Set @section@(11,"Model")=cpuObj.Model
	Set @section@(12,"Vendor")=cpuObj.Vendor
	Set @section@(13,"64 bit") =..BoolToStr(##class(%SYSTEM.Version).Is64Bits())
	Set @section@(14,"Cores")=cpuObj.nCores
	Set @section@(15,"Cores Per Chip")=cpuObj.nCoresPerChip
	Set @section@(16,"Threads")=cpuObj.nThreads
	Set @section@(17,"Multi Thread Enabled")=..BoolToStr(cpuObj.MTEnabled)
	Set @section@(18,"Multi Thread Supported")=..BoolToStr(cpuObj.MTSupported)
	Set @section@(19,"Unicode")=..BoolToStr(##class(%SYSTEM.Version).IsUnicode())
	Set @section@(20,"Endian")=$Select(##class(%SYSTEM.Version).IsBigEndian():"Big Endian",1:"Little Endian")
}

Method Externalgateway() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(Config.Gateways).ListShortFunc(),.table)
	Set ..Sections($$$CurrentMethod)=table
}

Method Journals() [ Internal ]
{
	Merge ..Sections($$$CurrentMethod) = ..SystemProps("Journal")
	Do ..CreateDataFromSQL(##Class(%SYS.Journal.File).ByTimeReverseOrderFunc(),.table)
	Set ..Sections($$$CurrentMethod,"JournalFiles") = table
}

Method Mirror() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(SYS.Mirror).MirroredDatabaseListFunc(),.table)
	Set ..Sections($$$CurrentMethod,"Mirrored DB List") = table
}

Method Ecp() [ Internal ]
{
	Merge Properties = ..SystemProps("ECP")
	Set ..Sections($$$CurrentMethod,"Basic") = ..DrawHTMLTable(.Properties)
	//data server
	Do ..CreateDataFromSQL(##class(Config.ECPServers).StatusListSMPFilterFunc(), .table)
	Set ..Sections($$$CurrentMethod,"ECP Data Server") = table
	// application server
	Do ..CreateDataFromSQL(##class(SYS.ECP).ClientListFunc(), .table)
	Set ..Sections($$$CurrentMethod,"ECP Application Server") = table
}

Method Webgateway() [ Internal ]
{
	Set Reg=$SYSTEM.CSP.GetGatewayRegistry()
	Set activeMgrs=Reg.GetGatewayMgrs("a")
	Set inactiveMgrs=Reg.GetGatewayMgrs("i")
	Set table="<table>"
	Set table = table_"<thead><th>Server</th><th>Status</th></thead>"
	Set table = table_"<tbody>"
	Set webgatewayTab = ""
	For i=1:1:activeMgrs.Count() {
		#dim MgrImplObj As %CSP.Mgr.GatewayMgrImpl = activeMgrs.GetAt(i)
		Do MgrImplObj.GetServers(.servers)
		Set ptr=0
		While $ListNext(servers,ptr,server) {
			Set table = table_"<tr><td>"_$P(server,"=")_"</td><td>"_$P(server,"=",2)_"</td></tr>"

		}
		Set webgatewayTab = webgatewayTab_"<table><thead><th>Server</th><th>Status</th></thead><tbody>"
		Set GetWebServerInfo = MgrImplObj.GetInfo(.GatewayInfoObj)
		Set properties = $LB("WebServerName","Version","WebServerPort","WebServerSoftware","Build","ActiveInterface","Configuration","EventLog")
		Set ptr=0
		While $ListNext(properties,ptr,prop) {
			Set webgatewayTab =webgatewayTab _"<tr><td>"_prop_"</td><td>"_$Property(GatewayInfoObj,prop)_"</td></tr>"
		}
		Set webgatewayTab = webgatewayTab_"</tbody></table>"
	}
	Set table = table_"</tbody></table>"
	Set ..Sections($$$CurrentMethod,"Active Gateway Information") = webgatewayTab
	Set ..Sections($$$CurrentMethod,"ServersList") = table

	Set webgatewayTab = ""
	For i=1:1:inactiveMgrs.Count() {
		Set MgrImplObj  = inactiveMgrs.GetAt(i)
		Set webgatewayTab = webgatewayTab_"<table><thead><th>Server</th><th>Status</th></thead><tbody>"
		Set GetWebServerInfo = MgrImplObj.GetInfo(.GatewayInfoObj)
		Set properties = $LB("WebServerName","Version","WebServerPort","WebServerSoftware","Build","ActiveInterface","Configuration","EventLog")
		Set ptr=0
		While $ListNext(properties,ptr,prop) {
			Set webgatewayTab =webgatewayTab _"<tr><td>"_prop_"</td><td>"_$Property(GatewayInfoObj,prop)_"</td></tr>"
		}
		Set webgatewayTab = webgatewayTab_"</tbody></table>"
	}
	Set ..Sections($$$CurrentMethod,"Inactive Gateway Information") = webgatewayTab
}

Method Wqm() [ Internal ]
{
	If $$$ClassExist("Config.WorkQueues"){
		Set result = ##class(Config.WorkQueues).ListFilterFunc()
	}
	ElseIf $$$ClassExist("WQM.API"){
		Set result = ##class(WQM.API).MaxActiveWorkersFunc()
	}
	Do ..CreateDataFromSQL(result,.table)
	Set ..Sections($$$CurrentMethod,"WQM List")=table
}

Method Python() [ Internal ]
{
	If '$$$ClassExist("%SYS.Python") Q ""
#if $$$CacheVersionMajor>=2024
	Do ##class(%SYS.Python).GetPythonInfo(.pyInfo)
	Set ..Sections($$$CurrentMethod,"Python Info")=..DrawHTMLTable(.pyInfo)
#else
	Set ..Sections($$$CurrentMethod,"Python Info")="No data found"
#endif
}

Method License() [ Internal ]
{
	Try {Do ##class(%CSP.UI.Portal.License.Utils).GetLicenseInfo(.License)}Catch ex {}
	Set ..Sections($$$CurrentMethod,"License Key")=..DrawHTMLTable(.License)
	Do ..CreateDataFromSQL(##class(Config.LicenseServers).ListFunc(),.table)
	Set ..Sections($$$CurrentMethod,"License Servers")=table
}

Method Security() [ Internal ]
{
	Do ##Class(Security.System).Get("SYSTEM",.Properties)
	Set ..Sections($$$CurrentMethod,"Authentication/Web Session Options ")=..DrawHTMLTable(.Properties)
	Set ..Sections($$$CurrentMethod,"System-wide Security Parameters")=..DrawHTMLTable(.Properties)
}

Method Sslconfig() [ Internal ]
{
	Do ..CreateDataFromSQL(##Class(Security.SSLConfigs).ListFunc(),.table)
	Set ..Sections($$$CurrentMethod)=table
}

Method Ldap() [ Internal ]
{
	Do ..CreateDataFromSQL(##Class(Security.LDAPConfigs).ListFunc(),.table)
	Set ..Sections($$$CurrentMethod)=table
}

Method X509() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(%SYS.X509Credentials).ListDetailsFunc(),.table)
 	Set ..Sections($$$CurrentMethod)=table
}

Method Audit() [ Internal ]
{
	Set IsAuditEnabled =$Select( $LG(^SYS("Security","SystemD","SYSTEM"),2):"Enabled",1:"Disabled")
	Set ..Sections($$$CurrentMethod)="Audit database: "_"<b class="""_$ZCVT(IsAuditEnabled,"l")_""">"_IsAuditEnabled_"</b>"
	Do ..CreateDataFromSQL(##class(Security.Events).ListAllSystemFunc(),.table)
	Set ..Sections($$$CurrentMethod,"System Audit Events")=table
	Do ..CreateDataFromSQL(##class(Security.Events).ListAllUserFunc(),.table)
	Set ..Sections($$$CurrentMethod,"User-Defined Audit Events")=table
}

Method CreateDataFromSQL(ResultSet, Output table As %String)
{
	Kill table
	Set table="<Table>"
	Set table=table_"<thead>"
	Set colCount = ResultSet.%GetMetadata().columnCount
	For I=1:1:colCount {
		Set table=table_"<th>"_ResultSet.%GetMetadata().columns.GetAt(I).colName_"</th>"
	}
	Set table=table_"</thead>"
	Set table=table_"<tbody>"
	While ResultSet.%Next() {
		Set table=table_"<tr>"
		For i=1:1:ResultSet.%GetMetadata().columnCount {
			Set table=table_"<td>"_..EscapeHTML(ResultSet.%GetData(i))_"</td>"
		}
		Set table=table_"</tr>"
	}
	Set table=table_"</tbody>"
	Set table=table_"</table>"
}

ClassMethod ChangeFormats(ChangeFormats, Data)
{
	If ChangeFormats="bool" {
		Set Data= $Select(Data:"True",1:"False")
	}
	ElseIf ChangeFormats="checkbox" {
		If Data=1 {
			Set Data = "<i class=""fa-solid fa-square-check""></i>"
		}
		ElseIf Data=0 {
			Set Data = "<i class=""fa-regular fa-square""></i>"
		}
	}
	Else {
	}
	Return Data
}

Method PrintContainer(Container As %String = "")
{
	Return:Container=""
	Set Container = $ZCVT(Container,"l")
	Write "<div id="""_Container_""" class=""section-content"">",!
	Write "<div class=""section-header"">",!
	Write "<div class=""section-title"">",!
	Write "<div class=""section-icon""><i class=""fas fa-info-circle""></i></div>"
	Write $ZCVT(Container,"W")_" Information"
	Write "</div>",!
	Write "<button class=""minimize-btn"" onclick=""minimizeSection('"_Container_"', event)"">"
	Write " <i class=""fas fa-minus""></i>"
    Write "</button>",!
    Write "</div>",!
    Write "<div class=""table-container"">",!
    If ..Sections(Container)'=""{
	    Write "<h3>"_..Sections(Container)_"<h3>",!
    }
    Write "<table>"
    Write "<thead>"
    Write "<tr>"
    Set ptr=0
    While $ListNext(..Sections(Container,"TableHeader"),ptr,heading) {
	 Write "<th>"_heading_"</th>"
    }
    Write "</tr>"
    Write "</thead>"
    ; body
    Write "<tbody>"
    Set section=""
    Set section=""
    For {
	    Set section=$O(..Sections(Container, section), 1, data) Quit:section=""
	    continue:section="TableHeader"
	    If $Data(..Sections(Container, section))=1 {
		    Write "<tr>"
		    Write "<td><b>"_section_"</b></td>"
		    Write "<td>"_data_"</td>"
		    Write "<td></td>"
		    Write "</tr>"
	    }
	    ElseIf $Data(..Sections(Container, section))=10 {
		    Set sec = $O(..Sections(Container, section,""),1,data)
		     Write "<tr>"
		    Write "<td><b>"_sec_"</b></td>"
		    Write "<td>"_data_"</td>"
		    Write "<td></td>"
		    Write "</tr>"
	    }

    }
    Write "</tbody>",!
    Write "</table>",!
    Write "</div>",!
    Write "</div>",!
}

Method Task() [ Internal ]
{
	Set ..Sections($$$CurrentMethod)="Most tasks are system-related. Please exercise caution before suspending. If suspension is necessary, consult with the system administrator first"
	Do ..CreateDataFromSQL(##Class(%SYS.Task).OnDemandTasksFilterFunc(),.table)
	Set ..Sections($$$CurrentMethod,"TaskList")=table
}

Method Databases() [ Internal ]
{
	Do ..CreateDataFromSQL(##Class(Config.Databases).LocalDatabaseListFilterFunc(),.databases)
	Set ..Sections($$$CurrentMethod,"Databases")=databases
}

Method Sqlandobject() [ Internal ]
{
	Set tSC = ##class(%CSP.UI.Portal.SQL.Utils).GetConfigSQLProperties(.Properties)
	If $$$ISOK(tSC) {
		Set ..Sections($$$CurrentMethod,"SQL")=..DrawHTMLTable(.Properties)
	}
	Kill Properties
	Set Properties(..EscapeHTML("Throw <SWIZZLE FAIL> error when swizzling an object fails "))=$G(^%SYS("ThrowSwizzleError"),0)
	Set ..Sections($$$CurrentMethod,"Objects")=..DrawHTMLTable(.Properties,"checkbox")
}

Method Remotedatabase() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(Config.Databases).ListFilterFunc(,,2),.databases)
	Set ..Sections($$$CurrentMethod,"RemoteDatabases")=databases
}

Method Docdb() [ Internal ]
{
	Set tResult = ##Class(Security.DocDBs).ListFunc()
	Set files="<table>"
	Set files=files_"<thead>"
	Set files=files_"<th>Name</th><th>Namespace</th><th>Enabled Resource</th>"
	Set files=files_"</thead>"
	Set files=files_"<tbody>"
	While tResult.%Next() {
		Set files=files_"<tr>"_"<td>"_tResult.Name_"</td>"_"<td>"_tResult.Get("Namespace")_"<td>"_tResult.Get("Enabled Resource")_"</td>"_"</tr>"
	}
	Set files=files_"<tbody>"
	Set files=files_"</table>"
	Set ..Sections($$$CurrentMethod,"DB List")=files
}

Method Introperability() [ Internal ]
{
	Do ..GetInteropStatus()
}

Method GetInteropStatus()
{
	Set namespace=""
	For {
		Set namespace=$O(^|"^^"_$ZU(12)|SYS("CONFIG","IRIS","Namespaces",namespace)) Quit:namespace=""
		Kill table
		New $NAMESPACE
		try {Set $NAMESPACE=namespace}catch {continue}
		If '##class(%Dictionary.ClassDefinition).%ExistsId("Ens.Config.Production") continue
		Continue:'$D(^Ens.Config.ProductionD)
		Do ..CreateDataFromSQL(##Class(Ens.Config.Production).ProductionStatusFunc(),.table)
		Set ..Sections("introperability",namespace)=table
	}
}

Method Fhir()
{
	If $system.Version.GetISCComponents()="" Quit
	New $NAMESPACE
	Set $NAMESPACE="HSLIB"	
	Do ..CreateDataFromSQL(##class(HS.Util.Installer.ConfigItem).ConfigurationFunc(),.table)
	Set ..Sections($$$CurrentMethod,"Foundation Namespace")=table
}

Method Monitoring() [ Internal ]
{
	Set ..Sections($$$CurrentMethod,"MONMGR")=..MONMGR()
	//Set ..Sections($$$CurrentMethod,"HealthMonitor")=..HelathMonitor()
	Set ..Sections($$$CurrentMethod,"Trace")=..Trace()
	Set ..Sections($$$CurrentMethod,"SystemPerformance")=..SystemPerformance()
	Set ..Sections($$$CurrentMethod,"Structured Logging")=..LOGDMN()
	Set ..Sections($$$CurrentMethod,"SNMP")=..SNMP()
}

Method MONMGR() [ Internal ]
{
	If '$D(^["%SYS"]ISCMonitor("Monitor")) Q "<h4>No MONMGR configured</h4>"
	Set m=""
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th>"
	Set table = table_"<tbody>"
	Set table=table_"<tr><td>Status</td><td>"_$Case(+##Class(%SYS.Monitor).IsUp(),1:"Running",0:"Not Running",:"")_"</td>"
	F {
		Set m =$O(^["%SYS"]ISCMonitor("Monitor",m),1,data) Q:m=""
		If $ListValid(data) Set data=$LTS(data)
		Set table=table_"<tr><td>"_m_"</td><td>"_data_"</td></tr>"
	}
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	q table
}

Method Trace() [ Internal ]
{
	If '$$$ClassExist("%SYS.Trace") Quit ""
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th></thead>"
	Set table = table_"<tbody>"
	Set table=table_"<tr><td>Directory</td><td>"_##class(%SYS.Trace).GetDirectory()_"</td></tr>"
	Set table=table_"<tr><td>Events</td><td>"_##class(%SYS.Trace).GetEvents()_"</td></tr>"
	Set table=table_"<tr><td>FileSize</td><td>"_##class(%SYS.Trace).GetMaxSize()_"</td></tr>"
	Set table=table_"<tr><td>Process</td><td>"_$LTS(##class(%SYS.Trace).PIDList())_"</td></tr>"
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	quit table
}

Method LOGDMN() [ Internal ]
{
	Set CONFIG=$NA(^CONFIG("Logging"))
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th></thead>"
	Set table = table_"<tbody>"
	Set table=table_"<tr><td>Status</td><td>"_$Case(+##class(SYS.LogDmn).Status(),1:"Running",0:"Not Running",:"")_"</td></tr>"
	Set table=table_"<tr><td>Log level</td><td>"_@CONFIG@("Level")_"</td></tr>"
	Set table=table_"<tr><td>Child Process Launch Command</td><td>"_@CONFIG@("ChildProcessLaunchCommand")_"</td></tr>"
	Set table=table_"<tr><td>Format</td><td>"_@CONFIG@("Format")_"</td></tr>"
	Set table=table_"<tr><td>Interval</td><td>"_@CONFIG@("Interval")_"</td></tr>"
	Set table=table_"<tr><td>Event Filter</td><td>"_@CONFIG@("EventFilter")_"</td></tr>"
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	Return table
}

Method SystemPerformance() [ Internal ]
{
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th></thead>"
	Set table = table_"<tbody>"
	Set table=table_"<tr><td>Directory</td><td>"_$$getlogdir^SystemPerformance()_"</td></tr>"
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	Quit table
}

Method HelathMonitor()
{
	q 1
	w ^ISC.Monitor.ComponentD("SYS.Monitor.Health.Control")
	Set table = "<table>"
	Set table=table_"<thead><th>option</th><th>value</th></thead>"
	Set table = table_"<tbody>"
	Set table=table_"<tr><td>Directory</td><td>"_$$getlogdir^SystemPerformance()_"</td></tr>"
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	Quit table
}

Method SNMP()
{
	Q "<h4>In progress</h4>"
}

Method Process() [ Internal ]
{
 	Do ..CreateDataFromSQL(##CLASS(SYS.Process).CONTROLPANELFunc(),.table)
 	Set ..Sections($$$CurrentMethod,"Current Process")=table
}

Method Sharding() [ Internal ]
{
	Do ..CreateDataFromSQL(##class(%SQL.Manager.Catalog).ListShardsFunc(),.table)
	Set ..Sections($$$CurrentMethod,"Node-Level")=table
	Do ..CreateDataFromSQL(##class(%SQL.Manager.Catalog).ShardedTablesFunc(),.table)
	Set ..Sections($$$CurrentMethod,"Namespace-Level")=""
}

Method Zpm() [ Internal ]
{
	Set ..Sections($$$CurrentMethod)="<h3>InterSystems Package Manager</h3>"
	Set namespace=""
	For {
		Set namespace = $Order(..SystemProps("Namespaces",namespace)) Q:namespace=""
		New $namespace
		Set $NAMESPACE=namespace
		Continue:'$$$ClassExist("%IPM.Main")
		Set IsZPMInstalled = $system.CLS.IsMthd("%IPM.Main", "Shell")
		If IsZPMInstalled {
			Kill Prop
			Try {
				Do ##class(%IPM.Main).GetVersion("zpm",.reg)
				Set Prop("version")=##class(%IPM.Main).GetVersionModule()
				Set Prop("registry")=$Select(reg'="":reg,1:"No registry configured")
				Set namespace(namespace)=..BoolToStr(IsZPMInstalled)_"<br>"_
			 						  ..DrawHTMLTable(.Prop)_"<br>"_
			 						  ..CollectInstalledModules(namespace)
			}Catch ex{}
		 }
		 Else {
			 Set namespace(namespace)=..BoolToStr(IsZPMInstalled)
		 }
	}
	Set ..Sections($$$CurrentMethod,"ZPM Enabled")=..DrawHTMLTable(.namespace)
}

Method CollectInstalledModules(pNamespace As %String = {$NAMESPACE}) As %String
{
	Do ##class(%IPM.Main).GetListModules(pNamespace,"zpm",.list)
	Kill list("width")
	If $Data(list)>1 {
		Kill list("width")
		Return ..DrawDynamicHTMLTable(.list,$LB("Module","Version"))
	}
	Return ""
}

Method HealthRelevantMenu(menu)
{
	If $system.Version.GetISCComponents()=""&&(menu="fhir") Quit 1
	Q 0
}

ClassMethod GetVersion() [ CodeMode = expression ]
{
$Select($$$ClassExist("%ZHSLIB.HealthShareMgr"):##CLASS(%ZHSLIB.HealthShareMgr).VersionInfo(1),1:$ZV)
}

ClassMethod DrawHTMLTable(ByRef Details, ChangeFormats = "")
{
	Set table = "<table>"
	Set table=table_"<thead><th>Option</th><th>Value</th></thead>"
	Set table = table_"<tbody>"
	Set key=""
	For {
		Set key = $O(Details(key),1,data) Q:key=""
		Set table = table_"<tr><td>"_..FullName(key)_"</td>"
		If ChangeFormats'="" {
			Set table = table_"<td>"_..ChangeFormats(ChangeFormats,data)_"</td></tr>"
		}
		Else{
			Set table= table_"<td>"_data_"</td></tr>"
		}
	}
	Set table = table_"</tbody>"
	Set table = table_"</table>"
	Return table
}

ClassMethod DrawDynamicHTMLTable(ByRef Properties, headers As %List) As %String
{
	Set table = "<table>"
	Set table=table_"<thead>"
	Set ptr=0
	While $ListNext(headers,ptr,header) {
		Set table=table_"<th>"_header_"</th>"
	}
	Set table=table_"<tbody>"
	Set prop=""
	For {
		Set prop = $Order(Properties(prop),1,data) Q:prop=""
		Set table = table_"<tr>"
		For i=1:1:$LL(headers) {
			Set table=table_"<td>"_$LG(data,i)_"</td>"
		}
		Set table = table_"</tr>"
	}
	Set table=table_"</tbody>"
	Set table=table_"</table>"
	Return table
}

ClassMethod OnPageCSPROOT() As %Boolean
{
	Do ..OnPageHTML()
}

ClassMethod OnPageHTML() As %Boolean
{
	Write "<html>"
	Write !
	Do ..OnPageHEAD()
	Do ..OnPageBODY()
	Write !,"</html>"
	Return $$$OK
}

ClassMethod OnPageHEAD() As %Boolean
{
	Set %zUndefinedSystem = $$$GetUndefined
	$$$DisableUndefined
	Write "<head>",!
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write !,"<title>"_..#Title_"</title>",!
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Write "<style>",!
	Do ..LoadCSS()
	Write "</style>",!
	Write "</head>",!
	Do ..HyperEventHead(0,0)
	Return $$$OK
}

ClassMethod OnPageBODY() As %Boolean
{
	Do ..RenderHTML()
	Return $$$OK
}

ClassMethod LoadCSS()
{
	Set obj = ##class(%Dictionary.CompiledXData).%OpenId($Classname()_"||Style")
	Return:(obj = "") $$$OK
	Set xdata = obj.Data
	Set status = ##class(%XML.TextReader).ParseStream(xdata, .textreader)
	While textreader.Read() { If (textreader.NodeType="chars") { Write textreader.Value } }
	Return $$$OK
}

XData Style
{
<data>
	<![CDATA[*{margin:0;padding:0;box-sizing:border-box}body{font-family:-apple-system,BlinkMacSystemFont,'Courier New','Segoe UI',Roboto,Oxygen,Ubuntu,Cantarell,sans-serif;background-color:#f5f7fa;color:#333;line-height:1.6}.container{max-width:1400px;margin:0 auto;padding:20px}header{background:linear-gradient(135deg,#2A3987 0%,#764ba2 100%);color:white;/*padding:30px 0*/;box-shadow:0 2px 10px rgba(0,0,0,0.1);margin-bottom:30px}.header-content{display:flex;justify-content:space-between;align-items:center;max-width:1400px;margin:0 auto;padding:0 20px}h1{font-size:2rem;font-weight:600}.header-actions{display:flex;gap:15px;align-items:center}.toggle-btn{background:rgba(255,255,255,0.2);border:2px solid white;color:white;padding:12px 24px;border-radius:8px;cursor:pointer;font-size:1rem;font-weight:500;transition:all 0.3s ease;display:flex;align-items:center;gap:8px}.toggle-btn:hover{background:white;color:#2A3987;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,0.15)}.export-btn{background:rgba(255,255,255,0.2);border:2px solid white;color:white;padding:12px 24px;border-radius:8px;cursor:pointer;font-size:1rem;font-weight:500;transition:all 0.3s ease;display:flex;align-items:center;gap:8px}.export-btn:hover{background:white;color:#2A3987;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,0.15)}.button-row{display:flex;flex-wrap:wrap;gap:15px;margin-bottom:30px;justify-content:center}.section-btn{background:white;border:2px solid #e2e8f0;color:#4a5568;padding:15px 25px;border-radius:10px;cursor:pointer;font-size:1rem;font-weight:500;transition:all 0.3s ease;box-shadow:0 2px 5px rgba(0,0,0,0.05);display:flex;align-items:center;gap:8px}.section-btn:hover{border-color:#2A3987;color:#2A3987;transform:translateY(-2px);box-shadow:0 4px 12px rgba(102,126,234,0.2)}.section-btn.active{background:#2A3987;color:white;border-color:#2A3987}.section-content{background:white;border-radius:12px;margin-bottom:20px;box-shadow:0 2px 10px rgba(0,0,0,0.05);overflow:hidden;transition:all 0.3s ease;display:block}.section-content.collapsed{display:none}.section-header{background:#f7fafc;padding:20px;border-bottom:1px solid #e2e8f0;display:flex;justify-content:space-between;align-items:center}.section-title{font-size:1.5rem;font-weight:600;color:#2d3748;display:flex;align-items:center;gap:10px}.section-icon{width:40px;height:40px;background:#2A3987;color:white;border-radius:8px;display:flex;align-items:center;justify-content:center}.minimize-btn{background:#e2e8f0;border:none;color:#4a5568;width:36px;height:36px;border-radius:8px;cursor:pointer;font-size:1rem;display:flex;align-items:center;justify-content:center;transition:all 0.3s ease}.minimize-btn:hover{background:#cbd5e0;color:#2d3748}.table-container{overflow-x:auto;padding:20px}table{width:100%;border-collapse:collapse;font-size:0.95rem}th,td{padding:12px 15px;text-align:left;border-bottom:1px solid #e2e8f0}th{background:#f7fafc;font-weight:600;color:#4a5568;position:sticky;top:0;z-index:10}tr:hover{background:#f7fafc}.status-badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:0.85rem;font-weight:500}.status-active{background:#c6f6d5;color:#276749}.status-inactive{background:#fed7d7;color:#9b2c2c}.status-warning{background:#fefcbf;color:#744210}.value-cell{font-family:'Courier New',monospace;background:#f7fafc;padding:4px 8px;border-radius:4px;display:inline-block}@media (max-width:768px){.header-content{flex-direction:column;gap:20px}.header-actions{flex-direction:column;width:100%;gap:10px}.toggle-btn,.export-btn{width:100%;justify-content:center}.button-row{justify-content:flex-start}.section-btn{font-size:0.9rem;padding:12px 20px}h1{font-size:1.5rem}} .system-badge{display:inline-block;padding:6px 12px;border-radius:4px;font-weight:bold;font-size:14px;text-transform:uppercase;letter-spacing:0.5px;box-shadow:0 2px 4px rgba(0,0,0,0.1);transition:all 0.2s ease;cursor:default}.system-LIVE{background-color:#28a745;color:white;border:1px solid #1e7e34}.system-DEVELOPMENT{background-color:#007bff;color:white;border:1px solid #0056b3}.system-TEST{background-color:#ffc107;color:#212529;border:1px solid #d39e00}.system-FAILOVER{background-color:#dc3545;color:white;border:1px solid #c82333}.system-badge:hover{transform:translateY(-1px);box-shadow:0 4px 8px rgba(0,0,0,0.15)}
body.dark-mode {background-color: #1a202c; color: #e2e8f0;} body.dark-mode header {background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%) !important;} body.dark-mode .container, body.dark-mode .section-content, body.dark-mode .section-header, body.dark-mode .section-btn, body.dark-mode table, body.dark-mode th, body.dark-mode td {background-color: #2d3748; color: #e2e8f0; border-color: #4a5568;} body.dark-mode .section-btn.active {background-color: #2A3987; color: white; border-color: #2A3987;} body.dark-mode .header-content {background: transparent !important;} body.dark-mode .section-title {font-size: 1.5rem; font-weight: 600; color: #e2e8f0; display: flex; align-items: center; gap: 10px;} body.dark-mode .container {background-color: transparent;} body.dark-mode .minimize-btn {background-color: #4a5568; color: #e2e8f0;} body.dark-mode .minimize-btn:hover {background-color: #718096;} .toggle-btn, .export-btn, .theme-toggle {background: rgba(255, 255, 255, 0.2); border: 2px solid white; color: white; padding: 12px 24px; border-radius: 8px; cursor: pointer; font-size: 1rem; font-weight: 500; transition: var(--transition); display: flex; align-items: center; gap: 8px;}
.fab1 {position: fixed;bottom: 20px;right: 20px;width: 56px;height: 56px;border-radius: 50%;} .fab1:hover {transform: scale(1.1);box-shadow: 0 6px 30px rgba(0, 217, 255, 0.6);} body.dark-mode .fab1 {background-color: #2d3748;color: #e2e8f0;border-color: #4a5568;}
.success,.enabled { color:#18a99e;} .fail,.disabled { color:red; opacity: 0.5; or opacity: 0.3;}
]]>
	</data>
}

ClassMethod Scripts()
{

	&HTML<

    <script language="javascript">
        let allExpanded = true;
         let darkMode = false;

        function toggleSection(sectionId) {
            const section = document.getElementById(sectionId);
            const button = document.querySelector(`.section-btn[onclick="toggleSection('${sectionId}')"]`);

            if (section.classList.contains('collapsed')) {
                section.classList.remove('collapsed');
                button.classList.add('active');
                updateMinimizeButton(sectionId, false);
            } else {
                section.classList.add('collapsed');
                button.classList.remove('active');
                updateMinimizeButton(sectionId, true);
            }

            updateToggleAllButton();
        }

        function minimizeSection(sectionId, event) {
            event.stopPropagation();
            const section = document.getElementById(sectionId);
            const button = document.querySelector(`.section-btn[onclick="toggleSection('${sectionId}')"]`);

            if (section.classList.contains('collapsed')) {
                section.classList.remove('collapsed');
                button.classList.add('active');
                updateMinimizeButton(sectionId, false);
            } else {
                section.classList.add('collapsed');
                button.classList.remove('active');
                updateMinimizeButton(sectionId, true);
            }

            updateToggleAllButton();
        }

        function updateMinimizeButton(sectionId, isMinimized) {
            const minimizeBtn = document.querySelector(`#${sectionId} .minimize-btn i`);
            if (isMinimized) {
                minimizeBtn.classList.remove('fa-minus');
                minimizeBtn.classList.add('fa-plus');
            } else {
                minimizeBtn.classList.remove('fa-plus');
                minimizeBtn.classList.add('fa-minus');
            }
        }

        function toggleAll() {
            const sections = document.querySelectorAll('.section-content');
            const buttons = document.querySelectorAll('.section-btn');
            const toggleBtn = document.getElementById('toggleAllBtn');

            if (allExpanded) {
                // Collapse all
                sections.forEach(section => {
                    section.classList.add('collapsed');
                    const sectionId = section.id;
                    updateMinimizeButton(sectionId, true);
                });

                buttons.forEach(button => {
                    button.classList.remove('active');
                });

                toggleBtn.innerHTML = '<i class="fas fa-expand-alt"></i> Expand All';
                allExpanded = false;
            } else {
                // Expand all
                sections.forEach(section => {
                    section.classList.remove('collapsed');
                    const sectionId = section.id;
                    updateMinimizeButton(sectionId, false);
                });

                buttons.forEach(button => {
                    button.classList.add('active');
                });

                toggleBtn.innerHTML = '<i class="fas fa-compress-alt"></i> Collapse All';
                allExpanded = true;
            }
        }

        function updateToggleAllButton() {
            const sections = document.querySelectorAll('.section-content');
            const visibleSections = Array.from(sections).filter(section => !section.classList.contains('collapsed'));
            const toggleBtn = document.getElementById('toggleAllBtn');

            if (visibleSections.length === sections.length) {
                // All sections are expanded
                toggleBtn.innerHTML = '<i class="fas fa-compress-alt"></i> Collapse All';
                allExpanded = true;
            } else if (visibleSections.length === 0) {
                // All sections are collapsed
                toggleBtn.innerHTML = '<i class="fas fa-expand-alt"></i> Expand All';
                allExpanded = false;
            } else {
                // Mixed state - show expand all
                toggleBtn.innerHTML = '<i class="fas fa-expand-alt"></i> Expand All';
                allExpanded = false;
            }
        }

        function exportToHTML() {
            // Create a temporary div to hold the HTML content
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = document.documentElement.outerHTML;

            // Remove the export button from the cloned content
            const exportBtnInClone = tempDiv.querySelector('.export-btn');
            if (exportBtnInClone) {
                exportBtnInClone.remove();
            }

            // Get the modified HTML content
            const htmlContent = tempDiv.innerHTML;

            // Create blob and download
            const blob = new Blob([htmlContent], { type: 'text/html' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `system-info-${new Date().toISOString().split('T')[0]}.html`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);

            // Show success feedback
            const exportBtn = document.querySelector('.export-btn');
            const originalText = exportBtn.innerHTML;
            exportBtn.innerHTML = '<i class="fas fa-check"></i> Exported!';
            exportBtn.style.background = 'white';
            exportBtn.style.color = '#48bb78';

            setTimeout(() => {
                exportBtn.innerHTML = originalText;
                exportBtn.style.background = 'rgba(255,255,255,0.2)';
                exportBtn.style.color = 'white';
            }, 2000);
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                if (e.key === 'e') {
                    e.preventDefault();
                    if (!allExpanded) {
                        toggleAll();
                    }
                } else if (e.key === 'c') {
                    e.preventDefault();
                    if (allExpanded) {
                        toggleAll();
                    }
                } else if (e.key === 's') {
                    e.preventDefault();
                    exportToHTML();
                }
            }
        });


        function toggleTheme() {
            darkMode = !darkMode;
            document.body.classList.toggle('dark-mode');

            const themeToggle = document.getElementById('themeToggle');
            if (darkMode) {
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }

            // Save preference
            localStorage.setItem('darkMode', darkMode);
        }
        if (localStorage.getItem('darkMode') === 'true') {
            toggleTheme();
        }

         // Scroll to top function
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }
    </script>
	>
}

ClassMethod FullName(abbr As %String = "") [ CodeMode = expression ]
{
$Case(abbr,
"bbsiz":"Process Per Memory",
"globals16kb": "16KB Database Cache (MB)",
"globals64kb": "64KB Database Cache (MB)",
"globals8kb": "8KB Database Cache (MB)",
"globals32kb": "32KB Database Cache (MB)",
"routines": " Routine Cache (MB)",
"Shared Memory Heap":"gmheap",
"AutoParallel":"Execute queries in a single process",
"SaveMAC":"Retain cached query source",
"TODATEDefaultFormat":"TO_DATE default format",
"TimePrecision":"Default time precision for GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP",
"LockTimeout":"Lock timeout (seconds)",
"ClientMaxIdleTime":"Client maximum idle time (seconds)",
"ODBCVarcharMaxlen":"Default length for VARCHAR",
"AdaptiveMode":"Turn off Adaptive Mode to disable run time plan choice, automatic tuning, and Frozen/Upgrade query plans",
"TCPKeepAlive":"TCP keepalive for client connections (seconds)",
"ParameterSampling":"Turn on parameter sampling to sample the parameter value for query execution",
"LockThreshold":"Lock escalation threshold",
"IdKey":"Define primary key as ID key for tables created via DDL",
"IgnoreRedundant":"Ignore redundant DDL statements",
"FastDistinct":"GROUP BY and DISTINCT queries must produce original values",
"DisplayMode":"Result output display mode",
"ColAlign":"Result column alignment",
"IgnoreRedundant":"Ignore redundant DDL statements",
"Dialect":"SQL dialect",
"Path":"Schema search path",
"EscapeCondition":"IF condition to allow execution of ObjectScript commands",
:abbr
)
}

ClassMethod Icons(Icon) [ CodeMode = expression ]
{
$Case(Icon,
"system":"fa-info-circle",
"configuration":"fa-cog",
"namespaces":"fa-database",
"fhir":"fa-regular fa-fire",
"databases":"fa-hdd",
"remotedatabase":"fa-network-wired",
"journals":"fa-book",
"memory":"fa-memory",
"license":"fa-key",
"locks":"fa-lock",
"transaction":"fa-exchange-alt",
"task":"fa-tasks",
"interoperability":"fa-plug",
"security":"fa-shield-alt",
"ldap":"fa-users",
"x509":"fa-certificate",
"audit":"fa-clipboard-check",
"monitoring":"fa-chart-line",
"process":"fa-microchip",
"webgateway":"fa-globe",
"instances":"fa-server",
"mirror":"fa-clone",
"ecp":"fa-network-wired",
"docdb":"fa-file-alt",
"wqm":"fa-inbox",
"python":"fab fa-python",
"sslconfig":"fa-lock",
"sharding":"fa-layer-group",
"sqlandobject":"fa-solid fa-gears",
"externalgateway":"fa-regular fa-link",
"zpm":"fa-regular fa-cubes",
:"")
}

ClassMethod BoolToStr(Bool As %Boolean) [ CodeMode = expression ]
{
$Select(Bool: "Yes",1:"No")
}

Method Locks() [ Internal ]
{
	Do ..CreateDataFromSQL(##Class(%SYS.LockQuery).WebListFilterFunc(),.table)
	Set ..Sections($$$CurrentMethod,"Current Locks")=table
}

Method Transaction() [ Internal ]
{
	Set table="<table>"
	Set table=table_"<thead><th>ProcessId</th><th>Seconds</th></thead>"
	Set table=table_"<tbody>"
	If $D(^IRIS.Temp.SysMetrics("Transactions"))=1,$G(^IRIS.Temp.SysMetrics("Transactions"))="OK" {
		Set table="<h4>Current local transaction status: Normal</h4>"
		Set table=table_"<h5>There are no open local transactions.<h5>"
		Set table=table_"<h4>Current remote transaction status: Normal</h4>"
		Set table=table_"<h5>There are no open remote transactions.<h5>"
	}
	ElseIf $D(^IRIS.Temp.SysMetrics("Transactions"))=1,($G(^IRIS.Temp.SysMetrics("Transactions"))'="OK") {
		Set table="<h4>Current local transaction status: Troubled"
		Set table=table_"<h5>There are no open local transactions.<h5>"
		Set table=table_"<h4>Current remote transaction status: Normal</h4>"
		Set table=table_"<h5>There are no open remote transactions.<h5>"
	}
	ElseIf $D(^IRIS.Temp.SysMetrics("Transactions"))>10 {
		For {
		 Set sub = $O(^IRIS.Temp.SysMetrics("Transactions",sub)) q:sub=""
		 Set pid = ^IRIS.Temp.SysMetrics("Transactions",sub,"pid")
		 Set sec = ^IRIS.Temp.SysMetrics("Transactions",sub,"secs")

		 Set table=table_"<tr><td>"_pid_"</td><td>"_sec_"</td></tr>"
		}
		Set table=table_"</tbody>"
		Set table=table_"</div>"
	}
	Set ..Sections($$$CurrentMethod,"Current Transactions")=table
}

ClassMethod Menu()
{
	Set menu("Audit")=$LB()
	Set menu("Basic")=$LB()
	Set menu("Configuration")=$LB()
	Set menu("Databases")=$LB()
	Set menu("DocDB")=$LB()
	Set menu("ECP")=$LB()
	Set menu("Instances")=$LB()
	Set menu("Introperability")=$LB()
	Set menu("Journals")=$LB()
	Set menu("LDAP")=$LB()
	Set menu("License")=$LB()
	Set menu("Locks")=$LB()
	Set menu("Memory")=$LB()
	Set menu("Mirror")=$LB()
	Set menu("Monitoring")=$LB()
	Set menu("Namespaces")=$LB()
	Set menu("Process")=$LB()
	Set menu("Python")=$LB()
	Set menu("RemoteDataBase")=$LB()
	Set menu("SQLAndObject")=$LB()
	Set menu("SSLConfig")=$LB()
	Set menu("Security")=$LB()
	Set menu("Sharding")=$LB()
	Set menu("Task")=$LB()
	Set menu("Transaction")=$LB()
	Set menu("WQM")=$LB()
	Set menu("Webgateway")=$LB()
	Set menu("X509")=$LB()
	Set menu("ZPM")=$LB()
}

Method %INCLUDE()
{
	#define CurrentMethod 			##safeexpression(""""_$ZCVT($get(%methodname),"L")_"""")
	#define ClassExist(%cls)		##class(%Dictionary.CompiledClass).%ExistsId(%cls)
	#define DisableUndefined		Do $ZU(18,2)
	#define ResetUndefined(%val)	Do $ZU(18,%val)
	#Define GetUndefined			$ZU(18)
}

Method InitilizeSystemProps()
{
	New $NAMESPACE
	Set $NAMESPACE="%SYS"
	Set tSC = ##Class(Config.Miscellaneous).Get(.Properties)
	Merge ..SystemProps("Compatibility") = Properties
	Set tSC = ##Class(Config.config).Get(.Properties)
	Merge ..SystemProps("AdvancedMemory") = Properties
	Set tSC = ##Class(Config.Startup).Get(.Properties)
	Merge ..SystemProps("Startup") = Properties
	Set tSC = ##class(Config.ECP).Get(.Properties)
	Merge ..SystemProps("ECP") = Properties
	Set tSC = ##Class(Config.Journal).Get(.Properties)
	Merge ..SystemProps("Journal") = Properties
	Set rs = ##class(%SQL.Statement).%ExecDirect(, "SELECT Nsp FROM %SYS.Namespace_List()")
	While rs.%Next() {
		Set ..SystemProps("Namespaces",rs.Nsp)=""
	}
}

ClassMethod OnPostHTTP()
{
	$$$ResetUndefined(%zUndefinedSystem)
}

ClassMethod AppDescription() [ CodeMode = expression ]
{
"View detailed system information and configuration settings for your InterSystems IRIS instance, including databases, namespaces, memory usage, security settings, interoperability status, and more."
}
/*
ClassMethod Compare(pFile1 As %String, pFile2 As %String) [ Language = python ]
{
	import difflib

	with open("C:\\Users\\ak103336\\Desktop\\rep1.html", encoding="utf-8") as f1, open("C:\\Users\\ak103336\\Desktop\\rep3.html", encoding="utf-8") as f2:
	    html1 = f1.readlines()
	    html2 = f2.readlines()

	diff = difflib.HtmlDiff().make_file(html1, html2, fromdesc="File 1", todesc="File 2")

	with open("C:\\Users\\ak103336\\Desktop\\html_diff_output.html", "w", encoding="utf-8") as output:
	    output.write(diff)

	print("✅ Diff saved to html_diff_output.html")
}
*/
}
