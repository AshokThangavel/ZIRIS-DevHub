Class ZIRIS.DevHub.Tools.FocusBoard.Home Extends ZIRIS.DevHub.Portal.Template
{

Parameter Title As STRING [ Final ] = "Focus Board";

Parameter APPLICATION As STRING = "Focus Board";

ClassMethod OnPageHEAD() As %Boolean
{
	Write "<head>",!
	Write !,"<title>"_..#Title_"</title>",!
	Write "<style>",!
	Do ..LoadCSS()
	Write "</style>",!
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Write "</head>",!
	Write ..HyperEventHead(0,0)
	Return $$$OK
}

ClassMethod OnRenderScreen()
{
	&HTML<

    <body>
    <div class="container">
        <header class="header">
            <h1>My Focus Board</h1>
            <div class="header-actions">
                <button class="add-task-btn" id="addTaskBtn">
                    <i class="fas fa-plus"></i> Add Task
                </button>
                <button class="archive-btn" id="archiveBtn">
                    <i class="fas fa-archive"></i> Archive
                </button>
                <button class="dark-mode-toggle" id="darkModeToggle">
                    <i class="fas fa-moon"></i>
                </button>
            </div>
        </header>

        <div class="main-content">
            <div class="kanban-container">
                <div class="kanban-column">
                    <div class="column-header new">
                        <div class="column-title">New</div>
                        <div class="task-count" id="newCount">0</div>
                    </div>
                    <div class="task-list" id="new" data-status="new">
                        <!-- Tasks will be added here dynamically -->
                    </div>
                </div>

                <div class="kanban-column">
                    <div class="column-header planned">
                        <div class="column-title">Planned</div>
                        <div class="task-count" id="plannedCount">0</div>
                    </div>
                    <div class="task-list" id="planned" data-status="planned">
                        <!-- Tasks will be added here dynamically -->
                    </div>
                </div>

                <div class="kanban-column">
                    <div class="column-header active">
                        <div class="column-title">Active</div>
                        <div class="task-count" id="activeCount">0</div>
                    </div>
                    <div class="task-list" id="active" data-status="active">
                        <!-- Tasks will be added here dynamically -->
                    </div>
                </div>

                <div class="kanban-column">
                    <div class="column-header overdue">
                        <div class="column-title">Overdue</div>
                        <div class="task-count" id="overdueCount">0</div>
                    </div>
                    <div class="task-list" id="overdue" data-status="overdue">
                        <!-- Tasks will be added here dynamically -->
                    </div>
                </div>

                <div class="kanban-column">
                    <div class="column-header completed">
                        <div class="column-title">Completed</div>
                        <div class="task-count" id="completedCount">0</div>
                    </div>
                    <div class="task-list" id="completed" data-status="completed">
                        <!-- Tasks will be added here dynamically -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit Task Modal -->
    <div class="modal" id="taskModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title" id="modalTitle">Add New Task</div>
                <button class="close-btn" id="closeModalBtn">&times;</button>
            </div>
            <form id="taskForm">
                <input type="hidden" id="taskId">
                <div class="form-group">
                    <label for="taskTitle">Task Title</label>
                    <input type="text" class="form-control" id="taskTitle" required>
                </div>
                <div class="form-group">
                    <label for="taskDescription">Description</label>
                    <textarea class="form-control" id="taskDescription" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="taskPriority">Priority</label>
                    <select class="form-control" id="taskPriority">
                        <option value="normal">Normal</option>
                        <option value="high">High</option>
                        <option value="critical">Critical</option>
                    </select>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-secondary" id="cancelBtn">Cancel</button>
                    <button type="button" class="btn btn-archive" id="archiveTaskBtn" style="display:none;">Archive</button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Add Task</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Archive Modal -->
    <div class="modal archive-modal" id="archiveModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">Archived Tasks</div>
                <button class="close-btn" id="closeArchiveModalBtn">&times;</button>
            </div>
            <div class="archive-list" id="archiveList">
                <!-- Archived tasks will be displayed here -->
            </div>
        </div>
    </div>

    <!-- Notification -->
    <div class="notification" id="notification"></div>

	>
}

XData Style
{
<data>
	<![CDATA[
	:root{--bg-color:#f5f7fa;--text-color:#333;--card-bg:#fff;--border-color:#ddd;--shadow-color:rgba(0,0,0,.1);--header-bg:#4361ee;--header-text:white;--button-bg:#4361ee;--button-text:white;--column-bg:#fff;--task-card-bg:#fff;--task-card-shadow:0 2px 5px rgba(0,0,0,.08);--priority-normal-bg:#eef2f7;--priority-normal-text:#7f8c9d;--priority-high-bg:#fef5e7;--priority-high-text:#f39c12;--priority-critical-bg:#fadbd8;--priority-critical-text:#e74c3c;--scrollbar-bg:#f1f1f1;--scrollbar-thumb:#c1c1c1;--scrollbar-thumb-hover:#a8a8a8;--archive-bg:#6c757d;--archive-text:white}body.dark-mode{--bg-color:#1a1a2e;--text-color:#eee;--card-bg:#16213e;--border-color:#0f3460;--shadow-color:rgba(0,0,0,.3);--header-bg:#4361ee;--header-text:white;--button-bg:#4361ee;--button-text:white;--column-bg:#16213e;--task-card-bg:#0f3460;--task-card-shadow:0 2px 5px rgba(0,0,0,.3);--priority-normal-bg:#2c3e50;--priority-normal-text:#bdc3c7;--priority-high-bg:#34495e;--priority-high-text:#f39c12;--priority-critical-bg:#2c3e50;--priority-critical-text:#e74c3c;--scrollbar-bg:#0f3460;--scrollbar-thumb:#34495e;--scrollbar-thumb-hover:#2c3e50;--archive-bg:#495057;--archive-text:white}*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}html,body{height:100%;background-color:var(--bg-color);color:var(--text-color);overflow:hidden;transition:background-color .3s,color .3s}.container{display:flex;flex-direction:column;height:100%}.header{background-color:var(--header-bg);color:var(--header-text);padding:15px 20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 10px var(--shadow-color)}h1{font-size:24px;font-weight:600}.header-actions{display:flex;gap:15px;align-items:center}.add-task-btn,.archive-btn{background-color:var(--button-bg);color:var(--button-text);border:none;padding:10px 20px;border-radius:5px;cursor:pointer;font-size:16px;display:flex;align-items:center;gap:8px;transition:background-color .3s}.add-task-btn:hover,.archive-btn:hover{background-color:#3a56d4}.dark-mode-toggle{background:none;border:none;color:var(--header-text);font-size:20px;cursor:pointer;padding:8px;border-radius:50%;transition:background-color .3s}.dark-mode-toggle:hover{background-color:rgba(255,255,255,.1)}.main-content{display:flex;flex-direction:column;flex-grow:1;padding:20px;overflow:hidden}.kanban-container{display:flex;gap:20px;overflow-x:auto;flex-grow:1;padding-bottom:20px}.kanban-column{flex:1;min-width:250px;background-color:var(--column-bg);border-radius:8px;box-shadow:0 2px 10px var(--shadow-color);display:flex;flex-direction:column;height:100%}.column-header{display:flex;justify-content:space-between;align-items:center;padding:15px;border-radius:8px 8px 0 0;flex-shrink:0}.column-title{font-size:18px;font-weight:600}.task-count{background-color:rgba(255,255,255,.3);color:white;border-radius:50%;width:24px;height:24px;display:flex;align-items:center;justify-content:center;font-size:12px}.task-list{flex-grow:1;overflow-y:auto;padding:15px;border:2px dashed transparent;border-radius:0 0 8px 8px;transition:border-color .3s}.task-list::-webkit-scrollbar{width:6px}.task-list::-webkit-scrollbar-track{background:var(--scrollbar-bg);border-radius:3px}.task-list::-webkit-scrollbar-thumb{background:var(--scrollbar-thumb);border-radius:3px}.task-list::-webkit-scrollbar-thumb:hover{background:var(--scrollbar-thumb-hover)}.task-list.drag-over{border-color:#3498db;background-color:rgba(52,152,219,.1)}.task-card{background-color:var(--task-card-bg);border-radius:6px;padding:15px;margin-bottom:10px;box-shadow:var(--task-card-shadow);cursor:move;transition:transform .2s,box-shadow .2s;border-left:4px solid;position:relative}.task-card:hover{transform:translateY(-2px);box-shadow:0 4px 8px var(--shadow-color)}.task-card.dragging{opacity:.5}.task-card.new{border-left-color:#3498db}.task-card.planned{border-left-color:#2ecc71}.task-card.active{border-left-color:#27ae60}.task-card.overdue{border-left-color:#e74c3c}.task-card.completed{border-left-color:#2c3e50}.task-header{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:10px}.task-title{font-weight:600;font-size:16px;margin-bottom:5px}.task-id{font-size:12px;color:#7f8c9d}.task-description{color:#7f8c9d;font-size:14px;margin-bottom:10px}.task-footer{display:flex;justify-content:space-between;align-items:center;font-size:12px;color:#95a5a6}.priority-badge{padding:3px 8px;border-radius:12px;font-weight:600;text-transform:uppercase;font-size:10px}.priority-badge.normal{background-color:var(--priority-normal-bg);color:var(--priority-normal-text)}.priority-badge.high{background-color:var(--priority-high-bg);color:var(--priority-high-text)}.priority-badge.critical{background-color:var(--priority-critical-bg);color:var(--priority-critical-text)}.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background-color:rgba(0,0,0,.5);z-index:1000;justify-content:center;align-items:center}.modal-content{background-color:var(--card-bg);border-radius:8px;width:90%;max-width:500px;padding:25px;box-shadow:0 5px 15px var(--shadow-color)}.modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}.modal-title{font-size:20px;font-weight:600}.close-btn{background:none;border:none;font-size:20px;cursor:pointer;color:#95a5a6}.form-group{margin-bottom:15px}.form-group label{display:block;margin-bottom:5px;font-weight:500}.form-control{width:100%;padding:10px;border:1px solid var(--border-color);border-radius:4px;font-size:14px;background-color:var(--card-bg);color:var(--text-color)}.form-control:focus{outline:none;border-color:#3498db}.btn-group{display:flex;justify-content:flex-end;gap:10px;margin-top:20px}.btn{padding:8px 16px;border-radius:4px;border:none;cursor:pointer;font-size:14px;transition:background-color .3s}.btn-primary{background-color:#3498db;color:white}.btn-primary:hover{background-color:#2980b9}.btn-secondary{background-color:var(--priority-normal-bg);color:var(--priority-normal-text)}.btn-secondary:hover{background-color:var(--priority-high-bg)}.btn-danger{background-color:#e74c3c;color:white}.btn-danger:hover{background-color:#c0392b}.btn-archive{background-color:var(--archive-bg);color:var(--archive-text)}.btn-archive:hover{background-color:#5a6268}.notification{position:fixed;top:20px;right:20px;padding:15px 20px;background-color:#2ecc71;color:white;border-radius:4px;box-shadow:0 4px 8px var(--shadow-color);transform:translateX(150%);transition:transform .3s ease-out;z-index:1001}.notification.show{transform:translateX(0)}.notification.error{background-color:#e74c3c}.column-header.new{background-color:#3498db}.column-header.new .column-title{color:white}.column-header.planned{background-color:#2ecc71}.column-header.planned .column-title{color:white}.column-header.active{background-color:#27ae60}.column-header.active .column-title{color:white}.column-header.overdue{background-color:#e74c3c}.column-header.overdue .column-title{color:white}.column-header.completed{background-color:#2c3e50}.column-header.completed .column-title{color:white}.archive-modal .modal-content{width:90%;max-width:800px;max-height:80vh;overflow-y:auto}.archive-list{max-height:60vh;overflow-y:auto;margin-top:15px}.archive-item{background-color:var(--task-card-bg);border-radius:6px;padding:15px;margin-bottom:10px;box-shadow:var(--task-card-shadow);border-left:4px solid var(--archive-bg)}.archive-item-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}.archive-item-title{font-weight:600;font-size:16px}.archive-item-actions{display:flex;gap:10px}.archive-item-description{color:#7f8c9d;font-size:14px;margin-bottom:10px}.archive-item-footer{display:flex;justify-content:space-between;align-items:center;font-size:12px;color:#95a5a6}.archive-item-priority{padding:3px 8px;border-radius:12px;font-weight:600;text-transform:uppercase;font-size:10px}.archive-item-priority.normal{background-color:var(--priority-normal-bg);color:var(--priority-normal-text)}.archive-item-priority.high{background-color:var(--priority-high-bg);color:var(--priority-high-text)}.archive-item-priority.critical{background-color:var(--priority-critical-bg);color:var(--priority-critical-text)}.archive-task-btn{position:absolute;top:10px;right:10px;background:none;border:none;color:var(--archive-bg);cursor:pointer;font-size:14px;padding:5px;border-radius:4px;transition:background-color .3s}.archive-task-btn:hover{background-color:rgba(108,117,125,0.1);color:var(--archive-bg)}.task-actions{display:flex;justify-content:flex-end;gap:10px;margin-top:10px}.task-actions .btn{padding:4px 8px;font-size:12px}@media(max-width:768px){.kanban-container{flex-direction:column}.kanban-column{min-width:100%;height:auto}.task-list{max-height:300px}.archive-modal .modal-content{width:95%;max-height:90vh}}
]]>
	</data>
}
ClassMethod Scripts()
{

	&HTML<
	<script language="javascript">
       document.addEventListener('DOMContentLoaded', () => {
            // DOM Elements
            const addTaskBtn = document.getElementById('addTaskBtn');
            const archiveBtn = document.getElementById('archiveBtn');
            const darkModeToggle = document.getElementById('darkModeToggle');
            const taskModal = document.getElementById('taskModal');
            const archiveModal = document.getElementById('archiveModal');
            const closeModalBtn = document.getElementById('closeModalBtn');
            const closeArchiveModalBtn = document.getElementById('closeArchiveModalBtn');
            const cancelBtn = document.getElementById('cancelBtn');
            const archiveTaskBtn = document.getElementById('archiveTaskBtn');
            const taskForm = document.getElementById('taskForm');
            const notification = document.getElementById('notification');
            const modalTitle = document.getElementById('modalTitle');
            const taskIdInput = document.getElementById('taskId');
            const submitBtn = document.getElementById('submitBtn');
            const archiveList = document.getElementById('archiveList');

            // Task Lists
            const newList = document.getElementById('new');
            const plannedList = document.getElementById('planned');
            const activeList = document.getElementById('active');
            const overdueList = document.getElementById('overdue');
            const completedList = document.getElementById('completed');

            // Task Counters
            const newCount = document.getElementById('newCount');
            const plannedCount = document.getElementById('plannedCount');
            const activeCount = document.getElementById('activeCount');
            const overdueCount = document.getElementById('overdueCount');
            const completedCount = document.getElementById('completedCount');

            // Sample initial tasks
            let tasks = #server(..GetTaskList())#;
            tasks = JSON.parse(tasks);

            // Check for saved dark mode preference
            if (localStorage.getItem('darkMode') === 'true') {
                document.body.classList.add('dark-mode');
                darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            }

            // Initialize the board
            renderTasks();

            // Event Listeners
            addTaskBtn.addEventListener('click', () => {
                openAddTaskModal();
            });

            archiveBtn.addEventListener('click', () => {
                openArchiveModal();
            });

            darkModeToggle.addEventListener('click', () => {
                document.body.classList.toggle('dark-mode');
                const isDarkMode = document.body.classList.contains('dark-mode');

                // Update icon
                darkModeToggle.innerHTML = isDarkMode ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';

                // Save preference
                localStorage.setItem('darkMode', isDarkMode);
            });

            closeModalBtn.addEventListener('click', closeModal);
            closeArchiveModalBtn.addEventListener('click', closeArchiveModal);
            cancelBtn.addEventListener('click', closeModal);
            archiveTaskBtn.addEventListener('click', archiveTask);

            taskForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const taskId = taskIdInput.value;

                if (taskId) {
                    updateTask(parseInt(taskId));
                } else {
                    addNewTask();
                }
            });

            // Close modal when clicking outside
            window.addEventListener('click', (e) => {
                if (e.target === taskModal) {
                    closeModal();
                }
                if (e.target === archiveModal) {
                    closeArchiveModal();
                }
            });

            // Functions
            function openAddTaskModal() {
                modalTitle.textContent = 'Add New Task';
                submitBtn.textContent = 'Add Task';
                archiveTaskBtn.style.display = 'none';
                taskForm.reset();
                taskIdInput.value = '';
                taskModal.style.display = 'flex';
            }

            function openEditTaskModal(taskId) {
                const task = tasks.find(t => t.id === taskId);

                if (task) {
                    modalTitle.textContent = 'Edit Task';
                    submitBtn.textContent = 'Update Task';
                    taskIdInput.value = task.id;
                    document.getElementById('taskTitle').value = task.title;
                    document.getElementById('taskDescription').value = task.description;
                    document.getElementById('taskPriority').value = task.priority;

                    // Show archive button for existing tasks
                    archiveTaskBtn.style.display = 'inline-flex';
                    taskModal.style.display = 'flex';
                }
            }

            function openArchiveModal() {
                // Load archived tasks
                const archivedTasks = #server(..GetArchivedTasks())#;
                const parsedArchivedTasks = JSON.parse(archivedTasks);

                // Clear the archive list
                archiveList.innerHTML = '';

                if (parsedArchivedTasks.length === 0) {
                    archiveList.innerHTML = '<p style="text-align: center; color: #7f8c9d;">No archived tasks found.</p>';
                } else {
                    // Render archived tasks
                    parsedArchivedTasks.forEach(task => {
                        const archiveItem = createArchiveItemElement(task);
                        archiveList.appendChild(archiveItem);
                    });
                }

                archiveModal.style.display = 'flex';
            }

            function closeModal() {
                taskModal.style.display = 'none';
                taskForm.reset();
                taskIdInput.value = '';
            }

            function closeArchiveModal() {
                archiveModal.style.display = 'none';
            }

            function renderTasks() {
                tasks = #server(..GetTaskList())#;
                tasks = JSON.parse(tasks);
                newList.innerHTML = '';
                plannedList.innerHTML = '';
                activeList.innerHTML = '';
                overdueList.innerHTML = '';
                completedList.innerHTML = '';
                let newCounter = 0;
                let plannedCounter = 0;
                let activeCounter = 0;
                let overdueCounter = 0;
                let completedCounter = 0;

                // Render tasks based on status
                tasks.forEach(task => {
                    const taskElement = createTaskElement(task);

                    switch(task.status) {
                        case 'new':
                            newList.appendChild(taskElement);
                            newCounter++;
                            break;
                        case 'planned':
                            plannedList.appendChild(taskElement);
                            plannedCounter++;
                            break;
                        case 'active':
                            activeList.appendChild(taskElement);
                            activeCounter++;
                            break;
                        case 'overdue':
                            overdueList.appendChild(taskElement);
                            overdueCounter++;
                            break;
                        case 'completed':
                            completedList.appendChild(taskElement);
                            completedCounter++;
                            break;
                    }
                });
                newCount.textContent = newCounter;
                plannedCount.textContent = plannedCounter;
                activeCount.textContent = activeCounter;
                overdueCount.textContent = overdueCounter;
                completedCount.textContent = completedCounter;
                addDragAndDropListeners();
            }

            function createTaskElement(task) {
                const taskCard = document.createElement('div');
                taskCard.className = `task-card ${task.status}`;
                taskCard.draggable = true;
                taskCard.dataset.id = task.id;

                taskCard.innerHTML = `
                    <!--button class="archive-task-btn" data-id="${task.id}" title="Archive Task">
                        <i class="fas fa-archive"></i>
                    </button-->
                    <div class="task-header">
                        <div>
                            <div class="task-title">${task.title}</div>
                            <div class="task-id">#${task.id}</div>
                        </div>
                        <div class="priority-badge ${task.priority}">${task.priority}</div>

                    </div>
                    <div class="task-description">${task.description}</div>
                    <div class="task-footer">
                        <span>Double-click to edit</span>
                        <span>${formatDate(new Date())}</span>
                    </div>
                    <div class="task-actions">
                        <button class="btn btn-archive btn-sm archive-task-card-btn" data-id="${task.id}">
                            <i class="fas fa-archive"></i>

                        </button>


                        <button class="btn btn-danger btn-sm delete-task-card-btn" data-id="${task.id}">
                             <i class="fa-solid fa-trash-can"></i>

                        </button>

                    </div>


                `;

                // Add double-click event listener for editing
                taskCard.addEventListener('dblclick', () => {
                    openEditTaskModal(task.id);
                });

                // Add event listener for the archive button in the header
                /*const archiveBtnHeader = taskCard.querySelector('.archive-task-btn');
                archiveBtnHeader.addEventListener('click', (e) => {
                    e.stopPropagation();
                    archiveTaskById(task.id);
                });*/

                // Add event listener for the archive button in the actions
                const archiveBtnAction = taskCard.querySelector('.archive-task-card-btn');
                archiveBtnAction.addEventListener('click', (e) => {
                    e.stopPropagation();
                    archiveTaskById(task.id);
                });


 				const delBtnAction = taskCard.querySelector('.delete-task-card-btn');
                delBtnAction.addEventListener('click', (e) => {
                    e.stopPropagation();
                    deleteArchivedTask1(task.id);
                });

                return taskCard;
            }

            function createArchiveItemElement(task) {
                const archiveItem = document.createElement('div');
                archiveItem.className = 'archive-item';
                archiveItem.dataset.id = task.id;

                archiveItem.innerHTML = `
                    <div class="archive-item-header">
                        <div class="archive-item-title">${task.title}</div>
                        <div class="archive-item-actions">
                            <button class="btn btn-primary btn-restore" data-id="${task.id}" ${task.status === 'completed' ? 'disabled' : ''}>
                                <i class="fas fa-undo"></i> Back to Board
                            </button>
                            <button class="btn btn-danger btn-delete" data-id="${task.id}">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                    <div class="archive-item-description">${task.description}</div>
                    <div class="archive-item-footer">
                        <div class="archive-item-priority ${task.priority}">${task.priority}</div>
                        <div>Archived on: ${task.archivedDate}</div>
                    </div>
                `;

                // Add event listeners for the buttons
                const restoreBtn = archiveItem.querySelector('.btn-restore');
                const deleteBtn = archiveItem.querySelector('.btn-delete');

                restoreBtn.addEventListener('click', () => {
                    restoreTask(task.id);
                });

                deleteBtn.addEventListener('click', () => {
                    deleteArchivedTask(task.id);
                });

                return archiveItem;
            }

            function addDragAndDropListeners() {
                const taskCards = document.querySelectorAll('.task-card');
                const taskLists = document.querySelectorAll('.task-list');

                taskCards.forEach(card => {
                    card.addEventListener('dragstart', handleDragStart);
                    card.addEventListener('dragend', handleDragEnd);
                });

                taskLists.forEach(list => {
                    list.addEventListener('dragover', handleDragOver);
                    list.addEventListener('drop', handleDrop);
                    list.addEventListener('dragenter', handleDragEnter);
                    list.addEventListener('dragleave', handleDragLeave);
                });
            }

            let draggedElement = null;

            function handleDragStart(e) {
                draggedElement = e.target;
                e.target.classList.add('dragging');
            }

            function handleDragEnd(e) {
                e.target.classList.remove('dragging');
            }

            function handleDragOver(e) {
                e.preventDefault();
            }

            function handleDragEnter(e) {
                if (e.target.classList.contains('task-list')) {
                    e.target.classList.add('drag-over');
                }
            }

            function handleDragLeave(e) {
                if (e.target.classList.contains('task-list')) {
                    e.target.classList.remove('drag-over');
                }
            }

            function handleDrop(e) {
                e.preventDefault();

                if (e.target.classList.contains('task-list')) {
                    e.target.classList.remove('drag-over');

                    if (draggedElement) {
                        const taskId = parseInt(draggedElement.dataset.id);
                        const newStatus = e.target.dataset.status;

                        // Update task status in the database
                        updateTaskStatus(taskId, newStatus);
                    }
                }
            }

            function updateTaskStatus(taskId, newStatus) {
                let st = #server(..UpdateTaskStatus(taskId,newStatus))#;
                renderTasks();
                showNotification(`Task #${taskId} moved to ${formatStatus(newStatus)}`);
            }

            function addNewTask() {
                const title = document.getElementById('taskTitle').value;
                const description = document.getElementById('taskDescription').value;
                const priority = document.getElementById('taskPriority').value;

                // Create new task object
                const newTask = {
                    title:title,
                    description:description,
                    status: 'new',
                    priority:priority
                };
                let st = #server(..AddNewTask(JSON.stringify(newTask)))#;
                closeModal();
                renderTasks();
                showNotification('New task added successfully');
            }

            function updateTask(taskId) {
                const title = document.getElementById('taskTitle').value;
                const description = document.getElementById('taskDescription').value;
                const priority = document.getElementById('taskPriority').value;
                let updateTask = {
                    title:title,
                    description:description,
                    priority:priority,
                    id:taskId
                };
                let st = #server(..UpdateTask(JSON.stringify(updateTask)))#;
                closeModal();
                renderTasks();
                showNotification('Task updated successfully');
            }

            function archiveTask() {
                const taskId = parseInt(taskIdInput.value);
                if (taskId) {
                    let st = #server(..ArchiveTask(taskId))#;
                    closeModal();
                    renderTasks();
                    showNotification('Task archived successfully');
                }
            }

            function archiveTaskById(taskId) {
                if (confirm('Are you sure you want to archive this task?')) {
                    let st = #server(..ArchiveTask(taskId))#;
                    renderTasks();
                    showNotification('Task archived successfully');
                }
            }

            function restoreTask(taskId) {
                let st = #server(..RestoreTask(taskId))#;
                if (st==1){
	                closeArchiveModal();
	                renderTasks();
	                showNotification('Task restored to New status');
                }
                else{
	                 showNotification('Error whil Task restoring');
                }
            }

            function deleteArchivedTask(taskId) {
                if (confirm('Are you sure you want to delete this archived task? This action cannot be undone.')) {
                    let st = #server(..DeleteArchivedTask(taskId))#;
                    // Refresh the archive list
                    openArchiveModal();
                    showNotification('Archived task deleted successfully');
                }
            }

           function deleteArchivedTask1(taskId) {
                if (confirm('Are you sure you want to delete this archived task? This action cannot be undone.')) {
                    let st = #server(..DeleteArchivedTask(taskId))#;
                    renderTasks();
                    showNotification('Archived task deleted successfully');
                }
            }

            function showNotification(message, isError = false) {
                notification.textContent = message;
                notification.className = 'notification';

                if (isError) {
                    notification.classList.add('error');
                }

                notification.classList.add('show');

                setTimeout(() => {
                    notification.classList.remove('show');
                }, 3000);
            }

            function formatStatus(status) {
                switch(status) {
                    case 'new': return 'New';
                    case 'planned': return 'Planned';
                    case 'active': return 'Active';
                    case 'overdue': return 'Overdue';
                    case 'completed': return 'Completed';
                    default: return status;
                }
            }

            function formatDate(date) {
                return date.toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric'
                });
            }
        });
    </script>
	>
}


ClassMethod GetTaskList() As %String [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).GetTaskList()
}

ClassMethod UpdateTaskStatus(taskId As %Integer, newStatus As %String) As %Status [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).UpdateTaskStatus(taskId, newStatus)
}

ClassMethod AddNewTask(pTaskDetails As %String) As %Status [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).SaveData(##class(%DynamicAbstractObject).%FromJSON(pTaskDetails))
}

ClassMethod UpdateTask(pTaskDetails As %String) As %Status [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).SaveData(##class(%DynamicAbstractObject).%FromJSON(pTaskDetails))
}

ClassMethod ArchiveTask(pTaskId) As %Status [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).ArchiveTask(pTaskId)
}

ClassMethod RestoreTask(pTaskId) As %Status [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).RestoreTask(pTaskId)
}

ClassMethod DeleteArchivedTask(pTaskId) [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).DeleteArchivedTask(pTaskId)
}

ClassMethod GetArchivedTasks() [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.Tools.FocusBoard.Data.Task).GetArchivedTasks()
}

}
