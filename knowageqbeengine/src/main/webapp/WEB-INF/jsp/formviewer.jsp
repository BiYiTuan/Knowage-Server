<%--
Knowage, Open Source Business Intelligence suite
Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.

Knowage is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

Knowage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--%>


<%@ page language="java" 
	     contentType="text/html; charset=UTF-8" 
	     pageEncoding="UTF-8"%>

<%-- ---------------------------------------------------------------------- --%>
<%-- JAVA IMPORTS															--%>
<%-- ---------------------------------------------------------------------- --%>
<%@page import="it.eng.spago.configuration.*"%>
<%@page import="it.eng.spago.base.*"%>
<%@page import="it.eng.spagobi.engines.qbe.QbeEngineConfig"%>
<%@page import="it.eng.spagobi.engines.qbe.QbeEngineInstance"%>
<%@page import="it.eng.spagobi.utilities.engines.EngineConstants"%>
<%@page import="it.eng.spagobi.commons.bo.UserProfile"%>
<%@page import="it.eng.spago.security.IEngUserProfile"%>
<%@page import="it.eng.spagobi.commons.constants.SpagoBIConstants"%>
<%@page import="java.util.Locale"%>
<%@page import="it.eng.spagobi.services.common.EnginConf"%>
<%@page import="it.eng.qbe.serializer.SerializationManager"%>
<%@page import="org.json.JSONObject"%>

<%-- ---------------------------------------------------------------------- --%>
<%-- JAVA CODE 																--%>
<%-- ---------------------------------------------------------------------- --%>
<%
	QbeEngineInstance qbeEngineInstance;
	UserProfile profile;
	Locale locale;
	String isFromCross;
	boolean isPowerUser;
	Integer resultLimit;
	boolean isMaxResultLimitBlocking;
	boolean isQueryValidationEnabled;
	boolean isQueryValidationBlocking;
	String modality;
	
	ResponseContainer responseContainer = ResponseContainerAccess.getResponseContainer(request);
	RequestContainer requestContainer = RequestContainerAccess.getRequestContainer(request);
	SourceBean serviceResponse = responseContainer.getServiceResponse();
	SourceBean serviceRequest = requestContainer.getServiceRequest();
	qbeEngineInstance = (QbeEngineInstance) serviceResponse.getAttribute("ENGINE_INSTANCE");
	profile = (UserProfile)qbeEngineInstance.getEnv().get(EngineConstants.ENV_USER_PROFILE);
	locale = (Locale) qbeEngineInstance.getEnv().get(EngineConstants.ENV_LOCALE);
	modality = (String) serviceRequest.getAttribute("MODALITY");
	if (modality == null || modality.trim().equals("")) {
		modality = "VIEW";
	}
	
	QbeEngineConfig qbeEngineConfig = QbeEngineConfig.getInstance();
	
	// settings for max records number limit
	resultLimit = qbeEngineConfig.getResultLimit();
	isMaxResultLimitBlocking = qbeEngineConfig.isMaxResultLimitBlocking();
	isQueryValidationEnabled = qbeEngineConfig.isQueryValidationEnabled();
	isQueryValidationBlocking = qbeEngineConfig.isQueryValidationBlocking();
%>

<%-- ---------------------------------------------------------------------- --%>
<%-- HTML	 																--%>
<%-- ---------------------------------------------------------------------- --%>

<%-- DOCTYPE declaration: it is required in order to fix some side effects, in particular in IE --%>
<%-- 21-01-2010: the xhtml1-strict DOCTYPE causes this problem in IE8:
	Open the Document Browser, execute a FORM document, when the form appears close the folders tree panel on the left,
	expand a grouping variables combobox, then the iframe containing the form is RESIZED in width!!!
	And it returns to the right width with a onmouseover event on certain elements....  
	Therefore this DOCTYPE must be commented!!!
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
end DOCTYPE declaration --%>
    
<html>

	<head>
		<%@include file="commons/includeExtJS.jspf" %>
		<%@include file="commons/includeMessageResource.jspf" %>
		<%@include file="commons/includeSbiQbeJS.jspf"%>
	</head>
	
	<body>
	
    	<script type="text/javascript"> 

    	Sbi.config = {}; 
    	
		Sbi.config.queryLimit = {};
		Sbi.config.queryLimit.maxRecords = <%= resultLimit != null ? "" + resultLimit.intValue() : "undefined" %>;
		Sbi.config.queryLimit.isBlocking = <%= isMaxResultLimitBlocking %>;
		Sbi.config.queryValidation = {};
		Sbi.config.queryValidation.isEnabled = <%= isQueryValidationEnabled %>;
		Sbi.config.queryValidation.isBlocking = <%= isQueryValidationBlocking %>;
    	
    	var url = {
		    	host: '<%= request.getServerName()%>'
		    	, port: '<%= request.getServerPort()%>'
		    	, contextPath: '<%= request.getContextPath().startsWith("/")||request.getContextPath().startsWith("\\")?
		    	   				  request.getContextPath().substring(1):
		    	   				  request.getContextPath()%>'
		    	    
		};

	    var params = {
		    	SBI_EXECUTION_ID: <%= request.getParameter("SBI_EXECUTION_ID")!=null?"'" + request.getParameter("SBI_EXECUTION_ID") +"'": "null" %>
		};
	
	    Sbi.config.serviceRegistry = new Sbi.service.ServiceRegistry({
	    	baseUrl: url
	        , baseParams: params
		});
	    
	    
	    var formEngineConfig = {};	    
      	Sbi.formviewer.formEnginePanel = null;
	    
        Ext.onReady(function() {
        	Ext.QuickTips.init();

			var template = <%= qbeEngineInstance.getFormState().getConf().toString() %>;
			var formValues = null;
			
			<%if( qbeEngineInstance.getFormState().getFormStateValues()!=null){%>
				formValues = <%= qbeEngineInstance.getFormState().getFormStateValues().toString() %>;
			<%}%>

			formEngineConfig.template = template;
			formEngineConfig.formValues = formValues;
			formEngineConfig.config = {
				region: 'center'
				, formViewerPageConfig : {
					showSaveFormButton : <%= modality.equalsIgnoreCase("VIEW") %>
				}
			};
			
			Sbi.formviewer.formEnginePanel = new Sbi.formviewer.FormEnginePanel(formEngineConfig);
	        var viewport = new Ext.Viewport({layout: 'border', items: [Sbi.formviewer.formEnginePanel]});  
           	
      	});
      	
	    </script>
	
	</body>

</html>
