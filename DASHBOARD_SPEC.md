# Valence Studio — Ultra-Detailed Professional Dashboard Specification

> **Purpose:** This document describes every single thing about the redesigned Valence Studio dashboard — every pixel, every CSS rule, every JS function, every API call, every animation, every interaction, every state. Nothing is left ambiguous.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [File Structure](#3-file-structure)
4. [Design System](#4-design-system)
5. [Application Shell Layout](#5-application-shell-layout)
6. [Topbar Component](#6-topbar-component)
7. [Sidebar Component](#7-sidebar-component)
8. [Bottom Terminal Strip](#8-bottom-terminal-strip)
9. [Tab: Overview](#9-tab-overview)
10. [Tab: Keyspace](#10-tab-keyspace)
11. [Tab: Cluster](#11-tab-cluster)
12. [Tab: Timing Wheel](#12-tab-timing-wheel)
13. [Tab: Console](#13-tab-console)
14. [JavaScript Architecture](#14-javascript-architecture)
15. [API Reference](#15-api-reference)
16. [Animation & Interaction Spec](#16-animation--interaction-spec)
17. [Responsive Behaviour](#17-responsive-behaviour)
18. [Accessibility](#18-accessibility)
19. [Performance Rules](#19-performance-rules)

---

## 1. Project Overview

**What is Valence Studio?**
A browser-based control plane for the Valence in-memory database engine — a 12-core, thread-per-core, lock-free, sub-microsecond key-value store with a hierarchical O(1) Timing Wheel for key expiration.

**Goal of this redesign:**
Replace the current basic HTML dashboard with an elite, enterprise-grade control plane that feels like Grafana + Linear + PlanetScale had a baby — dark, dense, purposeful, and fully real-time.

**Single-file constraint:**
The entire frontend lives in `valence_dashboard/public/index.html`. No bundler. No framework. No build step. Loads in under 200ms.

**What the dashboard does:**
- Shows live throughput, latency, and key stats from the Valence engine
- Lets operators browse, inspect, create, and delete keys
- Visualises the 12-shard hardware cluster topology
- Renders the Timing Wheel with real active TTL keys as glowing dots
- Provides a full RESP3 CLI and live server log — always on screen

---

## 2. Tech Stack

### Frontend

| Technology | Version / Source | Role |
|---|---|---|
| HTML5 | Native | Semantic structure, `<header>`, `<aside>`, `<main>`, `<dialog>` |
| CSS3 | Native | Custom Properties (design tokens), Grid, Flexbox, `@keyframes`, `backdrop-filter` |
| JavaScript | ES2024 (native, no transpile) | All logic — routing, data fetching, DOM updates, animations |
| Inter | Google Fonts CDN | UI font — labels, values, buttons |
| JetBrains Mono | Google Fonts CDN | Monospace font — CLI, timestamps, key names, hashes |
| Canvas 2D API | Native browser | Throughput chart, distribution bar chart |
| SVG | Inline in HTML | Timing Wheel clock face |
| Server-Sent Events | Native browser `EventSource` | Live telemetry push from `/api/telemetry/stream` |
| `fetch()` API | Native browser | All REST calls to the Express server |

### Backend (existing — no changes)

| Technology | Role |
|---|---|
| Node.js 24 (native `http` module) | HTTP server on port 8080 |
| `valence-server.exe` | Valence database engine on port 6379 |
| Raw TCP + RESP3 protocol | Node server talks to Valence engine |
| Murmur3-32 (JS implementation) | Hash function for shard routing display |
| Server-Sent Events | `/api/telemetry/stream` pushes live op events |

### No Build Step
- No Webpack, Vite, Rollup, or Parcel
- No React, Vue, Angular, Svelte
- No TypeScript compilation
- No npm dependencies on the frontend
- Everything is plain text that a browser can load directly

---

## 3. File Structure

```
c:/project_placement/
├── valence_dashboard/
│   ├── public/
│   │   └── index.html          ← ENTIRE frontend (HTML + CSS + JS, ~3000 lines)
│   ├── server.js               ← Node HTTP server (port 8080, NO CHANGES NEEDED)
│   └── package.json
├── valence-server.exe           ← Valence DB engine (port 6379, NO CHANGES NEEDED)
└── valence_terminal.py          ← Python CLI helper (untouched)
```

**Everything described below is written into `index.html` only.**

---

## 4. Design System

### 4.1 CSS Custom Properties (Design Tokens)

Every colour, font, size, and shadow is defined once in `:root {}` and never hard-coded elsewhere.

```css
:root {
  /* ── BACKGROUNDS ────────────────────────────────── */
  --bg-void:      #06070a;   /* outermost page background */
  --bg-base:      #080910;   /* topbar, sidebar background */
  --bg-surface:   #0d0f1b;   /* panel/card outer shell */
  --bg-card:      #111623;   /* inner card background */
  --bg-elevated:  #181e30;   /* hover state, raised elements */
  --bg-input:     #0a0c15;   /* text input fields */

  /* ── BRAND / PRIMARY ────────────────────────────── */
  --green:        #00ff9d;   /* Valence primary green */
  --green-mid:    #00e5a0;   /* slightly softer green */
  --green-dim:    rgba(0,255,157,0.08);   /* green tinted bg */
  --green-glow:   rgba(0,255,157,0.22);   /* green glow shadow */
  --green-border: rgba(0,255,157,0.30);   /* green border */

  /* ── SEMANTIC COLOURS ───────────────────────────── */
  --cyan:         #00d4ff;   /* info, routing, shard labels */
  --cyan-dim:     rgba(0,212,255,0.08);
  --cyan-glow:    rgba(0,212,255,0.20);
  --amber:        #f5a624;   /* warning, TTL near expiry (< 30s) */
  --amber-dim:    rgba(245,166,36,0.10);
  --red:          #ff4060;   /* error, delete actions, expired keys */
  --red-dim:      rgba(255,64,96,0.10);
  --red-border:   rgba(255,64,96,0.30);
  --purple:       #a78bfa;   /* memory arenas, Tier 2 */
  --purple-dim:   rgba(167,139,250,0.10);

  /* ── TEXT ───────────────────────────────────────── */
  --text-hi:      #f1f3fb;   /* primary — headings, big numbers */
  --text-mid:     #8892b0;   /* secondary — labels, descriptions */
  --text-lo:      #4a5280;   /* muted — placeholders, hints */
  --text-dim:     #2a3050;   /* very muted — dividers, empty states */

  /* ── BORDERS ────────────────────────────────────── */
  --border-lo:    rgba(255,255,255,0.05);
  --border-mid:   rgba(255,255,255,0.09);
  --border-hi:    rgba(255,255,255,0.14);

  /* ── GRADIENTS ──────────────────────────────────── */
  --grad-brand:   linear-gradient(135deg, #00ff9d 0%, #00d4ff 100%);
  --grad-green:   linear-gradient(180deg, #00ff9d 0%, rgba(0,255,157,0.2) 100%);
  --grad-core:    linear-gradient(90deg, #00ff9d 0%, #00d4ff 100%);

  /* ── TYPOGRAPHY ─────────────────────────────────── */
  --font-sans:    'Inter', -apple-system, system-ui, sans-serif;
  --font-mono:    'JetBrains Mono', 'Cascadia Code', 'Fira Code', monospace;

  /* ── SIZING ─────────────────────────────────────── */
  --topbar-h:     48px;
  --sidebar-w:    224px;
  --bottom-h:     220px;
  --radius-panel: 10px;
  --radius-card:  8px;
  --radius-input: 7px;
  --radius-badge: 4px;
  --gap:          16px;
}
```

### 4.2 Typography Scale

| Name | Font | Weight | Size | Usage |
|---|---|---|---|---|
| `display` | Inter | 800 | 30px | KPI big numbers (1,250,480) |
| `display-unit` | Inter | 500 | 13px | KPI units (ops/sec) |
| `title` | Inter | 700 | 14px | Panel headings |
| `label` | Inter | 700 | 10px | ALL CAPS section labels |
| `body` | Inter | 400 | 13px | General prose text |
| `body-sm` | Inter | 400 | 12px | Table cells, descriptions |
| `mono-lg` | JetBrains Mono | 700 | 13px | Key names, CLI prompt |
| `mono-md` | JetBrains Mono | 500 | 12px | CLI output, values |
| `mono-sm` | JetBrains Mono | 400 | 11px | Timestamps, hashes |
| `mono-xs` | JetBrains Mono | 400 | 10px | Shard IDs, badges |

### 4.3 Spacing System

```
2px   — inline icon gap
4px   — tight element gap (badge padding)
8px   — compact gap (core grid)
12px  — default padding within cards
16px  — standard gap between panels (--gap)
20px  — content area padding
24px  — section separation
```

### 4.4 Shadow / Glow System

```css
/* Panel outer shadow */
box-shadow: 0 1px 3px rgba(0,0,0,0.5), 0 0 0 1px var(--border-lo);

/* Green glow on active elements */
box-shadow: 0 0 12px var(--green-glow), 0 0 4px var(--green-glow);

/* Brand logo glow */
box-shadow: 0 0 20px var(--green-glow), 0 0 6px var(--green-glow);

/* Inset sidebar active pill */
box-shadow: inset 3px 0 0 var(--green);

/* Input focus ring */
box-shadow: 0 0 0 2px var(--green-dim);
```

### 4.5 Component States

Every interactive element has 4 states:

| State | Treatment |
|---|---|
| Default | Base background, `--border-lo` border |
| Hover | `--bg-elevated` bg, `--border-mid` border, `translateY(-1px)` |
| Active/Selected | `--green-dim` bg, `--green-border` border, left green bar |
| Disabled | `opacity: 0.4`, `cursor: not-allowed` |

---

## 5. Application Shell Layout

### 5.1 HTML Structure

```html
<body>
  <header class="topbar">...</header>

  <div class="app-shell">
    <aside class="sidebar">...</aside>

    <div class="workspace">
      <main class="content-area" id="content-area">
        <!-- Tab views injected here -->
        <div class="tab-view" id="view-overview">...</div>
        <div class="tab-view" id="view-keyspace">...</div>
        <div class="tab-view" id="view-cluster">...</div>
        <div class="tab-view" id="view-timing-wheel">...</div>
        <div class="tab-view" id="view-console">...</div>
      </main>

      <div class="bottom-strip">
        <div class="strip-pane" id="server-log-pane">...</div>
        <div class="strip-pane" id="cli-pane">...</div>
      </div>
    </div>
  </div>
</body>
```

### 5.2 CSS Grid Layout

```css
body {
  display: grid;
  grid-template-rows: var(--topbar-h) 1fr;
  height: 100vh;
  overflow: hidden;
}

.app-shell {
  display: grid;
  grid-template-columns: var(--sidebar-w) 1fr;
  overflow: hidden;
}

.workspace {
  display: grid;
  grid-template-rows: 1fr var(--bottom-h);
  overflow: hidden;
}

.content-area {
  overflow-y: auto;
  padding: 20px;
}
```

### 5.3 Scrollbar Styling

```css
* { scrollbar-width: thin; scrollbar-color: var(--green-border) transparent; }
::-webkit-scrollbar { width: 4px; height: 4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: var(--green-border); border-radius: 99px; }
::-webkit-scrollbar-thumb:hover { background: var(--green); }
```

---

## 6. Topbar Component

### 6.1 Visual Layout

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│ [V] VALENCE  STUDIO │● ONLINE 127.0.0.1:6379│⊞ CPU SHARDS 12│⊟ ACTIVE KEYS 47 │
│                     │≡ RSS MEMORY 4.2 MB    │⏱ UPTIME 00:12:43│         ● Connected│
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Elements

**Brand Block (left):**
- `div.brand-logo` — 30×30px, `background: var(--grad-brand)`, `border-radius: 7px`, letter "V" in `Inter 900 14px #000`, `box-shadow: 0 0 20px var(--green-glow)`
- `span.brand-name` — "VALENCE" in `Inter 800 15px #fff letter-spacing: 1.8px`
- `span.brand-tag` — "STUDIO" in `Inter 700 9px var(--text-mid)`, pill badge with `--bg-elevated` bg

**Divider:** 1px vertical line `rgba(255,255,255,0.08)` height 22px

**Status Pills (centre, flex row with gap 24px):**

Each pill has: small icon SVG + label text + value text

| ID | Icon | Label | Value | Value Colour |
|---|---|---|---|---|
| `#top-status` | circle dot | (none) | ONLINE / OFFLINE | `--green` / `--red` |
| `#top-addr` | (none) | (none) | 127.0.0.1:6379 | `--text-mid` |
| `#top-shards` | grid icon | CPU SHARDS | 12 | `--text-hi` |
| `#top-keys` | key icon | ACTIVE KEYS | live | `--green` |
| `#top-mem` | db icon | RSS MEMORY | X.X MB | `--cyan` |
| `#top-uptime` | clock icon | UPTIME | HH:MM:SS | `--text-hi` |

**Right block:**
- Breathing dot `--green` + "Connected" text
- Updates to `--red` dot + "Disconnected" if engine offline

### 6.3 Bottom Glow Line

```css
.topbar::after {
  content: '';
  position: absolute;
  bottom: 0; left: 0; right: 0; height: 1px;
  background: linear-gradient(90deg, transparent 0%, var(--green-glow) 50%, transparent 100%);
}
```

### 6.4 Uptime Counter

JavaScript `setInterval` every 1 second increments a counter and formats as `HH:MM:SS`. On first poll, seeds from `/api/system/info` `uptimeSeconds` field.

---

## 7. Sidebar Component

### 7.1 Visual Layout

```
┌─────────────────────┐
│ NAVIGATION          │  ← section label
│                     │
│  ◉ Overview         │  ← active (green left bar + dim bg)
│    Keyspace         │
│    Cluster          │
│    Timing Wheel     │
│    Console          │
│                     │
│ SYSTEM              │  ← section label
│    Docs & Help      │
│                     │
│ ─────────────────── │
│ v0.1.0 · thread-per │  ← version footer
└─────────────────────┘
```

### 7.2 CSS

```css
.sidebar {
  background: var(--bg-base);
  border-right: 1px solid var(--border-lo);
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
}

/* Right edge gradient glow */
.sidebar::after {
  content: '';
  position: absolute; top: 0; right: 0; bottom: 0; width: 1px;
  background: linear-gradient(180deg, transparent 0%, var(--green-glow) 50%, transparent 100%);
  opacity: 0.4;
}
```

### 7.3 Nav Button States

```css
.nav-btn {
  display: flex; align-items: center; gap: 10px;
  height: 40px; padding: 0 12px;
  border-radius: var(--radius-card);
  color: var(--text-mid);
  font-size: 13px; font-weight: 500;
  cursor: pointer;
  transition: all 150ms ease;
  position: relative;
}

.nav-btn:hover {
  background: var(--bg-elevated);
  color: var(--text-hi);
}

.nav-btn.active {
  background: var(--green-dim);
  color: var(--green);
  font-weight: 600;
}

/* Left glow bar on active */
.nav-btn.active::before {
  content: '';
  position: absolute; left: 0;
  top: 50%; transform: translateY(-50%);
  width: 3px; height: 22px;
  background: var(--green);
  border-radius: 0 3px 3px 0;
  box-shadow: 0 0 10px var(--green-glow);
}
```

### 7.4 Nav Items

Each nav button has:
- A 16px SVG icon (from Lucide sprite or inline SVG path)
- A text label
- An `id` for JS targeting: `#nav-overview`, `#nav-keyspace`, etc.
- `onclick="navigateTo('overview')"` handler

### 7.5 Section Labels

```css
.sidebar-section-label {
  font: 700 9.5px/1 var(--font-sans);
  letter-spacing: 1.4px;
  text-transform: uppercase;
  color: var(--text-dim);
  padding: 20px 16px 6px;
}
```

### 7.6 Footer

Version string `v0.1.0 · Thread-Per-Core` in `mono-xs` style, `color: var(--text-dim)`.

---

## 8. Bottom Terminal Strip

The most important UX element — always visible across every tab. Split 50/50 horizontally.

### 8.1 Layout

```css
.bottom-strip {
  height: var(--bottom-h);       /* 220px */
  display: grid;
  grid-template-columns: 1fr 1fr;
  border-top: 1px solid var(--border-lo);
  background: var(--bg-base);
  flex-shrink: 0;
}

.strip-pane {
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* Vertical divider between panes */
.strip-pane:first-child {
  border-right: 1px solid var(--border-lo);
}
```

### 8.2 Left Pane — Server Log

**Header bar (36px):**
```
SERVER LOG — 127.0.0.1:6379   ● LIVE   [PAUSE]  [CLEAR]
```
- Title: `mono-sm` `var(--text-mid)`
- `● LIVE` — breathing green dot + text
- `[PAUSE]` button — toggles SSE pausing (when paused: turns amber, shows "● PAUSED")
- `[CLEAR]` button — clears the log DOM

**Log body:**
- `overflow-y: auto`, `flex: 1`
- Background: `#040508` (near-black)
- Padding: `8px 12px`
- Each log line is a `<div class="log-line">`

**Log line format:**
```
[HH:MM:SS]  [SHARD 04]  SET cart:session_101 → OK (0.21μs)
```

**Log line colour coding:**

| Tag | Colour | Example |
|---|---|---|
| `[VALENCE]` | `var(--text-hi)` | Engine startup messages |
| `[SHARD XX]` | `var(--green)` | Key operations |
| `[WHEEL]` | `var(--cyan)` | Timing wheel events |
| `[BENCH]` | `var(--amber)` | Benchmark output |
| `[EXPIRE]` | `var(--red)` | Key expiry events |
| `[ERROR]` | `var(--red)` | Errors |

**Log line CSS:**
```css
.log-line {
  font: 400 11px/1.7 var(--font-mono);
  white-space: pre;
  padding: 1px 0;
  display: flex;
  gap: 10px;
  align-items: baseline;
}
.log-line .ts   { color: var(--text-dim); }
.log-line .tag  { font-weight: 700; min-width: 80px; }
.log-line .body { color: var(--text-mid); }
```

**Behaviour:**
- New lines inserted at bottom, auto-scroll to bottom
- Max 200 lines retained in DOM (older removed)
- PAUSE button stops appending new lines (buffers internally, resumes on un-pause)

### 8.3 Right Pane — RESP3 CLI

**Header bar (36px):**
```
RESP3 CLI — valence:6379     [42 commands]     [CLEAR]
```
- `[42 commands]` badge updates live per command executed

**Output area:**
- Same dark background as log
- Each command line: `<div class="cli-cmd">valence:6379> COMMAND</div>` in white bold
- Each response: `<div class="cli-res">→ result text</div>` in green, indented 14px
- Errors: `<div class="cli-err">→ ERR: message</div>` in red

**Input row (36px):**
```css
.cli-input-row {
  height: 36px;
  background: #07080d;
  border-top: 1px solid var(--border-lo);
  border-left: 3px solid var(--green);
  display: flex; align-items: center;
  padding: 0 12px; gap: 8px;
}
.cli-prompt  { color: var(--green); font: 700 12px var(--font-mono); }
.cli-input   { flex: 1; background: transparent; border: none; outline: none;
               color: #fff; font: 500 12px var(--font-mono); caret-color: var(--green); }
```

**Input behaviour:**
- `Enter` → send command via `POST /api/exec`
- `ArrowUp` / `ArrowDown` → cycle command history array
- `Tab` → autocomplete from command list: `SET GET DEL KEYS TTL SHARDS BENCH WHEEL INFO CLUSTER.SHARDS`
- Blocked commands: `FLUSHALL`, `FLUSHDB`, `SHUTDOWN`, `DEBUG SLEEP` — print a red warning instead
- Command counter increments on each `Enter`

---

## 9. Tab: Overview

### 9.1 KPI Cards Row

Four equal-width cards in a CSS grid `grid-template-columns: repeat(4, 1fr)`, gap `--gap`.

**Card anatomy:**
```css
.kpi-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-lo);
  border-radius: var(--radius-panel);
  padding: 18px 20px;
  position: relative;
  overflow: hidden;
  transition: border-color 200ms;
}
.kpi-card:hover { border-color: var(--border-hi); }

/* Left colour stripe */
.kpi-card::before {
  content: '';
  position: absolute; left: 0; top: 0; bottom: 0; width: 3px;
}
```

**Four KPI Cards:**

| # | Title | Value ID | Unit | Stripe Color | Value Source |
|---|---|---|---|---|---|
| 1 | PEAK THROUGHPUT | `#kpi-throughput` | ops/sec across 12 cores | `--green` | `measuredPeakThroughput` from BENCH |
| 2 | AVERAGE LATENCY | `#kpi-latency` | sub-μs TCP response | `--cyan` | rolling avg from telemetry stream |
| 3 | ACTIVE KEYS | `#kpi-keys` | keys in DRAM across all shards | `--amber` | `/api/system/info` `totalKeys` |
| 4 | UPTIME | `#kpi-uptime` | HH:MM:SS | `--purple` | local counter seeded from info API |

**Count-up animation on load:**
- All 4 numbers animate from 0 to their value over 1.2 seconds using `requestAnimationFrame`
- Easing: `easeOutExpo`

### 9.2 Middle Row — Core Grid + Live Feed

Two-column layout: `grid-template-columns: 55% 45%`, gap `--gap`

#### 9.2.1 Thread-Per-Core Activity Grid

**Panel header:**
```
THREAD-PER-CORE ACTIVITY (12 CORES)
```

**Grid:** `display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(3, auto); gap: 8px`

**Core Cell (one per CPU core, 12 total):**
```
┌─────────────────────────────┐
│ C00                     12% │
│ ████████░░░░░░░░░░░░░░░░░░ │
│ 12,420 ops                  │
└─────────────────────────────┘
```

```css
.core-cell {
  background: var(--bg-card);
  border: 1px solid var(--border-lo);
  border-radius: var(--radius-card);
  padding: 9px 11px;
  display: flex; flex-direction: column; gap: 5px;
  transition: background 250ms, border-color 200ms, transform 150ms;
}

/* Pulse state — triggered on op received */
.core-cell.pulsing {
  background: var(--green-dim);
  border-color: var(--green-border);
  transform: scale(1.015);
}
```

**Core cell internals:**
- `span.core-id` — "C00" in `mono-xs 700 var(--text-mid)`
- `span.core-pct` — "12%" in `mono-xs var(--text-lo)`, right-aligned
- `div.core-bar-track` — `height: 3px; background: var(--bg-elevated); border-radius: 2px`
  - `div.core-bar-fill` — `background: var(--grad-core); width: X%; transition: width 400ms ease`
- `span.core-ops` — "12,420 ops" in `mono-xs var(--text-dim)`

**Data source:** SSE telemetry stream. Each event has `core` field → extracts core index → pulses that cell, increments `coreOpsCounters[index]`, updates bar width using `corePercentages[index]`.

**Percentages:** Simulated values, modulated randomly ±3% each second for a live feel. Real data when BENCH runs.

#### 9.2.2 Live Operations Feed

**Panel header:**
```
LIVE OPERATIONS FEED                      Last 20 operations
```

**Feed body:** `overflow-y: auto; max-height: 240px; background: #040508;`

**Each row:**
```
[12:43:12]  [C04]  [0.21μs]  SET  cart:session_101  →  OK
```

```css
.feed-row {
  display: grid;
  grid-template-columns: 68px 38px 58px 40px 1fr 50px;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  border-bottom: 1px solid rgba(255,255,255,0.025);
  font: 400 11px var(--font-mono);
  animation: feedSlideIn 120ms ease forwards;
}
.feed-row:hover { background: var(--bg-elevated); }

.feed-ts   { color: var(--text-dim); }
.feed-core { color: var(--green); font-weight: 700; }
.feed-lat  { color: var(--cyan); }
.feed-cmd  { color: var(--amber); font-weight: 700; }
.feed-key  { color: var(--text-hi); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.feed-res  { color: #4ade80; text-align: right; }
.feed-res.err { color: var(--red); }

@keyframes feedSlideIn {
  from { opacity: 0; transform: translateY(-4px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

**Behaviour:**
- New row inserted at **top** of list
- Old rows beyond 20 removed from bottom
- Data from SSE telemetry stream

### 9.3 Throughput Chart — Last 60 Seconds

**Panel header:**
```
THROUGHPUT — LAST 60 SECONDS (ops/sec)
```

**Chart:** HTML5 `<canvas>` element, rendered with 2D Canvas API.

**Canvas dimensions:** full panel width × 90px height

**What's drawn:**
- Y-axis: two labels `1.25M` (top) and `0` (bottom) in `mono-xs var(--text-dim)`
- 60 bars, each 1 second of throughput data, spaced evenly
- Bar colour: gradient fill from `#00ff9d` at top to `rgba(0,255,157,0.25)` at bottom
- Rounded tops: `border-radius` simulated with `arc()` calls
- Newest bar at the right edge

**Data:**
- `throughputHistory` — a circular buffer array of 60 numbers (ops/sec)
- Every second: shift array left by 1, push new value from SSE stream (or simulated)
- `redrawThroughputChart()` called every second

**Auto-scale:**
- Y-axis max = `Math.max(...throughputHistory) * 1.1`, rounded to nearest 250k
- Label updates to match (`1.25M`, `750K`, etc.)

---

## 10. Tab: Keyspace

### 10.1 Layout

```css
.view-keyspace {
  display: grid;
  grid-template-columns: 1fr 310px;
  gap: var(--gap);
  height: 100%;
}
```

Left: table area. Right: detail drawer (always visible, shows placeholder when no key selected).

### 10.2 Toolbar

```
[🔍 Search keys...]  [All Types ▼]  [+ SET KEY]  [↺ REFRESH]
```

- Search input: `dark-input` class, `oninput` debounced 300ms → calls `fetchKeys()`
- Type dropdown: options `All Types | string | ttl-active | expired`
- `[+ SET KEY]` — toggles inline set form below toolbar
- `[↺ REFRESH]` — re-calls `fetchKeys()`

### 10.3 Inline SET Key Form

Hidden by default, shown by toggle. Slides down with `max-height` animation.

```
[Key Name: ___________] [Value: _______________] [EX (s): ___] [Save] [Cancel]
```

On Save: calls `POST /api/exec` with `SET key "value" EX ttl`, re-fetches table, hides form.

Validation: key and value must be non-empty. Shows inline red error message if invalid.

### 10.4 Key Table

```css
.key-table {
  width: 100%;
  border-collapse: collapse;
  font: 400 12px var(--font-mono);
}

.key-table th {
  background: rgba(255,255,255,0.02);
  color: var(--text-lo);
  text-align: left;
  padding: 9px 14px;
  border-bottom: 1px solid var(--border-mid);
  font: 700 9.5px var(--font-sans);
  letter-spacing: 0.8px;
  text-transform: uppercase;
}

.key-table td {
  padding: 8px 14px;
  border-bottom: 1px solid var(--border-lo);
  color: var(--text-hi);
}

.key-table tr:hover td { background: var(--bg-elevated); cursor: pointer; }
.key-table tr.selected td { background: var(--green-dim); }
.key-table tr.selected td:first-child { box-shadow: inset 3px 0 0 var(--green); }
```

**Columns:**

| Column | Content | Styling |
|---|---|---|
| KEY NAME | key string | `font-weight: 700; color: var(--text-hi)` |
| TYPE | badge pill | `string`=cyan, `expired`=red |
| SIZE | "128 B" / "1.2 KB" | `var(--text-mid)` |
| TTL | countdown or `--` | green > 60s, amber 10–60s, red < 10s, dim if no TTL |
| SHARD | "Shard 04" | `var(--text-lo)` |
| ACTIONS | VIEW · DEL links | VIEW=cyan, DEL=red |

**Type Badge CSS:**
```css
.type-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: var(--radius-badge);
  font: 600 9.5px var(--font-mono);
  text-transform: uppercase;
}
.type-badge.string  { background: var(--cyan-dim);   color: var(--cyan); }
.type-badge.expired { background: var(--red-dim);    color: var(--red);  }
```

**Empty State:**
When no keys exist: centred message "No keys found. Use SET in the console to add keys." in `--text-lo`.

**Pagination:** If > 50 keys, show `[← Prev]  Page 1 of N  [Next →]` controls.

### 10.5 Key Detail Drawer

Always visible (right column). Shows placeholder when nothing selected.

**Placeholder state:**
```
◈ Select a key from the table
  to inspect its value, routing,
  expiration, and metadata.
```

**Selected state:**

```
cart:session_101                          ✕
─────────────────────────────────────────

VALUE
┌──────────────────────────────────────┐
│ {                                    │
│   "userId": "user_1001",             │
│   "items": [...]                     │
│ }                                    │
└──────────────────────────────────────┘

ROUTING
Murmur3 Hash:  0x7f3a2c9e4b1d
Shard:         04  (CPU Core 4)

EXPIRATION
TTL:           14s remaining
Tier:          1 (Seconds wheel)
Slot:          15

METADATA
Size:          128 bytes
Type:          string

                          [DELETE KEY]
```

- Value is in a `<pre class="code-block">` with scrollable overflow, monospace
- Hash displayed in hex
- TTL shown with live countdown (decrements every second via `setInterval`)
- DELETE KEY button: `--red` background on hover, calls `DEL key`, closes drawer, refreshes table

---

## 11. Tab: Cluster

### 11.1 Header Row

```
CLUSTER TOPOLOGY    12 CPU-CORE SHARDS | MURMUR3 HASH ROUTING | LOCK-FREE MEMORY ARENAS
```

Title in `title` style, sub-items in `label` style separated by `|` dividers.

### 11.2 Feature Pills Row (3 cards)

```css
.topology-pills { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--gap); }
```

Each pill:
```
┌──────────────────────────────────────────┐
│  [icon]  12 CORES PINNED                 │
│          One shard per CPU core          │
│          Zero lock contention            │
└──────────────────────────────────────────┘
```

```css
.topo-pill {
  background: var(--bg-surface);
  border: 1px solid var(--border-lo);
  border-radius: var(--radius-panel);
  padding: 16px 18px;
  display: flex; align-items: flex-start; gap: 14px;
}
.topo-pill-icon {
  width: 40px; height: 40px;
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  font-size: 20px; flex-shrink: 0;
}
```

| # | Icon | Title | Subtitle | Icon Background |
|---|---|---|---|---|
| 1 | CPU chip SVG | 12 CORES PINNED | One shard per CPU core. Zero lock contention. | `var(--green-dim)`, icon `var(--green)` |
| 2 | `#` hash SVG | MURMUR3 ROUTING | Consistent key distribution. Even load across all shards. | `var(--cyan-dim)`, icon `var(--cyan)` |
| 3 | lock SVG | LOCK-FREE ARENAS | Thread-local memory pools. No mutexes, no blocking. | `var(--purple-dim)`, icon `var(--purple)` |

### 11.3 Main Area — Shard Grid + Summary

```css
.cluster-main { display: grid; grid-template-columns: 1fr 260px; gap: var(--gap); }
```

#### 11.3.1 Shard Grid (12 cards)

`display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(3, auto); gap: 8px`

**Shard Card:**
```
┌──────────────────────────────────────┐
│ SHARD 00                    ● ACTIVE │
│──────────────────────────────────────│
│ CPU CORE:   0                        │
│ KEYS OWNED: 4                        │
│ MEMORY:     0.38 MB                  │
│ LAST OP:    0.21 μs                  │
│ [▓▓░░░░░░░░░░░░░░░░] 8%             │
└──────────────────────────────────────┘
```

```css
.shard-card {
  background: var(--bg-card);
  border: 1px solid var(--border-lo);
  border-radius: var(--radius-card);
  padding: 12px 14px;
  font: 400 11px var(--font-mono);
  display: flex; flex-direction: column; gap: 4px;
  transition: border-color 200ms, transform 150ms;
}
.shard-card:hover { border-color: var(--green-border); transform: translateY(-2px); }
```

- **Header:** `SHARD XX` in bold white + `● ACTIVE` badge (green dot + green text)
- **Separator:** 1px `--border-lo` line
- **Row label:** `var(--text-lo)` · **Row value:** `var(--text-hi)` bold
- **Mini bar:** 3px height, gradient fill, `width: (keyCount / maxKeyCount * 100)%`
- Shard data comes from `GET /api/keys` (group by shard)

#### 11.3.2 Cluster Summary Panel

```
CLUSTER SUMMARY
───────────────────────────────
Total Shards        12
Total Keys          47
Total Memory        4.2 MB
Avg Keys / Shard    3.9
Hash Algorithm      Murmur3 (32-bit)
Routing Strategy    key_hash % 12
Lock Contention     None
Memory Model        Thread-local arenas

KEY DISTRIBUTION
───────────────────────────────
Min Keys            3
Max Keys            5
Std Deviation       0.6
Distribution        Even ✓
```

Each row: `display: flex; justify-content: space-between;` — label left in `--text-mid`, value right in `--text-hi`.

"Even ✓" value is coloured `--green`. "Std Deviation" value coloured `--cyan`.

### 11.4 Distribution Chart

**Header:** `MURMUR3 HASH DISTRIBUTION ACROSS 12 SHARDS`  
**Sub:** `Total Keys: 47 | Avg: 3.9 per shard` (right-aligned)

**Canvas bar chart:**
- X axis: C00, C01, … C11 labels
- Y axis: 0 to `maxKeys + 2`, with a tick at `avgKeys` (dashed amber line)
- Bars: `var(--green)` fill with gradient, same width/gap as shard grid proportions
- Each bar has a number label above it: the key count
- `redrawDistributionChart()` called on keyspace fetch

---

## 12. Tab: Timing Wheel

### 12.1 Layout

```css
.view-timing-wheel {
  display: flex; flex-direction: column; gap: var(--gap);
}
.tw-main {
  display: grid;
  grid-template-columns: 360px 1fr;
  gap: var(--gap);
}
```

### 12.2 Clock SVG

Full inline SVG, `width: 320px; height: 320px; viewBox="0 0 320 320"`

**SVG Elements (drawn in order, back to front):**

1. **Outer ring background** — `<circle cx="160" cy="160" r="148" fill="#04050a" stroke="var(--border-lo)" stroke-width="1.5"/>`

2. **Inner ring background** — `<circle cx="160" cy="160" r="100" fill="#030408" stroke="var(--border-lo)" stroke-width="1"/>`

3. **Tier 2 label** (between outer & inner edge):
   - `<text>TIER 2 — MINUTES</text>` at radius ~128, centred bottom
   - `<text>(60 slots)</text>` below it

4. **Tier 1 label** (inside inner ring):
   - `<text>TIER 1 — SECONDS</text>` centred
   - `<text>(60 slots)</text>` below

5. **60 outer tick marks** — one per second slot, drawn as short `<line>` elements:
   - Major ticks every 5 slots: length 10px, `stroke: var(--text-mid)`
   - Minor ticks: length 5px, `stroke: var(--text-dim)`
   - Computed: `angle = (i * 6 - 90) * (Math.PI / 180)`
   - Outer radius 148, inner endpoint 138/143

6. **Slot number labels** — every 5 slots (00, 05, 10, …, 55):
   - `<text>` at radius 126
   - Font: `9px JetBrains Mono`
   - Colour: `var(--text-dim)`

7. **60 inner tick marks** (same geometry, inner ring at radius 100/93)

8. **Active TTL key dots** — rendered by `refreshWheelDots()`:
   - Position: `cx = 160 + 124 * cos(angle)`, `cy = 160 + 124 * sin(angle)` (outer ring)
   - `<circle r="5" fill="var(--green)" stroke="#030408" stroke-width="1.5"/>`
   - `filter: drop-shadow(0 0 6px var(--green-glow))`
   - Keys expiring in < 5s: dot blinks via `opacity` animation class `.dot-urgent`

9. **Clock hand** — `<line id="tw-clock-hand" x1="160" y1="160" ...>`
   - `stroke: var(--green); stroke-width: 2.5; stroke-linecap: round`
   - Updated every second: `x2 = 160 + 90 * cos(angle)`, `y2 = 160 + 90 * sin(angle)`
   - angle = `(currentSecond * 6 - 90) * PI / 180`

10. **Centre dot** — `<circle cx="160" cy="160" r="6" fill="var(--green)"/>` with glow filter

**Legend (below SVG):**
```
● Key with TTL      ○ Empty slot
```

**Chips (below legend):**
```
┌────────────────────┬────────────────────┐
│ CURRENT SECOND     │ CURRENT MINUTE     │
│       03 /60       │      21 /60        │
└────────────────────┴────────────────────┘
```

### 12.3 Right Panel — Expiration Queue + Tier Cards

**Active Expiration Queue table:**

| Column | Content |
|---|---|
| KEY NAME | key string |
| TIER | "Tier 1" (green) or "Tier 2" (cyan) |
| SLOT | "Slot 15" (purple) |
| EXPIRES IN | countdown in seconds (red < 5s, amber < 30s, green otherwise) |
| SHARD | "Shard 04" |
| ACTIONS | DEL (red) |

Max height: 180px with `overflow-y: auto`.

**Tier Cards (2 cards, side by side):**

```
┌─────────────────────────────┐  ┌─────────────────────────────┐
│ TIER 1 — SECONDS            │  │ TIER 2 — MINUTES            │
│ 60 slots (0-59)             │  │ 60 slots (0-59)             │
│ For TTL ≤ 60 seconds        │  │ For TTL > 60 seconds        │
│ O(1) insertion & eviction   │  │ Coarse-grained scheduling   │
└─────────────────────────────┘  └─────────────────────────────┘
```

Tier 1: `border-color: var(--green-border); background: var(--green-dim)`
Tier 2: `border-color: var(--cyan-glow); background: var(--cyan-dim)`

### 12.4 O(1) Eviction Info Banner

```
ℹ️  O(1) EVICTION — NO SCANNING
     When the clock hand advances to slot 15, all keys in that bucket
     are dropped instantly in constant time O(1). Redis scans 20 random
     keys repeatedly. Valence evicts the exact right key without scanning
     any other.
```

```css
.info-banner {
  background: var(--bg-surface);
  border: 1px solid var(--border-mid);
  border-left: 3px solid var(--cyan);
  border-radius: var(--radius-panel);
  padding: 14px 18px;
  display: flex; gap: 12px; align-items: flex-start;
  font: 400 12.5px var(--font-sans);
  color: var(--text-mid);
  line-height: 1.6;
}
.info-banner-icon { color: var(--cyan); font-size: 18px; flex-shrink: 0; margin-top: 1px; }
.info-banner strong { color: var(--text-hi); }
```

---

## 13. Tab: Console

### 13.1 Layout

Full height of content area:

```css
.view-console {
  display: flex; flex-direction: column;
  height: calc(100vh - var(--topbar-h) - var(--bottom-h) - 40px);
}
```

### 13.2 Console Header

```
VALENCE CONSOLE  ●  127.0.0.1:6379              [42 commands]  [CLEAR]
```

- Title: `Inter 700 13px` white
- Dot: green breathe animation
- Address: `mono-sm var(--text-mid)`
- `[42 commands]` badge: `--bg-elevated` bg, `--text-mid` text, updates live
- `[CLEAR]` button clears output area

### 13.3 Quick Action Buttons

```
[SHARDS]  [KEYS *]  [INFO]  [WHEEL]  [BENCH 1000]  [HELP]  [CLEAR]
```

```css
.quick-btn {
  background: var(--bg-elevated);
  border: 1px solid var(--border-mid);
  color: var(--text-mid);
  font: 500 10.5px var(--font-mono);
  padding: 4px 10px;
  border-radius: 5px;
  cursor: pointer;
  transition: all 150ms;
}
.quick-btn:hover { border-color: var(--green-border); color: var(--green); background: var(--green-dim); }
```

Clicking any quick button sets the input value to that command and immediately executes it.

### 13.4 Output Stream

```css
.console-output {
  flex: 1;
  overflow-y: auto;
  background: #030408;
  padding: 14px 16px;
  display: flex; flex-direction: column; gap: 4px;
  font: 400 12px var(--font-mono);
}
```

**Welcome message (on load):**
```
[VALENCE] Connected to Valence Engine at 127.0.0.1:6379
[VALENCE] Thread-per-core: 12 shards bound to CPU cores 0–11
[VALENCE] Type HELP for available commands. Tab to autocomplete.
```

**Command line:**
```css
.con-cmd { color: #fff; font-weight: 700; }
.con-cmd::before { content: 'valence:6379> '; color: var(--green); }
```

**Response line:**
```css
.con-res { color: var(--green); margin-left: 14px; white-space: pre-wrap; }
.con-err { color: var(--red);   margin-left: 14px; }
```

### 13.5 Input Row

```css
.console-input-row {
  height: 44px;
  background: #07080d;
  border-top: 1px solid var(--border-lo);
  border-left: 3px solid var(--green);
  display: flex; align-items: center;
  padding: 0 14px; gap: 10px;
  flex-shrink: 0;
}
```

- Prompt: `valence:6379>` in `--green` bold mono
- Input field: transparent bg, white text, green caret
- Blinking block cursor: `▋` character after input text via `::after` pseudo-element

### 13.6 HELP Command Output

When user types `HELP`, print this:
```
VALENCE COMMANDS
─────────────────────────────────────────────────────────
  SET  key "value" [EX seconds]   Store key with optional TTL
  GET  key                        Retrieve value at O(1)
  DEL  key                        Remove key from its shard
  TTL  key                        Check remaining time-to-live
  KEYS *                          List all keys in keyspace
  SHARDS                          Show 12 hardware shard topology
  CLUSTER.SHARDS                  Detailed shard statistics
  BENCH <n>                       Run live benchmark (n ops)
  WHEEL                           Inspect O(1) timing wheel
  INFO                            Engine memory & thread stats
─────────────────────────────────────────────────────────
  Blocked: FLUSHALL  FLUSHDB  SHUTDOWN  DEBUG SLEEP
```

---

## 14. JavaScript Architecture

### 14.1 Global State Object

```javascript
const STATE = {
  currentTab: 'overview',
  cliHistory: [],          // array of command strings
  histPointer: -1,         // current history index
  cmdCount: 0,             // total commands executed
  uptimeSeconds: 0,        // seconds since engine start
  logPaused: false,        // server log paused?
  logBuffer: [],           // buffered log lines while paused
  selectedKey: null,       // currently selected keyspace row
  coreOps: new Array(12).fill(0),     // per-core op counters
  corePct: [12,8,34,6,78,22,18,9,14,28,11,20], // % usage
  throughputHistory: new Array(60).fill(0), // circular 60s buffer
  peakThroughput: 0,
  avgLatencyUs: 0.22,
  latencySamples: [],      // last 100 latency values for rolling avg
  sseSource: null,         // EventSource instance
  keyspaceCache: null,     // cached keys array
  shardKeyCounts: new Array(12).fill(0),
};
```

### 14.2 Core Functions

| Function | Purpose |
|---|---|
| `navigateTo(tab)` | Switches active tab, updates sidebar, triggers tab-specific init |
| `initApp()` | Called on `DOMContentLoaded` — sets up everything |
| `connectSSE()` | Creates `EventSource('/api/telemetry/stream')`, binds handlers |
| `onSSEMessage(event)` | Parses SSE JSON, routes to log + feed + core cells |
| `pollSystemInfo()` | `GET /api/system/info` every 2s, updates topbar pills |
| `fetchKeys(query, type)` | `GET /api/keys?q=&type=`, renders table |
| `execCmd(cmdString)` | `POST /api/exec`, handles response, updates CLI output |
| `selectKeyRow(keyObj, rowEl)` | Opens detail drawer, populates all fields |
| `deleteKey(keyName)` | Sends `DEL key`, closes drawer, refreshes table |
| `handleInlineSet()` | Reads form, calls `execCmd(SET ...)`, closes form |
| `refreshTimingWheel()` | `GET /api/timing-wheel/slots`, updates SVG dots + table |
| `tickWheelHand()` | Moves clock hand to current second, updates chips |
| `tickUptimeCounter()` | Increments `STATE.uptimeSeconds`, updates topbar |
| `pulseCoreCell(index)` | Adds `.pulsing` class, removes after 420ms |
| `appendLogLine(tag, msg)` | Creates + appends log line DOM element |
| `appendCliOutput(type, text)` | Creates + appends CLI output DOM element |
| `redrawThroughputChart()` | Redraws canvas 2D throughput bars |
| `redrawDistributionChart()` | Redraws cluster distribution bars |
| `countUpAnimate(el, end, duration)` | Animates number from 0 to end |
| `murmur3_32(key)` | Client-side Murmur3 hash for routing display |
| `formatTTL(seconds)` | Formats seconds → "14s" / "1h 24m" / "--" |
| `formatBytes(bytes)` | Formats bytes → "128 B" / "1.2 KB" |
| `toggleLogPause()` | Pauses/resumes server log, drains buffer on resume |
| `clearLog()` | Empties server log DOM |
| `clearCli()` | Empties CLI output DOM |
| `runQuickCmd(cmd)` | Sets CLI input + executes |
| `triggerBenchStress()` | Animates all core cells to 100% during bench |
| `cliTabComplete()` | Autocompletes current input prefix |
| `cliHistoryUp()` | Moves history pointer up |
| `cliHistoryDown()` | Moves history pointer down |

### 14.3 SSE Event Handling

```javascript
connectSSE() {
  STATE.sseSource = new EventSource('/api/telemetry/stream');
  STATE.sseSource.onmessage = (e) => {
    const item = JSON.parse(e.data);
    if (item.type === 'CONNECTED') return;

    // 1. Append to Server Log (left bottom strip)
    appendLogLine(item.command, item.key, item.status, item.latencyUs, item.timestamp);

    // 2. Append to Live Feed (overview tab)
    prependFeedRow(item);

    // 3. Pulse correct core cell (overview tab)
    if (item.core) {
      const idx = parseInt(item.core.replace('C',''), 10);
      pulseCoreCell(idx);
    }

    // 4. Update throughput history
    STATE.throughputHistory[59] += 1;
  };
  STATE.sseSource.onerror = () => {
    // Attempt reconnect after 2 seconds
    setTimeout(connectSSE, 2000);
  };
}
```

### 14.4 Timing Intervals

| Interval | Frequency | Action |
|---|---|---|
| `setInterval` | 1 second | `tickUptimeCounter()`, `tickWheelHand()`, push throughput bucket |
| `setInterval` | 2 seconds | `pollSystemInfo()` |
| `setInterval` | 1 second (when timing-wheel tab active) | `refreshTimingWheel()` |
| `requestAnimationFrame` | 60fps during bench | Core cell animation |
| `setInterval` | 1 second | Shift throughput history, `redrawThroughputChart()` |

---

## 15. API Reference

All APIs already exist in `server.js`. No backend changes needed.

### `GET /api/system/info`

**Response:**
```json
{
  "success": true,
  "status": "ONLINE",
  "shards": 12,
  "totalKeys": 47,
  "memoryDramMb": "4.2",
  "uptimeSeconds": 742,
  "peakThroughput": 1250480
}
```

**Used by:** topbar pills, KPI cards, cluster summary

---

### `GET /api/keys?q=&type=`

**Response:**
```json
{
  "keys": [
    {
      "key": "cart:session_101",
      "type": "string",
      "sizeBytes": 128,
      "ttl": 14,
      "core": "Core 4",
      "valPreview": "{\"userId\":\"user_1001\"}"
    }
  ]
}
```

**Used by:** Keyspace table, Cluster shard counts, distribution chart

---

### `POST /api/exec`

**Request:**
```json
{ "cmd": "SET cart:session_101 \"Biryani\" EX 15" }
```

**Response:**
```json
{
  "success": true,
  "output": "\"OK\"",
  "core": "C04",
  "shardId": 4,
  "latencyUs": 0.21,
  "command": "SET",
  "key": "cart:session_101"
}
```

**Used by:** Console tab, key detail drawer (DELETE), inline set form

---

### `GET /api/telemetry/stream`

**SSE stream.** Each event:
```json
{
  "type": "SET",
  "key": "cart:session_101",
  "core": "C04",
  "latencyUs": 0.21,
  "status": "OK",
  "timestamp": "12:43:12"
}
```

**Used by:** Server log, live ops feed, core pulse, throughput chart

---

### `GET /api/timing-wheel/slots`

**Response:**
```json
{
  "currentSlot": 15,
  "currentMinute": 21,
  "slots": [
    {
      "slot": 15,
      "items": [
        { "key": "cart:session_101", "remainingSec": 14, "core": "Core 4" }
      ]
    }
  ]
}
```

**Used by:** Timing Wheel SVG dots, expiration queue table, slot chips

---

## 16. Animation & Interaction Spec

### 16.1 Tab Switch Animation

```css
@keyframes tabFadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}
.tab-view.active { animation: tabFadeIn 200ms ease forwards; }
```

### 16.2 Core Cell Pulse

```css
@keyframes cellPulse {
  0%   { background: var(--bg-card); border-color: var(--border-lo); transform: scale(1); }
  30%  { background: var(--green-dim); border-color: var(--green-border); transform: scale(1.02); }
  100% { background: var(--bg-card); border-color: var(--border-lo); transform: scale(1); }
}
.core-cell.pulsing { animation: cellPulse 420ms ease forwards; }
```

### 16.3 Status Dot Breathe

```css
@keyframes breathe {
  0%, 100% { opacity: 1; box-shadow: 0 0 8px var(--green-glow); }
  50%       { opacity: 0.4; box-shadow: 0 0 3px var(--green-glow); }
}
.live-dot { animation: breathe 2.4s ease-in-out infinite; }
```

### 16.4 Timing Wheel Dot Urgent Blink

```css
@keyframes dotBlink {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.2; }
}
.dot-urgent { animation: dotBlink 0.8s step-end infinite; }
```

Applied to dots where `remainingSec < 5`.

### 16.5 Count-Up Animation (KPI cards on load)

```javascript
function countUpAnimate(element, endValue, duration = 1200, isFloat = false) {
  const startTime = performance.now();
  function tick(now) {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    // easeOutExpo
    const eased = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
    const current = endValue * eased;
    element.textContent = isFloat
      ? current.toFixed(2)
      : Math.round(current).toLocaleString();
    if (progress < 1) requestAnimationFrame(tick);
  }
  requestAnimationFrame(tick);
}
```

### 16.6 Feed Row Slide-In

```css
@keyframes feedSlideIn {
  from { opacity: 0; transform: translateY(-5px); }
  to   { opacity: 1; transform: translateY(0); }
}
.feed-row { animation: feedSlideIn 120ms ease; }
```

### 16.7 Benchmark Stress Visual

When `BENCH N` command is received:
1. All 12 core cells animate to 100% bar width
2. All 12 core cells get `.pulsing` class in rapid succession
3. Throughput chart bars jump to max height
4. After 5 seconds: values restore to pre-bench readings

### 16.8 Hover & Focus States

```css
/* All interactive cards */
.shard-card:hover { transform: translateY(-2px); border-color: var(--green-border); }

/* All buttons */
button:focus-visible { outline: 2px solid var(--green); outline-offset: 2px; }

/* Table rows */
tr:hover td { background: var(--bg-elevated); }
tr.selected td:first-child { box-shadow: inset 3px 0 0 var(--green); }
```

---

## 17. Responsive Behaviour

| Breakpoint | Changes |
|---|---|
| `> 1280px` | Full layout as described above |
| `960px – 1280px` | Sidebar width reduces to 180px. Cluster grid becomes 3×4. |
| `768px – 960px` | Sidebar hidden, replaced by top tab bar. KPI cards become 2×2 grid. Bottom strip stacks vertically. |
| `< 768px` | Single column. Content scrolls vertically. Bottom strip is collapsible panel. Core grid 2×6. |

---

## 18. Accessibility

| Concern | Implementation |
|---|---|
| Colour contrast | All text on dark bg meets WCAG AA (4.5:1 ratio minimum) |
| Focus ring | `outline: 2px solid var(--green)` on all interactive elements |
| `aria-label` | Every icon-only button has descriptive `aria-label` |
| `role="log"` | Server log and CLI output areas use `role="log" aria-live="polite"` |
| `role="status"` | Topbar status pill uses `role="status"` |
| Keyboard nav | All nav buttons, table rows, and inputs fully keyboard operable |
| `prefers-reduced-motion` | All keyframe animations disabled if `@media (prefers-reduced-motion: reduce)` |

---

## 19. Performance Rules

| Rule | Reason |
|---|---|
| Only `transform` and `opacity` animated | Avoids layout/paint, GPU composited only |
| Canvas for charts (not DOM bars) | 60fps redraws with zero DOM overhead |
| SSE instead of polling | 1 persistent connection vs repeated HTTP requests |
| Max 200 log lines in DOM | Prevents unbounded memory growth |
| Max 20 feed rows in DOM | Same |
| `requestAnimationFrame` for bench visuals | Syncs to display refresh, no dropped frames |
| Keys cached in `STATE.keyspaceCache` | Avoids redundant API calls on filter/search |
| Debounced search input (300ms) | Prevents API flood on keystroke |
| `will-change: transform` on shard cards | Pre-promotes hover-animated elements to own layer |
| Images: zero external assets | No network waterfall besides 2 font CDN requests |

---

> **Implementation:** All of the above is implemented in a single `index.html` file  
> (~3,000 lines of HTML, CSS, and JS), served by the existing `server.js` on port 8080.  
> **Zero external dependencies. Zero build step. Open browser → done.**
