# ZIRIS-DevHub
Welcome to **ZIRIS DevHub**🛠️ — a centralized toolkit and launcher framework designed for InterSystems IRIS developers.  
Easily organize, access, and extend developer tools, admin utilities, CSP pages, and more — all in one place.

---

## 🚀 Overview

`ZIRIS.DevHub` provides a **centralized home page** (`ZIRIS.DevHub.Home.cls`) that acts as the launchpad for all your development and admin tools.  
This modular framework enables developers to quickly navigate and manage various utilities built as individual classes.

Note: Recompile the "ZIRIS.DevHub.Template" class to get the screens in ZIRIS.DevHub.Home.cls

---

## 📦 Package Structure & Naming Convention

To maintain clarity, scalability, and ease of navigation, the following **package structure** and **naming convention** is used:

<b>Note: CSP classes can be included in any of the packages below if needed.</b>
```

ZIRIS.DevHub
├── Home.cls               ; Central launcher / main page for the toolkit
├── Tools                  ; General developer tools
│   └── [Action].cls       ; e.g., BookmarkLauncher.cls
├── Admin                  ; Admin-related tools and screens
│   └── [Action].cls       ; e.g., ShowGlobals.cls
├── Errors                 ; Error handling and viewer tools
│   └── [Action].cls       ; e.g., ViewErrors.cls
├── CSP                    ; Custom CSP pages and components
│   └── [Action].cls       ; e.g., ErrorViewer.cls
└── Utils                  ; Utility and helper classes
└── [Function].cls     ; e.g., StringHelper.cls

```

### Naming Convention

Classes are named following this pattern:

```

ZIRIS.DevHub.[Module].[Action/Function].cls

````

- **`Module`** — Functional area (e.g., Tools, Admin, Errors, CSP, Utils)  
- **`Action/Function`** — Specific task or utility performed by the class (e.g., ShowGlobals, ViewErrors, BookmarkLauncher)

---

## 📖 Usage

1. Import or clone the repository into your IRIS namespace.
2. Compile all classes.
3. Open the main launcher page by navigating to:

```CSP
ZIRIS.DevHub.Home.cls is the Home class you can access all developer tools here

e.g
http://server:[port]/namespacecsp/ZIRIS.DevHub.Home.cls
http://172.23.125.184:52773/csp/user/ZIRIS.DevHub.Home.cls
````

4. From the Home page, access all available tools and utilities in one place.

---

## 🤝 Contributions

We welcome contributions from the community! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Implement your feature or fix.
4. Follow the existing **package and naming conventions**:

   * Use the `ZIRIS.DevHub.[Module].[Action/Function].cls` format.
   * Organize classes under the appropriate module folder.
   * Use ZIRIS.DevHub.Template super class for CSP Applications( %CSP.Page)
5. Write clear commit messages.
6. Submit a pull request with a description of your changes.

## 🌐 New CSP Application

Create a new CSP application within the appropriate module folder.

### Steps:

1. **Extend the Base Template**  
   Your CSP class should extend:  
   ```objectscript
   ZIRIS.DevHub.Template

2. **Add Required Parameters**

   * `CATEGORY` — Used for sorting or grouping the application.
   * `APPLICATION` — The display name of your application.

3. **Describe the Application**

   * Implement the `AppDescription()` class method to return a brief description of your application.

   Example:

   ```objectscript
   ClassMethod AppDescription() As %String
   {
       return "This tool allows developers to view and manage global variables."
   }
   ```


---

## ⚙️ Installation

You can install ZIRIS DevHub by cloning this repository or importing the classes into your IRIS namespace:
1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/ZIRIS-DevHub.git
2. **Navigate to the project directory**:

   ```bash
   cd ZIRIS-DevHub
   ```

3. **Run the docker compose file**:

   ```bash
   docker compose -f docker-compose.yml up -d --build
   ```

Then, in the IRIS terminal:

```objectscript
ZN "YOURNAMESPACE"
do $System.OBJ.LoadDir("/path/to/ZIRIS-DevHub/src", "ck")
```

*Or*, if published as a ZPM package, you can install via:

```objectscript
zpm:USER> install ZIRIS-DevHub
```

---

### License

This project is licensed under the [MIT License](LICENSE).

---

## 📬 Contact

For questions or support, please open an issue or contact the maintainer.

---
Thank you for using **ZIRIS DevHub** — making IRIS development easier, one tool at a time!

---
