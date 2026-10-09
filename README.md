# Kusa

Your AI workspace, even offline. A responsive local web app built for the AppBuildersPH Local AI hackathon.

## Windows quick start

1. Install Python 3.10 or newer from https://www.python.org/downloads/windows/. Include the Python launcher (`py`).
2. Extract this ZIP into a normal folder, such as Documents\Kusa. Do not run it inside the ZIP.
3. Double-click `setup.bat`. This creates a private Python environment and downloads the PDF reader. Internet is needed for this setup step.
4. Double-click `start.bat`. Keep the console window open. Visit **http://localhost:8765** if the browser does not open automatically.
5. Kusa opens with clearly labeled sample content. Use “Start fresh” to remove it before entering your own work.

For Ask Kusa:

1. Install Ollama from https://ollama.com/download/windows and open it.
2. Open PowerShell and run `ollama pull qwen2.5:3b` once. This downloads a local model.
3. In Kusa Settings, choose `qwen2.5:3b`, save, and click **Check connection**.
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
- Subject folders, renaming, and moving documents between folders.
- Local text extraction from PDF, TXT, and Markdown; write notes directly.
- Local Ollama chat with selected document excerpts, inspectable sources, and editable task suggestions requiring approval.
- Browser persistence, JSON export, and backup import.
- Clear errors when a model is unavailable; no simulated AI answers.

Use Tasks to view all deadlines, including past and future dates. Overview shows today's pending items only. There are no automatic submissions, push reminders, or recurring classes in this version.

## Storage and backup

Workspace content is stored in localStorage for **http://localhost:8765** in the browser you use. It is not encrypted and is not synced. Using a different browser or switching between localhost and 127.0.0.1 creates a separate browser workspace. Clearing browser/site data deletes it. Export backups regularly.

A backup includes document text, tasks, schedule, and chat history. This version restores documents/tasks/schedules but starts with empty chats; the import dialog discloses this. Backup exports are sensitive local files. Do not commit them to a public repository.

Limits: 10 MB per uploaded file, 100 pages per PDF, 300,000 extracted characters per file. Browser storage is commonly much smaller than disk storage; Kusa reports a storage error when capacity is exceeded. Scanned PDFs require OCR and are not supported.

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
## Wikipedia search (optional)

Ask Kusa has **My files · offline** and **Wikipedia · online** modes. File mode uses imported documents and a local Ollama model. Online mode sends the question to Wikipedia's search API, then passes short article snippets to the local Ollama model. Kusa displays article links for verification. Wikipedia search requires internet but no account, API key, or payment. Wikipedia does not cover all websites or breaking news, and excerpts may not be current. Check the article and its sources before relying on time-sensitive facts. Offline mode still works without Wi-Fi.

## Four workspaces (v0.7)

Use the Workspace menu to switch between Personal, Education, Finance, and Business. Existing Programming, History, and Mathematics folders move to Education; General moves to Personal. Existing documents, tasks, and schedules remain in browser storage. Each workspace shows its own materials and deadlines. Finance has a manual income/expense overview in Philippine pesos; these entries are estimates based solely on what you enter, with no bank connection. In Documents, use Move to place a file in any workspace. In Ask Kusa, say `Move report.pdf to Finance` for a matching file in the current workspace; Kusa asks you to confirm the destination. This command matches an existing filename; it does not automatically classify the contents of a file. Export a workspace backup before clearing browser data.
