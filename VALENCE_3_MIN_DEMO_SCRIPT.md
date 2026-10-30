# 🎙️ VALENCE 2.0: OFFICIAL 3–4 MINUTE DEMO VIDEO SCRIPT
## (Dashboard First ➔ Attach Swiggy in Access & Security ➔ Query Workbench Live Execution)

> **Setup Before Recording / Presenting:**
> - Have **Valence Studio** open at: [https://valence-b8tm.onrender.com](https://valence-b8tm.onrender.com) (or `http://localhost:8080`)
> - Have **Swiggy App** open in another tab: [https://integration-browsing-coalition-chris.trycloudflare.com](https://integration-browsing-coalition-chris.trycloudflare.com) (or `http://localhost:3000`)
> - The left sidebar is pinned open by default.

---

### ⏱️ [0:00 – 0:45] STEP 1: Overview & Cockpit (Cold Start Architecture)

👉 **What to show on screen:**  
Full screen on **Overview & Cockpit** (`#view-overview`).

🗣️ **What to speak:**
> *"Hello everyone. Today I'm presenting **Valence 2.0**—a next-generation, lock-free in-memory state engine engineered from scratch in pure Rust, designed as a modern, multi-core replacement for Redis.
>
> On my screen is the Valence Studio control plane deployed live on Render at `valence-b8tm.onrender.com`. 
>
> Look at our live telemetry: the database engine on port 6379 currently starts at **0 keys in RAM**. There are no hardcoded mocks or static tables—every counter, shard status bar, and microsecond telemetry readout is bound live to hardware counters.
>
> Redis is fundamentally single-threaded and bottlenecks on modern multi-core CPUs due to global lock contention. Valence eliminates this with a **Thread-Per-Core architecture**, partitioning state across hardware cores with Murmur3 consistent hashing."*

---

### ⏱️ [0:45 – 1:20] STEP 2: Key Explorer, Hardware Matrix & Timing Wheel Engine

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

### ⏱️ [1:20 – 2:05] STEP 3: Cloudinary Edge CDN Media Hub

👉 **What to show on screen:**  
1. In the left sidebar under `EDGE MEDIA`, click **Cloudinary CDN Hub**.
2. Point out the top 4 KPIs:
   - **`Media Keys in RAM`**
   - **`98.0% DRAM Preserved`**
   - **`97.8% Edge Bandwidth Saved`**
   - **`4.2 ms Global Edge TTFB`**
3. Click the green button: **`[⚡ Test Ingest Pipeline]`**.
   - Alert confirms: `Ingested sample media into Valence Port 6379! 16-byte RAM pointers stored.`. Click **OK**.
   - Show the table populated with live pointers (`hyderabadi_biryani`, `butter_chicken`, `paneer_tikka`).
4. **Drag the interactive comparison slider** back and forth (Left: 4.2 MB raw JPEG vs Right: 84 KB WebP with `f_auto, q_auto:good, g_auto:food`).

🗣️ **What to speak:**
> *"The biggest memory killer in food and e-commerce databases is media bloat. Storing high-resolution food banners directly in RAM causes database memory to explode.
>
> Valence solves this through our native **Cloudinary CDN Hub**. Instead of holding massive 4-megabyte image payloads in RAM, Valence decouples heavy binary pixels to Cloudinary’s global edge CDN, while storing only lightweight **16-byte zero-copy pointers** inside our Rust RAM engine.
>
> On this interactive slider, you can see our automated edge pipeline applying dynamic format conversion, content-aware smart cropping, and auto-quality. We preserve **98% of server DRAM** while delivering images to mobile users with a **4.2 millisecond TTFB**."*

---

### ⏱️ [2:05 – 2:45] STEP 4: Access & Security (Attaching the Swiggy Consumer App)

👉 **What to show on screen:**  
1. In the left sidebar under `ADMINISTRATION`, click **Access & Security**.
2. Point your cursor to the top panel: **Application Peering & Ingress Control**.
3. In `Target Service URL / Port`, show `https://integration-browsing-coalition-chris.trycloudflare.com` (or `http://localhost:3000`).
4. Click the green button: **`[⚡ ATTACH APPLICATION]`**.
5. Alert pops up: `Attached successfully to http://localhost:3000 (Swiggy Food Delivery)!`. Click **OK**.
6. Point your mouse to the top header status pill: it turns green: **`● Attached: Swiggy Food Delivery (Port 3000)`**.

🗣️ **What to speak:**
> *"Now let's connect our consumer application. Under **Access & Security**, we have our **Application Peering & Ingress Control**.
>
> We enter our Swiggy food delivery service endpoint and click **Attach Application**.
>
> Instantly, Valence establishes a high-throughput RESP3 peering session. Notice the top header status pill immediately turns green: **Attached: Swiggy Food Delivery**. Our database is now directly linked with our consumer food ordering backend."*

---

### ⏱️ [2:45 – 3:30] STEP 5: Query Workbench & Live Swiggy State Execution

👉 **What to show on screen:**  
1. In the left sidebar, click **Query Workbench**.
2. In the code editor area (`type here valence command`), type or paste:
   ```redis
   SET swiggy:cart:user_81 '{"dish":"hyderabadi_biryani","qty":2,"price":499}' EX 300
   GET swiggy:cart:user_81
   ```
3. Click the blue/green **`[▶ Run]`** button.
4. Show the **Execution Results Card** appearing below:
   - Core tag: `C11`
   - Latency readout: **`0.18 µs`** (sub-microsecond execution!)
   - Output: `{"dish":"hyderabadi_biryani","qty":2,"price":499}`
5. Switch to the tab showing the **Swiggy App** (`https://integration-browsing-coalition-chris.trycloudflare.com`).
   - Click **`Add to Cart`** on Hyderabadi Biryani.
   - Point out that the consumer frontend communicates in real-time with this exact in-memory state.

🗣️ **What to speak:**
> *"Now let's test our live consumer data directly inside the **Query Workbench**.
>
> Here we can execute raw Redis RESP commands against Valence. I'll write a `SET` command storing user cart state for our attached Swiggy app with an active 300-second TTL, followed by a `GET` command.
>
> When I click **Run**, look at the execution result:
> Valence processes the query in **0.18 microseconds**, automatically routing the key to CPU Core 11 via Murmur3 hashing.
>
> Switching to our live Swiggy consumer app on this public URL, our food ordering frontend interacts directly with this ultra-fast state engine, powering cart reservations, order tracking, and restaurant menus with zero lag."*

---

### ⏱️ [3:30 – 3:50] STEP 6: Summary & Conclusion

👉 **What to show on screen:**  
Switch back to **Overview & Cockpit** or **Key Explorer** to show the live keys.

🗣️ **What to speak:**
> *"To conclude: **Valence 2.0** brings pure Rust safety, Thread-Per-Core lock-free concurrency, an O(1) Timing Wheel, and Cloudinary media decoupling to high-scale backend systems.
>
> It gives engineering teams full Redis wire-protocol compatibility with up to 10x lower latency and 98% lower memory costs.
>
> Thank you for your time!"*
