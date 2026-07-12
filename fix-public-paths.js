const fs = require("fs");
const path = require("path");

const folders = ["src", "app", "pages", "components"];
const exts = [".js", ".jsx", ".ts", ".tsx", ".css", ".scss"];

function walk(dir) {
  if (!fs.existsSync(dir)) return;

  for (const file of fs.readdirSync(dir)) {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      walk(fullPath);
      continue;
    }

    if (!exts.includes(path.extname(file))) continue;

    let content = fs.readFileSync(fullPath, "utf8");
    const oldContent = content;

    // حذف /out من مسارات الصور والفيديو
    content = content.replace(/\/out\/assets\//g, "/assets/");
    content = content.replace(/\/out\/images\//g, "/images/");
    content = content.replace(/\/out\/videos\//g, "/videos/");
    content = content.replace(/\/out\//g, "/");

    if (content !== oldContent) {
      fs.writeFileSync(fullPath, content, "utf8");
      console.log("Fixed:", fullPath);
    }
  }
}

folders.forEach(folder => walk(path.join(__dirname, folder)));

console.log("✅ Done");