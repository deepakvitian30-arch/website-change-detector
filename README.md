# Vinnovate IT Club — Website Change Detector

A robust, production-style Website Change Detector application designed and built with **zero requirement compromise** according to the master build specification.

---

## 🌟 Key Capabilities & Architecture

- **Real Browser Automation**: Playwright headless browser rendering with real Chromium/Chrome/Edge support. Handles dynamic single-page applications, client-rendered JavaScript, and full-page screenshots.
- **Strict SSRF Security Protection**: Pre-flight DNS resolution and real-time request/redirect interception. Blocks loopback (`127.0.0.0/8`, `::1`), private subnets (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `fc00::/7`), link-local/cloud metadata (`169.254.169.254`, `metadata.google.internal`), and non-HTTP/HTTPS protocols.
- **Durable Recoverable Job Queue & Scheduler**: Database-backed job queue with atomic distributed lease locking (prevents duplicate overlapping runs), expired lock auto-recovery, and bounded exponential backoff with jitter on transient failures.
- **Failure Classification Engine**: Distinguishes site outages, timeouts, blocked responses (HTTP 403/429/WAF), CAPTCHA challenges, and browser crashes. Outages and blocks are **never falsely classified as content changes**.
- **Configurable Noise Normalization Pipeline**: Ignores timestamps, dates, dynamic counters, rotating ads, volatile tokens, and whitespace. Configurable per-page sensitivity settings (`low`, `medium`, `high`).
- **Interactive Visual Region Picker**: Browser-based selector inspector allowing users to pick regions to monitor (green) and ignore (red) with real DOM validation.
- **Deep Text & Visual Comparison**: Side-by-side and unified text diffs with addition/removal highlighting, alongside visual screenshot difference heat-map overlays generated using Pillow. Compare **any two versions** of a page.
- **Multi-Channel Deduplicated Notifications**: Email (SMTP), Discord webhooks, and Telegram bot. Strict deduplication prevents duplicate alerts for the same version and recipient. Secrets are masked and delivery logs are audited with provider confirmation.
- **Shared URL Monitoring & Polite Rate Limiting**: Deduplicates physical fetches when multiple subscribers monitor the same canonical URL. Enforces domain concurrency and minimum request intervals.
- **Bonus Capabilities**: Per-page RSS 2.0 XML feeds, keyword-only alert filtering (`include`/`exclude`), numerical metric tracking, and AI/heuristic change summaries.

---

## 📂 Project Structure

```
website detector/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   ├── endpoints/       # auth, pages, comparisons, notifications, picker, dashboard, feed
│   │   │   ├── deps.py          # Dependency injection & JWT auth
│   │   ├── core/                # config, database, security
│   │   ├── models/              # SQLAlchemy models (User, MonitoredPage, ContentVersion, CheckRun, etc.)
│   │   ├── schemas/             # Pydantic schemas with server-side validation
│   │   ├── queue/               # Durable queue, lease locks, background scheduler
│   │   ├── services/            # SSRF protector, Playwright capture, normalizer, diff, image diff, dispatcher
│   │   ├── main.py              # FastAPI main application
│   │   └── worker.py            # Standalone async background worker
│   ├── tests/                   # Full pytest automated test suite (32 tests passing)
│   └── requirements.txt
├── frontend/
│   ├── src/
│   │   ├── api/client.ts        # Typed API client
│   │   ├── components/          # VisualPickerModal, TextDiffViewer, VisualDiffViewer, StatusBadge, Navbar, Layout
│   │   ├── pages/               # DashboardPage, PagesListPage, PageDetailPage, ComparisonPage, NotificationsPage, SettingsPage
│   │   ├── App.tsx
│   │   └── main.tsx
│   └── vite.config.ts
├── test_site/
│   └── server.py                # Controlled local test website for E2E verification
├── scripts/
│   └── e2e_live_demo.py         # 8-step live end-to-end verification script
├── REQUIREMENTS_TRACEABILITY.md # Full RTM mapping R1-R8 to code and tests
└── .env.example
```

---

## 🚀 Quickstart & Local Setup

### 1. Prerequisites
- Python 3.10+ (Python 3.12 verified)
- Node.js 18+ & npm
- Google Chrome or Microsoft Edge installed on host system

### 2. Backend Setup
```powershell
# Navigate to project root
cd "c:\Users\deepa\Desktop\website detector"

# Activate Python virtual environment
.\venv\Scripts\Activate.ps1

# Install backend dependencies (if needed)
pip install -r backend/requirements.txt
```

### 3. Frontend Setup
```powershell
cd frontend
npm install
npm run build
```

---

## ⚙️ Running the Application

### Option A: Run Backend API & Embedded Worker
```powershell
# From project root:
.\venv\Scripts\python.exe -m uvicorn app.main:app --app-dir backend --host 127.0.0.1 --port 8000 --reload
```
The FastAPI backend will start at `http://127.0.0.1:8000` with interactive OpenAPI docs at `http://127.0.0.1:8000/docs`. The scheduler and worker run automatically in the background.

### Option B: Run Standalone Worker Service
For scaled deployments with multiple workers:
```powershell
.\venv\Scripts\python.exe -m app.worker
```

### Option C: Run Frontend Dev Server
```powershell
cd frontend
npm.cmd run dev
```
Open your browser at `http://localhost:5173`.

---

## 🧪 Automated Test Suite

Run the complete backend test suite:
```powershell
.\venv\Scripts\python.exe -m pytest backend/tests -v
```
**Results: 32 passed across all test modules:**
- `test_ssrf_protector.py`: Loopback, private IP, scheme, cloud metadata, and DNS resolution validation.
- `test_failure_classifier.py`: Outages, timeouts, blocked responses, CAPTCHAs, browser crashes.
- `test_normalizer.py`: Timestamps, numbers, rotating ads, CSS selectors, sensitivity levels.
- `test_queue_and_retry.py`: Lease locking, duplicate prevention, bounded exponential backoff with jitter.
- `test_notifications.py`: Deduplication keys and multi-channel audit logging.
- `test_image_diff.py`: Pixel difference mask generation and missing screenshot handling.
- `test_api_endpoints.py`: CRUD, SSRF API rejection, secret token masking, and RSS syndication.
- `test_e2e_flow.py`: Full monitoring lifecycle from baseline to change detection.

---

## 🎯 Live End-to-End Verification (Phase E)

To demonstrate the full 8-gate verification against a live target with real headless browser automation:

```powershell
# 1. Start the controlled test website server:
.\venv\Scripts\python.exe -m uvicorn test_site.server:app --host 127.0.0.1 --port 8088

# 2. In another terminal, run the live verification script:
.\venv\Scripts\python.exe scripts/e2e_live_demo.py
```

### Verification Results:
1. **Gate 1 — Baseline Creation**: Establishes initial Version 1 snapshot, `is_baseline=True`, 0 false alerts.
2. **Gate 2 — Unchanged Check**: Content identical except dynamic timestamp; normalization hashes match; 0 new versions created; 0 alerts.
3. **Gate 3 — Outage Classification**: HTTP 503 triggers `OUTAGE` classification; page status marked `ERROR`; 0 content versions created; 0 false change alerts.
4. **Gate 4 — CAPTCHA Classification**: Turnstile/bot challenge classified as `CAPTCHA`; page status marked `BLOCKED`; 0 false change alerts.
5. **Gate 5 — Real Content Change**: Detects additions and deletions; creates Version 2; generates structured text diffs and visual difference overlay image; dispatches notifications.
6. **Gate 6 — Notification Deduplication**: Secondary alert dispatch for the same change and recipient is completely deduplicated (0 duplicate alerts delivered).
7. **Gate 7 — Shared Monitoring**: Multiple subscribers monitoring the same canonical URL reuse physical browser renders.
8. **Gate 8 — Rate Limiting**: Domain requests strictly adhere to polite minimum intervals and concurrency bounds.

---

## 🔒 Security Design Summary

- **SSRF Defenses**: Validates all input URLs before scheduling. Aborts any request or redirect resolving to private or metadata addresses during headless browser execution.
- **Credential Protection**: The system does not request, collect, or store target website credentials.
- **Notification Secret Masking**: Telegram bot tokens and webhook secrets are stored securely and never returned in cleartext to frontend responses.
- **Resource Constraints**: Strict navigation and execution timeouts, bounded retry limits, and domain concurrency caps prevent resource exhaustion.
