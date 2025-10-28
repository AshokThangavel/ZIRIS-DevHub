Class ZIRIS.DevHub.Admin.IntegrityWebLog Extends ZIRIS.DevHub.Portal.Template
{
Parameter Title As STRING = "Integrity Log";

Parameter APPLICATION As STRING = "Integrity Log";

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
<body>
    <header class="app-header">
        <h1 title="IntegrityLog files genreated via Integrity Check Task"><i class="bi bi-shield-check me-2"></i>Integrity Log</h1>
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="bi bi-moon-fill" id="theme-icon"></i>
        </button>
    </header>

    <div class="main-container">
        <div class="left-panel">
            <h5 class="mb-3">Files</h5>
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
                <p>Click on any file from the left panel to load its integrity log details</p>
            </div>

            <div id="detailsContainer" style="display: none;">
                <h5 class="mb-3" id="selectedFileName"></h5>
                <table id="detailsTable" class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Directory</th>
                            <th>Global</th>
                            <th>Details</th>
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

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
</body>
	>
}

XData Style
{
<data>
	<![CDATA[
	:root{--text-color:#212529;--bg-primary:#fff;--bg-secondary:#f8f9fa;--bg-tertiary:#e9ecef;--text-primary:#212529;--text-secondary:#6c757d;--border-color:#dee2e6;--hover-bg:#f1f3f5;--selected-bg:#0d6efd;--selected-text:#fff;--shadow:rgba(0,0,0,.1);--header-bg:#0d6efd;--header-text:#fff}[data-theme=dark]{--text-color:white;--bg-primary:#1a1a1a;--bg-secondary:#2d2d2d;--bg-tertiary:#3a3a3a;--text-primary:#e9ecef;--text-secondary:#adb5bd;--border-color:#495057;--hover-bg:#343a40;--selected-bg:#0a4c8a;--selected-text:#fff;--shadow:rgba(0,0,0,.3);--header-bg:#0a4c8a;--header-text:#fff}*{transition:background-color .3s ease,color .3s ease,border-color .3s ease}body{background-color:var(--bg-primary);color:var(--text-primary);font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;height:100vh;overflow:hidden}.app-header{background-color:var(--header-bg);color:var(--header-text);padding:1rem 1.5rem;box-shadow:0 2px 4px var(--shadow);display:flex;justify-content:space-between;align-items:center}.app-header h1{margin:0;font-size:1.5rem;font-weight:600}.theme-toggle{background:none;border:2px solid var(--header-text);color:var(--header-text);padding:.375rem .75rem;border-radius:.375rem;cursor:pointer;transition:all .3s ease}.theme-toggle:hover{background-color:var(--header-text);color:var(--header-bg)}.main-container{display:flex;height:calc(100vh - 72px)}.left-panel{color:var(--text-color);width:300px;background-color:var(--bg-secondary);border-right:1px solid var(--border-color);overflow-y:auto;padding:1rem;display:flex;flex-direction:column}.search-container{margin-bottom:1rem}.search-box{width:100%;padding:.5rem 1rem;background-color:var(--bg-primary);border:1px solid var(--border-color);border-radius:.375rem;color:var(--text-primary);transition:all .3s ease}.search-box:focus{outline:none;border-color:var(--header-bg);box-shadow:0 0 0 .2rem rgba(13,110,253,.25)}.file-list-container{flex:1;overflow-y:auto}.file-list{list-style:none;padding:0;margin:0}.file-item{padding:.75rem 1rem;margin-bottom:.5rem;background-color:var(--bg-primary);border:1px solid var(--border-color);border-radius:.375rem;cursor:pointer;transition:all .2s ease;display:flex;align-items:center;gap:.75rem}.file-item:hover{background-color:var(--hover-bg);transform:translateX(4px);box-shadow:0 2px 8px var(--shadow)}.file-item.active{background-color:var(--selected-bg);border-color:var(--selected-bg);color:var(--selected-text)}.file-item i{font-size:1.25rem;color:var(--text-secondary)}.file-item.active i{color:var(--selected-text)}.right-panel{flex:1;background-color:var(--bg-primary);padding:1.5rem;overflow-y:auto}.empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:var(--text-secondary)}.empty-state i{font-size:4rem;margin-bottom:1rem;opacity:.5}.dataTables_wrapper{background-color:var(--bg-primary);color:var(--text-primary)}.dataTables_wrapper .dataTables_length,.dataTables_wrapper .dataTables_filter,.dataTables_wrapper .dataTables_info,.dataTables_wrapper .dataTables_paginate{color:var(--text-secondary)}.dataTables_wrapper .dataTables_length select,.dataTables_wrapper .dataTables_filter input{background-color:var(--bg-secondary);border:1px solid var(--border-color);color:var(--text-primary)}.dataTables_wrapper .dataTables_filter input:focus{border-color:var(--header-bg);box-shadow:0 0 0 .2rem rgba(13,110,253,.25)}table.dataTable thead th{background-color:var(--bg-secondary);color:var(--text-primary);border-bottom:2px solid var(--header-bg)}table.dataTable tbody tr{background-color:var(--bg-primary)}table.dataTable tbody tr:hover{background-color:var(--hover-bg)!important}table.dataTable tbody tr:nth-child(even){background-color:var(--bg-secondary)}table.dataTable tbody tr:nth-child(even):hover{background-color:var(--hover-bg)!important}.dataTables_wrapper .dataTables_paginate .paginate_button{background-color:var(--bg-secondary);border:1px solid var(--border-color);color:var(--text-primary)!important}.dataTables_wrapper .dataTables_paginate .paginate_button:hover{background-color:var(--hover-bg);color:var(--text-primary)!important}.dataTables_wrapper .dataTables_paginate .paginate_button.current{background-color:var(--header-bg)!important;color:var(--header-text)!important;border-color:var(--header-bg)}.loading-spinner{display:none;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%)}.details-cell{max-width:400px;word-wrap:break-word}.directory-cell{font-family:'Courier New',monospace;font-size:.9rem}.global-cell{font-weight:600;color:var(--header-bg)}@media(max-width:768px){.main-container{flex-direction:column}.left-panel{width:100%;height:200px;border-right:none;border-bottom:1px solid var(--border-color)}}
	]]>>
</data>
}

ClassMethod GetIntergityFiles()
{
	#dim response As %DynamicArray = []
	Set dir = ##class(%Library.File).NormalizeDirectory($SYSTEM.Util.ManagerDirectory())
	If ##class(%File).Exists(dir_"integ.txt") {
		Do response.%Push({"fileName": "integ.txt"})
	}
    Set wildcard = "INTEGRIT-*.LOG"
	Set tResult = ##class(%File).FileSetFunc(dir,wildcard)
	while tResult.%Next(){
		Do response.%Push({"fileName": (tResult.ItemName)})
	}
	Return response.%ToJSON()
}

ClassMethod fileDetailsData(pFileName = "") As %String
{
	#dim response As %DynamicArray = []

	set file = ##class(%Library.File).NormalizeDirectory($SYSTEM.Util.ManagerDirectory())_pFileName
	set stream = ##class(%Stream.FileCharacter).%New()
 	Do stream.LinkToFile( file)
 	Set data =""
	While 'stream.AtEnd {
 		set line = stream.ReadLine()
 		if line["Directory:" {
	 		Set cdir = $P(line,"Directory: ",2)
 		}
 		if line["Global:" {
	 		set cgbl=$P($P(line,": ",2)," ")
	 		set data=$P($P(line,": ",2)," ",2,*)
 		}
 		else {
	 		set data=data_$C(13,10)_line
	 		if line["Elapsed Time" {
		 		//set %gbl(cdir,cgbl)=data

		 		Set json = {
			 		"directory":(cdir),
			 		"global":(..EscapeHTML(cgbl)),
			 		"details":(data)
		 		}
		 		set (data,cgbl)=""
		 		Do response.%Push(json)
	 		}
 		}
	}
	return response.%ToJSON()
}

ClassMethod Scripts()
{

	&HTML<
	<script language="javascript">
        // Simulated API data
        let fileNamesData =#server(..GetIntergityFiles())#;
        fileNamesData = JSON.parse(fileNamesData);
        console.log(fileNamesData);

        let fileDetailsData ;

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

        // Load file list from API
        function loadFileList() {
            const fileList = $('#fileList');
            fileList.empty();

            // Simulate API call
            setTimeout(() => {
                fileNamesData.forEach(file => {
                    const li = $(`
                        <li class="file-item" data-filename="${file.fileName}">
                            <i class="bi bi-file-earmark-text"></i>
                            <span>${file.fileName}</span>
                        </li>
                    `);
                    fileList.append(li);
                });

                // Add click handlers
                $('.file-item').click(function() {
                    const fileName = $(this).data('filename');
                    selectFile(fileName, $(this));
                });
            }, 500);
        }

        // Select file and load details
        function selectFile(fileName, element) {
            // Update active state
            $('.file-item').removeClass('active');
            element.addClass('active');

            // Show loading
            showLoading();

            setTimeout(() => {
                details = #server(..fileDetailsData(fileName))#
                details = JSON.parse(details);
                loadFileDetails(fileName, details);
            }, 800);
        }

        // Load file details into DataTable
        function loadFileDetails(fileName, details) {
            $('#emptyState').hide();
            $('#detailsContainer').show();
            $('#selectedFileName').text(`Details for ${fileName}`);

            // Destroy existing DataTable if it exists
            if (dataTable) {
                dataTable.destroy();
            }

            // Clear table body
            $('#detailsTable tbody').empty();

            // Populate table
            details.forEach(item => {
                const row = $(`
                    <tr>
                        <td class="directory-cell">${item.directory}</td>
                        <td class="global-cell">${item.global}</td>
                        <td class="details-cell">${item.details}</td>
                    </tr>
                `);
                $('#detailsTable tbody').append(row);
            });

            // Initialize DataTable
            dataTable = $('#detailsTable').DataTable({
                pageLength: 10,
                responsive: true,
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
                    { orderable: true, targets: [0, 1, 2] }
                ]
            });

            hideLoading();
        }

        // Show loading spinner
        function showLoading() {
            $('.loading-spinner').show();
            $('#detailsContainer').hide();
        }

        // Hide loading spinner
        function hideLoading() {
            $('.loading-spinner').hide();
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