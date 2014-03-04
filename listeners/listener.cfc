<cfcomponent>
	<cfset variables.instanceName = "">

	<cffunction name="init" access="public" returntype="listener">
		<cfargument name="instanceName" type="string" required="true">
		<cfset variables.instanceName = arguments.instanceName>
		<cfreturn this>
	</cffunction>

	<cffunction name="logEntry" access="public" returntype="void">
		<cfargument name="dateTime" type="Date" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="applicationCode" type="string" required="true">
		<cfargument name="severityCode" type="string" required="true">
		<cfargument name="hostName" type="string" required="true">
		<cfargument name="exceptionMessage" required="false" default="">
		<cfargument name="exceptionDetails" required="false" default="">
		<cfargument name="CFID" type="string" required="false" default="">
		<cfargument name="CFTOKEN" type="string" required="false" default="">
		<cfargument name="userAgent" type="string" required="false" default="">
		<cfargument name="templatePath" type="string" required="false" default="">
		<cfargument name="HTMLReport" type="string" required="false" default="">
		<cfargument name="APIKey" type="string" required="false" default="">
		<cfargument name="source" type="string" required="false" default="Unknown">
		<cfscript>
			// get listener service wrapper
			var serviceLoader = createObject("component", "bugLog.components.service").init( instanceName = variables.instanceName );

			// get handle to bugLogListener service
			var bugLogListener = serviceLoader.getService();

			// create entry bean
			var rawEntry = createObject("component","bugLog.components.rawEntryBean")
								.init()
								.setDateTime(arguments.dateTime)
								.setMessage(arguments.message)
								.setApplicationCode(arguments.applicationCode)
								.setSourceName(arguments.source)
								.setSeverityCode(arguments.severityCode)
								.setHostName(getStrakerHostName(arguments.hostName))
								.setExceptionMessage(arguments.exceptionMessage)
								.setExceptionDetails(arguments.exceptionDetails)
								.setCFID(arguments.cfid)
								.setCFTOKEN(arguments.cftoken)
								.setUserAgent(arguments.userAgent)
								.setTemplatePath(arguments.templatePath)
								.setHTMLReport(arguments.HTMLReport)
								.setReceivedOn(now());

			// validate Entry
			bugLogListener.validate(rawEntry, arguments.APIKey);

			// log entry
			bugLogListener.logEntry(rawEntry);
		</cfscript>
	</cffunction>

	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->

	<cffunction name="getStrakerHostName" returntype="string" hint="Pass me an original hostname and I try and return server9 or server11 or something like that">
		<cfargument name="hostname" type="string" required="true">
		<cfscript>
			var sReturn = arguments.hostname
			var qReturn = ""
			var iFind = 0

			query name="qReturn" datasource="buglog"{
				echo("	select * from st_hosts ");
			}

			loop query="qReturn"{
				if (findNoCase(qReturn.label, arguments.hostName,1)){
					sReturn = qReturn.hostname
					break;
				}
			}
			return sReturn;
		</cfscript>
	</cffunction>

	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->


</cfcomponent>