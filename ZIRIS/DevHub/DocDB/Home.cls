Class ZIRIS.DevHub.DocDB.Home Extends ZIRIS.DevHub.Portal.Template
{
Parameter Title As STRING = "DocDB";

Parameter APPLICATION As STRING = "DocDB";

Parameter CATEGORY As STRING = "DocDB";

ClassMethod OnPageHEAD() As %Boolean
{
    Do ##super()
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write "<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">"
	Return $$$OK
}
/// Setup your ServerInformation here
ClassMethod GetServerInfo() As %String
{
	Set sc=##class(%RoutineMgr).GetWebServerPort(.Port,.Server,.URLPrefix,.URL)
	Set hostIP = ##class(%SYSTEM.Util).GetEnviron("HOST_IP")
	If hostIP'="" {
		Set ServerInfo = $Piece(URL,"//")_"//"_hostIP_$Select(Port'="":":"_Port,1:"")
	}
	Else {
		If URL'[":"{
			Set ServerInfo = $E(URL,1,*-1)_":"_Port
		}
		Set ServerInfo = $E(URL,1,*-1)
	}
	Return ServerInfo
}

/// Write your javascripts here within &HTML< ... >
ClassMethod Scripts()
{
	&HTML<
	<script language="javascript">
        // Base URL for API calls
        const baseUrl = #server(..GetServerInfo())#+'/api/docdb/';
        // DOM elements
        const namespaceTree = document.getElementById('namespaceTree');
        const welcomeMessage = document.getElementById('welcomeMessage');
        const detailsPanel = document.getElementById('detailsPanel');
        const selectedDocdbTitle = document.getElementById('selectedDocdbTitle');
        const propertiesContent = document.getElementById('propertiesContent');
        const propertiesTable = document.getElementById('propertiesTable').querySelector('tbody');
        const propertiesToggle = document.getElementById('propertiesToggle');
        const docIdInput = document.getElementById('docId');
        const fetchButton = document.getElementById('fetchButton');
        const addDocumentBtn = document.getElementById('addDocumentBtn');
        const loadingIndicator = document.getElementById('loadingIndicator');
        const resultContainer = document.getElementById('resultContainer');
        const resultContent = document.getElementById('resultContent');
        const errorMessage = document.getElementById('errorMessage');
        const successMessage = document.getElementById('successMessage');
        // New DocDB modal elements
        const newDocdbBtn = document.getElementById('newDocdbBtn');
        const newDocdbModal = document.getElementById('newDocdbModal');
        const closeModal = document.querySelectorAll('.close');
        const cancelCreateBtn = document.getElementById('cancelCreateBtn');
        const confirmCreateBtn = document.getElementById('confirmCreateBtn');
        const newDocdbName = document.getElementById('newDocdbName');
        const newDocdbNamespace = document.getElementById('newDocdbNamespace');

        // Add Document modal elements
        const addDocumentModal = document.getElementById('addDocumentModal');
        const cancelAddDocumentBtn = document.getElementById('cancelAddDocumentBtn');
        const confirmAddDocumentBtn = document.getElementById('confirmAddDocumentBtn');
        const documentData = document.getElementById('documentData');

        // Edit Document modal elements
        const editDocumentModal = document.getElementById('editDocumentModal');
        const cancelEditDocumentBtn = document.getElementById('cancelEditDocumentBtn');
        const confirmEditDocumentBtn = document.getElementById('confirmEditDocumentBtn');
        const editDocumentData = document.getElementById('editDocumentData');

        // State variables
        let selectedNamespace = '';
        let selectedDocdb = '';
        let currentDocId = '';
        let namespacesList = [];

        // Initialize the application
        document.addEventListener('DOMContentLoaded', () => {
            loadNamespaces();

            // Event listeners
            fetchButton.addEventListener('click', handleFetchDocument);
            addDocumentBtn.addEventListener('click', openAddDocumentModal);
            docIdInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') handleFetchDocument();
            });

            // Properties toggle
            propertiesToggle.addEventListener('click', toggleProperties);

            // Double-click to edit document
            resultContent.addEventListener('dblclick', openEditDocumentModal);

            // New DocDB modal event listeners
            newDocdbBtn.addEventListener('click', openNewDocdbModal);
            cancelCreateBtn.addEventListener('click', closeNewDocdbModal);
            confirmCreateBtn.addEventListener('click', createNewDocdb);

            // Add Document modal event listeners
            cancelAddDocumentBtn.addEventListener('click', closeAddDocumentModal);
            confirmAddDocumentBtn.addEventListener('click', addNewDocument);

            // Edit Document modal event listeners
            cancelEditDocumentBtn.addEventListener('click', closeEditDocumentModal);
            confirmEditDocumentBtn.addEventListener('click', updateDocument);

            // Close modals when clicking the X
            closeModal.forEach(element => {
                element.addEventListener('click', function() {
                    if (this.closest('#newDocdbModal')) {
                        closeNewDocdbModal();
                    } else if (this.closest('#addDocumentModal')) {
                        closeAddDocumentModal();
                    } else if (this.closest('#editDocumentModal')) {
                        closeEditDocumentModal();
                    }
                });
            });

            // Close modal when clicking outside of it
            window.addEventListener('click', (e) => {
                if (e.target === newDocdbModal) {
                    closeNewDocdbModal();
                } else if (e.target === addDocumentModal) {
                    closeAddDocumentModal();
                } else if (e.target === editDocumentModal) {
                    closeEditDocumentModal();
                }
            });
        });

        // Toggle properties table visibility
        function toggleProperties() {
            const icon = propertiesToggle.querySelector('i');
            if (propertiesContent.classList.contains('collapsed')) {
                propertiesContent.classList.remove('collapsed');
                icon.className = 'fas fa-chevron-up';
            } else {
                propertiesContent.classList.add('collapsed');
                icon.className = 'fas fa-chevron-down';
            }
        }

        // Load namespaces from the API
        async function loadNamespaces() {
            try {
                const response = await fetch(baseUrl);
                if (!response.ok) throw new Error('Failed to load namespaces');

                const data = await response.json();
                namespacesList = data.content.content.namespaces;

                // Clear existing tree
                namespaceTree.innerHTML = '';

                // Add namespace items to the tree
                namespacesList.forEach(namespace => {
                    const namespaceItem = createNamespaceItem(namespace);
                    namespaceTree.appendChild(namespaceItem);
                });

                // Populate namespace dropdown in modal
                populateNamespaceDropdown();

                hideMessages();
            } catch (error) {
                showError(`Error loading namespaces: ${error.message}`);
            }
        }

        // Populate namespace dropdown in the modal
        function populateNamespaceDropdown() {
            // Clear existing options except the first one
            while (newDocdbNamespace.options.length > 1) {
                newDocdbNamespace.remove(1);
            }

            // Add namespace options
            namespacesList.forEach(namespace => {
                const option = document.createElement('option');
                option.value = namespace;
                option.textContent = namespace;
                newDocdbNamespace.appendChild(option);
            });
        }

        // Create a namespace item for the tree
        function createNamespaceItem(namespace) {
            const li = document.createElement('li');

            const namespaceDiv = document.createElement('div');
            namespaceDiv.className = 'namespace-item';

            const toggle = document.createElement('span');
            toggle.className = 'toggle';
            toggle.innerHTML = '<i class="fas fa-chevron-right"></i>';

            const namespaceName = document.createElement('span');
            namespaceName.textContent = namespace;

            namespaceDiv.appendChild(toggle);
            namespaceDiv.appendChild(namespaceName);

            // Add click event to the entire namespace item
            namespaceDiv.addEventListener('click', (e) => {
                // If the toggle was clicked, let it handle the event
                if (e.target.closest('.toggle')) return;

                // Otherwise, toggle the namespace
                toggleNamespace(namespace, toggle);
            });

            // Add click event to the toggle
            toggle.addEventListener('click', (e) => {
                e.stopPropagation();
                toggleNamespace(namespace, toggle);
            });

            const docdbList = document.createElement('ul');
            docdbList.id = `docdb-${namespace}`;

            li.appendChild(namespaceDiv);
            li.appendChild(docdbList);

            return li;
        }

        // Toggle namespace expansion and load document databases
        async function toggleNamespace(namespace, toggleElement) {
            const docdbList = document.getElementById(`docdb-${namespace}`);

            if (docdbList.style.display === 'block') {
                // Collapse
                docdbList.style.display = 'none';
                toggleElement.innerHTML = '<i class="fas fa-chevron-right"></i>';
            } else {
                // Expand
                if (docdbList.children.length === 0) {
                    // Load document databases
                    try {
                        const response = await fetch(`${baseUrl}v1/${encodeURIComponent(namespace)}`);
                        if (!response.ok) throw new Error('Failed to load document databases');

                        const data = await response.json();
                        const docdbs = data.content;

                        // Add document database items
                        docdbs.forEach(docdb => {
                            const docdbItem = createDocdbItem(namespace, docdb);
                            docdbList.appendChild(docdbItem);
                        });
                    } catch (error) {
                        showError(`Error loading document databases: ${error.message}`);
                        return;
                    }
                }

                docdbList.style.display = 'block';
                toggleElement.innerHTML = '<i class="fas fa-chevron-down"></i>';
            }

            // Clean up right panel when namespace is toggled
            cleanupRightPanel();
        }

        // Create a document database item for the tree
        function createDocdbItem(namespace, docdb) {
            const li = document.createElement('li');

            const docdbDiv = document.createElement('div');
            docdbDiv.className = 'docdb-item';
            docdbDiv.textContent = docdb;
            docdbDiv.addEventListener('click', () => selectDocdb(namespace, docdb, docdbDiv));

            li.appendChild(docdbDiv);

            return li;
        }

        // Clean up the right panel
        function cleanupRightPanel() {
            welcomeMessage.style.display = 'block';
            detailsPanel.style.display = 'none';
            resultContainer.style.display = 'none';
            docIdInput.value = '';
            hideMessages();
        }

        // Select a document database and show its details
        async function selectDocdb(namespace, docdb, element) {
            // Update UI selection
            document.querySelectorAll('.docdb-item').forEach(item => {
                item.classList.remove('selected');
            });
            element.classList.add('selected');

            // Update state
            selectedNamespace = namespace;
            selectedDocdb = docdb;

            // Show details panel
            welcomeMessage.style.display = 'none';
            detailsPanel.style.display = 'block';
            selectedDocdbTitle.textContent = `${docdb} Properties`;

            // Reset result
            resultContainer.style.display = 'none';
            docIdInput.value = '';
            hideMessages();

            try {
                const response = await fetch(`${baseUrl}v1/${encodeURIComponent(namespace)}/db/${docdb}`);
                if (!response.ok) throw new Error('Failed to load document database properties');

                const data = await response.json();
                const properties = data.content.properties;

                // Clear existing properties
                propertiesTable.innerHTML = '';

                // Add properties to the table
                properties.forEach(prop => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${prop.Name}</td>
                        <td>${prop.Type}</td>
                    `;
                    propertiesTable.appendChild(row);
                });

                // Keep properties minimized (collapsed)
                propertiesContent.classList.add('collapsed');
                propertiesToggle.querySelector('i').className = 'fas fa-chevron-down';
            } catch (error) {
                showError(`Error loading document database properties: ${error.message}`);
            }
        }

        // Handle document fetch
        async function handleFetchDocument() {
            const docId = docIdInput.value.trim();

            if (!selectedNamespace || !selectedDocdb || !docId) {
                showError('Please select a document database and enter a document ID');
                return;
            }

            // Store current document ID for editing
            currentDocId = docId;

            // Show loading indicator
            loadingIndicator.style.display = 'inline-block';
            fetchButton.disabled = true;
            resultContainer.style.display = 'none';
            hideMessages();

            try {

                const response = await fetch(`${baseUrl}v1/${encodeURIComponent(selectedNamespace)}/doc/${selectedDocdb}/${docId}`);
                if (!response.ok) throw new Error('Failed to fetch document');

                const data = await response.json();

                // Display the result
                resultContent.textContent = JSON.stringify(data, null, 2);
                resultContainer.style.display = 'block';
            } catch (error) {
                showError(`Error fetching document: ${error.message}`);
            } finally {
                // Hide loading indicator
                loadingIndicator.style.display = 'none';
                fetchButton.disabled = false;
            }
        }

        // Open the new DocDB modal
        function openNewDocdbModal() {
            newDocdbModal.style.display = 'flex';
            newDocdbName.value = '';
            newDocdbNamespace.selectedIndex = 0;
        }

        // Close the new DocDB modal
        function closeNewDocdbModal() {
            newDocdbModal.style.display = 'none';
        }

        // Create a new document database
        async function createNewDocdb() {
            const docdbName = newDocdbName.value.trim();
            const namespace = newDocdbNamespace.value;

            if (!docdbName || !namespace) {
                showError('Please enter a document database name and select a namespace');
                return;
            }

            try {

                const response = await fetch(`${baseUrl}v1/${encodeURIComponent(namespace)}/db/${docdbName}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });

                if (!response.ok) throw new Error('Failed to create document database');

                // Close the modal
                closeNewDocdbModal();

                // Refresh the document databases for the selected namespace
                const docdbList = document.getElementById(`docdb-${namespace}`);
                if (docdbList) {
                    // Clear existing document databases
                    docdbList.innerHTML = '';

                    // Reload document databases
                    const docdbResponse = await fetch(`${baseUrl}v1/${encodeURIComponent(namespace)}`);
                    if (!docdbResponse.ok) throw new Error('Failed to load document databases');

                    const data = await docdbResponse.json();
                    const docdbs = data.content;

                    // Add document database items
                    docdbs.forEach(docdb => {
                        const docdbItem = createDocdbItem(namespace, docdb);
                        docdbList.appendChild(docdbItem);
                    });

                    // Make sure the namespace is expanded
                    docdbList.style.display = 'block';
                    const toggle = docdbList.previousElementSibling.querySelector('.toggle');
                    if (toggle) {
                        toggle.innerHTML = '<i class="fas fa-chevron-down"></i>';
                    }
                }

                // Show success message
                showSuccess(`Document database "${docdbName}" created successfully in namespace "${namespace}"`);
            } catch (error) {
                showError(`Error creating document database: ${error.message}`);
            }
        }

        // Open the Add Document modal
        function openAddDocumentModal() {
            if (!selectedNamespace || !selectedDocdb) {
                showError('Please select a document database first');
                return;
            }

            addDocumentModal.style.display = 'flex';
            documentData.value = '';
        }

        // Close the Add Document modal
        function closeAddDocumentModal() {
            addDocumentModal.style.display = 'none';
        }

        // Add a new document
        async function addNewDocument() {
            const jsonData = documentData.value.trim();

            if (!jsonData) {
                showError('Please enter document data');
                return;
            }

            // Validate JSON
            let parsedData;
            try {
                parsedData = JSON.parse(jsonData);
            } catch (error) {
                showError('Invalid JSON format: ' + error.message);
                return;
            }

            try {

                const response = await fetch(`${baseUrl}v1/${encodeURIComponent(selectedNamespace)}/doc/${selectedDocdb}/`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: jsonData
                });

                if (!response.ok) throw new Error('Failed to add document');

                const result = await response.json();

                // Close the modal
                closeAddDocumentModal();

                // Show success message with document ID if available
                let message = 'Document added successfully';
                if (result.content && result.content.id) {
                    message += ` with ID: ${result.content.id}`;
                }
                showSuccess(message);

                // Optionally, you can fetch the newly created document
                if (result.content && result.content.id) {
                    docIdInput.value = result.content.id;
                    handleFetchDocument();
                }
            } catch (error) {
                showError(`Error adding document: ${error.message}`);
            }
        }

        // Open the Edit Document modal
        function openEditDocumentModal() {
            if (!selectedNamespace || !selectedDocdb || !currentDocId) {
                showError('No document selected for editing');
                return;
            }

            editDocumentModal.style.display = 'flex';
            editDocumentData.value = resultContent.textContent;
        }

        // Close the Edit Document modal
        function closeEditDocumentModal() {
            editDocumentModal.style.display = 'none';
        }

        // Update a document
        async function updateDocument() {
            const jsonData = editDocumentData.value.trim();

            if (!jsonData) {
                showError('Please enter document data');
                return;
            }

            // Validate JSON
            let parsedData;
            try {
                parsedData = JSON.parse(jsonData);
            } catch (error) {
                showError('Invalid JSON format: ' + error.message);
                return;
            }

            try {
                const response = await fetch(`${baseUrl}v1/${encodeURIComponent(selectedNamespace)}/doc/${selectedDocdb}/${currentDocId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: jsonData
                });

                if (!response.ok) throw new Error('Failed to update document');

                // Close the modal
                closeEditDocumentModal();

                // Show success message
                showSuccess(`Document with ID "${currentDocId}" updated successfully`);

                // Refresh the document to show updated content
                handleFetchDocument();
            } catch (error) {
                showError(`Error updating document: ${error.message}`);
            }
        }

        // Show error message
        function showError(message) {
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
            successMessage.style.display = 'none';
        }

        // Show success message
        function showSuccess(message) {
            successMessage.textContent = message;
            successMessage.style.display = 'block';
            errorMessage.style.display = 'none';
        }

        // Hide all messages
        function hideMessages() {
            errorMessage.style.display = 'none';
            successMessage.style.display = 'none';
        }
    </script>
	>
}

XData Style
{
<data>
	<![CDATA[
	*{box-sizing:border-box;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}body{background-color:#f5f7fa;color:#333;line-height:1.6;padding:0;margin:0;height:100vh;display:flex;flex-direction:column}.header{background-color:#4361ee;color:#fff;padding:15px 20px;box-shadow:0 2px 4px rgba(0,0,0,0.1)}.header h1{margin:0;font-size:24px}.main-container{display:flex;flex:1;overflow:hidden}.left-panel{width:300px;background-color:#fff;border-right:1px solid #ddd;overflow-y:auto;padding:20px;display:flex;flex-direction:column}.right-panel{flex:1;padding:20px;overflow-y:auto;background-color:#f9f9f9}.tree-view{list-style-type:none;padding-left:0;margin-top:10px;flex:1}.tree-view ul{list-style-type:none;padding-left:20px;margin-top:5px;display:none}.tree-view li{margin:5px 0;position:relative}.tree-view .toggle{display:inline-block;width:16px;height:16px;margin-right:5px;text-align:center;cursor:pointer;color:#4361ee}.tree-view .namespace-item,.tree-view .docdb-item{padding:8px;border-radius:4px;cursor:pointer;display:flex;align-items:center}.tree-view .namespace-item{font-weight:600;background-color:#f1f1f1}.tree-view .docdb-item{margin-left:20px}.tree-view .namespace-item:hover,.tree-view .docdb-item:hover{background-color:#e1f0fa}.tree-view .selected{background-color:#d4e6f1;border-left:3px solid #4361ee}.container{background-color:#fff;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.1);padding:25px;margin-bottom:20px}.form-group{margin-bottom:20px}label{display:block;margin-bottom:8px;font-weight:600;color:#2c3e50}input[type="text"],select,textarea{width:100%;padding:12px;border:1px solid #ddd;border-radius:4px;font-size:16px}input[type="text"]:focus,select:focus,textarea:focus{border-color:#4361ee;outline:none;box-shadow:0 0 0 2px rgba(67,97,238,0.2)}button{background-color:#4361ee;color:#fff;border:none;padding:12px 20px;border-radius:4px;cursor:pointer;font-size:16px;transition:background-color .3s;margin-top:10px}button:hover{background-color:#3a56d4}button:disabled{background-color:#95a5a6;cursor:not-allowed}.button-group{display:flex;gap:10px;margin-top:10px}.properties-container{margin-top:20px}.properties-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}.properties-toggle{background:none;border:none;color:#4361ee;cursor:pointer;font-size:18px;padding:0;margin:0}.properties-toggle:hover{color:#3a56d4}.properties-table{width:100%;border-collapse:collapse;margin-top:10px}.properties-table th,.properties-table td{border:1px solid #ddd;padding:10px;text-align:left}.properties-table th{background-color:#f2f2f2;font-weight:600}.properties-table tr:nth-child(even){background-color:#f9f9f9}.result-container{margin-top:20px;padding:15px;background-color:#f8f9fa;border-radius:4px;border-left:4px solid #4361ee}.result-container pre{background-color:#f1f1f1;padding:15px;border-radius:4px;overflow-x:auto;white-space:pre-wrap;cursor:pointer;user-select:text}.result-container pre:hover{background-color:#e8e8e8}.edit-hint{font-size:12px;color:#7f8c8d;margin-top:5px;font-style:italic}.loading{display:inline-block;width:20px;height:20px;border:3px solid rgba(67,97,238,0.3);border-radius:50%;border-top-color:#4361ee;animation:spin 1s ease-in-out infinite;margin-left:10px;vertical-align:middle}@keyframes spin{to{transform:rotate(360deg)}}.error-message{color:#e74c3c;margin-top:10px;padding:10px;background-color:#fadbd8;border-radius:4px;display:none}.success-message{color:#27ae60;margin-top:10px;padding:10px;background-color:#d4edda;border-radius:4px;display:none}.welcome-message{text-align:center;padding:40px 20px;color:#7f8c8d}.welcome-message h2{color:#4361ee;margin-bottom:15px}.new-docdb-btn{background-color:#4361ee;color:#fff;border:none;padding:10px 15px;border-radius:4px;cursor:pointer;font-size:14px;margin-top:15px;display:flex;align-items:center;justify-content:center;width:100%}.new-docdb-btn:hover{background-color:#3a56d4}.modal{display:none;position:fixed;z-index:1000;left:0;top:0;width:100%;height:100%;background-color:rgba(0,0,0,0.5);align-items:center;justify-content:center}.modal-content{background-color:#fff;padding:25px;border-radius:8px;box-shadow:0 4px 20px rgba(0,0,0,0.2);width:500px;max-width:90%}.modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}.modal-header h2{margin:0;color:#4361ee}.close{color:#aaa;font-size:28px;font-weight:bold;cursor:pointer}.close:hover{color:#000}.modal-footer{display:flex;justify-content:flex-end;gap:10px;margin-top:20px}.btn-secondary{background-color:#95a5a6}.btn-secondary:hover{background-color:#7f8c8d}textarea{min-height:200px;resize:vertical;font-family:'Courier New',Courier,monospace}h2,h3{color:#4361ee}.collapsed{display:none}
	]]>>
</data>
}

ClassMethod OnRenderScreen() As %Status
{
	&HTML<

<body>
    <div class="header">
        <h1>Document Database Explorer</h1>
    </div>

    <div class="main-container">
        <div class="left-panel">
            <!--h2>Namespaces & Document Databases</h2-->
            <button id="newDocdbBtn" class="new-docdb-btn">+ New DocDB</button>
            <ul id="namespaceTree" class="tree-view">
                <!-- Tree will be populated by JavaScript -->
            </ul>
        </div>

        <div class="right-panel">
            <div id="welcomeMessage" class="welcome-message">
                <h2>Welcome to Document Database Explorer</h2>
                <p>Select a document database from the left panel to view its properties and fetch documents.</p>
            </div>

            <div id="detailsPanel" style="display: none;">
                <div class="container">
                    <h3 id="selectedDocdbTitle">Document Database Properties</h3>

                    <div class="properties-container">
                        <div class="properties-header">
                            <h4>Properties</h4>
                            <button id="propertiesToggle" class="properties-toggle">
                                <i class="fas fa-chevron-down"></i>
                            </button>
                        </div>
                        <div id="propertiesContent" class="collapsed">
                            <table class="properties-table" id="propertiesTable">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Type</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="docId">Document ID:</label>
                        <input type="text" id="docId" placeholder="Enter document ID">
                        <div class="button-group">
                            <button id="fetchButton">Fetch Document</button>
                            <button id="addDocumentBtn">Add Document</button>
                        </div>
                        <span id="loadingIndicator" class="loading" style="display: none;"></span>
                    </div>

                    <div class="error-message" id="errorMessage"></div>
                    <div class="success-message" id="successMessage"></div>

                    <div class="result-container" id="resultContainer" style="display: none;">
                        <h3>Document Result</h3>
                        <pre id="resultContent"></pre>
                        <div class="edit-hint">Double-click on the document to edit</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for creating new DocDB -->
    <div id="newDocdbModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Create New Document Database</h2>
                <span class="close">&times;</span>
            </div>
            <div class="form-group">
                <label for="newDocdbName">DocDB Name:</label>
                <input type="text" id="newDocdbName" placeholder="Enter document database name">
            </div>
            <div class="form-group">
                <label for="newDocdbNamespace">Namespace:</label>
                <select id="newDocdbNamespace">
                    <option value="">-- Select Namespace --</option>
                </select>
            </div>
            <div class="modal-footer">
                <button id="cancelCreateBtn" class="btn-secondary">Cancel</button>
                <button id="confirmCreateBtn">Create</button>
            </div>
        </div>
    </div>

    <!-- Modal for adding new document -->
    <div id="addDocumentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add New Document</h2>
                <span class="close">&times;</span>
            </div>
            <div class="form-group">
                <label for="documentData">Document Data (JSON):</label>
                <textarea id="documentData" placeholder='Enter JSON data, for example:
{
  "name": "Example Document",
  "description": "This is an example document",
  "created": "2023-05-15",
  "tags": ["example", "test"]
}'></textarea>
            </div>
            <div class="modal-footer">
                <button id="cancelAddDocumentBtn" class="btn-secondary">Cancel</button>
                <button id="confirmAddDocumentBtn">Save Document</button>
            </div>
        </div>
    </div>

    <!-- Modal for editing document -->
    <div id="editDocumentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit Document</h2>
                <span class="close">&times;</span>
            </div>
            <div class="form-group">
                <label for="editDocumentData">Document Data (JSON):</label>
                <textarea id="editDocumentData"></textarea>
            </div>
            <div class="modal-footer">
                <button id="cancelEditDocumentBtn" class="btn-secondary">Cancel</button>
                <button id="confirmEditDocumentBtn">Update Document</button>
            </div>
        </div>
    </div>
</body>
	>
}

ClassMethod EnableDocDBService()
{
	New $NAMESPACE
	Set $NAMESPACE="%SYS"
	do ##class(Security.Services).Get("%Service_DocDB", .svc)
	If svc("Enabled")=0 {
		Set svc("Enabled")=1
		do ##class(Security.Services).Modify("%Service_DocDB", .svc)
	}
	Return $$$OK
}

ClassMethod CreateSampleDocDB()
{
	New $NAMESPACE
	Set $NAMESPACE="USER"
	Do ##class(%SYSTEM.DocDB).CreateDatabase("test.docdb")
	Set myoref = $ClassMethod("test.docdb","%New")
	SET test = ["Anne","Bradford","Charles","Deborah"]
	Set myoref.%Doc=test
	Set st = myoref.%Save()
}

}