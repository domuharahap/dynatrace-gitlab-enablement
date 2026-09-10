--8<-- "snippets/dt-enablement.md"

# Part 4 — Live Stats & Extended Scenarios

## Use Case

Stream incremental BizEvents **throughout** the test run — not just at the end. A background thread group publishes rolling stats every 30 seconds, enabling a real-time Dynatrace dashboard that updates while the test is running. This version also adds extended test scenarios covering more dtpay endpoints, producing a richer distributed trace topology.

**Events published in this version:**

| Event | When | Key Fields |
|---|---|---|
| `com.jmeter.test.start` | Before test (setUp group) | test name, target URL, thread count, duration |
| `com.jmeter.test.stats` | Every 30 s during test | rolling avg/min/max latency, error count, throughput |
| `com.jmeter.test.summary` | After test (tearDown group) | final avg/min/max latency, error %, throughput, total requests |

---

## Step 1 — Stop Any Running Test

```bash
stopJmeterTest
```

---

## Step 2 — Run the v2.0 Test

```bash
runJmeterTest v2.0 paste-your-codespaces-url-generated-id-here-80.app.github.dev
```

---

## Step 3 — Verify the Job Started

```bash
kubectl -n jmeter get all
```

---

## Step 4 — Watch the Live BizEvents in Logs

Follow the logs — you will see a BizEvent emitted every 30 seconds during the test:

```bash
kubectl logs -n jmeter -l app=jmeter-tester --follow
```

Watch for repeating log lines like `[stats] BizEvent sent — T+30s`, `[stats] BizEvent sent — T+60s` to confirm live stats are publishing.

![JMeter v2.0 test run](img/jmeter/v2.0-jmeter.png)

---

## Step 5 — Understand What Is New in v2.0

A third thread group — the **Stats Reporter** — runs in parallel with the main load threads. It wakes up every 30 seconds, collects rolling statistics from all active samplers, and POSTs a `com.jmeter.test.stats` BizEvent to Dynatrace.

The interval is configurable via `STATS_INTERVAL_SEC` (default: `30`).

The extended test plan also adds additional request scenarios (balance check, transaction history) to cover a broader set of dtpay endpoints, producing a richer service-map topology in Dynatrace.

---

## Step 6 — Query Live Stats in Dynatrace While the Test Runs

!!! example "Step-by-step"

    1. In Dynatrace, navigate to **Notebooks → New Notebook → Add DQL section**
    2. Run the following query **while the test is still running**:

    ```dql
    fetch bizevents
    | filter event.type == "com.jmeter.test.stats.live"
    | sort timestamp desc
    | limit 20
    ```

    3. Click **Run** every 30 seconds — you should see new rows appearing in real time as the test progresses

---

## Step 7 — Explore the Extended Service Map

JMeter v2.0 exercises additional dtpay endpoints, producing a richer service graph:

- Navigate to **Services → dtpay services → Service flow** to see the expanded topology compared to v1.x
- The extended test plan runs for **~10 minutes** with **50 concurrent users**

---

## Step 8 — Build a Real-Time Dashboard

!!! example "Step-by-step"

    1. Download: [JMeter Perf Test Report-v2.0](dashboard/JMeter-Performance-Test-Report-v2.0.json)
    2. In Dynatrace, navigate to **Dashboards → Upload**
    3. Set **auto-refresh** to every **1 minute**
    4. Watch the dashboard update live as JMeter publishes rolling stats

    ![Dynatrace live dashboard for v2.0](img/jmeter/v2.0-dt-dashboard.png)

---

## Step 9 — Compare Multiple Test Runs

Use DQL to compare performance summaries across runs — useful for tracking regressions across releases or config changes:

```dql
fetch bizevents
| filter event.type == "com.jmeter.test.summary"
| sort timestamp desc
| fields timestamp, test.name, avg.latency.ms, error.rate.pct, throughput.rps
```

!!! example "Step-by-step"

    1. Download: [JMeter Perf Test Report-v2.1](dashboard/JMeter-Performance-Test-Report-v2.1.json)
    2. Upload as a **New Dashboard** with 1-minute auto-refresh
    3. Run the test several times and observe how each run's summary appears as a new row

    ![Dynatrace cross-run comparison dashboard](img/jmeter/v2.0-dt-dashboard-compare.png)

---

## Reference — Configuration Variables

| Variable | Default | Description |
|---|---|---|
| `JVM_THREADS` | `50` | Concurrent virtual users |
| `JVM_LOOPS` | `-1` | Iterations per thread (`-1` = run for full duration) |
| `JVM_DURATION` | `600` | Test duration in seconds |
| `JVM_APP_URL` | `dtpay.127.0.0.1.sslip.io` | Target domain — bare hostname, no protocol or port |
| `JVM_DT_URL` | *(required)* | Dynatrace environment URL |
| `JVM_DT_TOKEN` | *(required)* | DT API token with `bizevents.ingest` scope |
| `STATS_INTERVAL_SEC` | `30` | How often v2.0 publishes a live stats BizEvent |

`JVM_DT_URL` and `JVM_DT_TOKEN` are read from the `dynatrace-creds` Kubernetes Secret in the `jmeter` namespace — created automatically by `runJmeterTest` from `DT_ENVIRONMENT` and `DT_OPERATOR_TOKEN`.

---

## Reference — All DQL Queries

**Watch live stats in real time (run while test is active):**
```dql
fetch bizevents
| filter event.type == "com.jmeter.test.stats"
| sort timestamp desc
| limit 20
```

**Full event history for a single run:**
```dql
fetch bizevents
| filter event.type in ("com.jmeter.test.start", "com.jmeter.test.stats", "com.jmeter.test.summary")
| sort timestamp asc
```

**Compare test run summaries:**
```dql
fetch bizevents
| filter event.type == "com.jmeter.test.summary"
| sort timestamp desc
| fields timestamp, test.name, avg.latency.ms, error.rate.pct, throughput.rps
```

---

## What You Accomplished

Across all four JMeter versions in this workshop you progressed from zero instrumentation to production-grade observability:

| Version | Capability Unlocked |
|---|---|
| v1.0 | Distributed traces in DT APM — no config required |
| v1.2 | Test traffic isolation via `x-dynatrace-test` header |
| v1.3 | BizEvent test summaries queryable in DQL |
| v2.0 | Real-time rolling stats + richer service topology |

<div class="grid cards" markdown>
- [Continue to Cleanup :octicons-arrow-right-24:](cleanup.md)
</div>
