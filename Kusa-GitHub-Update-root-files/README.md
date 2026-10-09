# Kusa

Your AI workspace, even offline. A responsive local web app built for the AppBuildersPH Local AI hackathon.

## Windows quick start

1. Install Python 3.10 or newer from https://www.python.org/downloads/windows/. Include the Python launcher (`py`).
2. Extract this ZIP into a normal folder, such as Documents\Kusa. Do not run it inside the ZIP.
3. Double-click `setup.bat`. This creates a private Python environment and downloads the PDF reader. Internet is needed for this setup step.
4. Double-click `start.bat`. Keep the console window open. Visit **http://localhost:8765** if the browser does not open automatically.
5. Kusa opens with clearly labeled sample content. Use “Start fresh” to remove it before entering your own work.

## Build a Windows executable

To create `dist\Kusa.exe`, run `build-windows.bat` on Windows with Python 3.10 or newer and an internet connection. The build downloads PyInstaller once and bundles Kusa's Python server and web files. Double-click the resulting executable to launch Kusa in your browser; keep its console window open while using it. This packages Kusa, not Ollama or the AI model. Install Ollama and download the model separately using the steps below. Build and test the executable on Windows before sharing it.

## Publish the website and phone PWA

The `docs` folder is the public website. Before publishing after app changes, run `python sync-site-app.py` to copy the latest PWA into `docs/app`. Push the repository to GitHub, then in the repository open **Settings → Pages** and set the source to the `main` branch and `/docs` folder. The site opens at `https://kyletbh.github.io/kusa-local-ai/`; the phone app is at `/app/` on that site. Phone users can add it to their Home Screen. The hosted phone app supports its local workspace and text-file workflow, but Ask Kusa's offline AI is not included there yet.

The `.github/workflows/windows-release.yml` workflow builds `Kusa-Windows.zip` and attaches it to a GitHub Release when you publish one. The website's Windows download button points to the latest release. Publish a release after the workflow is on GitHub so visitors have a Windows download.

For Ask Kusa:

1. Install Ollama from https://ollama.com/download/windows and open it.
2. Open PowerShell and run `ollama pull qwen2.5:3b` once. This downloads a local model.
3. Open Kusa Settings. It checks Ollama automatically. If setup is needed, follow the guided steps to install Ollama and download `qwen2.5:3b`; the install and model download require internet and your approval.
4. Add a document to a subject folder. In Ask Kusa, select that folder and send a question.
5. Test with Wi-Fi off after installation and model download. The website, imported text, and AI model run locally.

Your RTX 3050 laptop with 16 GB RAM is the target test machine. Close unnecessary apps first. Model speed and answer quality still need testing on your laptop; they are not guaranteed by this package.

If `py` is not found but `python` works, run these commands in the extracted folder:

```powershell
python -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
.venv\Scripts\python.exe server.py
```

## Included features

- Phone-friendly and desktop layouts with the approved 3D Kusa logo, blue folders, and minimalist K chat identity.
- Today's classes and pending deadlines, based on the computer's local date.
- Editable single-date schedule entries; create/edit/delete tasks and mark them complete.
- Click Load demo data to add labeled sample files, tasks, schedules, and finance entries across workspaces without deleting existing records. Quick file sorting opens the picker into Personal; in Ask Kusa use “Move [exact filename] to Finance” and confirm the destination.
- Education includes Mathematics, Science, English, Filipino, History, Computer Studies, and custom subjects. Each subject starts with Notes and Lectures; Modules and Learning Materials; Research Papers; Projects and Presentations; Books and References; Class Schedules; Academic Deadlines; and Online Courses and Certificates. Finance and Business start with the exact organizer folders listed below. These organize files and tasks; they do not automate accounting, payroll, or inventory.
- Three-dot menus on every folder and document. Rename, archive/restore, and delete folders; rename, move, archive/restore, and delete documents. Folder deletion can move its files, tasks, schedules, and chat history to another folder; permanent deletion requires a second confirmation.
- Light, dark, and device-matched appearance themes in Settings.
- Local text extraction from PDF, TXT, and Markdown; write notes directly.
- Local Ollama chat with selected document excerpts, inspectable sources, and editable task suggestions requiring approval.
- Browser persistence, JSON export, and backup import.
- Clear errors when a model is unavailable; no simulated AI answers.

Use Tasks to view all deadlines, including past and future dates. Overview shows today's pending items only. There are no automatic submissions, push reminders, or recurring classes in this version.

## Storage and backup

Workspace content is stored in localStorage for **http://localhost:8765** in the browser you use. It is not encrypted and is not synced. Using a different browser or switching between localhost and 127.0.0.1 creates a separate browser workspace. Clearing browser/site data deletes it. Export backups regularly.

A backup includes document text, tasks, schedule, and chat history. This version restores documents/tasks/schedules but starts with empty chats; the import dialog discloses this. Backup exports are sensitive local files. Do not commit them to a public repository.

Limits: 10 MB per uploaded file, 100 pages per PDF, 300,000 extracted characters per file. Browser storage is commonly much smaller than disk storage; Kusa reports a storage error when capacity is exceeded. Scanned PDFs require OCR and are not supported.

## Guided local AI setup (v0.10.4)

Settings checks whether Ollama is running and whether the selected model is present. If either is missing, Kusa shows short setup steps and the official Ollama download page. The user installs Ollama and downloads the model with Ollama; Kusa does not install software or download multi-gigabyte models silently. After the model is downloaded, local inference can work offline. Advanced model selection remains available in Settings.

## How local AI works

The Python server serves bundled HTML/CSS/JavaScript and proxies only to Ollama at 127.0.0.1:11434. It binds to 127.0.0.1. The API uses `/api/tags` and `/api/chat` with `stream: false` and JSON output. It rejects model names containing “cloud”. Use downloaded local models only.

Documents are split into excerpts and ranked by word overlap with the question. Up to five excerpts are passed to the model along with recent chat messages. This is simple keyword retrieval, not semantic embeddings. Broad summaries may miss material outside those excerpts. Retrieved passages and model-selected citations are labeled separately, and their contents are inspectable. Citation existence does not guarantee the model's claim is supported: verify the passage.

The model proposes task titles only. Users choose which to save; dates and times are entered explicitly rather than guessed. Imported documents are treated as data, not instructions, in the prompt. No autonomous tools, external actions, cloud AI, remote fonts, analytics, or CDNs are used.

The layout is phone-sized, but inference runs on the laptop hosting the app. This package does not expose the server to phones on the network and does not implement on-phone inference. It is not ready to deploy as a public hosted service.

## Validation and remaining checks

Completed here: Python/JavaScript syntax checks; PDF text extraction through the HTTP API; retrieval source labels; rejection of foreign-origin requests; state/render logic tests for folder creation, notes, task completion, schedules, persistence, escaping, and task approval. The AI API contract was checked using a clearly isolated test double, not actual model inference.

A browser engine download was blocked in the build environment, so full browser layout/interaction QA remains to be done on your computer. Actual Ollama inference, speed, and answer quality also require your local test. The Windows batch launchers have not been executed on Windows here.

Suggested acceptance test:
1. Add a folder, import a PDF, and create a task. Reload and confirm they remain.
2. Ask a question whose answer is in the PDF. Inspect its source.
3. Ask for a checklist, edit suggestions, approve, and check Tasks.
4. Turn off Wi-Fi and repeat with a different question.
5. Export a backup before the demo.

## Development

Files: `server.py` (local server), `web/index.html`, `web/style.css`, `web/app.js`, `web/assets/logo.png`, `requirements.txt`, Windows launchers.

On macOS/Linux:
```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python server.py
```

Optional environment variable: KUSA_PORT (default 8765). The Windows browser launcher uses the default port. Do not expose this development server to the internet.

## Submission disclosure

- App code: Python standard library, vanilla JavaScript, HTML, CSS.
- PDF extraction: pypdf.
- AI runtime/model: Ollama and the exact model you actually test (starting suggestion qwen2.5:3b). Check and disclose the model license for your use.
- Retrieval: custom keyword matching; no embedding model.
- Development assistance: OpenAI ChatGPT/Codex; logo generated with OpenAI image generation during this session.
- No pre-existing app source code reused in this package; standard dependencies are existing libraries.
- AI runs locally after initial downloads. Initial installation/model downloads require internet. No public deployment is required for the local workflow.
- Your name/team, repository URL, video post URL, and measured results must be added by you. Do not report unmeasured performance claims.

Official API reference: https://docs.ollama.com/api/chat and https://docs.ollama.com/api/tags
## iPhone access (v0.10.8)

To use the same Ask Kusa model on iPhone without internet, connect the computer and phone to the same Wi-Fi router, then run `start-phone.bat` on the computer. Open the private phone link printed in its window in iPhone Safari. Keep Wi-Fi on and keep the computer, Kusa, and Ollama running; internet is not needed. If Windows Firewall asks, allow Python on Private networks only. Use phone mode only on a trusted Wi-Fi network. The link contains a private pairing token. `start.bat` remains computer-only.

Use the printed local link for Ask Kusa. The previously hosted HTTPS PWA preview is a separate app origin and cannot access the computer's local backend. Phone and computer data are stored separately in their respective browser profiles; there is no sync. Turning Wi-Fi off disconnects the phone, though Ask Kusa continues working locally on the computer.

## Four workspaces (v0.10.8)

Use the Workspace menu to switch between Personal, Education, Finance, and Business. Existing Programming, History, and Mathematics folders move to Education; General moves to Personal. Education starts with the six listed subjects and eight study folders inside each subject; you can add custom subjects. Finance has Bills and Utilities; Budget and Budget Plans; Expenses and Receipts; Income and Salary Records; Savings Goals; Debts and Loans; Bank Statements; Investments; Stocks and Asset Records; Insurance Policies; Taxes and Tax Documents; Subscriptions and Recurring Payments; Payment Tracking; Financial Goals; Financial Reports; and Business Financial Documents. Business has Meetings and Meeting Minutes; Tasks and Projects; Payroll and Payroll Schedules; Employee Records; Inventory and Stock Management; Sales Reports; Customers and Clients; Invoices and Receivables; Contracts and Agreements; Business Permits and Licenses; Business Plans; Company Policies; Deliveries and Orders; Business Deadlines; and Financial Reports. The three-dot menus on documents provide Rename, Move, Archive/Restore, and Delete. Choose Light, Dark, or Use device setting in Settings. Existing documents, tasks, and schedules remain in browser storage. Each workspace shows its own materials and deadlines. Finance has a manual income/expense overview in Philippine pesos; these entries are estimates based solely on what you enter, with no bank connection. In Documents, use Move to place a file in any workspace. In Ask Kusa, say `Move report.pdf to Finance` for a matching file in the current workspace; Kusa asks you to confirm the destination. You can also load clearly labeled sample data to try all workspaces. This command matches an existing filename; it does not automatically classify the contents of a file. Export a workspace backup before clearing browser data.
