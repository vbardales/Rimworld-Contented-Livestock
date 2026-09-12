// Run with NODE_PATH pointing to a directory containing playwright and sharp.
const fs=require('fs'),path=require('path'),http=require('http');
const {chromium}=require('playwright'),sharp=require('sharp');
const root=path.resolve(__dirname,'..');
function lum(rgb){return rgb.map(x=>{x/=255;return x<=.04045?x/12.92:((x+.055)/1.055)**2.4;}).reduce((a,x,i)=>a+x*[.2126,.7152,.0722][i],0);}
function ratio(a,b){return (Math.max(a,b)+.05)/(Math.min(a,b)+.05);}
(async()=>{
 const server=http.createServer((req,res)=>{const p=path.resolve(root,'.'+decodeURIComponent(req.url.split('?')[0]));if(!p.startsWith(root+path.sep)){res.writeHead(403).end();return;}fs.readFile(p,(e,b)=>{if(e){res.writeHead(404).end();return;}res.setHeader('Content-Type',p.endsWith('.html')?'text/html':p.endsWith('.json')?'application/json':p.endsWith('.xml')?'application/xml':p.endsWith('.png')?'image/png':'text/plain');res.end(b);});});
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try{
 browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 const page=await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
 await page.goto(`http://127.0.0.1:${server.address().port}/Art/preview.html`);
 const config=await page.evaluate(()=>window.previewReady);
 const cdp=await page.context().newCDPSession(page);await cdp.send('DOM.enable');await cdp.send('CSS.enable');
 const {root:dom}=await cdp.send('DOM.getDocument');
 const fonts={};for(const selector of ['.name','.summary','.version']){const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:dom.nodeId,selector});fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;}
 const boxes=await page.evaluate(()=>Object.fromEntries(['.name','.summary','.version'].map(s=>{const r=document.querySelector(s).getBoundingClientRect();return [s,{x:r.x,y:r.y,width:r.width,height:r.height}];})));
 const png=await page.screenshot();
 await sharp(png).png({compressionLevel:9}).toFile(path.join(root,'Mod/About/Preview.png'));
 await sharp(png).resize({width:268}).png().toFile(path.join(__dirname,'preview-268.png'));
 await page.addStyleTag({content:'.name,.summary,.version {visibility:hidden;}'});
 const background=await page.screenshot();await sharp(background).png().toFile(path.join(__dirname,'preview-background.png'));
 const {data,info}=await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
 const primary=lum(config.palette.inkPrimary.match(/[a-f\d]{2}/gi).map(x=>parseInt(x,16)));
 const contrasts={};
 for(const selector of ['.name','.summary']){const b=boxes[selector];let min=Infinity,point;
 for(let y=Math.floor(b.y);y<Math.ceil(b.y+b.height);y++)for(let x=Math.floor(b.x);x<Math.ceil(b.x+b.width);x++){const i=(y*info.width+x)*3;const r=ratio(primary,lum([...data.slice(i,i+3)]));if(r<min){min=r;point=[x,y];}}
 contrasts[selector]={minimum:min,point,method:'Every pixel of bounding rectangle on rendered background without text'};
 }
 const hexLum=h=>lum(h.match(/[a-f\d]{2}/gi).map(x=>parseInt(x,16)));
 contrasts.badge={minimum:ratio(hexLum(config.palette.accent),hexLum(config.palette.badgeInk))};
 contrasts.tag={applicable:false,reason:'Public original mod; no tag'};
 const report={size:[896,504],thumbnailWidth:268,bytes:fs.statSync(path.join(root,'Mod/About/Preview.png')).size,version:config.version,fonts,boxes,contrasts};
 fs.writeFileSync(path.join(__dirname,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
 if(Object.values(contrasts).some(c=>c.minimum<4.5))throw Error('Contrast below 4.5');
 if(report.bytes>=900000)throw Error('Preview exceeds 900 KB');
 if(Object.values(fonts).flat().some(f=>!f.familyName.includes('Segoe UI')))throw Error('Unexpected fallback font');
 }finally{if(browser)await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
