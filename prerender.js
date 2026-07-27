import puppeteer from "puppeteer";
import express from "express";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DIST_DIR = path.resolve(__dirname, "dist/client");

// Production API base URL.
// The API is exposed publicly at:
// https://api-shop.yarotech.com.ng/api
const API_URL = "https://api-shop.yarotech.com.ng/api".replace(/\/+$/, "");

async function getProductSlugs() {
  console.log("📦 Fetching products from API...");

  const url = `${API_URL}/products?per_page=1000`;
  console.log(`🌐 Product API URL: ${url}`);

  try {
    const res = await fetch(url);

    if (!res.ok) {
      console.warn(`⚠️ Product API returned ${res.status}. Continuing without product routes.`);
      return [];
    }

    const data = await res.json();
    const items = data?.data?.items;

    if (!Array.isArray(items)) {
      console.warn("⚠️ Product API response did not contain data.items array. Continuing without product routes.");
      return [];
    }

    const slugs = items
      .map((product) => product?.slug)
      .filter(Boolean);

    console.log(`✅ Found ${slugs.length} products.`);
    return slugs;
  } catch (err) {
    console.warn("⚠️ Failed to fetch products. Continuing without product routes.");
    console.warn(err);
    return [];
  }
}

async function generateSitemap() {
  console.log("🗺️ Generating sitemap...");

  const url = `${API_URL}/sitemap.xml`;
  console.log(`🌐 Sitemap URL: ${url}`);

  try {
    const res = await fetch(url);

    if (!res.ok) {
      console.warn(`⚠️ Sitemap endpoint returned ${res.status}. Skipping sitemap generation.`);
      return;
    }

    const xml = await res.text();

    await fs.writeFile(
      path.join(DIST_DIR, "sitemap.xml"),
      xml,
      "utf8"
    );

    console.log("✅ sitemap.xml generated.");
  } catch (err) {
    console.warn("⚠️ Failed to generate sitemap. Continuing build.");
    console.warn(err);
  }
}

async function main() {
  const indexPath = path.join(DIST_DIR, "index.html");
  const spaPath = path.join(DIST_DIR, "spa.html");

  try {
    await fs.access(indexPath);
  } catch {
    console.error(`❌ Could not find ${indexPath}. Run the Vite build first.`);
    process.exit(1);
  }

  try {
    await fs.copyFile(indexPath, spaPath);
    console.log("✅ Copied index.html → spa.html");
  } catch (err) {
    console.error("❌ Unable to create spa.html");
    console.error(err);
    process.exit(1);
  }

  const app = express();
  app.use(express.static(DIST_DIR));
  app.use((req, res) => {
    res.sendFile(spaPath);
  });

  const server = app.listen(0, async () => {
    const address = server.address();
    const port = typeof address === "object" && address !== null ? address.port : null;

    if (!port) {
      console.error("❌ Could not determine local server port.");
      server.close();
      process.exit(1);
    }

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
    const productRoutes = slugs.map((slug) => `/shop/${slug}`);
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
          "--disable-software-rasterizer",
          "--no-zygote",
        ],
      });

      console.log("✅ Browser launched.");

      const page = await browser.newPage();
      console.log("✅ New page created.");

      page.setDefaultNavigationTimeout(120000);
      page.setDefaultTimeout(120000);

      for (const route of allRoutes) {
        const url = `http://localhost:${port}${route}`;
        console.log(`\n=================================`);
        console.log(`Rendering: ${route}`);
        console.log(`=================================`);

        try {
          await page.goto(url, {
            waitUntil: "networkidle2",
            timeout: 120000,
          });

          await new Promise((resolve) => setTimeout(resolve, 1000));

          const html = await page.content();

          let outputPath;
          if (route === "/") {
            outputPath = path.join(DIST_DIR, "index.html");
          } else {
            const cleanRoute = route.replace(/^\/|\/$/g, "");
            const routeDir = path.join(DIST_DIR, cleanRoute);

            await fs.mkdir(routeDir, { recursive: true });
            outputPath = path.join(routeDir, "index.html");
          }

          await fs.writeFile(outputPath, html, "utf8");
          console.log(`✅ Done (${route})`);
        } catch (err) {
          console.error(`❌ Failed to prerender ${route}`);
          console.error(err);
        }
      }

      console.log("\n🎉 All routes processed.");
    } catch (err) {
      console.error("❌ Browser error");
      console.error(err);
    } finally {
      if (browser) {
        try {
          await browser.close();
          console.log("✅ Browser closed.");
        } catch (err) {
          console.warn("⚠️ Browser close failed.");
          console.warn(err);
        }
      }

      server.close(() => {
        console.log("✅ Local server stopped.");
      });
    }
  });
}

main().catch((err) => {
  console.error("❌ Fatal prerender error:");
  console.error(err);
  process.exit(1);
});