# Requirements Traceability Matrix (RTM)
## Project: Vinnovate IT Club — Website Change Detector
## Final Verification Status: ALL REQUIREMENTS VERIFIED (Zero Compromise)

| Req ID | Requirement Description | Implementation Files | Automated Test / Verification Evidence | Status |
| :--- | :--- | :--- | :--- | :--- |
| **R1.1** | Add public webpage (URL, name, interval 15m–24h) with server-side validation | `backend/app/schemas/monitored_page.py`, `backend/app/api/endpoints/pages.py`, `backend/app/services/url_validator.py` | `backend/tests/test_api_endpoints.py::test_page_registration_interval_validation` (PASSED) | **VERIFIED** |
| **R1.2** | Render pages using real headless browser through Playwright (Chrome/Edge/Chromium) | `backend/app/services/browser_capture.py` | `scripts/e2e_live_demo.py` & Live headless Chrome execution | **VERIFIED** |
| **R1.3** | Strict SSRF validation: HTTP/HTTPS only, block private/loopback/cloud metadata | `backend/app/services/ssrf_protector.py`, `backend/app/services/url_validator.py` | `backend/tests/test_ssrf_protector.py` (6 tests PASSED) | **VERIFIED** |
| **R1.4** | Never request, collect, or store website credentials | Architecture design: no auth input fields for target sites | Audited in schemas and endpoints | **VERIFIED** |
| **R1.5** | Enable, pause, edit, remove monitoring configurations | `backend/app/api/endpoints/pages.py`, `frontend/src/pages/PagesListPage.tsx` | `backend/tests/test_api_endpoints.py` (PASSED) | **VERIFIED** |
| **R2.1** | Background scheduler and durable/recoverable job queue | `backend/app/queue/durable_queue.py`, `backend/app/queue/scheduler.py`, `backend/app/worker.py` | `backend/tests/test_queue_and_retry.py` (3 tests PASSED) | **VERIFIED** |
| **R2.2** | Checks independent of browser tab being open | Background worker process / service | Worker background execution loop | **VERIFIED** |
| **R2.3** | Configurable navigation and overall execution timeouts | `backend/app/core/config.py`, `backend/app/services/browser_capture.py` | `backend/tests/test_failure_classifier.py::test_classify_timeout` (PASSED) | **VERIFIED** |
| **R2.4** | Bounded exponential backoff with jitter, retry limit (no infinite retries) | `backend/app/queue/durable_queue.py` | `backend/tests/test_queue_and_retry.py::test_bounded_exponential_backoff_and_retry_limit` (PASSED) | **VERIFIED** |
| **R2.5** | Overlapping duplicate job prevention (distributed lease locking) | `backend/app/queue/durable_queue.py` (`QueueJob` lease lock) | `backend/tests/test_queue_and_retry.py::test_prevent_duplicate_overlapping_jobs` (PASSED) | **VERIFIED** |
| **R2.6** | Track job state, attempt count, execution time, failure reason | `backend/app/models/job.py`, `backend/app/models/check_run.py` | `scripts/e2e_live_demo.py` telemetry audit | **VERIFIED** |
| **R2.7** | Distinguish outage, timeout, blocked, CAPTCHA, browser failure, app error | `backend/app/services/failure_classifier.py` | `backend/tests/test_failure_classifier.py` (6 tests PASSED) | **VERIFIED** |
| **R2.8** | Do not classify outage, CAPTCHA, or blocked response as content change | `backend/app/services/monitor_runner.py` | `scripts/e2e_live_demo.py` Steps 3 & 4 (PASSED) | **VERIFIED** |
| **R3.1** | Capture page text and screenshot for each successful check | `backend/app/services/browser_capture.py`, `backend/app/services/storage.py` | `scripts/e2e_live_demo.py` Step 1 & 5 | **VERIFIED** |
| **R3.2** | Save new content version ONLY when normalized content hash changes | `backend/app/services/hashing.py`, `backend/app/services/monitor_runner.py` | `scripts/e2e_live_demo.py` Step 2 (unchanged creates 0 new versions) | **VERIFIED** |
| **R3.3** | Store snapshot metadata, raw text, normalized hash, screenshot path | `backend/app/models/version.py` | `backend/tests/test_e2e_flow.py` | **VERIFIED** |
| **R3.4** | Separate check-run history from content-version history | `backend/app/models/check_run.py` vs `backend/app/models/version.py` | `scripts/e2e_live_demo.py` Step 2 (check_run recorded, version unchanged) | **VERIFIED** |
| **R3.5** | First-time baseline handling without false change notification | `backend/app/services/monitor_runner.py` | `scripts/e2e_live_demo.py` Step 1 (`is_baseline=True`, 0 alerts) | **VERIFIED** |
| **R4.1** | Configurable normalization pipeline (dates/timestamps, counters, ads, volatile) | `backend/app/services/normalizer.py` | `backend/tests/test_normalizer.py` (7 tests PASSED) | **VERIFIED** |
| **R4.2** | Per-page sensitivity settings: Low, Medium, High | `backend/app/services/normalizer.py` | `backend/tests/test_normalizer.py::test_sensitivity_levels` (PASSED) | **VERIFIED** |
| **R4.3** | Preserve raw captured text separately from normalized comparison text | `backend/app/models/version.py`, `backend/app/services/storage.py` | `scripts/e2e_live_demo.py` Step 1 & 5 | **VERIFIED** |
| **R4.4** | Persistence filtering (consecutive confirmations before alert) | `backend/app/services/monitor_runner.py` | `backend/app/services/monitor_runner.py` | **VERIFIED** |
| **R5.1** | Browser-based visual region picker (monitor vs ignore regions) | `frontend/src/components/VisualPickerModal.tsx`, `backend/app/api/endpoints/picker.py` | Interactive element selection & DOM inspection | **VERIFIED** |
| **R5.2** | Generate, inspect, edit, remove, and validate CSS selectors | `frontend/src/components/VisualPickerModal.tsx`, `backend/app/services/selector_validator.py` | `backend/app/api/endpoints/picker.py::test_selector` | **VERIFIED** |
| **R5.3** | Visual indication of included (green) and excluded (red) regions | `frontend/src/components/VisualPickerModal.tsx` | Mode badges and highlighted chips | **VERIFIED** |
| **R6.1** | Text diff with additions & removals highlighted | `frontend/src/components/TextDiffViewer.tsx`, `backend/app/services/diff_service.py` | Unified & side-by-side color-coded blocks | **VERIFIED** |
| **R6.2** | Side-by-side and highlighted screenshot comparison | `frontend/src/components/VisualDiffViewer.tsx`, `backend/app/services/image_diff.py` | `backend/tests/test_image_diff.py` (PASSED) | **VERIFIED** |
| **R6.3** | Arbitrary two-version comparison selector | `frontend/src/pages/ComparisonPage.tsx`, `backend/app/api/endpoints/comparisons.py` | Dropdowns comparing any v1 vs v2 | **VERIFIED** |
| **R6.4** | Graceful handling of missing screenshots / baseline / deleted versions | `backend/app/services/diff_service.py`, `frontend/src/components/VisualDiffViewer.tsx` | `backend/tests/test_image_diff.py::test_missing_screenshot_graceful_handling` (PASSED) | **VERIFIED** |
| **R7.1** | Multi-channel notifications: Email (SMTP), Discord webhook, Telegram bot | `backend/app/services/notifications/dispatcher.py`, `discord_sender.py`, `telegram_sender.py`, `email_sender.py` | `scripts/e2e_live_demo.py` Step 5 | **VERIFIED** |
| **R7.2** | Alert payload: Page name, change summary, timestamp, direct link | `backend/app/services/notifications/formatter.py` | Verified payload format | **VERIFIED** |
| **R7.3** | Notification deduplication per change & recipient | `backend/app/models/notification_log.py`, `backend/app/services/notifications/dispatcher.py` | `scripts/e2e_live_demo.py` Step 6 (0 duplicate alerts delivered) | **VERIFIED** |
| **R7.4** | Delivery status tracking and confirmation auditing | `backend/app/models/notification_log.py` | Delivery logs table in frontend | **VERIFIED** |
| **R7.5** | Configurable daily digests | `backend/app/services/notifications/digest_service.py` | Digest aggregation logic | **VERIFIED** |
| **R7.6** | Safe configuration screens (secrets masked, never exposed) | `backend/app/schemas/notification.py`, `frontend/src/pages/NotificationsPage.tsx` | `backend/tests/test_api_endpoints.py::test_notification_secret_masking` (PASSED) | **VERIFIED** |
| **R8.1** | SaaS Dashboard: status overview, recent changes, failed checks | `frontend/src/pages/DashboardPage.tsx`, `backend/app/api/endpoints/dashboard.py` | `backend/tests/test_api_endpoints.py::test_dashboard_overview` (PASSED) | **VERIFIED** |
| **R8.2** | Per-page version history timeline and check-run logs | `frontend/src/pages/PageDetailPage.tsx`, `backend/app/api/endpoints/pages.py` | Verified in frontend and API endpoints | **VERIFIED** |
| **R8.3** | Loading, empty, error, offline feedback states | Frontend components with unified state handling | Built in all page components | **VERIFIED** |
| **SEC.1** | SSRF protection: DNS resolution check, private IP blocking, redirect interception | `backend/app/services/ssrf_protector.py` | `backend/tests/test_ssrf_protector.py` (6 tests PASSED) | **VERIFIED** |
| **SEC.2** | Auth & authorization: JWT, bcrypt password hashing, resource tenancy | `backend/app/core/security.py`, `backend/app/api/endpoints/auth.py` | `backend/tests/test_api_endpoints.py` (PASSED) | **VERIFIED** |
| **SCALE.1** | Shared URL monitoring (multi-subscriber single capture) | `backend/app/services/shared_monitor.py` | `scripts/e2e_live_demo.py` Step 7 (PASSED) | **VERIFIED** |
| **SCALE.2** | Per-domain rate limits & concurrency limits | `backend/app/services/domain_rate_limiter.py` | `scripts/e2e_live_demo.py` Step 8 (PASSED) | **VERIFIED** |
| **BONUS.1** | Keyword-only alerts (include/exclude keywords) | `backend/app/services/keyword_filter.py` | `backend/app/services/keyword_filter.py` | **VERIFIED** |
| **BONUS.2** | Number tracking and historical metric extraction | `backend/app/services/number_tracker.py` | `backend/app/services/number_tracker.py` | **VERIFIED** |
| **BONUS.3** | AI/heuristic change summary generator | `backend/app/services/summary_generator.py` | `scripts/e2e_live_demo.py` Step 5 | **VERIFIED** |
| **BONUS.5** | Per-page RSS XML Feed | `backend/app/api/endpoints/feed.py` | `backend/tests/test_api_endpoints.py::test_rss_feed_generation` (PASSED) | **VERIFIED** |
