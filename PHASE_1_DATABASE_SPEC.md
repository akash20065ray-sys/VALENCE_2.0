# VALENCE STUDIO — PHASE 1: DATABASE REDESIGN SPECIFICATION
**Version:** 1.0.0 Enterprise Standard  
**Document Classification:** Engineering Design Document & UI/UX Blueprint  
**Target Systems:** Valence Rust In-Memory Store (`valence-server.exe` :6379), Valence Studio Node Bridge (`server.js` :8080)  
**Author:** Antigravity Principal Systems Architect & UI Engineer  
**Date:** October 2026  

---

## 1. Executive Summary & Design System

### 1.1 Objective
Phase 1 re-architects the core **DATABASE** domain of Valence Studio. It replaces fragmented prototype screens with three synchronized, high-density engineering workspaces:
1. **Subphase 1.1 — Database Overview**: Executive cluster health, 3 high-density KPI telemetry cards, dual-axis 60s performance canvas, 12-core hardware matrix with shard inspection, top namespaces distribution, and a live command stream with regex filtering.
2. **Subphase 1.2 — Key Explorer**: 3-column master-detail data workbench featuring an interactive namespace hierarchy, multi-select key table with batch mutation operations, a collapsible JSON tree editor, exact Murmur3 hash shard binding, and Timing Wheel bucket slot management.
3. **Subphase 1.3 — Query Console (v-Shell)**: Full-height, low-latency Unix terminal emulator supporting RESP3 protocol commands, quick-action telemetry chips, sub-microsecond latency tagging, shard routing annotations, Tab autocompletion, and destructive safety rails.

### 1.2 Carbon Matte Dark Design Tokens
The visual design enforces a zero-glow, carbon matte aesthetic engineered for extended terminal operations, high information density, and sub-millisecond visual scanning.

```css
:root {
  /* Surface Layers (Neutral Carbon Matte) */
  --bg-void:        #08090b; /* Outer window backdrop */
  --bg-base:        #0a0b0e; /* Main workspace canvas */
  --bg-surface:     #0e1014; /* Navigation panels, toolbars */
  --bg-card:        #121418; /* Elevated cards, data tables, drawers */
  --bg-card-hover:  #16191f; /* Hover states */
  --bg-input:       #0d0f13; /* Input fields, terminal backdrop */

  /* Structural Borders */
  --border-subtle:  #1a1d24; /* Hairline card borders, row dividers */
  --border-medium:  #262a34; /* Active focus borders, container bounds */
  --border-strong:  #343a48; /* Highlighted card strokes */

  /* Functional Accents */
  --accent-emerald: #00e5a0; /* Valence primary: healthy status, writes, throughput */
  --accent-cyan:    #00c8ff; /* Telemetry: reads, latency canvas, CPU core binding */
  --accent-amber:   #f5a624; /* Warnings: memory high-water, TTL expiring <60s */
  --accent-coral:   #ff4060; /* Danger: errors, shard stalls, FLUSH/DEL safety rails */
  --accent-purple:  #a78bfa; /* Structural metadata: LSN, epochs, Murmur3 hashes */

  /* Typography Colors */
  --text-primary:   #e6e8eb; /* High-contrast headers, active keys */
  --text-secondary: #9da5b4; /* Column headers, secondary metadata */
  --text-muted:     #5a6272; /* Disabled text, subtle labels, timestamps */

  /* Typography Families */
  --font-mono:      'JetBrains Mono', 'SF Mono', 'Consolas', monospace;
  --font-sans:      'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

### 1.3 Global Header & Shell Architecture
Every view within Phase 1 renders inside the unified global application frame:

```
+-----------------------------------------------------------------------------------------------------------------------------+
| [V] VALENCE STUDIO  |  [● LIVE] valence-primary-01  |  12/12 Shards Pinned  |  Active Epoch: #8798  |  Uptime: 14d 06h 22m  |
+-----------------------------------------------------------------------------------------------------------------------------+
| SIDEBAR (240px)     | MAIN WORKSPACE CONTENT AREA (Flex: 1, 100vh - 48px)                                                   |
|                     |                                                                                                       |
| ▾ DATABASE          |                                                                                                       |
|   • Overview        |   [ Active Subphase Workspace View ]                                                                  |
|   • Key Explorer    |                                                                                                       |
|   • Query Console   |                                                                                                       |
| ▸ PERFORMANCE       |                                                                                                       |
| ▸ CLUSTER & STORAGE |                                                                                                       |
| ▸ OPERATIONS        |                                                                                                       |
| ▸ ADMINISTRATION    |                                                                                                       |
+-----------------------------------------------------------------------------------------------------------------------------+
```

---

## 2. Subphase 1.1: Database Overview

### 2.1 Overview Architecture & Visual Wireframe
The Overview view is designed as an executive and operational control board. It aggregates real-time cluster health, throughput/latency dual-axis canvas streams, 12-core hardware thread saturation, namespace memory consumption, and a live filtered command stream.

```
+-----------------------------------------------------------------------------------------------------------------------------+
| TIER 1: EXECUTIVE HEALTH STATUS STRIP                                                                                       |
| Node: valence-primary-01 [HEALTHY] | Engine: v0.1.0-alpha | CPU: 12 Cores / 12 Shards | Memory: 384.2 MB / 8.0 GB (4.8%)        |
| Active Epoch: #8798 | Current LSN: 8797 | WAL: ENABLED (fsync: 10ms) | RDB Snapshot: Last saved 2m ago                     |
+-----------------------------------------------------------------------------------------------------------------------------+
| TIER 2: HIGH-DENSITY KPI CARDS (3-Column Grid)                                                                              |
| +--------------------------------+ +--------------------------------+ +---------------------------------------------------+ |
| | THROUGHPUT (OPS/SEC)           | | LATENCY PROFILE (RESP)         | | KEYSPACE INVENTORY                                | |
| | 128,450 ops/s     [+3.2% 1m]   | | 0.18 μs avg    [p50: 0.14 μs]  | | 240 Keys Stored    [100% Valid]                 | |
| | Reads: 94.2k | Writes: 34.2k   | | p95: 0.38 μs   | p99: 0.92 μs  | | Top: cart:* (128) | session:* (64) | user:* (48)| |
| | [~~~~~ 30s Canvas Sparkline ~] | | [|||||||| p50/p95/p99 Bars ||] | | [|||||||||||||||| Namespace Stacked Bar |||||||]  | |
| +--------------------------------+ +--------------------------------+ +---------------------------------------------------+ |
+-----------------------------------------------------------------------------------------------------------------------------+
| TIER 3: REAL-TIME DUAL TELEMETRY & HARDWARE MATRIX                                                                          |
| +---------------------------------------------------------+ +-------------------------------------------------------------+ |
| | REAL-TIME PERFORMANCE ENGINE (60s Canvas Stream)        | | 12-CORE HARDWARE SHARD MATRIX                               | |
| | [Dual Y-Axis Canvas: Throughput (Green) + Latency (Blue)]| | [S00: 4.2%  20k] [S01: 5.1%  21k] [S02: 3.8%  19k]          | |
| | 150k -|                                                 | | [S03: 4.9%  22k] [S04: 6.2%  26k] [S05: 4.1%  18k]          | |
| | 100k -|      /\_/\                                      | | [S06: 3.9%  17k] [S07: 4.8%  21k] [S08: 5.4%  23k]          | |
| |  50k -|_____/     \________/\___________ (Throughput)   | | [S09: 4.2%  19k] [S10: 3.7%  16k] [S11: 5.0%  22k]          | |
| |    0 -|---------------------------------- 0.2 μs (Lat)  | | [Selected: Shard 04 -> Thread: Pinned Core 4 | Keys: 22]    | |
| +---------------------------------------------------------+ +-------------------------------------------------------------+ |
+-----------------------------------------------------------------------------------------------------------------------------+
| TIER 4: WORKSPACE INTELLIGENCE                                                                                              |
| +---------------------------------------------------------+ +-------------------------------------------------------------+ |
| | TOP NAMESPACES (Keys, Memory & Expiry Profile)          | | LIVE COMMAND STREAM (SSE Tail) [Filter: Regex...] [Pause]   | |
| | Namespace     Keys    Memory    TTL Profile     Action  | | 15:08:02.104  SET  cart:9942:items  "..." [Shard 04] [0.18μs] | |
| | cart:*         128    210 KB    100% < 24h      [Scan]  | | 15:08:02.106  GET  user:301:profile  [Shard 02] [0.12μs]        | |
| | session:*       64    112 KB    100% < 2h       [Scan]  | | 15:08:02.109  HGET cart:8121:meta   "total" [S08] [0.15μs]      | |
| | user:*          48     58 KB    Persistent      [Scan]  | | 15:08:02.112  EXPIRE session:901 3600  [Wheel: Slot 41]         | |
| +---------------------------------------------------------+ +-------------------------------------------------------------+ |
+-----------------------------------------------------------------------------------------------------------------------------+
```

### 2.2 Component Breakdown & Data Mapping

#### 2.2.1 Tier 1: Executive Cluster Health Strip
- **Visual Design:** Full-width, single-line horizontal bar (`height: 38px`, `background: var(--bg-surface)`, `border-bottom: 1px solid var(--border-subtle)`).
- **Data Attributes:**
  - `Node ID`: Real socket binding (`127.0.0.1:6379`).
  - `Engine Status`: Live heartbeat badge (`[● LIVE] #00e5a0` or `[● OFFLINE] #ff4060`).
  - `Shard Pinned Cores`: Exact count returned by `INFO shards` (`12/12 pinned`).
  - `Active Epoch`: Current consensus/storage epoch (`#8798`).
  - `WAL LSN`: Log Sequence Number (`8797`), indicating zero WAL lag.
  - `Memory RSS`: Real process memory consumption mapped from Windows OS process metrics.

#### 2.2.2 Tier 2: Three High-Density KPI Cards
1. **Throughput (Ops/sec) Card:**
   - Primary metric: Calculated instantaneous ops/sec (`JetBrains Mono`, `32px`, `font-weight: 700`, `color: #e6e8eb`).
   - Split metric: Sub-labels for `Reads/sec` (Cyan) and `Writes/sec` (Emerald).
   - Micro-visualization: 30-second rolling Canvas sparkline (`height: 36px`, smoothed quadratic Bezier curve, emerald fill gradient with 12% alpha).
2. **Latency Profile Card:**
   - Primary metric: Sub-microsecond execution latency (`0.18 μs`).
   - Distribution matrix: Micro-horizontal progress bars displaying `p50` (`0.14 μs`), `p95` (`0.38 μs`), and `p99` (`0.92 μs`).
   - Health threshold: If `p99 > 5.0 μs`, status tag transitions from Emerald to Amber.
3. **Keyspace Inventory Card:**
   - Primary metric: Total active keys (`240 Keys`).
   - Breakdown: Stacked horizontal progress bar displaying top namespaces proportion:
     - Emerald: `cart:*` (53.3%)
     - Cyan: `session:*` (26.7%)
     - Purple: `user:*` (20.0%)
   - Sub-stat: Active TTL ratio (`100% with expiry tracking`).

#### 2.2.3 Tier 3: Real-Time Dual Telemetry Canvas & 12-Core Shard Matrix
- **Dual Y-Axis 60s Canvas (Width: 58%, Height: 240px):**
  - High-performance HTML5 Canvas 2D running at `60 FPS` via `requestAnimationFrame`.
  - Left Y-Axis: Operations per second (`0` to `200,000 ops/s`, tick color `#5a6272`).
  - Right Y-Axis: Execution latency (`0.0` to `2.0 μs`, tick color `#00c8ff`).
  - Zero-lag rendering: Uses fixed-length ring buffers (`Float32Array(120)`) with zero garbage collection allocations.
- **12-Core Hardware Shard Matrix (Width: 42%, Height: 240px):**
  - 4x3 interactive grid representing the 12 pinned CPU worker threads.
  - Each shard tile displays:
    - Shard Identifier: `S00` to `S11`.
    - Real-time CPU saturation progress ring (0% to 100%).
    - Active key count allocated to that shard via Murmur3 hash.
    - Hover state: Elevation with cyan hairline border (`#00c8ff`).
    - Click action: Opens sliding Shard Drawer with granular thread statistics (event loop lag, timing wheel bucket counts, lock contention metrics).

#### 2.2.4 Tier 4: Workspace Intelligence
- **Top Namespaces Table (50% Width):**
  - Displays aggregated keyspace groupings.
  - Columns: Namespace Prefix (`cart:*`), Key Count (`128`), Estimated Memory (`210 KB`), Expiry Range (`< 24h`), Action button (`[Scan in Explorer]`).
  - Clicking `[Scan in Explorer]` routes directly to Subphase 1.2 with the prefix pre-filtered.
- **Live Command Stream (50% Width):**
  - Live SSE feed (`/api/telemetry/stream`) displaying raw engine commands.
  - Controls: Interactive Regex Search Filter (`input[type="text"]`), Pause/Resume Toggle, Clear Stream button.
  - Row format: `[HH:mm:ss.SSS]` `[COMMAND (Color-coded: GET=Cyan, SET=Emerald, DEL=Coral)]` `[KEY]` `[SHARD]` `[LATENCY]`.

---

## 3. Subphase 1.2: Key Explorer

### 3.1 Key Explorer Architecture & Visual Wireframe
The Key Explorer is a high-density, 3-column master-detail data manipulation studio. It enables real-time search, multi-selection batch mutations, deep JSON inspection/editing, and hardware Murmur3/Timing Wheel telemetry.

```
+-----------------------------------------------------------------------------------------------------------------------------+
| TOP CONTROLS: [🔍 Search keys (regex, prefix, glob)...] [All Types ▾] [All Shards ▾] [⟳ Refresh] [+ NEW KEY]              |
+-----------------------------------------------------------------------------------------------------------------------------+
| COL 1: NAMESPACES (230px)   | COL 2: MASTER KEYS TABLE (Flex: 1)                     | COL 3: KEY INSPECTOR DRAWER (380px)  |
| ▾ All Namespaces (240)      | [ ] Key Name        Type  Size   TTL      Core  Action | KEY: cart:9942:items                 |
|   ▸ cart:* (128)            | [x] cart:9942:items  JSON 1.2KB  58s ▾    S04   [•••]  | Type: JSON | Size: 1,248 bytes       |
|   ▸ session:* (64)          | [x] cart:8121:meta   HASH 480B   4m 12s   S08   [•••]  | ------------------------------------ |
|   ▸ user:* (48)             | [ ] session:901:tok  STR  128B   14m 02s  S01   [•••]  | HARDWARE ROUTING & LIFECYCLE         |
|                             | [ ] user:301:profile HASH 2.1KB  PERSIST  S02   [•••]  | Murmur3 Hash: 0xa8f4c91b             |
| LIFECYCLE FILTERS           | [ ] user:302:profile HASH 1.9KB  PERSIST  S06   [•••]  | Target Shard: Shard 04 (Core 4)      |
| [ ] Expiring < 1m (12)      | [ ] cart:4410:items  JSON 890B   18s ▾    S11   [•••]  | Timing Wheel: Slot 58 / Ring Level 0 |
| [ ] Expiring < 1h (180)     |                                                        | TTL: 58s [Extend +60s] [Persist]     |
| [ ] Persistent (48)         | +----------------------------------------------------+ | ------------------------------------ |
|                             | | FLOATING BATCH ACTION BAR (2 Keys Selected)        | | VALUE VIEWER / EDITOR [Tree | Raw]   |
| BULK NAMESPACE OPS          | | [Extend TTL: +1h ▾] [Delete Selected (2)] [Export] | | ▼ {                                  |
| [Flush Namespace...]        | +----------------------------------------------------+ |   "user_id": 9942,                   |
| [Export Namespace JSON]     |                                                        |   ▼ "items": [                       |
|                             | Showing 1 - 25 of 240 keys    [|<] [<] Page 1 of 10 [>]|       { "sku": "FOOD-88", "qty": 2 } |
|                             |                                                        |     ]                                |
|                             |                                                        |   }                                  |
|                             |                                                        | [SAVE CHANGES]       [DELETE KEY]    |
+-----------------------------------------------------------------------------------------------------------------------------+
```

### 3.2 Column Component Specifications

#### 3.2.1 Column 1: Namespaces & Lifecycle Filter (230px Width)
- **Namespace Tree:**
  - Auto-grouped tree generated from keys using `:` delimiters.
  - Displays key count badge alongside each branch.
  - Clicking a branch activates instant filtering in Column 2 (`selectedNamespace = "cart:*"`).
- **Lifecycle Filter Chips:**
  - `Expiring < 1m`: Identifies keys on the immediate eviction verge in Timing Wheel level 0.
  - `Expiring < 1h`: Keys with active TTL countdowns.
  - `Persistent`: Keys configured with no TTL (`TTL = -1`).
- **Bulk Namespace Operations:**
  - `Flush Namespace`: Opens destructive confirmation dialog before executing a batched pipeline delete.
  - `Export JSON`: Streams all keys and values under the selected namespace as a downloadable `.json` snapshot.

#### 3.2.2 Column 2: Master Key Table & Multi-Select Batch Bar (Flex: 1)
- **Top Control Bar:**
  - Full-text search input with support for glob expressions (`user:*`), regex, or raw substrings.
  - Type Filter Dropdown (`All Types`, `STRING`, `HASH`, `LIST`, `SET`, `JSON`).
  - Shard Filter Dropdown (`All Shards`, `Shard 00` through `Shard 11`).
  - Action button: `+ NEW KEY` opens creation modal.
- **Data Table Grid:**
  - Multi-select checkbox column with header "Select All".
  - Columns:
    - `Key Name`: High-contrast monospace, truncated with ellipsis, tooltip on hover.
    - `Type`: Colored badge (`JSON` Emerald, `HASH` Cyan, `STRING` Muted).
    - `Size`: Tabular human-readable byte size (`1.2 KB`, `480 B`).
    - `TTL`: Dynamic ticking countdown. Colors: `<60s` Amber/Coral, `<1h` Muted, `PERSIST` Emerald.
    - `Shard / Core`: Micro badge showing CPU thread assignment (`S04`, `S08`).
    - `Action`: Context menu trigger `[•••]` (`Edit`, `Duplicate`, `Delete`, `Copy Key Name`).
- **Floating Batch Action Bar (Appears when `selectedKeys.length > 0`):**
  - Sticky floating pill positioned at bottom-center of Column 2.
  - Styled with subtle carbon elevation and emerald hairline border.
  - Actions:
    - `Bulk Extend TTL`: Dropdown options (`+60s`, `+5m`, `+1h`, `+24h`, `Remove Expiry`).
    - `Delete Batch`: Prompts modal confirmation before issuing atomic pipeline `DEL`.
    - `Export Selection`: Downloads selected key/value pairs.

#### 3.2.3 Column 3: Deep Key Inspector Drawer (380px Width)
- **Key Header & Metadata:**
  - Full key string with 1-click clipboard copy icon.
  - Memory footprint in bytes and data type badge.
- **Hardware Routing & Timing Wheel Inspector:**
  - `Murmur3 Hash`: Exact 64-bit integer hash calculated on the key string (e.g., `0xa8f4c91b`).
  - `Hardware Shard Binding`: Displays assigned worker core (`Shard 04` -> `Thread Core 4`).
  - `Timing Wheel Bucket`: Displays current Timing Wheel slot index (0-59) and cascade ring level.
  - `TTL Controller`: Live decrementing counter with rapid mutation buttons (`+60s`, `+1h`, `PERSIST`).
- **Collapsible JSON Tree Viewer & Raw Editor:**
  - Mode toggle: `[Tree View]` vs `[Raw JSON]`.
  - Tree View: Interactive expandable/collapsible nodes with type-colored values (strings in green, numbers in cyan, booleans in amber).
  - Raw Editor: Embedded lightweight code editor with syntax linting and JSON formatting.
  - `[SAVE CHANGES]` Button: Triggers targeted write back to `valence-server` with instant optimistic UI update.
  - `[DELETE KEY]` Danger Button: Prompts inline confirmation to delete the key.

#### 3.2.4 Modal Specification: `+ NEW KEY` Modal
- Triggered by the `[+ NEW KEY]` button in the top control bar.
- Fields:
  - `Key Name` (Text input): As the user types, an interactive live preview displays the calculated `Murmur3 Hash` and the destination `Hardware Shard (0-11)`.
  - `Data Type` (Dropdown): `STRING`, `HASH`, `LIST`, `SET`, `JSON`.
  - `TTL (Seconds)` (Number input): Default `3600`, toggle for `No Expiration`. Displays destination Timing Wheel bucket slot.
  - `Value Editor` (Monospace text area): JSON format validation with error markers.
- Actions: `[Cancel]` and `[Create Key]`.

---

## 4. Subphase 1.3: Query Console (v-Shell)

### 4.1 Query Console Architecture & Visual Wireframe
The Query Console provides an industrial-grade Unix terminal environment connected directly to Valence via RESP3. It bypasses GUI abstractions, providing raw command execution with shard routing annotations, microsecond latency measurements, command history, and destructive safety rails.

```
+-----------------------------------------------------------------------------------------------------------------------------+
| QUICK ACTION CHIPS: [SHARDS] [KEYS *] [INFO] [WHEEL] [DBSIZE] [HELP]                        [Safety Rails: ON] [Clear]     |
+-----------------------------------------------------------------------------------------------------------------------------+
| TERMINAL OUTPUT LOG (Flex: 1, Monospace, Auto-scroll to bottom)                                                             |
| Valence Studio v-Shell [Protocol: RESP3 | Socket: 127.0.0.1:6379]                                                           |
| Type "HELP" for command catalog, "CLEAR" to clear buffer.                                                                    |
|                                                                                                                             |
| valence-primary-01:6379> INFO                                                                                               |
|   # Server                                                                                                                  |
|   valence_version: 0.1.0-alpha                                                                                              |
|   num_shards: 12                                                                                                            |
|   active_epoch: 8798                                                                                                        |
|   wal_enabled: 1                                                                                                            |
|   wal_current_lsn: 8797                                                                                                     |
|   connected_clients: 2                                                                                                      |
|   [OK] [Shard: Host Intercept] [Latency: 0.12 μs]                                                                           |
|                                                                                                                             |
| valence-primary-01:6379> GET cart:9942:items                                                                                |
|   "{\"user_id\":9942,\"items\":[{\"sku\":\"FOOD-88\",\"qty\":2}]}"                                                          |
|   [OK] [Shard 04 · CPU Core 4] [Latency: 0.19 μs]                                                                           |
|                                                                                                                             |
| valence-primary-01:6379> SET user:800:session "active" EX 300                                                               |
|   OK                                                                                                                        |
|   [OK] [Shard 09 · CPU Core 9 · Wheel Slot 22] [Latency: 0.24 μs]                                                           |
|                                                                                                                             |
| valence-primary-01:6379> FLUSHDB                                                                                            |
|   ▲ SAFETY RAIL BLOCKED: Command 'FLUSHDB' will destroy all 240 active keys.                                                |
|     To execute, append flag: FLUSHDB --force-destructive                                                                    |
|                                                                                                                             |
+-----------------------------------------------------------------------------------------------------------------------------+
| INTERACTIVE COMMAND INPUT STRIP                                                                                             |
| valence-primary-01:6379> SET temp:key "hello world" EX 60█                                                                  |
| [Tab] Autocomplete: SETEX, SETNX, SETBIT | [▲/▼] History (42 commands)                                                       |
+-----------------------------------------------------------------------------------------------------------------------------+
```

### 4.2 Terminal Capabilities & Engineering Specifications

#### 4.2.1 Quick Action Telemetry Chips
- Pinned at the top of the terminal for rapid 1-click execution:
  - `SHARDS`: Interrogates all 12 worker shards, printing key distribution and CPU load.
  - `KEYS *`: Lists all keys with shard annotations.
  - `INFO`: Queries full server metrics, memory RSS, and WAL status.
  - `WHEEL`: Inspects active Timing Wheel expiry buckets and ring levels.
  - `DBSIZE`: Returns active key count.
  - `HELP`: Displays command syntax reference.
  - `Safety Rails Toggle`: Enables/disables execution guardrails.

#### 4.2.2 Shard Routing & Microsecond Latency Annotations
- Every command response automatically appends an engine metadata pill:
  - `[OK]` in Emerald (`#00e5a0`) or `[ERR]` in Coral (`#ff4060`).
  - `[Shard XX · CPU Core X]`: Identified via Murmur3 key hash or engine response header.
  - `[Wheel Slot XX]`: Printed whenever an `EX` or `EXPIREAT` command modifies the Timing Wheel.
  - `[Latency: 0.XX μs]`: Exact client-to-engine round-trip duration measured via `performance.now()`.

#### 4.2.3 Autocompletion & Command History
- **Command History Buffer:**
  - Maintains the last 100 executed commands in memory and persisted in `localStorage`.
  - Accessible via standard `ArrowUp` and `ArrowDown` terminal keybindings.
- **Tab Autocompletion:**
  - Autocompletes standard RESP commands (`GET`, `SET`, `DEL`, `EXPIRE`, `TTL`, `HGET`, `HSET`, `INFO`, `SHARDS`, `WHEEL`, `CLIENT LIST`).
  - Autocompletes active key names when typing command arguments (e.g., `GET ca[Tab]` -> `GET cart:9942:items`).

#### 4.2.4 Safety Rails & Destructive Command Interception
- Prevents accidental data loss in production environments.
- Intercepts commands: `FLUSHDB`, `FLUSHALL`, and wildcard deletions (`DEL *`).
- When Safety Rails are enabled:
  - Execution is blocked client-side before transmission to port 6379.
  - A formatted warning explains the risk and key count affected.
  - Unblocking requires typing `--force-destructive` or toggling Safety Rails off in the header chip.

---

## 5. Backend REST & SSE API Integration Matrix

All three subphases connect directly to the existing Node bridge (`valence_dashboard/server.js` on port 8080) and Valence Rust TCP engine (port 6379).

| Subphase | Endpoint / Route | Method | Protocol | Target Engine Command | Description |
|---|---|---|---|---|---|
| **1.1 Overview** | `/api/stats` | `GET` | HTTP | `INFO`, `DBSIZE`, `CLIENT LIST` | Executive health metrics, memory, epoch, uptime. |
| **1.1 Overview** | `/api/shards` | `GET` | HTTP | `SHARDS` (Custom intercept) | 12-core key distribution and CPU core mappings. |
| **1.1 Overview** | `/api/telemetry/stream` | `GET` | SSE | `MONITOR` / Telemetry Bus | Real-time dual-axis canvas data and live command stream. |
| **1.2 Key Explorer** | `/api/keys` | `GET` | HTTP | `KEYS *`, `TYPE`, `TTL` | Paginated keyspace inventory with type, size, TTL, and shard. |
| **1.2 Key Explorer** | `/api/keys/get` | `GET` | HTTP | `GET`, `HGETALL`, `LRANGE` | Retrieves raw value for deep inspector drawer. |
| **1.2 Key Explorer** | `/api/keys/set` | `POST` | HTTP | `SET key value [EX ttl]` | Inline editor mutation and new key creation. |
| **1.2 Key Explorer** | `/api/keys/delete` | `POST` | HTTP | `DEL key` | Single key deletion. |
| **1.2 Key Explorer** | `/api/keys/batch-ttl`| `POST` | HTTP | Pipeline `EXPIRE` | Multi-select bulk TTL extension. |
| **1.2 Key Explorer** | `/api/keys/batch-delete`| `POST` | HTTP | Pipeline `DEL` | Multi-select bulk key deletion. |
| **1.3 Query Console** | `/api/terminal/exec` | `POST` | HTTP | Raw RESP3 Socket Execution | Executes arbitrary commands on port 6379 with latency timing. |

---

## 6. Implementation Roadmap & Verification Milestones

```
PHASE 1 IMPLEMENTATION FLOW
===========================
[Subphase 1.1: Database Overview]
  ├── Step 1.1.1: Refactor Global Navigation Frame & Header Status Strip
  ├── Step 1.1.2: Implement Tier 2 KPI Cards (Sparkline & Latency Bars)
  ├── Step 1.1.3: Build 60s Dual-Axis Canvas & 12-Core Shard Matrix
  └── Step 1.1.4: Wire Top Namespaces & Live Filtered Command Stream
         │
         ▼
[Subphase 1.2: Key Explorer]
  ├── Step 1.2.1: Construct 3-Column Responsive Grid Container
  ├── Step 1.2.2: Implement Column 1 Namespace Tree & Expiry Filters
  ├── Step 1.2.3: Build Column 2 Master Table with Floating Batch Action Bar
  ├── Step 1.2.4: Implement Column 3 Deep Key Inspector (Tree/JSON + Timing Wheel)
  └── Step 1.2.5: Build `+ NEW KEY` Modal with Live Murmur3 Shard Preview
         │
         ▼
[Subphase 1.3: Query Console (v-Shell)]
  ├── Step 1.3.1: Build Full-Height Monospace Terminal Window
  ├── Step 1.3.2: Wire Quick Action Telemetry Chips
  ├── Step 1.3.3: Implement Command Parsing, History & Tab Autocompletion
  ├── Step 1.3.4: Integrate Shard Routing & Sub-microsecond Latency Tagging
  └── Step 1.3.5: Implement Destructive Safety Rails Interceptor
         │
         ▼
[End-to-End Verification against Live valence-server.exe (:6379)]
```

### Verification Protocol
1. **Live Shard Accuracy:** Verify that all 12 shard tiles reflect the exact key distribution verified over TCP port 6379.
2. **Timing Wheel Synchronization:** Verify that keys set with TTLs decrement in real-time in both Key Explorer and Overview without requiring manual page refresh.
3. **Zero-Build Native Performance:** Verify that the 60s canvas and SSE command stream maintain 60 FPS with zero DOM churn or CPU throttling.
4. **Safety Rail Defense:** Execute `FLUSHDB` in Query Console and verify that the safety rail intercepts the command before transmitting to port 6379.

