import"./hoisted.BI9sxElo.js";function f(e){return new Date(e).toLocaleDateString("en-US",{year:"numeric",month:"long",day:"numeric"})}function y(e,o=new Date){const n=o.toISOString().split("T")[0],t=e.find(c=>c.date===n);if(t)return t;const r=new Date(o.getFullYear(),0,0),l=o-r,a=1e3*60*60*24,i=Math.floor(l/a);return e[i%e.length]}async function p(){try{const o=await(await fetch("/data/quotes.json")).json(),n=new Date,t=y(o,n),r=f(n.toISOString().split("T")[0]);document.getElementById("date-string").textContent=r;const a=encodeURIComponent("https://www.successquotes.co/daily"),c=`https://twitter.com/intent/tweet?text=${encodeURIComponent(`Today's Success Quote: "${t.quote}" - ${t.author}`)}&url=${a}`,u=`https://www.facebook.com/sharer/sharer.php?u=${a}`,d=`https://www.linkedin.com/sharing/share-offsite/?url=${a}`,g=`
          <div style="width: 100%;">
            <blockquote class="quote-text" style="font-size: 2.2em; margin-bottom: 30px;">
              "${t.quote}"
            </blockquote>
            
            <p class="quote-author" style="font-size: 1.4em; margin-bottom: 25px;">
              — ${t.author}
            </p>
            
            <!-- Meta Tags -->
            <div class="quote-meta">
              ${t.topic?`<a href="/topic/${t.topicSlug}" class="quote-tag">${t.topic}</a>`:""}
              ${t.category?`<a href="/category/${t.categorySlug}" class="quote-tag">${t.category}</a>`:""}
              <a href="/author/${t.authorSlug}" class="quote-tag">More by ${t.author}</a>
            </div>
            
            <!-- Share Buttons -->
            <div class="share-buttons">
              <a href="${c}" target="_blank" rel="noopener noreferrer" class="share-btn" title="Share on Twitter">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z"/>
                </svg>
              </a>
              <a href="${u}" target="_blank" rel="noopener noreferrer" class="share-btn" title="Share on Facebook">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/>
                </svg>
              </a>
              <a href="${d}" target="_blank" rel="noopener noreferrer" class="share-btn" title="Share on LinkedIn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"/>
                  <circle cx="4" cy="4" r="2"/>
                </svg>
              </a>
              <button class="share-btn" title="Copy link" onclick="copyToClipboard()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71"/>
                  <path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71"/>
                </svg>
              </button>
            </div>
          </div>
        `,s=document.getElementById("quote-card");s.style.display="block",s.style.alignItems="flex-start",s.style.justifyContent="flex-start",s.innerHTML=g;const h=document.getElementById("view-quote-btn");h.href=`/quote/${t.authorSlug}/${t.slug}`,h.style.display="inline-block",document.title=`Quote of the Day - ${r} | Success Quotes`}catch(e){console.error("Error loading quote:",e),document.getElementById("quote-card").innerHTML=`<div style="color: #888;">Failed to load today's quote. Please refresh the page.</div>`}}p();
