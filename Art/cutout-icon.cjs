// One-off: flood-fills the background of ModIcon-source.png from its border inward, turning
// only the background transparent. The background is a near-black brown plate (~10,3,1); the
// mascot's own black linework (0,0,0 and darker) sits at Euclidean distance >=10 from that
// colour and never connects to the border, so it survives. A blind "<12 on every channel"
// threshold used to catch that linework too, since 0,0,0 also passes it — fixed by matching the
// background's own sampled colour within a radius instead of any generic near-black test.
// Writes Art/ModIcon-cutout.png. Re-run by hand only if the source icon changes; its output is
// committed. Same approach as ManyHappyReturns/_tools/cutout-icon.cjs, adapted to this mod's
// file layout.
const sharp = require('sharp');
const path = require('path');
const root = path.resolve(__dirname, '..');
(async () => {
  const src = path.join(root, 'Art/ModIcon-source.png');
  const img = sharp(src).ensureAlpha();
  const { data, info } = await img.raw().toBuffer({ resolveWithObject: true });
  const { width: w, height: h, channels: c } = info;
  let sr = 0, sg = 0, sb = 0, n = 0;
  for (let x = 0; x < w; x++) for (const y of [0, h - 1]) { const i = (y * w + x) * c; sr += data[i]; sg += data[i + 1]; sb += data[i + 2]; n++; }
  for (let y = 0; y < h; y++) for (const x of [0, w - 1]) { const i = (y * w + x) * c; sr += data[i]; sg += data[i + 1]; sb += data[i + 2]; n++; }
  const bg = [sr / n, sg / n, sb / n];
  const radius = 9.5;
  const isBg = i => {
    const dr = data[i] - bg[0], dg = data[i + 1] - bg[1], db = data[i + 2] - bg[2];
    return Math.sqrt(dr * dr + dg * dg + db * db) < radius;
  };
  const visited = new Uint8Array(w * h);
  const stack = [];
  for (let x = 0; x < w; x++) { stack.push([x, 0]); stack.push([x, h - 1]); }
  for (let y = 0; y < h; y++) { stack.push([0, y]); stack.push([w - 1, y]); }
  while (stack.length) {
    const [x, y] = stack.pop();
    if (x < 0 || y < 0 || x >= w || y >= h) continue;
    const p = y * w + x;
    if (visited[p]) continue;
    const i = p * c;
    if (!isBg(i)) continue;
    visited[p] = 1;
    data[i + 3] = 0;
    stack.push([x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]);
  }
  let removed = 0;
  for (let p = 0; p < w * h; p++) if (visited[p]) removed++;
  console.log(`removed ${removed} of ${w * h} pixels (${(100 * removed / (w * h)).toFixed(1)}%)`);
  await sharp(data, { raw: { width: w, height: h, channels: c } })
    .png({ compressionLevel: 9 })
    .toFile(path.join(root, 'Art/ModIcon-cutout.png'));
})();
