/// View swagger json for web applications
Class ZIRIS.DevHub.Tools.Swagger.JsonViewer Extends ZIRIS.DevHub.Portal.Template
{

Parameter Title As STRING [ Final ] = "SwaggerJsonViewer";

Parameter APPLICATION As STRING = "SwaggerJsonViewer";

Parameter CATEGORY = "LOGS";

ClassMethod OnPage() As %Status
{
	Do ..OnPageCSPROOT()
	Return $$$OK
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
	Write "<head>",!
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write !,"<title>"_..#Title_"</title>",!
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Write "<style>",!
	Do ..LoadCSS()
	Write "</style>",!
	Write "</head>",!
	W ..HyperEventHead(0,0)
	Return $$$OK
}

ClassMethod OnPageBODY() As %Boolean
{
	Do ..RenderSwaggerAPIInfo()
	Return $$$OK
}

ClassMethod RenderSwaggerAPIInfo() As %Status
{
	&HTML<
	<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web Applications Manager</title>
    <!--link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.15.5/swagger-ui.css"-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>

    </style>
</head>
<body>
    <div class="header">
        <h1>Web Applications Manager</h1>
        <div class="search-container">
            <input type="text" class="search-input" id="search-input" placeholder="Search APIs...">
            <i class="fas fa-search search-icon"></i>
        </div>
         <select id="namespaceSelect" class="namespace-info">
     >
	Set rs = ##class(%SQL.Statement).%ExecDirect(, "SELECT Nsp FROM %SYS.Namespace_List()")
	While rs.%Next() {
		Write "<option value="""_rs.Nsp_""">"_rs.Nsp_"</option>"
	}
   &HTML<
	</select>
    </div>

    <div class="container">
        <!-- App List View -->
        <div id="app-list-view" class="app-list-container">
            <div id="loading-apps" class="loading-container">
                <div class="spinner"></div>
                <p>Loading web applications...</p>
            </div>

            <div id="error-container" class="error-container" style="display: none;"></div>

            <div id="empty-state" class="empty-state" style="display: none;">
                <i class="fas fa-folder-open"></i>
                <h3>No web applications found</h3>
                <p>There are no web applications available at this time.</p>
            </div>

            <div id="no-results" class="no-results" style="display: none;">
                <i class="fas fa-search"></i>
                <h3>No results found</h3>
                <p>Try adjusting your search to find what you're looking for.</p>
            </div>

            <div id="app-list" style="display: none;"></div>
            <div id="search-info" class="search-info" style="display: none;"></div>
        </div>

        <!-- Swagger View -->
        <div id="swagger-view" class="swagger-container">
            <div class="swagger-header">
                <div class="swagger-title" id="swagger-title">API Documentation</div>
                <button id="back-button" class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    Back to Applications
                </button>
            </div>
            <div class="swagger-content">
                <div id="swagger-loading" class="loading-container">
                    <div class="spinner"></div>
                    <p>Loading API documentation...</p>
                </div>

                <div id="swagger-error" class="error-container" style="display: none;"></div>

                <div id="swagger-ui" style="display: none;"></div>

                <div id="raw-spec" class="raw-spec" style="display: none;">
                    <h4>Raw Specification</h4>
                    <pre id="raw-spec-content"></pre>
                </div>
            </div>
        </div>
    </div>



</body>
</html>
	>
	Do ..Scripts()
	q 1
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
	<![CDATA[
	:root{--primary-color:#4361ee;--secondary-color:#3a7bc8;--success-color:#5cb85c;--danger-color:#d9534f;--light-bg:#f8f9fa;--border-color:#dee2e6}*{box-sizing:border-box;margin:0;padding:0;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}body{background-color:var(--light-bg);color:#333;height:100vh;overflow:hidden;display:flex;flex-direction:column}.header{background-color:var(--primary-color);color:#fff;padding:15px 20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 4px rgba(0,0,0,.1);flex-shrink:0}.header h1{margin:0;font-size:24px}.search-container{position:relative;width:300px}.search-input{width:100%;padding:8px 35px 8px 15px;border:none;border-radius:20px;font-size:14px;outline:none}.search-icon{position:absolute;right:12px;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.7)}.container{max-width:1200px;margin:20px auto;padding:0 20px;flex:1;width:100%;overflow:hidden;display:flex;flex-direction:column}.app-list-container{display:block;overflow-y:auto;flex:1}.app-card{background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.1);margin-bottom:15px;overflow:hidden;transition:transform .2s,box-shadow .2s}.app-card:hover{transform:translateY(-3px);box-shadow:0 4px 12px rgba(0,0,0,.15);cursor:pointer}.app-card.highlighted{border:2px solid var(--primary-color)}.app-header{padding:15px 20px;border-bottom:1px solid var(--border-color);display:flex;justify-content:space-between;align-items:center}.app-name{font-size:18px;font-weight:600;color:var(--primary-color)}.app-status{padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600}.status-enabled{background-color:rgba(92,184,92,.2);color:var(--success-color)}.status-disabled{background-color:rgba(217,83,79,.2);color:var(--danger-color)}.app-details{padding:15px 20px;display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:10px}.app-detail{display:flex;flex-direction:column}.app-detail-label{font-size:12px;color:#6c757d;margin-bottom:3px}.app-detail-value{font-weight:500}.highlight{background-color:#fff3cd;padding:0 2px;border-radius:2px}.swagger-container{display:none;flex-direction:column;flex:1;overflow:hidden}.swagger-header{background:#fff;border-radius:8px 8px 0 0;padding:15px 20px;box-shadow:0 2px 4px rgba(0,0,0,.1);display:flex;justify-content:space-between;align-items:center;flex-shrink:0}.swagger-title{font-size:20px;font-weight:600;color:var(--primary-color)}.back-button{display:flex;align-items:center;gap:8px;background-color:var(--primary-color);color:#fff;border:none;padding:8px 15px;border-radius:4px;cursor:pointer;font-weight:500;transition:background-color .2s}.back-button:hover{background-color:var(--secondary-color)}.swagger-content{background:#fff;border-radius:0 0 8px 8px;box-shadow:0 2px 8px rgba(0,0,0,.1);padding:20px;display:flex;flex-direction:column;flex:1;overflow:hidden}.loading-container{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px;text-align:center}.spinner{border:4px solid rgba(0,0,0,.1);border-radius:50%;border-top:4px solid var(--primary-color);width:40px;height:40px;animation:spin 1s linear infinite;margin-bottom:15px}@keyframes spin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}.error-container{background-color:#f8d7da;color:#721c24;padding:15px;border-radius:4px;margin:20px 0;border-left:4px solid var(--danger-color)}.empty-state{text-align:center;padding:40px;color:#6c757d}.empty-state i{font-size:48px;margin-bottom:15px;color:#dee2e6}.no-results{text-align:center;padding:40px;color:#6c757d}.no-results i{font-size:48px;margin-bottom:15px;color:#dee2e6}.notification{position:fixed;top:20px;right:20px;padding:15px 20px;background-color:#f8d7da;color:#721c24;border-radius:4px;box-shadow:0 4px 8px rgba(0,0,0,.1);z-index:1e3;display:flex;align-items:center;gap:10px}.notification.success{background-color:#d4edda;color:#155724}.notification i{font-size:18px}.debug-panel{background-color:#f8f9fa;border:1px solid #dee2e6;border-radius:4px;padding:15px;margin-top:20px;font-family:monospace;font-size:12px;max-height:200px;overflow-y:auto}.debug-panel h4{margin-top:0;margin-bottom:10px;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}.raw-spec{background-color:#f8f9fa;border:1px solid #dee2e6;border-radius:4px;padding:15px;margin-top:20px;font-family:monospace;font-size:12px;flex:1;display:flex;flex-direction:column;overflow:hidden}.raw-spec h4{margin-top:0;margin-bottom:10px;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;flex-shrink:0}.raw-spec pre{white-space:pre-wrap;word-wrap:break-word;overflow-y:auto;flex:1;padding:10px;background:#fff;border-radius:4px;border:1px solid #dee2e6}.manual-render-button{margin-top:10px;padding:8px 15px;background-color:var(--primary-color);color:#fff;border:none;border-radius:4px;cursor:pointer;font-weight:500}.manual-render-button:hover{background-color:var(--secondary-color)}.search-info{margin-bottom:15px;color:#6c757d;font-size:14px}
	.namespace-info {padding: 8px 12px; border-radius: 4px; background-color: white;}
	]]>>
</data>
}

ClassMethod Scripts()
{

	&HTML<
	<script language="javascript">
		//const serverURL = #server(..GetServerDetails())#;

		document.addEventListener('DOMContentLoaded', function() {
    // DOM Elements
    const appListView = document.getElementById('app-list-view');
    const swaggerView = document.getElementById('swagger-view');
    const loadingApps = document.getElementById('loading-apps');
    const errorContainer = document.getElementById('error-container');
    const emptyState = document.getElementById('empty-state');
    const noResults = document.getElementById('no-results');
    const appList = document.getElementById('app-list');
    const searchInput = document.getElementById('search-input');
    const searchInfo = document.getElementById('search-info');
    const swaggerLoading = document.getElementById('swagger-loading');
    const swaggerError = document.getElementById('swagger-error');
    const swaggerUI = document.getElementById('swagger-ui');
    const swaggerTitle = document.getElementById('swagger-title');
    const backButton = document.getElementById('back-button');

    const rawSpec = document.getElementById('raw-spec');
    const rawSpecContent = document.getElementById('raw-spec-content');
    const manualRenderButton = document.getElementById('manual-render-button');

    // Define serverURL if not already defined
    //const serverURL = serverURL || 'http://localhost'; // Replace with your actual server URL

    // Global variables
    let currentSpec = null;
    let allApplications = [];
    let filteredApplications = [];

    // Try to fetch web applications from server, fall back to sample data
    fetchWebApplications();

    const namespaceSelect = document.getElementById('namespaceSelect');
    if (namespaceSelect) namespaceSelect.addEventListener('change', changeNamespace);

    // Back button event
    backButton.addEventListener('click', function() {
        showAppListView();
    });

    // Search input event
    searchInput.addEventListener('input', function() {
        filterApplications();
    });

    // Function to fetch web applications
    async function fetchWebApplications(namespace="%SYS") {
        try {
            // Fix: Use === instead of = for comparison
            /*if (namespace === "%SYS") {
                namespace = "%25SYS";
            }
            const url = `${serverURL}/api/mgmnt/v1/${namespace}/restapps`;

            // Try to fetch from server
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const applications = await response.json();
            */
            applications = #server(..GetSwagger(namespace))#;
            applications = JSON.parse(applications);
            allApplications = applications;
            filteredApplications = [...applications];
            displayApplications(filteredApplications);
            showNotification('Web applications loaded successfully', 'success');
        } catch (error) {
            // Fall back to sample data
            loadingApps.style.display = 'none';
            console.error('Error fetching applications:', error);
            showNotification('Error loading applications. Please try again.', 'error');
        }
    }

    // Function to change namespace - MOVED INSIDE DOMContentLoaded
    async function changeNamespace() {
        const namespaceSelect = document.getElementById('namespaceSelect');

        if (namespaceSelect) {
            const selectedNamespace = namespaceSelect.value;
            const currentNamespace = document.getElementById('currentNamespace');
            if (currentNamespace) {
                currentNamespace.textContent = selectedNamespace;
            }
            fetchWebApplications(selectedNamespace);
            localStorage.setItem('namespace', selectedNamespace);
        }
    }

    // Function to filter applications based on search term
    function filterApplications() {
        const searchTerm = searchInput.value.toLowerCase().trim();

        if (searchTerm === '') {
            filteredApplications = [...allApplications];
        } else {
            filteredApplications = allApplications.filter(app => {
                // Search in name, namespace, dispatchClass, resource, and swaggerSpec
                return (
                    app.name.toLowerCase().includes(searchTerm) ||
                    app.namespace.toLowerCase().includes(searchTerm) ||
                    app.dispatchClass.toLowerCase().includes(searchTerm) ||
                    (app.resource && app.resource.toLowerCase().includes(searchTerm)) ||
                    app.swaggerSpec.toLowerCase().includes(searchTerm)
                );
            });
        }

        displayApplications(filteredApplications);
    }

    // Function to highlight search term in text
    function highlightSearchTerm(text, searchTerm) {
        if (!searchTerm) return text;

        const regex = new RegExp(`(${searchTerm})`, 'gi');
        return text.replace(regex, '<span class="highlight">$1</span>');
    }

    // Function to display applications
    function displayApplications(applications) {
        loadingApps.style.display = 'none';
        const searchTerm = searchInput.value.toLowerCase().trim();

        if (applications.length === 0) {
            if (searchTerm) {
                noResults.style.display = 'block';
                emptyState.style.display = 'none';
                appList.style.display = 'none';
                searchInfo.style.display = 'none';
            } else {
                emptyState.style.display = 'block';
                noResults.style.display = 'none';
                appList.style.display = 'none';
                searchInfo.style.display = 'none';
            }
            return;
        }

        appList.style.display = 'block';
        emptyState.style.display = 'none';
        noResults.style.display = 'none';

        // Show search info if there's a search term
        if (searchTerm) {
            searchInfo.style.display = 'block';
            searchInfo.textContent = `Showing ${applications.length} of ${allApplications.length} applications matching "${searchTerm}"`;
        } else {
            searchInfo.style.display = 'none';
        }

        appList.innerHTML = '';

        applications.forEach(app => {
            const appCard = document.createElement('div');
            appCard.className = 'app-card';
            appCard.dataset.name = app.name;

            // Highlight search term in the displayed text
            const highlightedName = highlightSearchTerm(app.name, searchTerm);
            const highlightedNamespace = highlightSearchTerm(app.namespace, searchTerm);
            const highlightedDispatchClass = highlightSearchTerm(app.dispatchClass, searchTerm);
            const highlightedResource = app.resource ? highlightSearchTerm(app.resource, searchTerm) : '';
            const highlightedSwaggerSpec = highlightSearchTerm(app.swaggerSpec, searchTerm);

            appCard.innerHTML = `
                <div class="app-header">
                    <div class="app-name">${highlightedName}</div>
                    <div class="app-status ${app.enabled ? 'status-enabled' : 'status-disabled'}">
                        ${app.enabled ? 'Enabled' : 'Disabled'}
                    </div>
                </div>
                <div class="app-details">
                    <div class="app-detail">
                        <div class="app-detail-label">Dispatch Class</div>
                        <div class="app-detail-value">${highlightedDispatchClass}</div>
                    </div>
                    <div class="app-detail">
                        <div class="app-detail-label">Namespace</div>
                        <div class="app-detail-value">${highlightedNamespace}</div>
                    </div>
                    ${app.resource ? `
                    <div class="app-detail">
                        <div class="app-detail-label">Resource</div>
                        <div class="app-detail-value">${highlightedResource}</div>
                    </div>
                    ` : ''}
                    <div class="app-detail">
                        <div class="app-detail-label">Swagger Spec</div>
                        <div class="app-detail-value">${highlightedSwaggerSpec}</div>
                    </div>
                </div>
            `;

            appCard.addEventListener('click', function() {
                if (app.enabled) {
                    loadSwaggerSpec(app);
                } else {
                    showNotification(`Cannot view documentation for disabled application: ${app.name}`);
                }
            });

            appList.appendChild(appCard);
        });
    }

    // Function to load Swagger specification
    async function loadSwaggerSpec(app) {
        showSwaggerView(app.name)
        try {
            let spec;
            // First try to fetch from the actual swaggerSpec URL
            /*try {
                const response = await fetch('http://localhost/irishealth2025com'+app.swaggerSpec);

                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }

                spec = await response.json();
                source = "server";

            } catch (fetchError) {
                console.warn('Failed to fetch from swaggerSpec URL, using sample data:', fetchError.message);

            }
            */
            spec = #server(..GetWebRESTApplication(app.namespace,app.swaggerSpec))#;
            spec = JSON.parse(spec);
            currentSpec = spec;
            rawSpecContent.textContent = JSON.stringify(spec, null, 2);
            swaggerLoading.style.display = 'none';
            swaggerUI.style.display = 'block';

        } catch (error) {
            swaggerLoading.style.display = 'none';
            showSwaggerError(`Failed to load API documentation: ${error.message}`);
        }
    }

    // Function to show app list view
    function showAppListView() {
        appListView.style.display = 'block';
        swaggerView.style.display = 'none';
        rawSpec.style.display = 'none';
    }

    // Function to show swagger view
    function showSwaggerView(appName) {
        appListView.style.display = 'none';
        swaggerView.style.display = 'flex';
        swaggerTitle.textContent = `API Documentation: ${appName}`;
        swaggerLoading.style.display = 'flex';
        swaggerError.style.display = 'none';
        swaggerUI.style.display = 'none';

        rawSpec.style.display = 'flex';
    }

    // Function to show error
    function showError(message) {
        loadingApps.style.display = 'none';
        errorContainer.textContent = message;
        errorContainer.style.display = 'block';
    }

    // Function to show swagger error
    function showSwaggerError(message) {
        swaggerError.textContent = message;
        swaggerError.style.display = 'block';
    }

    // Function to show notification
    function showNotification(message, type = 'error') {
        // Remove existing notification
        const existingNotification = document.querySelector('.notification');
        if (existingNotification) {
            existingNotification.remove();
        }

        // Create new notification
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;

        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
        notification.innerHTML = `
            <i class="fas ${icon}"></i>
            <span>${message}</span>
        `;

        document.body.appendChild(notification);

        // Auto remove after 3 seconds
        setTimeout(() => {
            notification.remove();
        }, 1000);
    }
});
    </script>
	>
}

ClassMethod GetSwagger(Namespace)
{
	Set response=[]

	Set sc=##class(%REST.API).GetWebRESTApps(Namespace,.appList)

	// Return error or array of application descriptions
	If $$$ISOK(sc) {
		Set sc=##class(%REST.API).ListToArray(appList,.response)
	}
	Return response.%ToJSON()
}

ClassMethod GetWebRESTApplication(namespace As %String, webApplication As %String) As %String
{
	New $namespace
	Set namespace=$zcvt(namespace,"U")
	Set $namespace=namespace
	If $extract(webApplication)'="/" Set webApplication="/"_webApplication
	Set sc=##class(%REST.API).GetWebRESTApplication(namespace,$P(webApplication,"/spec",2),.swagger)
	If $P(webApplication,"/spec",2)="/api/interop-editors" {
		Set sc=$$$ERROR($$$RESTNoWebApp,webApplication),swagger=[]
	}
	Set:$$$ISERR(sc) swagger=[]
	Quit swagger.%ToJSON()
}

// need to implement for API calls

ClassMethod GetServerDetails()
{
	If '$Data(^Server) {
		Set sc=##class(%RoutineMgr).GetWebServerPort(.Port,.Server,.URLPrefix,.URL)
		Return $E(URL,1,*-1)_":"_Port
	}
	Else {
		Quit $G(^Server,"http://localhost/irishealth2025com")
	}
}

}
