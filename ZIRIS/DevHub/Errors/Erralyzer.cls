Class ZIRIS.DevHub.Errors.Erralyzer Extends ZIRIS.DevHub.Portal.Template
{

Parameter Title As STRING [ Final ] = "Erralyzer";

Parameter APPLICATION As STRING = "Erralyzer";

Parameter ERR [ Final, Internal ] = "^ERRORS";

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

ClassMethod RenderStack() As %Status
{
	&HTML<
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erralyzer</title>
</head>
<body>
    <!-- App Header -->
    <header class="app-header">
        <div class="header-title">Error Stack Viewer(Erralyzer)</div>
        <div class="header-controls">
            <div class="namespace-info">
                <span>Namespace:</span>
                <span id="currentNamespace"></span>
            </div>
            <button class="theme-toggle" id="themeToggle">
                <span id="themeIcon">🌙</span>
                <span id="themeText"></span>
            </button>
        </div>
    </header>

    <div class="container">
        <!-- Errors Page -->
        <div class="errors-page" id="errorsPage">
            <div class="controls-container">
                <div class="filter-controls">
                    <label for="namespaceSelect">Namespace:</label>
                    <select id="namespaceSelect">
     >
	Set rs = ##class(%SQL.Statement).%ExecDirect(, "SELECT Nsp FROM %SYS.Namespace_List()")
	While rs.%Next() {
		Write "<option value="""_rs.Nsp_""">"_rs.Nsp_"</option>"
	}
   &HTML<
	</select>
        <!--label for="dateFilter" style="margin-left: 20px;">Filter by Date:</label>
        <input type="date" id="dateFilter" placeholder="YYYY-MM-DD"-->
        <!--span class="date-hint">(YYYY-MM-DD)</span-->
        <input type="text" id="seachErrorTxt" placeholder="Type any error...">
        <button class="clear-filter" id="seachError" onclick="seracherrors()" >Search</button>
        <button class="clear-filter" id="clearFilter">Clear Filter</button>
        <label for="rowsPerPage" style="margin-left: 20px;">Rows Per Page:</label>
        <select id="rowsPerPage">
            <option value="5">5</option>
            <option value="10" selected>10</option>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
        </select>
        <div class="error-count" id="errorCount">0 Errors</div>
    </div>
    <div class="pagination-controls">
        <div class="pagination">
            <button id="prevPage">&laquo; Previous</button>
            <!--div class="pagination-info" id="paginationInfo">Page 1 of 1</div-->
            <button id="nextPage">Next &raquo;</button>
        </div>
    </div>
	</div>
	<div class="errors-list" id="errorsList">
	    <div class="errors-list-header">
	        <div class="column-header date-column">
	            Date
	            <button class="sort-button" id="sortDate">↑</button>
	        </div>
	        <div class="column-header time-column">
	            Time
	            <button class="sort-button" id="sortTime">↑</button>
	        </div>
	        <div class="column-header time-column">
	            Process
	            <button class="sort-button" id="sortTime">↑</button>
	        </div>
	        <div class="column-header time-column">
	            Error #
	            <button class="sort-button" id="sortTime">↑</button>
	        </div>
	        <div class="column-header message-column">
	            Error Message
	        </div>
	        <div class="column-header time-column">
	            User
	            <button class="sort-button" id="sortTime">↑</button>
	        </div>
	    </div>
	    <div class="errors-list-body" id="errorsListBody">
	        <div class="loading">
	            <div class="loading-spinner"></div>
	            <div>Loading errors...</div>
	        </div>
	    </div>
	</div>
	</div>
	<!-- Stack Trace Viewer Page -->
	<div class="stack-viewer-page" id="stackViewerPage">
	<div class="stack-viewer-header">
	    <button class="back-button" id="backButton">
	        <span class="back-icon">←</span> Back to Errors
	    </button>
	    <div class="stack-viewer-title" id="errorTitle">Error Details</div>
	</div>

	<div class="stack-viewer-content">
	    <div class="stack-grid">
	        <div class="grid-header">
	            Call Stack Levels
	        </div>
	        <div class="grid-content" id="stackLevels">
	            <div class="loading">
	                <div class="loading-spinner"></div>
	                <div>Loading stack trace...</div>
	            </div>
	        </div>
	    </div>

    <div class="variables-panel">
    <div class="panel-header">
        Variables for Selected Level
    </div>
    <div class="panel-content" id="variablesContent">
        <div class="variables-container">
            <div class="empty-state">
                Select a stack level to view its variables
            </div>
            </div>
        </div>
    </div>
	</div>
	</div>
	</div>

    <div class="notification" id="notification"></div>
</body>
</html>
	>
	Do ..Scripts()
	q 1
}

ClassMethod OnPageBODY() As %Boolean
{
	Do ..RenderStack()
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
	<![CDATA[
	:root {--primary-color: #18a99e;--isc-color: #18a99e;--secondary-color: #2c3e50;--background-color: #f8f9fa;--border-color: #dee2e6;--hover-color: #e9ecef;--selected-color: #d1ecf1;--variable-bg: #f1f8ff;--error-color: #e74c3c;--warning-color: #f39c12;--success-color: #2ecc71;--loading-color: #95a5a6;--header-bg: linear-gradient(135deg, #1a2a6c, #2c3e50);--header-text: #ffffff;--card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);} [data-theme="dark"] {--background-color: #1a1a1a;--secondary-color: #e0e0e0;--border-color: #444444;--hover-color: #333333;--selected-color: #2c3e50;--variable-bg: #2c3e50;--header-bg: linear-gradient(135deg, #2c3e50, #1a1a1a);} * {box-sizing: border-box;margin: 0;padding: 0;font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;} body {background-color: var(--background-color);color: var(--secondary-color);padding: 0;height: 100vh;display: flex;flex-direction: column;overflow: hidden;} .app-header {background: var(--header-bg);color: var(--header-text);padding: 15px 20px;box-shadow: var(--card-shadow);display: flex;justify-content: space-between;align-items: center;flex-shrink: 0;} .header-title {font-size: 1.5rem;font-weight: 600;letter-spacing: 0.5px;} .header-controls {display: flex;align-items: center;gap: 15px;} .theme-toggle {background: rgba(255, 255, 255, 0.2);border: none;color: var(--header-text);padding: 8px 12px;border-radius: 20px;cursor: pointer;font-size: 0.9rem;transition: background 0.3s ease;display: flex;align-items: center;gap: 5px;} .theme-toggle:hover {background: rgba(255, 255, 255, 0.3);} .container {max-width: 1400px;margin: 0 auto;width: 100%;display: flex;flex-direction: column;flex-grow: 1;overflow: hidden;padding: 20px;} .main-content {display: flex;gap: 20px;flex-grow: 1;min-height: 0;overflow: hidden;} .errors-page {display: flex;flex-direction: column;flex-grow: 1;overflow: hidden;} .controls-container {display: flex;justify-content: space-between;align-items: center;margin-bottom: 20px;flex-wrap: wrap;gap: 15px;} .filter-controls {display: flex;align-items: center;gap: 10px;flex-wrap: wrap;} .filter-controls label {font-weight: 600;} .filter-controls input, .filter-controls select {padding: 8px 12px;border: 1px solid var(--border-color);border-radius: 4px;background-color: white;color: var(--secondary-color);} [data-theme="dark"] .filter-controls input, [data-theme="dark"] .filter-controls select {background-color: #2c3e50;border-color: #444;color: #e0e0e0;} .filter-controls input.invalid {border-color: var(--error-color);} .clear-filter {background-color: var(--secondary-color);color: white;border: none;padding: 8px 12px;border-radius: 4px;cursor: pointer;font-weight: 500;transition: background-color 0.2s;} .clear-filter:hover {background-color: #1a2530;} .pagination-controls {display: flex;align-items: center;} .pagination {display: flex;align-items: center;} .pagination button {background-color: white;border: 1px solid var(--border-color);padding: 5px 10px;margin: 0 5px;border-radius: 4px;cursor: pointer;transition: background-color 0.2s;color: var(--secondary-color);} [data-theme="dark"] .pagination button {background-color: #2c3e50;border-color: #444;color: #e0e0e0;} .pagination button:hover:not(:disabled) {background-color: var(--hover-color);} .pagination button:disabled {opacity: 0.5;cursor: not-allowed;} .pagination button.active {background-color: var(--primary-color);color: white;border-color: var(--primary-color);} .pagination-info {margin: 0 15px;color: #6c757d;font-size: 0.9rem;} .errors-list {flex-grow: 1;overflow-y: auto;background-color: white;border-radius: 8px;box-shadow: var(--card-shadow);display: flex;flex-direction: column;} [data-theme="dark"] .errors-list {background-color: #2c3e50;} .errors-list-header {display: flex;border-bottom: 2px solid var(--border-color);font-weight: bold;background-color: var(--hover-color);flex-shrink: 0;} .column-header {padding: 12px 15px;display: flex;align-items: center;} .date-column {flex: 0 0 120px;border-right: 1px solid var(--border-color);} .time-column {flex: 0 0 80px;border-right: 1px solid var(--border-color);} .message-column {flex: 1;} .sort-button {background: none;border: none;cursor: pointer;margin-left: 8px;font-size: 0.9em;color: var(--primary-color);} .errors-list-body {flex-grow: 1;overflow-y: auto;} .error-row {display: flex;border-bottom: 1px solid var(--border-color);cursor: pointer;transition: background-color 0.2s;} .error-row:hover {background-color: var(--hover-color);} .error-row:last-child {border-bottom: none;} .error-cell {padding: 12px 15px;} .date-cell {flex: 0 0 120px;border-right: 1px solid var(--border-color);font-family: monospace;font-weight: 500;} .time-cell {flex: 0 0 80px;border-right: 1px solid var(--border-color);font-family: monospace;font-weight: 500;} .message-cell {flex: 1;display: flex;align-items: center;} .error-icon {margin-right: 8px;font-size: 1.1em;} .error-message-content {flex-grow: 1;} .error-message-text {font-weight: 500;} .error-message-text.error {color: var(--error-color);} .error-message-text.warning {color: var(--warning-color);} .error-message-text.info {color: var(--primary-color);} .error-id {font-family: monospace;color: #6c757d;font-size: 0.9em;margin-left: 10px;} .stack-viewer-page {display: none;flex-direction: column;flex-grow: 1;overflow: hidden;} .stack-viewer-header {display: flex;justify-content: space-between;align-items: center;margin-bottom: 20px;} .back-button {background-color: var(--secondary-color);color: white;border: none;padding: 8px 16px;border-radius: 4px;cursor: pointer;font-weight: bold;display: flex;align-items: center;transition: background-color 0.2s;} .back-button:hover {background-color: #1a2530;} .back-icon {margin-right: 8px;} .stack-viewer-title {font-size: 1rem;color: #2A3987;max-width:60%;} .stack-viewer-content {display: flex;gap: 20px;flex-grow: 1;min-height: 0;overflow: hidden;} .stack-grid, .variables-panel {flex: 1;background-color: white;border-radius: 8px;box-shadow: var(--card-shadow);display: flex;flex-direction: column;overflow: hidden;} [data-theme="dark"] .stack-grid, [data-theme="dark"] .variables-panel {background-color: #2c3e50;} .grid-header, .panel-header {background-color: var(--primary-color);color: white;padding: 15px;font-weight: bold;flex-shrink: 0;} .panel-header {background-color: var(--secondary-color);} .grid-content, .panel-content {flex-grow: 1;overflow-y: auto;padding: 0;} .stack-level {padding: 12px 15px;border-bottom: 1px solid var(--border-color);cursor: pointer;transition: background-color 0.2s;display: flex;align-items: center;} .stack-level:hover {background-color: var(--hover-color);} .stack-level.selected {background-color: var(--selected-color);border-left: 4px solid var(--primary-color);} .level-number {font-weight: bold;margin-right: 15px;min-width: 30px;} .level-type {font-weight: 600;margin-right: 15px;min-width: 120px;} .level-line {color: #6c757d;font-size: 0.9em;flex-grow: 1;} .variables-container {padding: 15px;} .variable-item {margin-bottom: 10px;padding: 10px;background-color: var(--variable-bg);border-radius: 4px;display: flex;} .variable-name {font-weight: 600;margin-right: 10px;min-width: 120px;} .variable-value {color: #28a745;font-family: monospace;} .empty-state {text-align: center;color: #6c757d;padding: 30px;} .intrinsics-section {margin-top: 20px;border-top: 1px solid var(--border-color);padding-top: 15px;} .intrinsics-title {font-weight: bold;margin-bottom: 10px;color: var(--primary-color);} .intrinsic-item {margin-bottom: 8px;display: flex;} .intrinsic-name {font-weight: 600;margin-right: 10px;min-width: 80px;font-family: monospace;} .intrinsic-value {color: #495057;font-family: monospace;word-break: break-all;} .notification {position: fixed;top: 20px;right: 20px;background-color: var(--primary-color);color: white;padding: 15px 20px;border-radius: 4px;box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);transform: translateX(150%);transition: transform 0.3s ease-out;z-index: 1000;} .notification.show {transform: translateX(0);} .notification.error {background-color: var(--error-color);} .notification.warning {background-color: var(--warning-color);} .loading {display: flex;justify-content: center;align-items: center;height: 100%;color: var(--loading-color);} .loading-spinner {border: 4px solid rgba(0, 0, 0, 0.1);border-radius: 50%;border-top: 4px solid var(--primary-color);width: 30px;height: 30px;animation: spin 1s linear infinite;margin-right: 10px;} @keyframes spin {0% {transform: rotate(0deg);} 100% {transform: rotate(360deg);}} .date-hint {font-size: 0.85rem;color: #6c757d;margin-left: 10px;} .error-count {background-color: var(--error-color);color: white;padding: 5px 12px;border-radius: 20px;font-weight: bold;margin-left: 10px;} .namespace-info {display: flex;align-items: center;margin-right: 15px;font-size: 0.9rem;color: var(--primary-color);}
	]]>>
</data>
}

ClassMethod Scripts()
{

	&HTML<
	<script language="javascript">
		const mtoday = new Date().toISOString().split('T')[0];
		//document.getElementById("dateFilter").setAttribute("max", mtoday);

        let cursor = null;
        let currentPage = 1;
        let counter=1;
        let rowsPerPage = 10;
        let totalPages = 1;
        let selectedDate = null;
        let selectedNamespace = "%SYS";
        let isLoadingErrors = false;
        let isLoadingStackTrace = false;
        const today = new Date();
        let hasSearched = false;
        let date=today.toISOString().split('T')[0];
        let xdate=today.toISOString().split('T')[0];
        let direction=1;
        let hasDateFiltered = false;
        let sortBy = 'date'; // Default sort by date
        let sortOrder = 'desc'; // Default sort order (newest first)

        async function fetchErrors(params = {}) {
	        if (!cursor) {
	            cursor = xdate+"|"+counter;
            }
            else {
            }
            let res = #server(..GetErrorsInfo(params.namespace,cursor,params.direction,rowsPerPage))#;
            response = JSON.parse(res);
            cursor= response.cursor;
            return response;
        }

        // Function to fetch stack trace from API
        async function fetchStackTrace(errorId,timestamp) {
           const [month, day, year] = timestamp.split(' ')[0].split('/');
		   const formattedDate = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
		   response = #server(..CollectStackInfo(formattedDate,errorId,selectedNamespace))#;
		   response = JSON.parse(response);
		   return response;
        }

        // Theme management
        function initTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
            updateThemeButton(savedTheme);
        }

        function initNamespace() {
			  let namespace = localStorage.getItem('namespace');
			  if (!namespace) {
			    namespace = '%SYS'; // default
			    try {
			      localStorage.setItem('namespace', namespace);
			    } catch (e) {
			      console.error('Could not set default namespace in localStorage', e);
			    }
			  }
			  changeNamespace(namespace);
			}

        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'light' ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeButton(newTheme);
        }

        function updateThemeButton(theme) {
            const themeIcon = document.getElementById('themeIcon');
            const themeText = document.getElementById('themeText');

            if (theme === 'dark') {
                themeIcon.textContent = '☀️';
                //themeText.textContent = 'Light Mode';
            } else {
                themeIcon.textContent = '🌙';
               // themeText.textContent = 'Dark Mode';
            }
        }

        // Function to show notification
        function showNotification(message, type = 'info') {
            const notification = document.getElementById('notification');
            notification.textContent = message;
            notification.className = 'notification show';

            if (type === 'error') {
                notification.classList.add('error');
            } else if (type === 'warning') {
                notification.classList.add('warning');
            }

            setTimeout(() => {
                notification.classList.remove('show');
            }, 3000);
        }

        // Function to load errors from API
        async function loadErrors(direction=1) {
            if (isLoadingErrors) return;

            isLoadingErrors = true;
            const errorsListBody = document.getElementById('errorsListBody');

            // Show loading state
            errorsListBody.innerHTML = `
                <div class="loading">
                    <div class="loading-spinner"></div>
                    <div>Loading errors...</div>
                </div>
            `;

            try {
                const params = {
                    limit: rowsPerPage,
                    namespace: selectedNamespace,
                    direction: direction,
                    date: date,
                    counter: counter
                };
                if (selectedDate) {
                    params.date = selectedDate;
                }

                const response = await fetchErrors(params);

                // Check if response is valid
                if (!response || !response.data || !response.pagination) {
                    throw new Error('Invalid API response format');
                }

                // Update pagination state
                totalPages = response.pagination.totalPages;

                counter = response.counter
                date = response.date
                firstErrDate = response.firstErrDate;

                const errorCount = document.getElementById('errorCount');
                if (errorCount) {
                    errorCount.textContent = `${response.pagination.total} Errors`;
                }
                renderErrorsList(response.data);
                counter = response.counter
                date = response.date
                updatePaginationInfo(response.pagination);

            } catch (error) {
                errorsListBody.innerHTML = `
                    <div class="empty-state">
                        Failed to load errors. Please try again.
                        <br><small>Error: ${error.message}</small>
                    </div>
                `;
                showNotification('Failed to load errors: ' + error.message, 'error');
            } finally {
                isLoadingErrors = false;
            }
        }

        // Function to change namespace
        function changeNamespace(namespace = '') {
            const namespaceSelect = document.getElementById('namespaceSelect');
            //const dateFilter = document.getElementById('dateFilter');
            //dateFilter.value = '';

            if (namespaceSelect) {
	            selectedNamespace = namespaceSelect.value;
                const currentNamespace = document.getElementById('currentNamespace');
                if (currentNamespace) {
                    currentNamespace.textContent = selectedNamespace;
                }
                currentPage = 1;
                date=xdate;
                counter='';
                cursor=null;
                loadErrors();
                showNotification(`Switched to ${selectedNamespace} namespace`);
                localStorage.setItem('namespace', selectedNamespace);
            }
        }

		async function fetchErrorsByText(errText=null) {
			let response = #server(..GetErrorsByText(errText,selectedNamespace,rowsPerPage))#;
			response = JSON.parse(response);
			return response;
			;

        }


        // Function to clear date filter
        function clearDateFilter() {
           // const dateFilter = document.getElementById('dateFilter');
            const seachErrorTxt = document.getElementById('seachErrorTxt');
            if (seachErrorTxt.value!='') {
	            //reset all
	            seachErrorTxt.value=''
	            date = xdate;
	            counter = null;
	            cursor='';
	            loadErrors();
            }

        }

        function seachErrorFilter() {

	        //alert('test');
        }


document.addEventListener('DOMContentLoaded', () => {
    const inputEl = document.getElementById('seachErrorTxt');
    const button = document.getElementById('seachError');

    if (!inputEl || !button) return;

    // Listen for input changes
    inputEl.addEventListener('input', async function () {
      const value = inputEl.value.trim();

      // Enable or disable button based on input
      button.disabled = value === '';

      // If input is cleared, automatically reload errors
      if (value === '') {
        try {
          await loadErrors(); // Reload all errors when input is cleared
        } catch (error) {
          console.error('Error auto-fetching full results:', error);
        }
      }
    });
  });

  // Search function
  async function seracherrors() {
    const inputEl = document.getElementById('seachErrorTxt');

    if (!inputEl) return;

    const searchValue = inputEl.value.trim();

    if (searchValue === '') {
      try {
        await loadErrors(); // Load full list
      } catch (error) {
        console.error('Error fetching full error list:', error);
      }
      return;
    }

    try {
      const response = await fetchErrorsByText(searchValue);
      renderErrorsList(response.data);
    } catch (error) {
      console.error('Error fetching filtered errors:', error);
    }
  }

        // Function to update pagination info
        function updatePaginationInfo(pagination) {
            const paginationInfo = document.getElementById('paginationInfo');
            const startItem = pagination.total === 0 ? 0 : (pagination.page - 1) * pagination.limit + 1;
            const endItem = Math.min(pagination.page * pagination.limit, pagination.total);

            if (paginationInfo) {
                paginationInfo.textContent = `Page ${pagination.page} of ${pagination.totalPages} (${startItem}-${endItem} of ${pagination.total})`;
            }

            // Update button states
            const prevButton = document.getElementById('prevPage');
            const nextButton = document.getElementById('nextPage');
            //alert(pagination.page+'   '+ pagination.totalPages)
           // alert(pagination.page === 1 || pagination.totalPages === 0);


            //if (prevButton) prevButton.disabled =  1;
            //if (nextButton) nextButton.disabled = (date==''&& counter=='');
        }

        // Function to render errors list
        function renderErrorsList(errors) {
            const errorsListBody = document.getElementById('errorsListBody');

            if (!errorsListBody) return;

            if (errors.length === 0) {
                errorsListBody.innerHTML = `
                    <div class="empty-state">
                        No errors found for the selected criteria
                    </div>
                `;
                return;
            }

            errorsListBody.innerHTML = '';

            errors.forEach(error => {
                const errorRow = document.createElement('div');
                errorRow.className = 'error-row';

                // Split timestamp into date and time
                const [datePart, timePart] = error.timestamp.split(' ');

                let icon = '';
                if (error.type === 'error') {
                    //icon = '❌';
                } else if (error.type === 'warning') {
                    //icon = '⚠️';
                } else {
                    //icon = 'ℹ️';
                }

                errorRow.innerHTML = `
                    <div class="error-cell date-cell">${datePart}</div>
                    <div class="error-cell time-cell">${timePart}</div>
                    <div class="error-cell time-cell">${error.process}</div>
                    <div class="error-cell time-cell">${error.id}</div>
                    <div class="error-cell message-cell">
                        <span class="error-icon">${icon}</span>
                        <div class="error-message-content">
                            <div class="error-message-text ${error.type}">${error.message}</div>
                            <!--span class="error-id">${error.id}</span-->
                        </div>
                    </div>
                    <div class="error-cell time-cell">${error.user}</div>
                `;

                errorRow.addEventListener('click', () => {
                    currentError = error;
                    showStackTraceViewer(error);
                });

                errorsListBody.appendChild(errorRow);
            });
        }

        // Function to show stack trace viewer
        async function showStackTraceViewer(error) {
            const errorsPage = document.getElementById('errorsPage');
            const stackViewerPage = document.getElementById('stackViewerPage');
            const errorTitle = document.getElementById('errorTitle');
            const stackLevels = document.getElementById('stackLevels');

            // Update error title
            if (errorTitle) {
                //errorTitle.textContent = `${error.id}: ${error.message}`;
                errorTitle.textContent = `${error.message}`;
            }

            // Hide errors page and show stack viewer page
            if (errorsPage) errorsPage.style.display = 'none';
            if (stackViewerPage) stackViewerPage.style.display = 'flex';

            // Show loading state for stack trace
            if (stackLevels) {
                stackLevels.innerHTML = `
                    <div class="loading">
                        <div class="loading-spinner"></div>
                        <div>Loading stack trace...</div>
                    </div>
                `;
            }

            try {
                // Load stack trace for the selected error

                const response = await fetchStackTrace(error.id,error.timestamp);


                // Check if response is valid
                if (!response || !response.data) {
                    throw new Error('Invalid stack trace response format');
                }

                // Fetch intrinsics data for the selected error

                //const intrinsicsResponse = await fetchIntrinsics(error.id, error.timestamp);


                // Store intrinsics data for current error
                //currentIntrinsics = intrinsicsResponse || [];

                renderStackLevels(response.data);

                // Show notification
                showNotification(`Showing stack trace for ${error.id}`);
            } catch (error) {

                if (stackLevels) {
                    stackLevels.innerHTML = `
                        <div class="empty-state">
                            Failed to load stack trace. Please try again.
                            <br><small>Error: ${error.message}</small>
                        </div>
                    `;
                }
                showNotification('Failed to load stack trace: ' + error.message, 'error');
            }
        }

        // Function to render stack levels
        function renderStackLevels(stackData) {
            const stackLevelsContainer = document.getElementById('stackLevels');

            if (!stackLevelsContainer) return;

            stackLevelsContainer.innerHTML = '';

            // Stack levels are already in reverse order in our data
            stackData.forEach(level => {
                const levelElement = document.createElement('div');
                levelElement.className = 'stack-level';
                levelElement.dataset.level = level.level;

                // create the Stack Levels (Last In First Out)
                levelElement.innerHTML = `
                    <div class="level-number">${level.level}</div>
                    <div class="level-type">${level.type}</div>
                    <div class="level-line">${level.line} ${level.source}</div>
                `;

                levelElement.addEventListener('click', () => {
                    // Remove selected class from all levels
                    document.querySelectorAll('.stack-level').forEach(el => {
                        el.classList.remove('selected');
                    });

                    // Add selected class to clicked level
                    levelElement.classList.add('selected');

                    // Show variables for selected level

                    showVariables(level);
                });

                stackLevelsContainer.appendChild(levelElement);
            });
        }

        // Function to show variables for a selected level
        function showVariables(level) {
            const variablesContent = document.getElementById('variablesContent');

            //if (!variablesContent) return;
            variablesContent.innerHTML = '';

            const variablesContainer = document.createElement('div');
            variablesContainer.className = 'variables-container';

            /*if (!level.variables || level.variables.length === 0) {
                variablesContainer.innerHTML = `
                    <div class="empty-state">
                        No variables available for level ${level.level}
                    </div>
                `;
                variablesContent.appendChild(variablesContainer);
                return;
            }

            // Create variables section
            const variablesSection = document.createElement('div');
            variablesSection.innerHTML = `<h3>Level ${level.level} Variables</h3>`;

            level.variables.forEach(variable => {
                const variableElement = document.createElement('div');
                variableElement.className = 'variable-item';

                variableElement.innerHTML = `
                    <div class="variable-name">${variable.name}</div>
                    <div class="variable-value">${variable.value}</div>
                `;

                variablesSection.appendChild(variableElement);
            });

            variablesContainer.appendChild(variablesSection);
             */

            // Add intrinsics section using fetched data
            const intrinsicsSection = document.createElement('div');
            intrinsicsSection.className = 'intrinsics-section';
            intrinsicsSection.innerHTML = '<div class="intrinsics-title">Variables</div>';

           currentIntrinsics=level.intrinsics

            // Check if we have intrinsics data
            if (currentIntrinsics && currentIntrinsics.length > 0) {
                currentIntrinsics.forEach(intrinsic => {

                    const intrinsicElement = document.createElement('div');
                    intrinsicElement.className = 'intrinsic-item';

                    intrinsicElement.innerHTML = `
                        <div class="intrinsic-name">${intrinsic.name}</div>
                        <div class="intrinsic-value">${intrinsic.value}</div>
                    `;

                    intrinsicsSection.appendChild(intrinsicElement);
                });
            } else {
                // Show message if no intrinsics data available
                const noIntrinsicsElement = document.createElement('div');
                noIntrinsicsElement.className = 'empty-state';
                noIntrinsicsElement.textContent = 'No intrinsics data available';
                intrinsicsSection.appendChild(noIntrinsicsElement);
            }

            variablesContainer.appendChild(intrinsicsSection);
            variablesContent.appendChild(variablesContainer);

            // Show notification
           // showNotification(`Showing variables for stack level ${level.level}`);
        }

        // Function to go back to errors page
        function goBackToErrors() {
            const errorsPage = document.getElementById('errorsPage');
            const stackViewerPage = document.getElementById('stackViewerPage');

            // Show errors page and hide stack viewer page
            if (errorsPage) errorsPage.style.display = 'flex';
            if (stackViewerPage) stackViewerPage.style.display = 'none';

            // Show notification
            showNotification('Back to errors list');
        }

        // Function to change rows per page
        function changeRowsPerPage() {
            const rowsPerPageSelect = document.getElementById('rowsPerPage');
            if (rowsPerPageSelect) {
                rowsPerPage = parseInt(rowsPerPageSelect.value);
                currentPage = 1; // Reset to first page
                loadErrors();
                showNotification(`Showing ${rowsPerPage} rows per page`);
            }
        }

        // Function to go to previous page
        function goToPrevPage() {
            if (currentPage >= 1) {
                currentPage--;
                loadErrors(0);
            }

        }

        // Function to go to next page
        function goToNextPage() {
            if (currentPage < totalPages) {
                currentPage++;
                loadErrors(1);
            }
        }


        // Initialize the application
        document.addEventListener('DOMContentLoaded', () => {


            // Initialize theme
            initTheme();
            initNamespace();
            // Load errors on initial page load
            loadErrors();

            // Set up event listeners with null checks
            const backButton = document.getElementById('backButton');
            if (backButton) backButton.addEventListener('click', goBackToErrors);

            const rowsPerPageSelect = document.getElementById('rowsPerPage');
            if (rowsPerPageSelect) rowsPerPageSelect.addEventListener('change', changeRowsPerPage);

            const prevPageButton = document.getElementById('prevPage');
            if (prevPageButton) prevPageButton.addEventListener('click', goToPrevPage);

            const nextPageButton = document.getElementById('nextPage');
            if (nextPageButton) nextPageButton.addEventListener('click', goToNextPage);

            const namespaceSelect = document.getElementById('namespaceSelect');
            if (namespaceSelect) namespaceSelect.addEventListener('change', changeNamespace);

            //const dateFilter = document.getElementById('dateFilter');
           // if (dateFilter) dateFilter.addEventListener('change', fetchErrorsByDate);

            const clearFilterButton = document.getElementById('clearFilter');
            if (clearFilterButton) clearFilterButton.addEventListener('click', clearDateFilter);

			const seachErrorButton = document.getElementById('seachError');
            if (seachError) clearFilterButton.addEventListener('click', seachErrorFilter);

            const sortDateButton = document.getElementById('sortDate');
            if (sortDateButton) sortDateButton.addEventListener('click', () => toggleSortOrder('date'));

            const sortTimeButton = document.getElementById('sortTime');
            if (sortTimeButton) sortTimeButton.addEventListener('click', () => toggleSortOrder('time'));

            const themeToggleButton = document.getElementById('themeToggle');
            if (themeToggleButton) themeToggleButton.addEventListener('click', toggleTheme);

            // Add real-time validation for date input
            /*

				if (dateFilter) {
				                dateFilter.addEventListener('input', function() {
				                    if (this.value && !isValidDate(this.value)) {
				                        this.classList.add('invalid');
				                    } else {
				                        this.classList.remove('invalid');
				                    }
				                });
				            }
				*/
        });


        async function fetchErrorsByDate(date) {
	        if (event.type=='change') return 0;
	        zdate=date;
	        mcounter=1;
	        alert('fetchErrorsByDate: '+zdate);
	        if (isLoadingErrors) return;

             console.log("Event object:", event);
		    console.log("Event target:", event.target);
		    console.trace("Event triggered");

            isLoadingErrors = true;
            const errorsListBody = document.getElementById('errorsListBody');

            // Show loading state
            errorsListBody.innerHTML = `
                <div class="loading">
                    <div class="loading-spinner"></div>
                    <div>Loading errors...</div>
                </div>
            `;

            try {
                const params = {
                    limit: rowsPerPage,
                    namespace: selectedNamespace,
                    direction: mcounter,
                    date: zdate,
                    counter: mcounter,
                    filterByDate:1,
                    cursor:''
                };
                if (selectedDate) {
                    params.date = selectedDate;
                }
                zcursor=params.cursor|| '';
                //pDate, namespace , cursor, direction , limit
                let response = #server(..GetErrorsPageByDate(params.date,params.namespace,zcursor,params.direction,params.limit))#;

                response = JSON.parse(response);
                console.log(response.data);

                // Check if response is valid
                if (!response || !response.data || !response.pagination) {
                    throw new Error('Invalid API response format');
                }

                // Update pagination state
                totalPages = response.pagination.totalPages;

                //for cursor pagination
                counter = response.counter
                //for cursor pagination
                date = response.date
                firstErrDate = response.firstErrDate
                //alert(firstErrDate);

                // Update error count
                const errorCount = document.getElementById('errorCount');
                if (errorCount) {
                    errorCount.textContent = `${response.pagination.total} Errors`;
                }

                // Render errors
                renderErrorsList(response.data);
                //for cursor pagination
                counter = response.counter
                //for cursor pagination
                date = response.date

                // Update pagination info
                updatePaginationInfo(response.pagination);

            } catch (error) {
                errorsListBody.innerHTML = `
                    <div class="empty-state">
                        Failed to load errors. Please try again.
                        <br><small>Error: ${error.message}</small>
                    </div>
                `;
                showNotification('Failed to load errors: ' + error.message, 'error');
            } finally {
                isLoadingErrors = false;
            }
	        return

		}


        /// Date filter

		/*document.addEventListener('DOMContentLoaded', () => {
		  const dateInput = document.getElementById('dateFilter');

		  if (!dateInput) return;

		  dateInput.addEventListener('input', async function () {
		    const selectedDate = dateInput.value;
		    if (selectedDate) {
		      try {
		        const response = await fetchErrorsByDate(selectedDate);
		        renderErrorsList(response.data);
		        hasDateFiltered = true;
		      } catch (error) {
		        console.error('Error fetching errors by date:', error);
		      }
		    } else if (hasDateFiltered) {
		      try {
		        loadErrors(); // Reset to full list
		        hasDateFiltered = false;
		      } catch (error) {
		        console.error('Error reloading full error list:', error);
		      }
		    }
		  });
		});*/

		/*
        // Function to toggle sort order
        function toggleSortOrder(column) {
	        return 0;
            // If clicking the same column, toggle order
            if (sortBy === column) {
                sortOrder = sortOrder === 'asc' ? 'desc' : 'asc';
            } else {
                // If clicking a different column, set new column and default to desc
                sortBy = column;
                sortOrder = 'desc';
            }

            // Update sort buttons
            const sortDateButton = document.getElementById('sortDate');
            const sortTimeButton = document.getElementById('sortTime');

            // Reset both buttons
            if (sortDateButton) sortDateButton.textContent = '↑';
            if (sortTimeButton) sortTimeButton.textContent = '↑';

            // Set active button
            if (column === 'date' && sortDateButton) {
                sortDateButton.textContent = sortOrder === 'asc' ? '↑' : '↓';
            } else if (column === 'time' && sortTimeButton) {
                sortTimeButton.textContent = sortOrder === 'asc' ? '↑' : '↓';
            }

            // Reload errors with new sort order
            currentPage = 1; // Reset to first page
            loadErrors();

            const columnText = column === 'date' ? 'date' : 'time';
            const orderText = sortOrder === 'asc' ? 'ascending' : 'descending';
            showNotification(`Sorting by ${columnText}: ${orderText}`);
        }
		*/

		/*

        // Function to validate date format (YYYY-MM-DD)
        function isValidDate(dateString) {
            if (!dateString) return true; // Empty date is valid (means no filter)

            const regex = /^\d{4}-\d{2}-\d{2}$/;
            if (!regex.test(dateString)) return false;

            const date = new Date(dateString);
            const timestamp = date.getTime();

            // Check if the date is valid
            if (typeof timestamp !== 'number' || Number.isNaN(timestamp)) return false;

            // Check if the parsed date components match the input
            const [year, month, day] = dateString.split('-').map(Number);
            return (
                date.getFullYear() === year &&
                date.getMonth() + 1 === month &&
                date.getDate() === day
            );
        }
		*/

        ////
    </script>
	>
}

/// need to add pagination based on limit
ClassMethod GetErrorsByText(errorText As %String = "", selectedNamespace As %String = "", pLimit) As %String
{
	#Define Null		""
	#dim response As %DynamicArray = []

	New $NAMESPACE
	Set errGbl = $NA(@..#ERR)
	Set:$Get(selectedNamespace)]"" $NAMESPACE=selectedNamespace
	Set firstErrDate = $Order(@errGbl@($$$Null))
	Set firstErrorCount=$Order(@errGbl@(firstErrDate,""))
	Set lastErrDate = $Order(@errGbl@($$$Null),-1)
	Set errorText = $ZCVT(errorText,"U")
	;
	For date = lastErrDate:-1:firstErrDate{
		For counter = $Order(@errGbl@(date,$$$Null),-1):-1:1{
			Set error = @errGbl@(date,counter,"*STACK",0,"V","$ZE")
			If $ZCVT(error,"U")[errorText {
				Do response.%Push(..BuildErrorMsgResponse(date,counter))
				Set recCount = $I(recCount)
			}
		}
	}
	Return {
		"pagination":{
			"total":(0),
			"page":(0),
			"totalPages":($G(totalPages,0))
		},
		"date":(date),
		"counter":(counter),
		"page":(0),
		"data":(response),
		"firstErrDate":(firstErrDate)
    }.%ToJSON()
}

ClassMethod GetErrorsInfo(namespace As %String, cursor As %String, direction As %String, limit As %Integer = 10) As %DynamicObject
{
	New $NAMESPACE
	Set $NAMESPACE = namespace
	;
	Set date = $P(cursor,"|")
	Set counter = $P(cursor,"|",2)

	Set direction=$Case(direction,1:"next",:"prev")
	Set errData = ..GetErrorsPage(limit,.cursor,direction)
	Set errorCount = ..GetErrorCount()
	Set totalPages = (errorCount + limit - 1) \ limit
	;
END	Set data= {
		"pagination":{
			"total":(errorCount),
			"page":(0),
			"totalPages":(totalPages)
		},
		"date":($P(cursor,"|")),
		"counter":($P(cursor,"|",2)),
		"page":(1),
		"data":(errData),
		"cursor":(cursor)
    }
    Return data.%ToJSON()
}

ClassMethod GetErrorsPage(pPageSize As %Integer = 10, pCursor As %String, pDirection As %String = "next")
{
	Set (date,counter,result)=""
	Set count=0
	Set arr=[]
	Set newCursor=""
	Set globalName=$NA(@..#ERR)
	If pCursor'="" {
		Set date = ..GetHorologFromDate($P(pCursor,"|"))
		Set counter = $Piece(pCursor,"|",2)
	}
	; initilize traversal key
	If pCursor=""&&(pDirection="next") {
		Set date = $Order(@globalName@(""),-1)
		If date="" Quit ""
		Set counter = $Order(@globalName@(date,""),-1)
	}
	ElseIf pCursor=""&&(pDirection="prev") {
		Quit ""
	}
	While count<pPageSize  {
		If pDirection="next" {
			Set counter = $Order(@globalName@(date,counter),-1)
			If counter="" {
				Set date = $Order(@globalName@(date),-1)
				If date="" Quit
				Set counter = $Order(@globalName@(date,""),-1)
			}
		}
		ElseIf pDirection="prev" {
			Set counter = $Order(@globalName@(date,counter),1)
			If counter="" {
				Set date = $Order(@globalName@(date),1)
				If date="" Quit
				Set counter = $Order(@globalName@(date,""),1)
			}
		}
		If date=""||(counter="") Quit
		Set json  = ..BuildErrorMsgResponse(date,counter)
		If pDirection="prev"{
			Set rec(date,counter)=json
		}
		Else{
			Do arr.%Push(json)
		}
		Set errKey=date_"|"_counter
		Set count=$I(count)
		Set newCursor = errKey
	}
	Set pCursor = newCursor
	If pDirection="prev"{
		Set sub=""
		For {
			Set sub=$o(rec(sub),-1) q:sub=""
			Set cnt=""
			For {
				Set cnt=$o(rec(sub,cnt),-1,drec) Quit:cnt=""
				Do arr.%Push(drec)
			}
		}
	}
	Return arr
}

ClassMethod GetErrorsPageByDate(pDate As %String = "", namespace As %String = {$NAMESPACE}, cursor As %String = "", direction As %String = "next", limit As %Integer = 10) As %DynamicObject
{
	New $NAMESPACE
	Set $NAMESPACE = namespace
	Set direction = $S('direction:"prev",1:"next")
	Set errData = ..GetErrorsPageByDateInt(pDate,limit,.cursor,direction)
	Set data= {
		"pagination":{
			"total":($G(errorCount,0)),
			"page":(1),
			"totalPages":($G(totalPages,0))
		},
		"date":($P(cursor,"|")),
		"counter":($P(cursor,"|",2)),
		"page":(1),
		"data":(errData),
		"cursor":(cursor),
		"firstErrDate":($G(firstErrDate,0))
    }
    Return data.%ToJSON()
}

ClassMethod GetErrorsPageByDateInt(pDate As %String, pPageSize As %Integer = 10, pCursor, pDirection As %String = "next")
{
	Set (counter,result)=""
	Set count=0
	Set arr=[]
	set newCursor=""
	Set globalName=$NA(@..#ERR)
	Set pDateCopy = pDate
	Set pDate=..GetHorologFromDate(pDate)
	Set date=pDate
	If pCursor'="" {
		Set date = ..GetHorologFromDate($P(pCursor,"|"))
		Set counter = $P(pCursor,"|",2)
	}
	If pCursor=""&&(pDirection="next") {
		Set date = ..GetHorologFromDate(pDate)
		If date="" Quit ""
		Set counter = $O(@globalName@(date,""),-1)
	}
	ElseIf pCursor=""&&(pDirection="prev") {
		Quit ""
	}
	While count<pPageSize  {
		If pDirection="next" {
			Set counter = $Order(@globalName@(date,counter),-1)
			If counter="" {
				Set date = $Order(@globalName@(date),-1)
				If date="" Quit
				Set counter = $Order(@globalName@(date,""),-1)
			}
		}
		ElseIf pDirection="prev" {
			Set counter = $Order(@globalName@(date,counter),1)
			If counter="" {
				Set date = $Order(@globalName@(date),1)
				If date="" Quit
				Set counter = $Order(@globalName@(date,""),1)
			}
		}
		If date=""||(counter="")||(date'=pDate) Quit
		Set json  = ..BuildErrorMsgResponse(date,counter)
		If pDirection="prev"{
			Set rec(date,counter)=json
		}
		Else{
			do arr.%Push(json)
		}
		Set errKey=date_"|"_counter
		Set count=$I(count)
		Set newCursor = errKey
	}
	Set pCursor = newCursor
	If pDirection="prev"{
		Set sub=""
		For {
			Set sub=$o(rec(sub),-1) q:sub=""
			Set cnt=""
			f {
				Set cnt=$o(rec(sub,cnt),-1,drec) Quit:cnt=""
				Do arr.%Push(drec)
			}
		}
	}
	return arr
}

ClassMethod CollectStackInfo(pDate = {+$H}, ErrorId = 35, Namespace = {$NAMESPACE})
{
	#define orefstr		"*OREF"

	#dim response As %DynamicObject  =  {"data":[]}

	New $NAMESPACE
	Set $NAMESPACE=Namespace
	;
	Set pDate=..GetHorologFromDate(pDate)
	If '$Data(@..#ERR(pDate,ErrorId)) Quit {}
	Set errGbl=$NAme(@..#ERR(pDate,ErrorId,"*STACK"))
	Set totalStackCount = $Order(@errGbl@(""),-1)
	Set start = 0
	If $D(@..#ERR(pDate,ErrorId,$$$orefstr)) {
		Set json={
			"intrinsics":[],
			"level":(totalStackCount+1),
			"line": "",
			"source": "",
			"variables": [],
			"type":"Dump Objects"
			}
		Set orefCount=""
		For {
			Set orefCount = $O(@..#ERR(pDate,ErrorId,$$$orefstr,orefCount)) q:orefCount=""
			Set orefData = ..BuildOrefDetails(pDate,ErrorId,orefCount)
			Set varJson={"name":("obj"_orefCount),"value":(orefData)}
			Do json.intrinsics.%Push(varJson)
		}
		Do response.data.%Push(json)
	}
	;
	For stackLevel = totalStackCount:-1:0 {
		Set data = $G(@errGbl@(stackLevel,"L"))
		Set str = $ZStrip(data, "<>", " ")
		Set data = $Replace($p(str," ",2,*)," ","&nbsp")
		If data=""&&(stackLevel=0) s data="Process State Intrinsics"
		Set json = {
			"level": (stackLevel),
			"type": (data),
			"line": "",
			"source": "",
			"variables": [
			  //{ "name": "dividend", "value": "100" },
			  //{ "name": "divisor", "value": "0" }
			]
		}
		;
		Set var=""
		Set data=[]
		For {
		  Set var = $Order(@errGbl@(stackLevel,"V",var),1,varibleData) Q:var=""
		  If $Data(@errGbl@(stackLevel,"V",var))>1 {
			  Set inc="",varibleData=""
			  For {
				  Set inc = $Order(@errGbl@(stackLevel,"V",var,inc),1,varibleData) Q:inc=""
				  Set var1=var
				  If $LG(varibleData,1)'="" {
					  Set var1=var_"("_""""_$REPLACE($LTS($LG(varibleData,1)),",",""",""")_""")"
				  }
				  Set varibleData = $LG(varibleData,3)
				  Set:varibleData["<" varibleData = ..EscapeHTML(varibleData)
				  Set varJson={"name":(var1),"value":(varibleData)}
				  Do data.%Push(varJson)
			  }
		  }
		  Else {
			  If $ListValid(varibleData) Set varibleData = $LTS(varibleData)
			  Set:varibleData["<" varibleData = ..EscapeHTML(varibleData)
			  Set varJson={"name":(var),"value":(varibleData)}
		  	  Do data.%Push(varJson)
		  }
		}
		Set json.intrinsics = data
		Do response.data.%Push(json)
	}
	Return response.%ToJSON()
}

ClassMethod BuildOrefDetails(pDate = {+$H}, ErrorId = 32, OrefData = 1)
{
	#define htmlbr		"<br>"
	#define orefstr		"*OREF"

  Set oref=+$g(OrefData)
  Set data=""
  If '$D(@..#ERR(pDate,ErrorId,$$$orefstr,+oref),desc) {
    Set data=data_"  ***ERROR***'"_oref_"' is not an oref value."_$$$htmlbr
    Quit ""
  }
  Set flags=$LI(desc,3)
  If flags["0" {
    Set data=data_"  ***WARNING*** Oref '"_oref_"' was missing or"_$$$htmlbr
    Set data=data_"  has been closed or was invalidated by the system."_$$$htmlbr
    Quit ""
  }
  ;
  Set class=$LI(desc,1)
  ;
  Set data=data_"+----------------- general information ---------------"_$$$htmlbr
  If flags["M" {
    Set data=data_"| ***WARNING*** instance different from latest class version"_$$$htmlbr
  }
  If flags["I" {
    Set data=data_"| ***ERROR*** Instance has an incomplete representation."_$$$htmlbr
  }
  Set data=data_"|      oref value: "_oref_$$$htmlbr
  Set data=data_"|      class name: "_class_$$$htmlbr
  If $Data(@..#ERR(pDate,ErrorId,$$$orefstr,oref,"%%OID")),$LD(desc,4,t) {
    Set data=data_"|           %%OID: "_$$Quote^%qcr(t)_$$$htmlbr
  }
  Set data=data_"| reference count: "_($LI(desc,2))_$$$htmlbr
  ;
  If flags["J" {
    Set data=data_"+----------------- JSON value ------------------------"_$$$htmlbr
    Set data=data_"| "_$LG(desc,5,"<Missing JSON>")_$$$htmlbr
    G last
  }
  ;
  Set data=data_"+----------------- property values --------------------"_$$$htmlbr
  Set prop="",found=0
  For  {
    Set prop=$O(@..#ERR(pDate,ErrorId,$$$orefstr,oref,prop),1,desc) Q:prop=""
    If prop="%%OID" Continue
    Set val=$LG(desc,3)
    If $LG(desc,2)="S" S val1=" <Set>"
    Set data=data_"|      "_$J(prop,17)_" = "_$S(val'="":val,1:"""""")_$G(val1)_$$$htmlbr
  }
  If found=0 Set data=data_"|           (none)"_$$$htmlbr
last ;
  Set data=data_"+-----------------------------------------------------"_$$$htmlbr
  ;
  Return data
}

ClassMethod GetHorologFromDate(pDate) As %Date [ CodeMode = expression ]
{
$Select(pDate?4N1"-"2N1"-"2N:$ZDH(pDate,3),1:pDate)
}

ClassMethod GetErrorCount() As %Integer
{
	Set count=0,date=""
	For { Set date=$O(@..#ERR(date)) Quit:date=""  Set count = count+$G(@..#ERR(date))}
	Return count
}

ClassMethod BuildErrorMsgResponse(date, counter) As %DynamicObject
{
	#define STCAK	"*STACK"
	#Define ZE		"$ZE"
	Set errGbl = $NA(@..#ERR)
	Set error = @errGbl@(date,counter,$$$STCAK,0,"V",$$$ZE)
	Set H = @errGbl@(date,counter,$$$STCAK,0,"V","$H")
	Set process = @errGbl@(date,counter,$$$STCAK,0,"V","$J")
	Set error = {
      "id": (counter),
      "message": (error),
      "timestamp": ($ZDateTime(H)),
      "type": "error",
      "namespace": ($Namespace),
      "process":(process),
      "user":(@errGbl@(date,counter,"*STACK",0,"V","$USERNAME"))
    }
    Return error
}

ClassMethod AppDescription() [ CodeMode = expression ]
{
"View the application error logs"
}

}
