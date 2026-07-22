import puppeteer from "puppeteer";
import express from "express";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DIST_DIR = path.resolve(__dirname, "dist/client");

async function getProductSlugs() {
  console.log("📦 Fetching products from API...");

  try {
    const res = await fetch(
      "https://shop.y.yarotech.com.ng/yarotech-api/public/api/products?per_page=1000"
    );

    if (!res.ok) {
      throw new Error(`API returned ${res.status}`);
    }

    const data = await res.json();

    if (data?.data?.items) {
      const slugs = data.data.items
        .map((p) => p.slug)
        .filter(Boolean);

      console.log(`✅ Found ${slugs.length} products.`);
      return slugs;
    }
  } catch (err) {
    console.error("❌ Failed to fetch products:");
    console.error(err);
  }

  return [];
}

async function generateSitemap() {
  try {
    console.log("🗺️ Generating sitemap...");

    const res = await fetch(
      "https://shop.y.yarotech.com.ng/yarotech-api/public/api/sitemap.xml"
    );

    if (!res.ok) {
      throw new Error(`Status ${res.status}`);
    }

    const xml = await res.text();

    await fs.writeFile(
      path.join(DIST_DIR, "sitemap.xml"),
      xml,
      "utf8"
    );

    console.log("✅ sitemap.xml generated.");
  } catch (err) {
    console.error("❌ Failed to generate sitemap");
    console.error(err);
  }
}

async function main() {
  const indexPath = path.join(DIST_DIR, "index.html");
  const spaPath = path.join(DIST_DIR, "spa.html");

  try {
    await fs.copyFile(indexPath, spaPath);
    console.log("✅ Copied index.html → spa.html");
  } catch (err) {
    console.error("Unable to create spa.html");
    console.error(err);
    return;
  }

  const app = express();

  app.use(express.static(DIST_DIR));

  app.use((req, res) => {
    res.sendFile(spaPath);
  });

  const server = app.listen(0, async () => {
    const port = server.address().port;

    console.log(`🚀 Local server started on port ${port}`);

    const staticRoutes = [
      "/",
      "/about",
      "/contact",
      "/services",
      "/projects",
      "/privacy",
      "/terms",
      "/shop",
    ];

    const slugs = await getProductSlugs();

    const productRoutes = slugs.map(
      (slug) => `/shop/${slug}`
    );

    const allRoutes = [...staticRoutes, ...productRoutes];

    console.log(`📄 Total routes: ${allRoutes.length}`);

    await generateSitemap();

    let browser;

    try {
      console.log("🌐 Launching Chromium...");

      browser = await puppeteer.launch({
        headless: true,
        protocolTimeout: 120000,
        args: [
          "--no-sandbox",
          "--disable-setuid-sandbox",
          "--disable-dev-shm-usage",
          "--disable-gpu",
        ],
      });

      console.log("✅ Browser launched.");

      const page = await browser.newPage();

      console.log("✅ New page created.");

      page.setDefaultNavigationTimeout(120000);
      page.setDefaultTimeout(120000);

      for (const route of allRoutes) {
        const start = Date.now();

        console.log("");
        console.log("=================================");
        console.log(`Rendering: ${route}`);
        console.log("=================================");

        try {
          await page.goto(
            `http://localhost:${port}${route}`,
            {
              waitUntil: "domcontentloaded",
              timeout: 120000,
            }
          );

          // Give React time to hydrate and fetch data
          await new Promise((resolve) =>
            setTimeout(resolve, 3000)
          );

          const html = await page.content();

          let savePath;

          if (route === "/") {
            savePath = path.join(
              DIST_DIR,
              "index.html"
            );
          } else {
            savePath = path.join(
              DIST_DIR,
              route.substring(1),
              "index.html"
            );

            await fs.mkdir(
              path.dirname(savePath),
              {
                recursive: true,
              }
            );
          }

          await fs.writeFile(
            savePath,
            html,
            "utf8"
          );

          console.log(
            `✅ Done (${Date.now() - start} ms)`
          );
        } catch (err) {
          console.error(`❌ Failed route: ${route}`);
          console.error(err);
        }
      }

      console.log("");
      console.log("🎉 All routes processed.");
    } catch (err) {
      console.error("");
      console.error("❌ Browser error");
      console.error(err);
    } finally {
      if (browser) {
        try {
          await browser.close();
          console.log("✅ Browser closed.");
        } catch {}
      }

      server.close(() => {
        console.log("✅ Local server stopped.");
      });
    }
  });
}

main().catch((err) => {
  console.error("Fatal error:");
  console.error(err);
});