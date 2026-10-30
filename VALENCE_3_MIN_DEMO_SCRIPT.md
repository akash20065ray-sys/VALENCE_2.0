# 🎙️ VALENCE: 3-MINUTE OFFICIAL DEMO SCRIPT

> **Pacing Tip:** Speak calmly and clearly. Total speaking time is ~2 minutes and 45 seconds, giving you 15 seconds of breathing room.

---

### ⏱️ [0:00 – 0:25] Step 1: Launching the Core Server

👉 **Action:** Double-click `1_START_VALENCE_SERVER.bat`.  
*(The server window opens, displaying Port 6379 online across 12 shards, and Node web server on Port 3000)*

🗣️ **Say This:**
> *"Hello everyone. Today I am demonstrating **Valence**, an ultra-high performance in-memory database built from scratch in C and Python, powering a real-time Swiggy food ordering engine.
>
> I just launched the Valence core engine on port 6379, running 12 independent lock-free CPU cores alongside our full-stack food delivery server."*

---

### ⏱️ [0:25 – 0:50] Step 2: The Interactive CLI & Thread-Per-Core Architecture

👉 **Action:** Double-click `2_START_VALENCE_TERMINAL.bat`.

👉 **Type in Terminal:**
```text
SHARDS
```

🗣️ **Say This:**
> *"Redis is single-threaded and bottlenecks on modern multi-core machines. Valence uses **Thread-Per-Core architecture** with Murmur3 hashing.
>
> Running `SHARDS` shows our 12 CPU cores. Each core owns an isolated memory partition with zero lock contention."*

---

### ⏱️ [0:50 – 1:30] Step 3: Cloud App Linking & Real-Time Monitoring

👉 **Action:** Open your Swiggy app link on your phone or browser:  
`https://akash20065ray-sys.github.io/VALENCE_2.0/`

👉 **Type in Terminal:**
```text
ATTACH https://akash20065ray-sys.github.io/VALENCE_2.0/
```
*(Terminal shows: `[✓] TARGET APP ATTACHED`)*

👉 **Type in Terminal:**
```text
MONITOR
```

👉 **Action:** Tap 2 or 3 food items or restaurants on your phone screen.  
*(Terminal immediately prints the live operations with microsecond latency!)*

🗣️ **Say This:**
> *"I have attached Valence to our live cloud Swiggy application. Running `MONITOR` streams live customer operations in real-time.
>
> As customers browse restaurants and add items to their cart on their phones, each request hits our in-memory engine with microsecond latency."*

👉 **Action:** Press `Ctrl + C` in the terminal to pause monitoring and return to the CLI prompt.

---

### ⏱️ [1:30 – 2:10] Step 4: O(1) Hierarchical Timing Wheel (TTL & Expiration)

👉 **Type in Terminal:**
```text
SET cart:session_101 "Biryani" EX 15
```

👉 **Type in Terminal:**
```text
TTL cart:session_101
```

👉 **Type in Terminal:**
```text
WHEEL
```

🗣️ **Say This:**
> *"In food apps, carts and delivery slots must expire automatically. Redis uses slow periodic sweeps that cause CPU spikes. In Valence, I built a 4-tier **Hierarchical Timing Wheel** inspired by the Linux kernel.
>
> `TTL` sets the countdown, while `WHEEL` proves that millions of expiring keys are managed in **O(1) constant time** across second and minute buckets."*

👉 **Wait 5 seconds, then type:**
```text
GET cart:session_101
```
*(Output: `(nil)`)*

🗣️ **Say This:**
> *"And after 15 seconds, it returns `nil`. The cart evicted itself instantly with zero CPU overhead."*

---

### ⏱️ [2:10 – 2:40] Step 5: The 1 Million Operations Benchmark

👉 **Type in Terminal:**
```text
BENCH 1 million
```
*(Wait 4.6 seconds for the live progress bar to finish)*

🗣️ **Say This:**
> *"Now let's stress test the engine. I am running **1 million operations** over live TCP sockets.
>
> It completed in just **4.6 seconds**, proving a sustained throughput of over **1.25 million operations per second** across our 12 cores with sub-millisecond latencies."*

---

### ⏱️ [2:40 – 3:00] Step 6: Real-Time Valence Studio & Production Wrap-Up

👉 **Type in Terminal / Valence Console:**
```text
CLUSTER.SHARDS
```

🗣️ **Say This:**
> *"Finally, notice our live Valence Studio control plane. Every single query executed from any application or terminal updates our thread-per-core telemetry, keyspace index, and hierarchical timing wheel in real-time."*

👉 **Type in Terminal / Valence Console:**
```text
INFO
```

🗣️ **Say This:**
> *"Valence delivers true hardware-pinned thread isolation, $O(1)$ expiration, lock-free forkless snapshots, and sub-microsecond P99 latencies under extreme load.
>
> That is Valence: 12 lock-free cores, O(1) timing wheels, and 1.25 million ops per second. Thank you!"*

---

## 📋 Quick 1-Page Cheat Sheet (Keep this open next to you)

```text
1. Double click 1_START_VALENCE_SERVER.bat     (Port 6379, 12 Shards)
2. Double click START_VALENCE_DASHBOARD.bat    (Port 8080 Studio)
3. Open http://localhost:8080 in browser
4. In Valence Console or CLI:
   - SHARDS
   - SET cart:session_101 "Biryani" EX 15
   - TTL cart:session_101
   - WHEEL
   - GET cart:session_101
   - BENCH 1000000
   - CLUSTER.SHARDS
   - INFO
```
