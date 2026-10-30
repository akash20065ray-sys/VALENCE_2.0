# 🎙️ VALENCE 2.0: OFFICIAL 3–4 MINUTE DEMO VIDEO SCRIPT
## (Dashboard Walkthrough First ➔ Swiggy in Query Workbench)

> **Setup Before Recording:**
> - Have **Valence Studio** open at: [http://localhost:8080](http://localhost:8080)
> - Have **Swiggy App** open in another tab: [https://openings-tennessee-conf-gate.trycloudflare.com](https://openings-tennessee-conf-gate.trycloudflare.com) (or `http://localhost:3000`)
> - The left sidebar is already pinned open by default.

---

### ⏱️ [0:00 – 0:50] STEP 1: Overview & Cockpit (Cold Start Architecture)

👉 **What to show on screen:**  
Full screen on **Overview & Cockpit** (`#view-overview`).

🗣️ **What to speak:**
> *"Hello everyone. Today I'm presenting **Valence 2.0**—a next-generation, lock-free in-memory state engine engineered from scratch in pure Rust, designed as a modern, multi-core replacement for Redis.
>
> On my screen is the Valence Studio control plane running locally on port 8080. 
>
> Look at our live telemetry: the database engine on port 6379 currently starts at **0 keys in RAM**. There are no hardcoded mocks or static tables—every counter, shard status bar, and microsecond telemetry readout is bound live to hardware counters.
>
> Redis is fundamentally single-threaded and bottlenecks on modern multi-core CPUs due to global lock contention. Valence eliminates this with a **Thread-Per-Core architecture**, partitioning state across hardware cores with Murmur3 consistent hashing."*

---

### ⏱️ [0:50 – 1:30] STEP 2: Key Explorer, Hardware Matrix & Timing Wheel Engine

👉 **What to show on screen:**  
1. Click **Key Explorer** in the left sidebar.
2. Click **Hardware Matrix** in the left sidebar.
3. Click **Timing Wheel Engine** in the left sidebar.

🗣️ **What to speak:**
> *"Let's explore the engine internals:
>
> First, in **Key Explorer**, every key stored in Valence is tracked with its physical memory footprint, active TTL, and exact hardware core affinity.
>
> Switching to the **Hardware Matrix**, you see our Thread-Per-Core design. Each CPU core owns an isolated memory shard with its own circular ring buffer. Requests never fight over global mutex locks—achieving true linear scaling.
>
> Next is our **Timing Wheel Engine**. For flash sales, cart reservation timeouts, and OTPs, traditional databases poll keys using slow $O(N)$ background scans. Valence replaces this with a hierarchical hardware timing wheel that fires expirations in true **O(1) constant time** with zero CPU spikes."*

---

### ⏱️ [1:30 – 2:25] STEP 3: Cloudinary Edge CDN Media Hub (The Image Decoupling Solution)

👉 **What to show on screen:**  
1. In the left sidebar under `EDGE MEDIA`, click **Cloudinary CDN Hub**.
2. Point out the top 4 KPIs:
   - **`Media Keys in RAM`**
   - **`98.0% DRAM Preserved`**
   - **`97.8% Edge Bandwidth Saved`**
   - **`4.2 ms Global Edge TTFB`**
3. Click the green button: **`[⚡ Test Ingest Pipeline]`**.
   - An alert pops up: `Ingested sample media into Valence Port 6379! 16-byte RAM pointers stored.`. Click **OK**.
   - Show the **Active Media Pointer Inventory** table immediately populated with `hyderabadi_biryani`, `butter_chicken`, and `paneer_tikka`.
4. **Drag the interactive split comparison slider** left and right with your mouse.
   - Show the Left side (Original Uncompressed: 4.2 MB raw JPEG).
   - Show the Right side (Cloudinary Edge Transformed: 84 KB WebP with `f_auto, q_auto:good, g_auto:food`).

🗣️ **What to speak:**
> *"The biggest memory killer in food and e-commerce databases is media bloat. If you store high-resolution food banners directly in RAM, your database memory explodes and costs thousands of dollars.
>
> Valence solves this through our native **Cloudinary CDN Hub**. Instead of holding massive 4-megabyte image payloads in RAM, Valence decouples heavy binary pixels to Cloudinary’s global edge CDN, while storing only lightweight **16-byte zero-copy pointers** inside our Rust RAM engine.
>
> On this interactive slider, you can see our automated edge pipeline applying dynamic format conversion, content-aware smart cropping, and auto-quality. We preserve **98% of server DRAM** while delivering images to mobile users with a **4.2 millisecond TTFB**."*

---

### ⏱️ [2:25 – 3:20] STEP 4: Query Workbench & Live Swiggy State Execution

👉 **What to show on screen:**  
1. Click **Query Workbench** in the left sidebar.
2. In the code editor area (`type here valence command`), type or paste:
   ```redis
   SET swiggy:cart:user_81 '{"dish":"hyderabadi_biryani","qty":2,"price":499}' EX 300
   GET swiggy:cart:user_81
   ```
3. Click the blue/green **`[▶ Run]`** button.
4. Show the **Execution Results Card** appearing below with:
   - Core badge (e.g. `C11`)
   - Latency tag: `0.18 µs`
   - Output: `{"dish":"hyderabadi_biryani","qty":2,"price":499}`
5. Switch to your other browser tab showing the **Swiggy App** (`https://openings-tennessee-conf-gate.trycloudflare.com`).
   - Click **`Add to Cart`** on Hyderabadi Biryani.
   - Point out that the consumer frontend communicates seamlessly with this exact in-memory state.

🗣️ **What to speak:**
> *"Now let's test our live consumer data directly inside the **Query Workbench**.
>
> Here we can execute raw Redis RESP commands against Valence. I'll write a `SET` command storing user cart state for our Swiggy food delivery app with an active 300-second TTL, followed by a `GET` command.
>
> When I click **Run**, look at the execution result:
> Valence processes the query in **sub-microseconds**, automatically routing the key to CPU Core 11 via Murmur3 hashing.
>
> Switching to our live Swiggy consumer app on this public URL, our food ordering frontend interacts directly with this ultra-fast state engine, powering cart reservations, order tracking, and restaurant menus with zero lag."*

---

### ⏱️ [3:20 – 3:45] STEP 5: Summary & Conclusion

👉 **What to show on screen:**  
Switch back to **Overview & Cockpit** or **Key Explorer** to show the newly added keys in the live table.

🗣️ **What to speak:**
> *"To conclude: **Valence 2.0** brings pure Rust safety, Thread-Per-Core lock-free concurrency, an $O(1)$ Timing Wheel, and Cloudinary media decoupling to high-scale backend systems.
>
> It gives engineering teams full Redis wire-protocol compatibility with up to 10x lower latency and 98% lower memory costs.
>
> Thank you for your time!"*
