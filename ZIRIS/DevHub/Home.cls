Class ZIRIS.DevHub.Home Extends ZIRIS.DevHub.Portal.Template
{
Parameter Title As STRING [ Final ] = "IRIS DevHubTools";

Parameter APPLICATION As STRING = "IRIS DevHubTools";

ClassMethod OnPageHEAD() As %Boolean
{
	Do ##super()
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Return $$$OK
}

ClassMethod OnRenderScreen()
{
	&HTML<
	<body>
    <header>
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-code"></i>
                    <h1>Developer Tools</h1>
                </div>
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-box" id="search" placeholder="Search tools by name, description or category...">
                </div>
                <div class="header-controls">
                    <div class="stats">
                        <div class="stat-item">
                            <span class="stat-value" id="total-tools">0</span>
                            <span class="stat-label">Tools</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-value" id="total-categories">0</span>
                            <span class="stat-label">Categories</span>
                        </div>
                    </div>
                    <button class="theme-toggle" id="theme-toggle" title="Toggle dark mode">
                        <i class="fas fa-moon"></i>
                    </button>
                    <button class="add-btn" id="add-tool-btn" title="Add new tool">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <main class="container">
        <div class="categories" id="categories">
            <button class="category-btn active" data-category="all">
                <i class="fas fa-th"></i> All Tools
            </button>
        </div>

        <div class="tools-grid" id="tools-grid">
            <!-- Tools will be dynamically added here -->
        </div>

        <div class="no-results" id="no-results" style="display: none;">
            <i class="fas fa-search"></i>
            <h3>No tools found</h3>
            <p>Try adjusting your search or filter criteria</p>
        </div>
    </main>

    <!-- Add Tool Modal -->
    <div class="modal-overlay" id="add-tool-modal">
        <div class="modal">
            <div class="modal-header">
                <h2 class="modal-title">Add New Tool</h2>
                <button class="close-btn" id="close-modal">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <form id="add-tool-form">
                    <div class="form-group">
                        <label class="form-label" for="tool-name">Name</label>
                        <input type="text" class="form-input" id="tool-name" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="tool-description">Description</label>
                        <textarea class="form-textarea" id="tool-description" required></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="tool-execution">Execution</label>
                        <input type="text" class="form-input" id="tool-execution" placeholder="e.g., qcpr.acw.clindoc.tools.NewTool.cls" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="tool-category">Category</label>
                        <select class="form-select" id="tool-category" required>
                            <option value="">Select a category</option>
                            <option value="documentation">Documentation</option>
                            <option value="data">Data</option>
                            <option value="development">Development</option>
                            <option value="monitoring">Monitoring</option>
                            <option value="administration">Administration</option>
                            <option value="reporting">Reporting</option>
                            <option value="automation">Automation</option>
                            <option value="communication">Communication</option>
                            <option value="security">Security</option>
                            <option value="customization">Customization</option>
                            <option value="integration">Integration</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="cancel-btn">Cancel</button>
                <button type="submit" class="btn btn-primary" id="save-btn">Save</button>
            </div>
        </div>
    </div>

    <div class="notification" id="notification">
        <i class="fas fa-check-circle"></i>
        <span id="notification-message">Copied to clipboard!</span>
    </div>
	>
}

XData Style
{
<data>
	<![CDATA[
	:root{--primary:#4361ee;--primary-dark:#3a56d4;--secondary:#3f37c9;--background:#f8f9fa;--card-bg:#fff;--text-primary:#212529;--text-secondary:#6c757d;--border:#e9ecef;--shadow:rgba(0,0,0,0.1);--success:#4cc9f0;--warning:#f72585;--modal-overlay:rgba(0,0,0,0.5)}[data-theme=dark]{--primary:#5e72e4;--primary-dark:#4c63d2;--secondary:#825ee4;--background:#1a1d29;--card-bg:#252836;--text-primary:#f8f9fa;--text-secondary:#adb5bd;--border:#343946;--shadow:rgba(0,0,0,0.3);--success:#1de9b6;--warning:#f5365c;--modal-overlay:rgba(0,0,0,0.7)}*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}body{background-color:var(--background);color:var(--text-primary);line-height:1.6;transition:background-color .3s ease,color .3s ease}.container{max-width:1400px;margin:0 auto;padding:20px}header{background-color:var(--card-bg);box-shadow:0 2px 10px var(--shadow);padding:15px 0;margin-bottom:20px;position:sticky;top:0;z-index:100;transition:background-color .3s ease}.header-content{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:15px}.logo{display:flex;align-items:center;gap:10px}.logo i{font-size:22px;color:var(--primary)}.logo h1{font-size:20px;font-weight:600;color:var(--primary)}.search-container{position:relative;width:100%;max-width:450px}.search-box{width:100%;padding:10px 20px 10px 40px;border:1px solid var(--border);border-radius:30px;font-size:15px;transition:all .3s ease;background-color:var(--background);color:var(--text-primary)}.search-box:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(67,97,238,0.2)}.search-icon{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--text-secondary)}.header-controls{display:flex;align-items:center;gap:15px}.stats{display:flex;gap:15px;align-items:center}.stat-item{display:flex;flex-direction:column;align-items:center}.stat-value{font-size:18px;font-weight:600;color:var(--primary)}.stat-label{font-size:11px;color:var(--text-secondary)}.theme-toggle{background:none;border:none;color:var(--text-primary);cursor:pointer;font-size:18px;padding:5px;border-radius:50%;transition:all .3s ease}.theme-toggle:hover{background-color:var(--background)}.add-btn{background-color:var(--primary);color:#fff;border:none;border-radius:50%;width:40px;height:40px;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .3s ease;font-size:18px}.add-btn:hover{background-color:var(--primary-dark);transform:scale(1.05)}.categories{display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap}.category-btn{padding:8px 16px;background-color:var(--card-bg);border:1px solid var(--border);border-radius:20px;font-size:14px;cursor:pointer;transition:all .3s ease;display:flex;align-items:center;gap:6px;color:var(--text-primary)}.category-btn:hover,.category-btn.active{background-color:var(--primary);color:#fff;border-color:var(--primary)}.tools-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:20px}.tool-card{background-color:var(--card-bg);border-radius:12px;overflow:hidden;box-shadow:0 4px 12px var(--shadow);transition:all .3s ease;display:flex;flex-direction:column;height:100%}.tool-card:hover{transform:translateY(-5px);box-shadow:0 10px 20px rgba(0,0,0,0.15)}.tool-header{padding:20px;display:flex;align-items:center;gap:15px;border-bottom:1px solid var(--border)}.tool-icon{width:50px;height:50px;border-radius:10px;background-color:rgba(67,97,238,0.1);display:flex;align-items:center;justify-content:center;font-size:24px;color:var(--primary)}.tool-title{font-size:18px;font-weight:600;margin-bottom:4px;color:var(--text-primary)}.tool-category{display:inline-block;padding:3px 10px;background-color:rgba(67,97,238,0.1);color:var(--primary);border-radius:12px;font-size:12px;font-weight:500}.tool-body{padding:20px;flex-grow:1;display:flex;flex-direction:column}.tool-description{color:var(--text-secondary);margin-bottom:15px;flex-grow:1}.tool-invocation{background-color:var(--background);padding:12px;border-radius:8px;font-family:'Courier New',monospace;font-size:14px;color:var(--text-primary);word-break:break-word;position:relative;margin-bottom:15px}.copy-btn{position:absolute;top:8px;right:8px;background:none;border:none;color:var(--text-secondary);cursor:pointer;transition:color .3s ease}.copy-btn:hover{color:var(--primary)}.tool-actions{display:flex;justify-content:center}.launch-btn{width:100%;padding:12px;border:none;border-radius:8px;font-size:16px;font-weight:500;cursor:pointer;transition:all .3s ease;display:flex;align-items:center;justify-content:center;gap:8px;background-color:var(--primary);color:#fff}.launch-btn:hover{background-color:var(--primary-dark)}.no-results{text-align:center;padding:60px 20px;color:var(--text-secondary)}.no-results i{font-size:48px;margin-bottom:20px;color:var(--text-secondary)}.notification{position:fixed;bottom:20px;right:20px;background-color:var(--success);color:#fff;padding:15px 20px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);display:flex;align-items:center;gap:10px;transform:translateY(100px);opacity:0;transition:all .3s ease;z-index:1000}.notification.show{transform:translateY(0);opacity:1}.modal-overlay{position:fixed;top:0;left:0;right:0;bottom:0;background-color:var(--modal-overlay);display:flex;align-items:center;justify-content:center;z-index:1000;opacity:0;visibility:hidden;transition:all .3s ease}.modal-overlay.active{opacity:1;visibility:visible}.modal{background-color:var(--card-bg);border-radius:12px;width:90%;max-width:500px;max-height:90vh;overflow-y:auto;box-shadow:0 10px 30px rgba(0,0,0,0.2);transform:scale(0.8);transition:transform .3s ease}.modal-overlay.active .modal{transform:scale(1)}.modal-header{padding:20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center}.modal-title{font-size:20px;font-weight:600;color:var(--text-primary)}.close-btn{background:none;border:none;font-size:20px;color:var(--text-secondary);cursor:pointer;transition:color .3s ease}.close-btn:hover{color:var(--warning)}.modal-body{padding:20px}.form-group{margin-bottom:20px}.form-label{display:block;margin-bottom:8px;font-weight:500;color:var(--text-primary)}.form-input,.form-textarea,.form-select{width:100%;padding:12px;border:1px solid var(--border);border-radius:8px;font-size:16px;background-color:var(--background);color:var(--text-primary);transition:all .3s ease}.form-input:focus,.form-textarea:focus,.form-select:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(67,97,238,0.2)}.form-textarea{resize:vertical;min-height:100px}.modal-footer{padding:20px;border-top:1px solid var(--border);display:flex;justify-content:flex-end;gap:10px}.btn{padding:10px 20px;border:none;border-radius:8px;font-size:16px;font-weight:500;cursor:pointer;transition:all .3s ease}.btn-primary{background-color:var(--primary);color:#fff}.btn-primary:hover{background-color:var(--primary-dark)}.btn-secondary{background-color:var(--background);color:var(--text-primary);border:1px solid var(--border)}.btn-secondary:hover{background-color:var(--border)}@media(max-width:768px){.header-content{flex-direction:column;align-items:stretch}.search-container{max-width:100%}.tools-grid{grid-template-columns:1fr}}
]]>
	</data>
}

ClassMethod SaveNewTool(Payload As %String) [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.DB.Utils).CreateNewToolIntoList({}.%FromJSON(Payload))
}

ClassMethod GetToolsList() [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.DB.Utils).GetToolsList()
}

ClassMethod Scripts()
{

	&HTML<
	<script language="javascript">
        // Sample data structure (replace with your actual data)
        //const toolsData =

        // DOM elements
        const searchInput = document.getElementById('search');
        const toolsGrid = document.getElementById('tools-grid');
        const categoriesContainer = document.getElementById('categories');
        const noResults = document.getElementById('no-results');
        const totalToolsElement = document.getElementById('total-tools');
        const totalCategoriesElement = document.getElementById('total-categories');
        const notification = document.getElementById('notification');
        const notificationMessage = document.getElementById('notification-message');
        const themeToggle = document.getElementById('theme-toggle');
        const addToolBtn = document.getElementById('add-tool-btn');
        const addToolModal = document.getElementById('add-tool-modal');
        const closeModalBtn = document.getElementById('close-modal');
        const cancelBtn = document.getElementById('cancel-btn');
        const saveBtn = document.getElementById('save-btn');
        const addToolForm = document.getElementById('add-tool-form');

        // Form elements
        const toolNameInput = document.getElementById('tool-name');
        const toolDescriptionInput = document.getElementById('tool-description');
        const toolExecutionInput = document.getElementById('tool-execution');
        const toolCategoryInput = document.getElementById('tool-category');

        // State
        toolsData = #server(..GetToolsList())#;
        toolsData = JSON.parse(toolsData);
        console.log(toolsData);
        let filteredTools = [...toolsData];
        let activeCategory = 'all';

        // Initialize the app
        function init() {
            renderTools();
            renderCategories();
            updateStats();

            // Event listeners
            searchInput.addEventListener('input', handleSearch);
            themeToggle.addEventListener('click', toggleTheme);
            addToolBtn.addEventListener('click', openAddToolModal);
            closeModalBtn.addEventListener('click', closeAddToolModal);
            cancelBtn.addEventListener('click', closeAddToolModal);
            saveBtn.addEventListener('click', saveNewTool);

            // Close modal when clicking outside
            addToolModal.addEventListener('click', (e) => {
                if (e.target === addToolModal) {
                    closeAddToolModal();
                }
            });

            // Check for saved theme preference
            const savedTheme = localStorage.getItem('theme') || 'light';
            if (savedTheme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            }
        }

        // Render tools
        function renderTools() {
            toolsGrid.innerHTML = '';

            if (filteredTools.length === 0) {
                noResults.style.display = 'block';
                return;
            }

            noResults.style.display = 'none';

            filteredTools.forEach(tool => {
                const toolCard = createToolCard(tool);
                toolsGrid.appendChild(toolCard);
            });
        }

        // Create a tool card element
        function createToolCard(tool) {
            const card = document.createElement('div');
            card.className = 'tool-card';

            card.innerHTML = `
                <div class="tool-header">
                    <!--div class="tool-icon">
                        <i class="${tool.icon}"></i>
                    </div-->
                    <div>
                        <div class="tool-title">${tool.name}</div>
                        <span class="tool-category">${tool.category}</span>
                    </div>
                </div>
                <div class="tool-body">
                    <!--div class="tool-description">${tool.description}</div-->
                    <div class="tool-description" title="${tool.description}">${tool.description.length > 35 ? tool.description.substring(0, 35) + '…' : tool.description}</div>
                    <div class="tool-invocation">
                        ${tool.cls}
                        <button class="copy-btn" data-cls="${tool.cls}">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="tool-actions">
                        <button class="launch-btn" data-cls="${tool.cls}">
                            <i class="fas fa-external-link-alt"></i> Launch
                        </button>
                    </div>
                </div>
            `;

            // Add event listener to copy button
            const copyBtn = card.querySelector('.copy-btn');
            copyBtn.addEventListener('click', () => copyToClipboard(tool.cls));

            // Add event listener to launch button
            const launchBtn = card.querySelector('.launch-btn');
            launchBtn.addEventListener('click', () => launchTool(tool.cls));

            return card;
        }

        // Render category buttons
        function renderCategories() {
            // Extract unique categories
            const categories = [...new Set(toolsData.map(tool => tool.category))];

            // Add category buttons
            categories.forEach(category => {
                const btn = document.createElement('button');
                btn.className = 'category-btn';
                btn.dataset.category = category;
                btn.innerHTML = `<i class="fas fa-tag"></i> ${category.charAt(0).toUpperCase() + category.slice(1)}`;

                btn.addEventListener('click', () => {
                    // Remove active class from all buttons
                    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    btn.classList.add('active');

                    // Set active category and filter
                    activeCategory = category;
                    filterTools();
                });

                categoriesContainer.appendChild(btn);
            });

            // Add event listener to "All Tools" button
            const allToolsBtn = document.querySelector('[data-category="all"]');
            allToolsBtn.addEventListener('click', () => {
                // Remove active class from all buttons
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                // Add active class to "All Tools" button
                allToolsBtn.classList.add('active');

                // Set active category and filter
                activeCategory = 'all';
                filterTools();
            });
        }

        // Update statistics
        function updateStats() {
            totalToolsElement.textContent = toolsData.length;

            const categories = [...new Set(toolsData.map(tool => tool.category))];
            totalCategoriesElement.textContent = categories.length;
        }

        // Handle search input
        function handleSearch() {
            filterTools();
        }

        // Filter tools based on search and category
        function filterTools() {
            const searchTerm = searchInput.value.toLowerCase();

            filteredTools = toolsData.filter(tool => {
                const matchesSearch = tool.name.toLowerCase().includes(searchTerm) ||
                                    tool.description.toLowerCase().includes(searchTerm) ||
                                    tool.category.toLowerCase().includes(searchTerm) ||
                                    tool.cls.toLowerCase().includes(searchTerm);

                const matchesCategory = activeCategory === 'all' || tool.category === activeCategory;

                return matchesSearch && matchesCategory;
            });

            renderTools();
        }

        // Copy to clipboard
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text)
                .then(() => {
                    showNotification('Copied to clipboard!');
                })
                .catch(err => {
                    console.error('Failed to copy: ', err);
                });
        }
        function launchTool(cls) {
            //window.open(`${cls.replace(/\/g, '-')}`, '_blank');
            window.open(`${cls}`, '_blank');
        }

        // Toggle dark/light theme
        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);

            // Update theme toggle icon
            if (newTheme === 'dark') {
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
        }

        // Open add tool modal
        function openAddToolModal() {
            addToolModal.classList.add('active');
            toolNameInput.focus();
        }

        // Close add tool modal
        function closeAddToolModal() {
            addToolModal.classList.remove('active');
            addToolForm.reset();
        }

        // Save new tool
        function saveNewTool(e) {
            e.preventDefault();

            // Get form values
            const name = toolNameInput.value.trim();
            const description = toolDescriptionInput.value.trim();
            const execution = toolExecutionInput.value.trim();
            const category = toolCategoryInput.value;

            // Validate form
            if (!name || !description || !execution || !category) {
                showNotification('Please fill in all fields', 'error');
                return;
            }

            // Create new tool object
            const newTool = {
                name,
                cls: execution,
                description,
                category,
                icon: getRandomIcon()
            };

            // In a real implementation, this would make an API call to save the tool
            // For demo purposes, we'll just add it to the toolsData array


            res = #server(..SaveNewTool(JSON.stringify(newTool)))#;
            if (res!=1) {
	            alert(res);
	            closeAddToolModal();
	            return;
            }
            toolsData.push(newTool);
            // Update UI
            filterTools();
            updateStats();
            closeAddToolModal();
            showNotification('Tool added successfully!');

            // If the new tool's category doesn't have a button yet, add it
            const categoryExists = document.querySelector(`[data-category="${category}"]`);
            if (!categoryExists && category !== 'other') {
                addCategoryButton(category);
            }
        }

        // Add a new category button
        function addCategoryButton(category) {
            const btn = document.createElement('button');
            btn.className = 'category-btn';
            btn.dataset.category = category;
            btn.innerHTML = `<i class="fas fa-tag"></i> ${category.charAt(0).toUpperCase() + category.slice(1)}`;

            btn.addEventListener('click', () => {
                // Remove active class from all buttons
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                btn.classList.add('active');

                // Set active category and filter
                activeCategory = category;
                filterTools();
            });

            categoriesContainer.appendChild(btn);
        }

        // Get a random icon for new tools
        function getRandomIcon() {
            const icons = [
                'fas fa-tools', 'fas fa-cog', 'fas fa-wrench', 'fas fa-plug',
                'fas fa-puzzle-piece', 'fas fa-microchip', 'fas fa-server',
                'fas fa-terminal', 'fas fa-code-branch', 'fas fa-database'
            ];
            return icons[Math.floor(Math.random() * icons.length)];
        }

        // Show notification
        function showNotification(message, type = 'success') {
            notificationMessage.textContent = message;
            notification.classList.add('show');

            // Change notification color based on type
            if (type === 'error') {
                notification.style.backgroundColor = 'var(--warning)';
            } else {
                notification.style.backgroundColor = 'var(--success)';
            }

            setTimeout(() => {
                notification.classList.remove('show');
            }, 3000);
        }

        // Initialize the app when DOM is loaded
        document.addEventListener('DOMContentLoaded', init);
    </script>
	>
}

}