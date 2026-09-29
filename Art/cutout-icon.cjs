// One-off: flood-fills the near-black background of ModIcon-source.png from its border inward,
// turning only the background transparent (the mascot ring's own dark outline is never touched,
// since it does not connect to the frame). Writes Art/ModIcon-cutout.png. Re-run by hand only if
// the source icon changes; its output is committed. Same approach as
// ManyHappyReturns/_tools/cutout-icon.cjs, adapted to this mod's file layout.
const sharp = require('sharp');
const path = require('path');
const root = path.resolve(__dirname, '..');
(async () => {
  const src = path.join(root, 'Art/ModIcon-source.png');
  const img = sharp(src).ensureAlpha();
  const { data, info } = await img.raw().toBuffer({ resolveWithObject: true });
  const { width: w, height: h, channels: c } = info;
  const isBg = i => data[i] < 12 && data[i + 1] < 12 && data[i + 2] < 12;
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
