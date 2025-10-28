Class ZIRIS.DevHub.Interop.LookupTables Extends ZIRIS.DevHub.Portal.Template
{
Parameter Title As STRING [ Final ] = "LookUp Tables";

Parameter APPLICATION As STRING = "LookUp Tables";

Parameter CATEGORY As STRING = "Interop";

Parameter LookupGbl As STRING [ Internal ] = "^Ens.LookupTable";

ClassMethod OnPageHEAD() As %Boolean
{
	Do ##super()
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Write "<link href=""https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"" rel=""stylesheet"">"
	Write "<link rel=""stylesheet"" href=""https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css"">"
	Write "<link rel=""stylesheet"" href=""https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"">"
	Return $$$OK
}

ClassMethod OnRenderScreen() As %Status
{
	&HTML<
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css"><link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"></head>
<script language="JavaScript" type="text/javascript" src="/irishealth2025com/csp/broker/cspxmlhttp.js"></script><script language="JavaScript" type="text/javascript" src="/irishealth2025com/csp/broker/cspbroker.js"></script>
<body>
    <header class="app-header">
        <h1 title="IntegrityLog files genreated via Integrity Check Task"><i class="bi bi-shield-check me-2"></i>LookUp Table</h1>
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="bi bi-moon-fill" id="theme-icon"></i>
        </button>
    </header>

    <div class="main-container">
        <div class="left-panel">
            <div class="left-panel-header">
            <select id="namespaceSelect">
            >
    Set rs = ##class(%SQL.Statement).%ExecDirect(, "SELECT Nsp FROM %SYS.Namespace_List()")
	While rs.%Next() {Write:##class(%EnsembleMgr).IsEnsembleNamespace(rs.Nsp) "<option value="""_rs.Nsp_""">"_rs.Nsp_"</option>"}
    &HTML<
            </select>
                <h5>Tables</h5>
                <button class="add-file-btn" onclick="showCreateFileModal()" title="Create New File">
                    <i class="bi bi-plus"></i>
                </button>
            </div>
            <div class="search-container">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" class="form-control border-start-0 search-box" id="fileSearch" placeholder="Search files...">
                </div>
            </div>
            <div class="file-list-container">
                <ul class="file-list" id="fileList">
                    <!-- Files will be populated here -->
                </ul>
            </div>
        </div>

        <div class="right-panel">
            <div class="empty-state" id="emptyState">
                <i class="bi bi-folder2-open"></i>
                <h4>Select a file to view details</h4>
                <p>Click on any file from the left panel to load its Lookup table details</p>
            </div>

            <div id="detailsContainer" style="display: none;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h5 id="selectedFileName"></h5>
                    <div class="action-buttons">
                        <button class="add-btn" id="addNewBtn" onclick="showAddModal()">
                            <i class="bi bi-plus-circle me-1"></i> Add New
                        </button>
                        <button class="delete-btn" id="deleteSelectedBtn" onclick="showDeleteModal()" disabled>
                            <i class="bi bi-trash me-1"></i> Delete Selected
                            <span class="selected-count" id="selectedCount"></span>
                        </button>
                        <button class="save-btn" id="saveChangesBtn" onclick="saveChanges()">
                            <i class="bi bi-save me-1"></i> Save Changes
                        </button>
                        <button class="cancel-btn" id="cancelChangesBtn" onclick="cancelChanges()">
                            <i class="bi bi-x-circle me-1"></i> Cancel
                        </button>
                    </div>
                </div>
                <table id="detailsTable" class="table table-striped table-hover" style="width:100%">
                    <thead>
                        <tr>
                            <th class="checkbox-cell">
                                <input type="checkbox" id="selectAllCheckbox" onchange="toggleSelectAll()">
                            </th>
                            <th>Key</th>
                            <th>Value</th>
                            <th>Old Value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data will be populated here -->
                    </tbody>
                </table>
            </div>

            <div class="loading-spinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Create File Modal -->
    <div id="createFileModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Create New File</h3>
                <span class="modal-close" onclick="closeCreateFileModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="newFileName">File Name:</label>
                    <input type="text" id="newFileName" class="form-control" placeholder="Enter file name">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeCreateFileModal()">Cancel</button>
                <button class="btn-primary" onclick="createNewFile()">Create File</button>
            </div>
        </div>
    </div>

    <!-- Add New Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Add New Entry</h3>
                <span class="modal-close" onclick="closeAddModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="newKey">Key:</label>
                    <input type="text" id="newKey" class="form-control" placeholder="Enter key">
                </div>
                <div class="form-group">
                    <label for="newValue">Value:</label>
                    <input type="text" id="newValue" class="form-control" placeholder="Enter value">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeAddModal()">Cancel</button>
                <button class="btn-primary" onclick="addNewEntry()">Add Entry</button>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Confirm Deletion</h3>
                <span class="modal-close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the selected entries?</p>
                <p id="deleteCount" style="font-weight: 600;"></p>
                <p>This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <button class="btn-danger" onclick="deleteSelectedEntries()">Delete</button>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Unsaved Changes</h3>
                <span class="modal-close" onclick="closeConfirmModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>You have unsaved changes. Moving to another file will discard these changes.</p>
                <p>Are you sure you want to continue?</p>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeConfirmModal()">Cancel</button>
                <button class="btn-primary" id="confirmMoveBtn">Continue</button>
            </div>
        </div>
    </div>

    <!-- Notification -->
    <div id="notification" class="notification"></div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
</body>
	>
	Do ..Scripts()
	Return $$$OK
}

XData Style
{
<data>
	<![CDATA[
	:root{--text-color:#212529;--bg-primary:#fff;--bg-secondary:#f8f9fa;--bg-tertiary:#e9ecef;--text-primary:#212529;--text-secondary:#6c757d;--border-color:#dee2e6;--hover-bg:#f1f3f5;--selected-bg:#0d6efd;--selected-text:#fff;--shadow:rgba(0,0,0,.1);--header-bg:#0d6efd;--header-text:#fff;--success-bg:#198754;--success-text:#fff;--danger-bg:#dc3545;--danger-text:#fff}[data-theme=dark]{--text-color:white;--bg-primary:#1a1a1a;--bg-secondary:#2d2d2d;--bg-tertiary:#3a3a3a;--text-primary:#e9ecef;--text-secondary:#adb5bd;--border-color:#495057;--hover-bg:#343a40;--selected-bg:#0a4c8a;--selected-text:#fff;--shadow:rgba(0,0,0,.3);--header-bg:#0a4c8a;--header-text:#fff;--success-bg:#1e7e34;--success-text:#fff;--danger-bg:#c82333;--danger-text:#fff}*{transition:background-color .3s ease,color .3s ease,border-color .3s ease}body{background-color:var(--bg-primary);color:var(--text-primary);font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;height:100vh;overflow:hidden}.app-header{background-color:var(--header-bg);color:var(--header-text);padding:1rem 1.5rem;box-shadow:0 2px 4px var(--shadow);display:flex;justify-content:space-between;align-items:center}.app-header h1{margin:0;font-size:1.5rem;font-weight:600}.theme-toggle{background:none;border:2px solid var(--header-text);color:var(--header-text);padding:.375rem .75rem;border-radius:.375rem;cursor:pointer;transition:all .3s ease}.theme-toggle:hover{background-color:var(--header-text);color:var(--header-bg)}.main-container{display:flex;height:calc(100vh - 72px)}.left-panel{color:var(--text-color);width:300px;background-color:var(--bg-secondary);border-right:1px solid var(--border-color);overflow-y:auto;padding:1rem;display:flex;flex-direction:column}.left-panel-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;}.left-panel-header h5{margin:0;}.add-file-btn{background-color:var(--success-bg);color:var(--success-text);border:none;padding:.25rem .5rem;border-radius:.25rem;cursor:pointer;transition:all 0.3s ease;font-size:1.25rem;}.add-file-btn:hover{background-color:#146c43;}.search-container{margin-bottom:1rem}.search-box{width:100%;padding:.5rem 1rem;background-color:var(--bg-primary);border:1px solid var(--border-color);border-radius:.375rem;color:var(--text-primary);transition:all .3s ease}.search-box:focus{outline:none;border-color:var(--header-bg);box-shadow:0 0 0 .2rem rgba(13,110,253,.25)}.file-list-container{flex:1;overflow-y:auto}.file-list{list-style:none;padding:0;margin:0}.file-item{padding:.75rem 1rem;margin-bottom:.5rem;background-color:var(--bg-primary);border:1px solid var(--border-color);border-radius:.375rem;cursor:pointer;transition:all .2s ease;display:flex;align-items:center;gap:.75rem}.file-item:hover{background-color:var(--hover-bg);transform:translateX(4px);box-shadow:0 2px 8px var(--shadow)}.file-item.active{background-color:var(--selected-bg);border-color:var(--selected-bg);color:var(--selected-text)}.file-item i{font-size:1.25rem;color:var(--text-secondary)}.file-item.active i{color:var(--selected-text)}.right-panel{flex:1;background-color:var(--bg-primary);padding:1.5rem;overflow-y:auto}.empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:var(--text-secondary)}.empty-state i{font-size:4rem;margin-bottom:1rem;opacity:.5}.dataTables_wrapper{background-color:var(--bg-primary);color:var(--text-primary);width:100%}.dataTables_wrapper .dataTables_length,.dataTables_wrapper .dataTables_filter,.dataTables_wrapper .dataTables_info,.dataTables_wrapper .dataTables_paginate{color:var(--text-secondary)}.dataTables_wrapper .dataTables_length select,.dataTables_wrapper .dataTables_filter input{background-color:var(--bg-secondary);border:1px solid var(--border-color);color:var(--text-primary)}.dataTables_wrapper .dataTables_filter input:focus{border-color:var(--header-bg);box-shadow:0 0 0 .2rem rgba(13,110,253,.25)}table.dataTable thead th{background-color:var(--bg-secondary);color:var(--text-primary);border-bottom:2px solid var(--header-bg)}table.dataTable tbody tr{background-color:var(--bg-primary)}table.dataTable tbody tr:hover{background-color:var(--hover-bg)!important}table.dataTable tbody tr:nth-child(even){background-color:var(--bg-secondary)}table.dataTable tbody tr:nth-child(even):hover{background-color:var(--hover-bg)!important}.dataTables_wrapper .dataTables_paginate .paginate_button{background-color:var(--bg-secondary);border:1px solid var(--border-color);color:var(--text-primary)!important}.dataTables_wrapper .dataTables_paginate .paginate_button:hover{background-color:var(--hover-bg);color:var(--text-primary)!important}.dataTables_wrapper .dataTables_paginate .paginate_button.current{background-color:var(--header-bg)!important;color:var(--header-text)!important;border-color:var(--header-bg)}.loading-spinner{display:none;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%)}.details-cell{max-width:400px;word-wrap:break-word}.directory-cell{font-family:'Courier New',monospace;font-size:.9rem}.global-cell{font-weight:600;color:var(--header-bg)}.old-value-cell{font-style:italic;color:var(--text-secondary);background-color:var(--bg-tertiary);border-radius:4px;padding:2px 6px;display:inline-block}.editable-cell{position:relative}.editable-cell:hover{background-color:var(--hover-bg)}.editable-cell.editing{background-color:var(--bg-tertiary)}.editable-input{width:100%;border:1px solid var(--header-bg);border-radius:4px;padding:4px;font-family:inherit;font-size:inherit;background-color:var(--bg-primary);color:var(--text-primary)}.action-buttons{margin-top:1rem;display:flex;gap:0.5rem;flex-wrap:wrap}.save-btn{background-color:var(--header-bg);color:var(--header-text);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.save-btn:hover{background-color:var(--selected-bg)}.cancel-btn{background-color:var(--text-secondary);color:var(--bg-primary);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.cancel-btn:hover{background-color:var(--border-color)}.add-btn{background-color:var(--success-bg);color:var(--success-text);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.add-btn:hover{background-color:#146c43;}.delete-btn{background-color:var(--danger-bg);color:var(--danger-text);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.delete-btn:hover{background-color:#c82333;}.delete-btn:disabled{background-color:var(--text-secondary);cursor:not-allowed;opacity:0.6;}.checkbox-cell{text-align:center;width:40px;}.checkbox-cell input[type="checkbox"]{cursor:pointer;}.notification{position:fixed;top:20px;right:20px;padding:1rem;border-radius:4px;color:var(--success-text);background-color:var(--success-bg);box-shadow:0 4px 8px var(--shadow);z-index:1000;opacity:0;transform:translateY(-20px);transition:all 0.3s ease}.notification.show{opacity:1;transform:translateY(0)}.notification.error{background-color:#dc3545;color:white}.notification.warning{background-color:#ffc107;color:#000}.changed-row{background-color:rgba(25, 135, 84, 0.1) !important;}.changed-row:hover{background-color:rgba(25, 135, 84, 0.2) !important;}.modal{display:none;position:fixed;z-index:1050;left:0;top:0;width:100%;height:100%;overflow:auto;background-color:rgba(0,0,0,0.5)}.modal-content{background-color:var(--bg-primary);margin:15% auto;padding:1.5rem;border:1px solid var(--border-color);border-radius:0.5rem;width:80%;max-width:500px;box-shadow:0 4px 8px var(--shadow)}.modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem}.modal-title{margin:0;font-size:1.25rem;font-weight:600}.modal-close{background:none;border:none;font-size:1.5rem;cursor:pointer;color:var(--text-secondary)}.modal-close:hover{color:var(--text-primary)}.modal-body{margin-bottom:1rem}.modal-footer{display:flex;justify-content:flex-end;gap:0.5rem}.form-group{margin-bottom:1rem}.form-group label{display:block;margin-bottom:0.5rem;font-weight:500}.form-control{width:100%;padding:0.5rem 1rem;background-color:var(--bg-secondary);border:1px solid var(--border-color);border-radius:.375rem;color:var(--text-primary);transition:all .3s ease}.form-control:focus{outline:none;border-color:var(--header-bg);box-shadow:0 0 0 .2rem rgba(13,110,253,.25)}.btn-primary{background-color:var(--header-bg);color:var(--header-text);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.btn-primary:hover{background-color:var(--selected-bg);}.btn-secondary{background-color:var(--text-secondary);color:var(--bg-primary);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.btn-secondary:hover{background-color:var(--border-color);}.btn-danger{background-color:var(--danger-bg);color:var(--danger-text);border:none;padding:0.5rem 1rem;border-radius:4px;cursor:pointer;transition:all 0.3s ease}.btn-danger:hover{background-color:#c82333;}.selected-count{margin-left:0.5rem;font-size:0.875rem;color:var(--text-secondary);}@media(max-width:768px){.main-container{flex-direction:column}.left-panel{width:100%;height:200px;border-right:none;border-bottom:1px solid var(--border-color)}.action-buttons{flex-direction:column;}.action-buttons button{width:100%;}}

	]]>>
</data>
}

ClassMethod GetLookUpTables(pNamespace As %String = "") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace
	Set response = []
	Set luTable=""
	For {
		Set luTable = $Order(@..#LookupGbl@(luTable)) Q:luTable=""
		Do response.%Push({"fileName":(luTable)})
	}
	Return response.%ToJSON()
}

ClassMethod fileDetailsData(pLookUpTableName = "", pNamespace As %String = "") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace

	If pLookUpTableName="" Quit "[]"
	&SQL(SELECT JSON_ARRAYAGG(JSON_OBJECT('key':KeyName,'value':DataValue)) INTO :response
				FROM Ens_Util.LookupTable WHERE tableName=:pLookUpTableName)
	Return response
}

ClassMethod CreateNewLookUpTable(data As %String = "", pNamespace As %String = "") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace

	Set LUTablePayload = ..ProcessPayload(data)
	Set @..#LookupGbl@(LUTablePayload.fileName)=$lb($H)
	Return {}.%Set("success",1,"boolean").%ToJSON()
}

ClassMethod AddNewLookUpTableEntry(data As %String = "", pNamespace As %String = "") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace

	Set status = 1
	Try {
		Set LUTablePayload =  ..ProcessPayload(data)
		Set LUTable = LUTablePayload.fileName
		Set key= LUTablePayload.newEntry.key
		Set value = LUTablePayload.newEntry.value
		&SQL(INSERT INTO Ens_Util.LookupTable (DataValue,tableName,KeyName)
					VALUES(:value,:LUTable,:key)
			)
	}
	Catch ex {
		Set status=0
	}
	Return {}.%Set("success",status,"boolean").%ToJSON()
}

ClassMethod SaveLUTDatas(data As %String = "", pNamespace As %String = "") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace

	Set status = 1
	Try {
		Set LUTablePayload = ..ProcessPayload(data)
		Set LUTable = LUTablePayload.fileName
		Set LUTableValue= LUTablePayload.updates.%GetIterator()
		While LUTableValue.%GetNext(,.LUTableData) {
			Set key = LUTableData.key
			Set value= LUTableData.value
			&SQL(UPDATE Ens_Util.LookupTable SET DataValue=:value WHERE tableName=:LUTable AND KeyName=:key)
		}
	}
	Catch ex {
		Set status=0
	}
	Return {}.%Set("success",status,"boolean").%ToJSON()
}

ClassMethod DeleteKeys(data As %String = "", pNamespace As %String = "")
{
	New $NAMESPACE
	Set $NAMESPACE = pNamespace

	Set status = 1
	Try {
		Set LUTablePayload = ..ProcessPayload(data)
		Set LUTable = LUTablePayload.fileName
		Set LUTableValue= LUTablePayload.keysToDelete.%GetIterator()
		While LUTableValue.%GetNext(,.key) {
			&SQL(DELETE FROM  Ens_Util.LookupTable WHERE tableName=:LUTable AND KeyName=:key)
		}
	}
	Catch ex {
		Set status=0
	}
	Return {}.%Set("success",status,"boolean").%ToJSON()
}

ClassMethod ProcessPayload(pData As %String = "") As %DynamicObject [ CodeMode = expression ]
{
##class(%DynamicAbstractObject).%FromJSON(pData)
}

ClassMethod Scripts()
{
	&HTML<
	<script language="javascript">
        let namespaceSelect = document.getElementById('namespaceSelect');
        let namespace = namespaceSelect.value
        let selectedNamespace = namespace;
        //Get the Lookup tables for namespace
        let fileNamesData =#server(..GetLookUpTables(selectedNamespace))#;
        fileNamesData = JSON.parse(fileNamesData);

        let fileDetailsData ;
        let originalData = []; // To store original data for comparison
        let currentFileName = '';
        let oldValueColumnVisible = false; // Track if old value column is visible
        let pendingFileSwitch = null; // Store the file switch request when confirmation is needed

		namespaceSelect = document.getElementById('namespaceSelect');
        if (namespaceSelect) namespaceSelect.addEventListener('change', changeNamespace);

        let dataTable = null;

        // Initialize the application
        $(document).ready(function() {
            loadFileList();
            initializeTheme();

            // Add search functionality
            $('#fileSearch').on('keyup', function() {
                const searchTerm = $(this).val().toLowerCase();
                filterFiles(searchTerm);
            });
        });

        // Filter files based on search term
        function filterFiles(searchTerm) {
            $('.file-item').each(function() {
                const fileName = $(this).data('filename').toLowerCase();
                if (fileName.includes(searchTerm)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }
	function changeNamespace(namespace = '') {
	    const namespaceSelect = document.getElementById('namespaceSelect');
	    if (namespaceSelect) {
	        selectedNamespace = namespaceSelect.value;
	        const currentNamespace = document.getElementById('currentNamespace');
	        if (currentNamespace) {
	            currentNamespace.textContent = selectedNamespace;
	        }

	        // Clear the right panel
	        $('#emptyState').show();
	        $('#detailsContainer').hide();

	        // Destroy existing DataTable if it exists
	        if (dataTable) {
	            dataTable.destroy();
	            dataTable = null;
	        }

	        // Reset current file tracking
	        currentFileName = '';
	        originalData = [];
	        oldValueColumnVisible = false;

	        // Remove active state from all file items
	        $('.file-item').removeClass('active');

	       let fileNamesData1 =#server(..GetLookUpTables(selectedNamespace))#;
	        fileNamesData1 = JSON.parse(fileNamesData1);
	        loadFileList1(fileNamesData1);
	    }
	}
        // Load file list from API
        function loadFileList() {
            const fileList = $('#fileList');
            fileList.empty();

            // Simulate API call
            setTimeout(() => {
                fileNamesData.forEach(file => {
                    const li = $(`
                        <li class="file-item" data-filename="${file.fileName}">
                            <i class="fa-solid fa-table"></i>
                            <span>${file.fileName}</span>
                        </li>
                    `);
                    fileList.append(li);
                });

                // Add click handlers
                $('.file-item').click(function() {
                    const fileName = $(this).data('filename');
                    handleFileSwitch(fileName, $(this));
                });
            }, 500);
        }

        // Handle file switch with confirmation for unsaved changes
        function handleFileSwitch(fileName, element) {
            // Check if there are unsaved changes
            if ($('.changed-row').length > 0 || oldValueColumnVisible) {
                // Store the switch request for later
                pendingFileSwitch = { fileName, element };

                // Show confirmation modal
                $('#confirmModal').show();
            } else {
                // No unsaved changes, proceed with switch
                selectFile(fileName, element);
            }
        }

        // Select file and load details
        function selectFile(fileName, element) {
            // Update active state
            $('.file-item').removeClass('active');
            element.addClass('active');
            currentFileName = fileName;

            // Show loading
            showLoading();

            setTimeout(() => {
                details = #server(..fileDetailsData(fileName,selectedNamespace))#;
                details = JSON.parse(details);
                loadFileDetails(fileName, details);
            }, 800);
        }

        // Load file details into DataTable
        function loadFileDetails(fileName, details) {
            $('#emptyState').hide();
            $('#detailsContainer').show();
            $('#selectedFileName').text(`Details for ${fileName}`);

            // Store original data for comparison
            originalData = JSON.parse(JSON.stringify(details));

            // Destroy existing DataTable if it exists
            if (dataTable) {
                dataTable.destroy();
            }

            // Clear table body
            $('#detailsTable tbody').empty();

            // Populate table
            details.forEach((item, index) => {
                const row = $(`
                    <tr data-index="${index}">
                        <td class="checkbox-cell">
                            <input type="checkbox" class="row-checkbox" data-key="${item.key}">
                        </td>
                        <td class="directory-cell">${item.key}</td>
                        <td class="global-cell editable-cell" data-key="${item.key}" data-original="${item.value}">${item.value}</td>
                        <td class="old-value-cell"></td>
                    </tr>
                `);
                $('#detailsTable tbody').append(row);
            });

            // Initialize DataTable
            dataTable = $('#detailsTable').DataTable({
                pageLength: 10,
                responsive: true,
                autoWidth: false,
                language: {
                    search: "Search:",
                    lengthMenu: "Show _MENU_ entries",
                    info: "Showing _START_ to _END_ of _TOTAL_ entries",
                    paginate: {
                        first: "First",
                        last: "Last",
                        next: "Next",
                        previous: "Previous"
                    }
                },
                columnDefs: [
                    { orderable: false, targets: 0 }, // Checkbox column not sortable
                    { orderable: true, targets: [1, 2, 3] },
                    { visible: false, targets: 3 }   // Hide the fourth column (Old Value) initially
                ]
            });

            // Reset old value column visibility
            oldValueColumnVisible = false;

            // Add click event to editable cells
            $('.editable-cell').on('click', function() {
                if ($(this).hasClass('editing')) return;

                const originalValue = $(this).text();
                const key = $(this).data('key');

                $(this).addClass('editing');
                $(this).html(`<input type="text" class="editable-input" value="${originalValue}">`);

                const input = $(this).find('input');
                input.focus();
                input.select();

                // Handle blur event
                input.on('blur', function() {
                    saveCellEdit($(this).parent(), key, originalValue);
                });

                // Handle enter key
                input.on('keydown', function(e) {
                    if (e.which === 13) { // Enter key
                        saveCellEdit($(this).parent(), key, originalValue);
                    } else if (e.which === 27) { // Escape key
                        cancelCellEdit($(this).parent(), originalValue);
                    }
                });
            });

            // Add change event to row checkboxes
            $('.row-checkbox').on('change', function() {
                updateDeleteButtonState();
            });

            hideLoading();
        }

        // Save cell edit
        function saveCellEdit(cell, key, originalValue) {
            const input = cell.find('input');
            const newValue = input.val();

            cell.removeClass('editing');
            cell.text(newValue);

            // Mark row as changed if value is different
            if (newValue !== originalValue) {
                cell.closest('tr').addClass('changed-row');

                // Show the old value column if not already visible
                if (!oldValueColumnVisible) {
                    dataTable.column(3).visible(true);
                    oldValueColumnVisible = true;
                }

                // Set the old value in the fourth column for this row
                const rowIndex = cell.closest('tr').data('index');
                const row = dataTable.row(rowIndex);
                row.cell(rowIndex, 3).data(originalValue);
            } else {
                cell.closest('tr').removeClass('changed-row');
                hideOldValueColumnIfNeeded();
            }
        }

        // Cancel cell edit
        function cancelCellEdit(cell, originalValue) {
            cell.removeClass('editing');
            cell.text(originalValue);
            cell.closest('tr').removeClass('changed-row');
            hideOldValueColumnIfNeeded();
        }

        // Hide old value column if no changes
        function hideOldValueColumnIfNeeded() {
            if ($('.changed-row').length === 0 && oldValueColumnVisible) {
                dataTable.column(3).visible(false);
                oldValueColumnVisible = false;
                // Force redraw to maintain table width
                dataTable.draw();
            }
        }

        // Save all changes
        function saveChanges() {
            const changedRows = [];

            $('#detailsTable tbody tr.changed-row').each(function() {
                const row = $(this);
                const key = row.find('td:nth-child(2)').text(); // Key is in second column now
                const newValue = row.find('td:nth-child(3)').text(); // Value is in third column now

                changedRows.push({
                    key: key,
                    value: newValue
                });
            });

            if (changedRows.length === 0) {
                showNotification('No changes to save', 'info');
                return;
            }

            // Show loading
            showLoading();

            // Prepare data for API call
            const updateData = {
                fileName: currentFileName,
                updates: changedRows
            };

            // Simulate API call
            setTimeout(() => {
                response = #server(..SaveLUTDatas(JSON.stringify(updateData),selectedNamespace))#;

                 response = JSON.parse(response);

                if (response.success) {
                    // Update original data
                    changedRows.forEach(update => {
                        const originalItem = originalData.find(item => item.key === update.key);
                        if (originalItem) {
                            originalItem.value = update.value;
                        }
                    });

                    // Remove changed class from rows
                    $('#detailsTable tbody tr.changed-row').removeClass('changed-row');

                    // Hide the old value column
                    hideOldValueColumnIfNeeded();

                    showNotification('Changes saved successfully', 'success');
                } else {
                    // Revert changes on failure
                    revertChanges();
                    showNotification('Failed to save changes. Reverted to original values.', 'error');
                }

                hideLoading();
            }, 1000);
        }

        // Revert changes to original values
        function revertChanges() {
            $('#detailsTable tbody tr.changed-row').each(function() {
                const row = $(this);
                const key = row.find('td:nth-child(2)').text(); // Key is in second column now
                const originalItem = originalData.find(item => item.key === key);

                if (originalItem) {
                    // Revert the value in the third column
                    row.find('td.editable-cell').text(originalItem.value);

                    // Clear the old value in the fourth column
                    row.find('td.old-value-cell').text('');
                }

                // Remove changed class
                row.removeClass('changed-row');
            });

            // Hide the old value column
            hideOldValueColumnIfNeeded();
        }

        // Cancel changes
        function cancelChanges() {
            revertChanges();
            showNotification('Changes discarded', 'info');
        }

        // Show create file modal
        function showCreateFileModal() {
            $('#newFileName').val('');
            $('#createFileModal').show();
        }

        // Close create file modal
        function closeCreateFileModal() {
            $('#createFileModal').hide();
        }

        // Create new file
        function createNewFile() {
            const fileName = $('#newFileName').val().trim();

            if (!fileName) {
                showNotification('Please enter a file name', 'warning');
                return;
            }

            // Check if file already exists
            if (fileNamesData.some(file => file.fileName.toLowerCase() === fileName.toLowerCase())) {
                showNotification('File with this name already exists', 'warning');
                return;
            }

            // Show loading
            showLoading();
            closeCreateFileModal();

            // Prepare data for API call
            const newFileData = {
                fileName: fileName
            };

            // Simulate API call
            setTimeout(() => {
                response = #server(..CreateNewLookUpTable(JSON.stringify(newFileData),selectedNamespace))#;
                response = JSON.parse(response)
                if (response.success) {
                    //setTimeout(() => {
                        let fileNamesData1 =#server(..GetLookUpTables(selectedNamespace))#;
                        fileNamesData1 = JSON.parse(fileNamesData1);
                        loadFileList1(fileNamesData1);
                        showNotification(`Lookup table "${fileName}" created successfully`, 'success');
                   // }, 500);
                    hideLoading();
                } else {
                    showNotification('Failed to create new file', 'error');
                    hideLoading();
                }
            }, 1000);
        }
        function loadFileList1(fileNamesData) {
            const fileList = $('#fileList');
            fileList.empty();

            // Simulate API call
            setTimeout(() => {
                fileNamesData.forEach(file => {
                    const li = $(`
                        <li class="file-item" data-filename="${file.fileName}">
                            <i class="fa-solid fa-table"></i>
                            <span>${file.fileName}</span>
                        </li>
                    `);
                    fileList.append(li);
                });

                // Add click handlers
                $('.file-item').click(function() {
                    const fileName = $(this).data('filename');
                    handleFileSwitch(fileName, $(this));
                });
            }, 500);
        }
        // Show add new modal
        function showAddModal() {
            $('#newKey').val('');
            $('#newValue').val('');
            $('#addModal').show();
        }

        // Close add new modal
        function closeAddModal() {
            $('#addModal').hide();
        }

        // Add new entry
        function addNewEntry() {
            const key = $('#newKey').val().trim();
            const value = $('#newValue').val().trim();

            if (!key || !value) {
                showNotification('Please enter both key and value', 'warning');
                return;
            }

            // Show loading
            showLoading();
            closeAddModal();

            // Prepare data for API call
            const newData = {
                fileName: currentFileName,
                newEntry: {
                    key: key,
                    value: value
                }
            };

            // Simulate API call
            setTimeout(() => {
                response = #server(..AddNewLookUpTableEntry(JSON.stringify(newData),selectedNamespace))#;
                response = JSON.parse(response);
                if (response.success) {
                    // Reload the current file data to get the latest
                    setTimeout(() => {
                        details = #server(..fileDetailsData(currentFileName,selectedNamespace))#;
                        details = JSON.parse(details);
                        loadFileDetails(currentFileName, details);
                        showNotification('New entry added successfully', 'success');
                    }, 500);
                } else {
                    showNotification('Failed to add new entry', 'error');
                    hideLoading();
                }
            }, 1000);
        }

        // Toggle select all checkboxes
        function toggleSelectAll() {
            const selectAll = $('#selectAllCheckbox').prop('checked');
            $('.row-checkbox').prop('checked', selectAll);
            updateDeleteButtonState();
        }

        // Update delete button state based on selected checkboxes
        function updateDeleteButtonState() {
            const selectedCount = $('.row-checkbox:checked').length;
            $('#deleteSelectedBtn').prop('disabled', selectedCount === 0);
            $('#selectedCount').text(selectedCount > 0 ? `(${selectedCount})` : '');
        }

        // Show delete confirmation modal
        function showDeleteModal() {
            const selectedCount = $('.row-checkbox:checked').length;
            $('#deleteCount').text(`You have selected ${selectedCount} entr${selectedCount === 1 ? 'y' : 'ies'} to delete.`);
            $('#deleteModal').show();
        }

        // Close delete confirmation modal
        function closeDeleteModal() {
            $('#deleteModal').hide();
        }

        // Delete selected entries
        function deleteSelectedEntries() {
            const selectedKeys = [];

            $('.row-checkbox:checked').each(function() {
                selectedKeys.push($(this).data('key'));
            });

            if (selectedKeys.length === 0) {
                showNotification('No entries selected for deletion', 'warning');
                return;
            }
            showLoading();
            closeDeleteModal();
            const deleteData = {
                fileName: currentFileName,
                keysToDelete: selectedKeys
            };
            setTimeout(() => {
                response = #server(..DeleteKeys(JSON.stringify(deleteData),selectedNamespace))#;
                response = JSON.parse(response);
                if (response.success) {
	              setTimeout(() => {
	                     details = #server(..fileDetailsData(currentFileName,selectedNamespace))#;
                		details = JSON.parse(details);
                		//loadFileList(details);
                        loadFileDetails(currentFileName, details);
                        showNotification(`Successfully deleted ${selectedKeys.length} entr${selectedKeys.length === 1 ? 'y' : 'ies'}`, 'success');
                    }, 500);

                } else {
                    showNotification('Failed to delete selected entries', 'error');
                    hideLoading();
                }
            }, 1000);

        }

        // Close confirmation modal
        function closeConfirmModal() {
            $('#confirmModal').hide();
            pendingFileSwitch = null;
        }

        // Confirm file switch
        $(document).on('click', '#confirmMoveBtn', function() {
            if (pendingFileSwitch) {
                // Discard changes
                revertChanges();

                // Proceed with file switch
                selectFile(pendingFileSwitch.fileName, pendingFileSwitch.element);

                // Close modal and clear pending switch
                closeConfirmModal();
            }
        });

        // Show notification
        function showNotification(message, type = 'success') {
            const notification = $('#notification');
            notification.text(message);
            notification.removeClass('error warning');

            if (type === 'error') {
                notification.addClass('error');
            } else if (type === 'warning') {
                notification.addClass('warning');
            }

            notification.addClass('show');

            setTimeout(() => {
                notification.removeClass('show');
            }, 3000);
        }

        // Show loading spinner
        function showLoading() {
            $('.loading-spinner').show();
            $('#detailsContainer').hide();
        }

        // Hide loading spinner
        function hideLoading() {
            $('.loading-spinner').hide();
            $('#detailsContainer').show();
        }

        // Theme toggle functionality
        function toggleTheme() {
            const html = document.documentElement;
            const currentTheme = html.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

            html.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);

            updateThemeIcon(newTheme);
        }

        // Initialize theme from localStorage
        function initializeTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
            updateThemeIcon(savedTheme);
        }

        // Update theme icon
        function updateThemeIcon(theme) {
            const icon = document.getElementById('theme-icon');
            icon.className = theme === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-fill';
        }
    </script>
	>
}

}
