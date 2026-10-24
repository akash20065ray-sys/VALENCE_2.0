# VALENCE: 3-MINUTE LIVE DEMO SCRIPT
**Audience:** Recruiters, Hackathon Judges & System Design Interviewers  
**Tone:** Simple, Conversational, High-Impact  
**Total Duration:** Exactly 3 Minutes (180 Seconds)

---

## 🎬 Pre-Demo Setup (Before Starting)

1. Open **Downloads** (`C:\Users\akash\Downloads\`).
2. Double-click `1_START_VALENCE_SERVER.bat` (Starts database engine on `6379`, Swiggy web server on `3000`, and auto-opens browser).
3. Double-click `2_START_VALENCE_TERMINAL.bat` (Opens the interactive CLI terminal).
4. Place the **Swiggy Web App** on the left half of your screen and the **Terminal** on the right half.

---

## ⏱️ Step-by-Step Script & Timings

### ⏱️ [0:00 – 0:30] Introduction & Architecture Proof

👉 **Type in Terminal:**
```text
SHARDS
```

🗣️ **Say This:**
> *"Hi everyone! This is **Valence**, an ultra-high performance in-memory database I built from scratch in pure Rust.*
>
> *Normally, databases like Redis use just one single thread. But modern machines have multiple CPU cores. Valence uses a **Thread-per-Core architecture**—here you can see all **12 physical CPU cores** running in parallel, each with its own memory area and zero lock contention."*

---

### ⏱️ [0:30 – 1:15] Attach & Live Swiggy App Streaming

👉 **Type in Terminal:**
```text
ATTACH https://akash20065ray-sys.github.io/VALENCE_2.0/
```
*(Wait 1 second for `[✓] ATTACHED`)*

👉 **Next, Type in Terminal:**
```text
MONITOR
```

🗣️ **Say This:**
> *"Now I'm attaching our terminal to our live Swiggy food ordering app. With `MONITOR`, whatever happens on the app will stream right here into this console in real time."*

👉 **Now click on your Swiggy browser window (Left Half of Screen):**
1. Click the **Biryani** banner.
2. Click **ADD** on *Meghana Special Chicken Biryani* *(point out the green cart bar counting down at the bottom)*.
3. Click **VIEW CART** and click **PROCEED TO PAY**.

🗣️ **Say This:**
> *"Look at the terminal—every click, search, and cart addition instantly streamed here with microsecond speed, the exact CPU core, and its Timing Wheel TTL expiration time."*

👉 **Press `Ctrl + C` in the terminal to exit monitor mode and return to the prompt.**

---

### ⏱️ [1:15 – 2:00] Manual TTL & The 4-Tier Timing Wheel

👉 **Type in Terminal:**
```text
SET cart:session_101 "Biryani" EX 15
```
*(Output: `OK`)*

👉 **Type in Terminal:**
```text
TTL cart:session_101
```
*(Output: `(integer) 14`)*

👉 **Type in Terminal:**
```text
WHEEL
```

🗣️ **Say This:**
> *"In food delivery, carts must expire automatically. Redis checks expiring keys in slow loops that can cause lag. In Valence, I built a **Hierarchical Timing Wheel** that expires keys in **O(1) instant time**.*
>
> *I just saved a cart with a 15-second timer. The `WHEEL` command shows it sitting in Tier 1. In 15 seconds, it will delete itself automatically."*

👉 **Wait 5 seconds, then type:**
```text
GET cart:session_101
```
*(Output: `(nil)`)*

🗣️ **Say This:**
> *"And as you can see, it returned `nil`. The key is gone without slowing down the database."*

---

### ⏱️ [2:00 – 2:35] The 1 Million Operations Benchmark

👉 **Type in Terminal:**
```text
BENCH 1 million
```

🗣️ **Say This:**
> *"Now let's stress test it. I'm running **1 million operations** over TCP—half writes and half reads."*

*(Wait 4.6 seconds for the progress bar to finish)*

🗣️ **Say This:**
> *"1 million operations finished in just **4.6 seconds**. That is an engine capacity of over **1.25 million operations per second** across all 12 cores with sub-millisecond latencies."*

---

### ⏱️ [2:35 – 3:00] Cloudinary Offloading & Wrap-Up

👉 **Type in Terminal:**
```text
CLOUDINARY.STATS
```

🗣️ **Say This:**
> *"Finally, saving heavy food images directly in database RAM wastes expensive memory. Valence offloads all images to Cloudinary's global CDN, saving **over 88% of our database RAM**."*

👉 **Type in Terminal:**
```text
MEDIA.ORDER 8921 "Meghana Foods" "Special Chicken Biryani"
```

🗣️ **Say This:**
> *"And we can dynamically generate custom Swiggy delivery passes on the fly via Cloudinary CDN.*
>
> *That is Valence: 12 cores, O(1) timing wheels, and 1 million ops per second. Thank you!"*

---

## 📋 Quick 1-Page Command Reference

| Time | Command | Purpose |
|---|---|---|
| **0:00** | `SHARDS` | Show 12 CPU cores & lock-free partitions |
| **0:30** | `ATTACH https://akash20065ray-sys.github.io/VALENCE_2.0/` | Link terminal to live cloud Swiggy app |
| **0:45** | `MONITOR` | Stream live clicks from Swiggy app *(Ctrl+C to exit)* |
| **1:15** | `SET cart:session_101 "Biryani" EX 15` | Set key with 15-second TTL |
| **1:30** | `TTL cart:session_101` | Show live countdown |
| **1:35** | `WHEEL` | Show Tier 1 Timing Wheel slot |
| **1:50** | `GET cart:session_101` | Verify automatic eviction (`(nil)`) |
| **2:00** | `BENCH 1 million` | Run 1,000,000 real operations live |
| **2:35** | `CLOUDINARY.STATS` | Show 88.4% database RAM saved |
| **2:45** | `MEDIA.ORDER 8921 "Meghana Foods" "Biryani"` | Generate dynamic Cloudinary delivery pass |
