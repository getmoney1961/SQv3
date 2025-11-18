import"./hoisted.BI9sxElo.js";let n=[],e=null;async function i(){try{n=await(await fetch("/data/quotes.json")).json()}catch(t){console.error("Error loading quotes:",t)}}function d(){if(n.length===0){alert("Loading quotes... Please try again in a moment.");return}const t=Math.floor(Math.random()*n.length);e=n[t],document.getElementById("loadingState").style.display="none",document.getElementById("quoteContent").style.display="block",document.getElementById("quoteText").textContent=`"${e.quote}"`,document.getElementById("quoteAuthor").textContent=`— ${e.author}`;const o=[];if(e.topic){const a=e.topic.toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,"");o.push(`<a href="/topic/${a}" class="quote-tag">${e.topic}</a>`)}if(e.category){const a=e.category.toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,"");o.push(`<a href="/category/${a}" class="quote-tag">${e.category}</a>`)}const r=e.author.toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,"");o.push(`<a href="/author/${r}" class="quote-tag">More by ${e.author}</a>`),document.getElementById("quoteMeta").innerHTML=o.join("");const u=e.quote.split(" ").slice(0,10).join(" ").toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,"").substring(0,60),s=`https://www.successquotes.co/quote/${r}/${u}`,c=encodeURIComponent(s),h=`
        <a href="https://twitter.com/intent/tweet?text=${encodeURIComponent(`"${e.quote}" - ${e.author}`)}&url=${c}" target="_blank" rel="noopener noreferrer" class="share-btn" title="Share on Twitter">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z"/>
          </svg>
        </a>
        <a href="https://www.facebook.com/sharer/sharer.php?u=${c}" target="_blank" rel="noopener noreferrer" class="share-btn" title="Share on Facebook">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/>
          </svg>
        </a>
        <a href="${s}" class="share-btn" title="View full quote page">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71"/>
            <path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71"/>
          </svg>
        </a>
      `;document.getElementById("shareButtons").innerHTML=h,document.getElementById("generateBtn").textContent="🎲 Generate Another Quote";const l=document.getElementById("quoteCard");l.style.opacity="0.5",setTimeout(()=>{l.style.opacity="1"},100)}i();document.addEventListener("DOMContentLoaded",function(){const t=document.getElementById("generateBtn");t&&t.addEventListener("click",d)});
