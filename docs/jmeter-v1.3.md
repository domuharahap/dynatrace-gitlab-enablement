--8<-- "snippets/dt-enablement.md"

# Part 3 — BizEvents: Start & End

## Use Case

Publish Dynatrace **Business Events** at the start and end of every test run. The `com.jmeter.test.summary` event captures avg/min/max latency, error rate, and throughput — all queryable in DQL. Use this to compare performance across releases or configuration changes without needing a separate reporting tool.

**Events published in this version:**

| Event | When | Key Fields |
|---|---|---|
| `com.jmeter.test.start` | Before test (setUp group) | test name, target URL, thread count, duration |
| `com.jmeter.test.summary` | After test (tearDown group) | avg/min/max latency, error %, throughput, total requests |

---

## Step 1 — Stop Any Running Test

```bash
stopJmeterTest
```

---

## Step 2 — Run the v1.3 Test

```bash
runJmeterTest v1.3 paste-your-codespaces-url-generated-id-here-80.app.github.dev
```

---

## Step 3 — Verify the Job Started

```bash
kubectl -n jmeter get all
```

---

## Step 4 — Watch the JMeter Logs

Follow the logs and look for the BizEvent sent at test start, then wait for the summary event when the test finishes:

```bash
kubectl logs -n jmeter -l app=jmeter-tester --follow
```

You should see log lines confirming `com.jmeter.test.start` was published at the beginning and `com.jmeter.test.summary` at the end.

![JMeter v1.3 test run](img/jmeter/v1.3-jmeter.png)

---

## Step 5 — Understand What Is New in v1.3

Two **Groovy scripts** are added to the JMeter plan:

- **setUp Thread Group** — executes before any load begins; builds a JSON payload and POSTs a `com.jmeter.test.start` event to the Dynatrace BizEvents ingest API
- **tearDown Thread Group** — executes after all threads finish; collects computed statistics from all samplers and POSTs a `com.jmeter.test.summary` event

Both scripts read `DT_URL` and `DT_TOKEN` from the `dynatrace-creds` Kubernetes secret created automatically by the framework.

---

## Step 6 — Query BizEvents in Dynatrace Notebooks

!!! example "Step-by-step"

    1. In Dynatrace, navigate to **Notebooks → New Notebook → Add DQL section**
    2. Run the following query to see the test start and summary events:

    ```dql
    fetch bizevents
    | filter event.type == "com.jmeter.test.start" or event.type == "com.jmeter.test.summary"
    | sort timestamp desc
    | limit 20
    ```

    3. You should see one `start` event and one `summary` event per completed test run

---

## Step 7 — Import the BizEvents Dashboard

!!! example "Step-by-step"

    1. Download: [JMeter Perf Test Report-v1.3](dashboard/Jmeter-Performance-Test-Report-v1.3.json)
    2. In Dynatrace, navigate to **Dashboards → Upload**
    3. Upload the JSON file to visualize the `start` and `summary` events

    ![Dynatrace dashboard for v1.3](img/jmeter/v1.3-dt-dashboard.png)

---

## What You Observed

With BizEvents at test boundaries you can now:

- Query test summaries in DQL at any time — hours or days after the test ran
- Compare `avg.latency.ms` and `error.rate.pct` across multiple test runs
- Correlate test start/end with deployment events or config changes in the same timeline

!!! tip "DQL — compare test run summaries"
    ```dql
    fetch bizevents
    | filter event.type == "com.jmeter.test.summary"
    | sort timestamp desc
    | fields timestamp, test.name, avg.latency.ms, error.rate.pct, throughput.rps
    ```

!!! tip "Ready for the next step?"
    In Part 4 you will stream incremental stats **every 30 seconds** during the test — enabling a live Dynatrace dashboard that updates in real time.

<div class="grid cards" markdown>
- [Continue to Part 4 — Live Stats :octicons-arrow-right-24:](jmeter-v2.0.md)
</div>
