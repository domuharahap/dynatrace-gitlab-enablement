--8<-- "snippets/dt-enablement.md"

# dtpay — Payment Observability Workshop

!!! example ""
    ![Workshop Banner](img/framework_banner.png){ align=center }

## About this Workshop

This hands-on workshop demonstrates how to use **Apache JMeter** and **Dynatrace** together to observe, analyze, and automate performance testing of the **dtpay** payment application — a Kubernetes-native Spring Boot + React demo app.

You will progressively add deeper Dynatrace integration across four JMeter versions, from basic APM traces all the way to real-time Business Event streaming during a live load test.

!!! info "Source Repository"
    [:material-github: github.com/domuharahap/dynatrace-jmeter-enablement](https://github.com/domuharahap/dynatrace-jmeter-enablement)

---

## What You'll Learn

By the end of this workshop you will be able to:

- [x] Deploy **dtpay**, a Kubernetes-native payment demo app, and explore its architecture
- [x] Run **JMeter load tests** as Kubernetes Jobs with zero local setup
- [x] View distributed traces and APM data for load-test traffic in **Dynatrace**
- [x] Tag load-test traffic with `x-dynatrace-test` headers to **isolate test vs. real-user traffic**
- [x] Publish **BizEvents** at test start and end with full performance summary stats
- [x] Stream **live incremental BizEvents** every 30 seconds for a real-time Dynatrace dashboard

---

## JMeter Versions at a Glance

| Version | Image | What's New |
|---|---|---|
| `v1.0` | `domuharahap/jmeter-tester:v1.0` | Basic load — results in DT APM traces |
| `v1.2` | `domuharahap/jmeter-tester:v1.2` | Adds `x-dynatrace-test` header for test marking |
| `v1.3` | `domuharahap/jmeter-tester:v1.3` | BizEvents at test start and end with summary stats |
| `v2.0` | `domuharahap/jmeter-tester:v2.0` | v1.3 + live stats BizEvent every 30 s & extended scenarios |

---

## Workshop Structure

| Section | Content |
|---|---|
| [Getting Started](getting-started.md) | Prerequisites, Codespace launch, port visibility, deploy dtpay |
| [dtpay — Payment App](dtpay.md) | Architecture, Kubernetes resources, nginx proxy config |
| [Part 1 — Basic APM Traces](jmeter-v1.0.md) | JMeter v1.0: baseline load test, DT distributed traces |
| [Part 2 — Test Marking](jmeter-v1.2.md) | JMeter v1.2: `x-dynatrace-test` header, Request Attributes |
| [Part 3 — BizEvents](jmeter-v1.3.md) | JMeter v1.3: test start & summary BizEvents, DQL |
| [Part 4 — Live Stats](jmeter-v2.0.md) | JMeter v2.0: rolling stats every 30 s, real-time dashboard |
| [Cleanup](cleanup.md) | Stop tests and remove workshop resources |
| [Resources](resources.md) | Reference links and further reading |

<div class="grid cards" markdown>
- [Let's get started :octicons-arrow-right-24:](getting-started.md)
</div>
