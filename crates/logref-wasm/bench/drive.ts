// Serve the bench dir statically, drive it in headless Chromium, wait for the
// benchmark to finish, screenshot the results, and print the numbers.
// Prereq: run bench/build.sh first (produces the gitignored runtime artifacts).
import { join } from "node:path";
import { chromium } from "playwright-core";

const DIR = import.meta.dir;
const PORT = 4599;

const CT: Record<string, string> = {
  ".html": "text/html", ".js": "text/javascript", ".wasm": "application/wasm",
  ".jsonl": "application/x-ndjson", ".json": "application/json",
};

const server = Bun.serve({
  port: PORT,
  async fetch(req) {
    let p = new URL(req.url).pathname;
    if (p === "/") p = "/index.html";
    const file = Bun.file(DIR + p);
    if (!(await file.exists())) return new Response("not found", { status: 404 });
    const ext = p.slice(p.lastIndexOf("."));
    return new Response(file, { headers: { "content-type": CT[ext] ?? "application/octet-stream" } });
  },
});

const browser = await chromium.launch({
  executablePath: "/opt/pw-browsers/chromium-1194/chrome-linux/chrome",
});
const page = await browser.newPage({ viewport: { width: 900, height: 640 } });
page.on("console", (m) => console.log("[page]", m.text()));
page.on("pageerror", (e) => console.log("[pageerror]", e.message));

await page.goto(`http://localhost:${PORT}/`, { waitUntil: "load" });

// Wait for the benchmark to set its global (or error).
await page.waitForFunction(() => (window as any).__BENCH_DONE__ || (window as any).__BENCH_ERROR__, null, { timeout: 60000 });

const err = await page.evaluate(() => (window as any).__BENCH_ERROR__);
if (err) { console.log("BENCH ERROR:\n" + err); await browser.close(); server.stop(); process.exit(1); }

const result = await page.evaluate(() => (window as any).__BENCH_DONE__);
await page.waitForTimeout(300);
const out = process.argv[2] ?? join(DIR, "..", "..", "..", "scratch-bench.png");
await page.screenshot({ path: out, fullPage: true });

console.log("\n=== BENCHMARK RESULT ===");
console.log(JSON.stringify(result, null, 2));
console.log("screenshot:", out);

await browser.close();
server.stop();
