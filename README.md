# ZIRIS-DevHub
Welcome to **ZIRIS DevHub** — a centralized toolkit and launcher framework designed for InterSystems IRIS developers.  
Easily organize, access, and extend developer tools, admin utilities, CSP pages, and more — all in one place.

---

## 🚀 Overview

`ZIRIS.DevHub` provides a **centralized home page** (`ZIRIS.DevHub.Home.cls`) that acts as the launchpad for all your development and admin tools.  
This modular framework enables developers to quickly navigate and manage various utilities built as individual classes.

---

## 📦 Package Structure & Naming Convention

To maintain clarity, scalability, and ease of navigation, the following **package structure** and **naming convention** is used:

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
/ZIRIS.DevHub.Home.cls
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
5. Write clear commit messages.
6. Submit a pull request with a description of your changes.

---

## ⚙️ Installation

You can install ZIRIS DevHub by cloning this repository or importing the classes into your IRIS namespace:

```bash
git clone https://github.com/yourusername/ZIRIS-DevHub.git
````

Then, in the IRIS terminal:

```objectscript
ZN "YOURNAMESPACE"
do $System.OBJ.LoadDir("/path/to/ZIRIS-DevHub/src", "ck")
```

*Or*, if published as a ZPM package, you can install via:

```objectscript
zpm:USER> install zirisd devhub
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
