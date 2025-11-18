import"./hoisted.BI9sxElo.js";let i=[],l=[],r=0;const g=20,y=new URLSearchParams(window.location.search),o=y.get("q")||"";document.getElementById("searchInput").value=o;async function p(){try{i=await(await fetch("/data/quotes.json")).json(),o?m(o):(document.getElementById("loadingState").style.display="none",document.getElementById("noResults").style.display="block",document.getElementById("searchStats").innerHTML="Enter a search term to find quotes")}catch(e){console.error("Error loading quotes:",e),document.getElementById("loadingState").innerHTML='<p style="color: #ff6b6b;">Error loading quotes. Please try again.</p>'}}function m(e){const t=e.toLowerCase();l=i.filter(n=>n.quote.toLowerCase().includes(t)||n.author.toLowerCase().includes(t)||n.topic&&n.topic.toLowerCase().includes(t)||n.category&&n.category.toLowerCase().includes(t)),d()}function d(){const e=document.getElementById("loadingState"),t=document.getElementById("noResults"),n=document.getElementById("resultsContainer"),s=document.getElementById("searchStats");if(e.style.display="none",l.length===0){t.style.display="block",n.style.display="none",s.innerHTML=`No results found for "${o}"`;return}t.style.display="none",n.style.display="block",s.innerHTML=`Found <strong style="color: white;">${l.length}</strong> ${l.length===1?"result":"results"} for "<strong style="color: white;">${o}</strong>"`,r=0,document.getElementById("results").innerHTML="",u()}function u(){const e=document.getElementById("results"),t=document.getElementById("loadMoreContainer"),n=l.slice(r,r+g);n.forEach(s=>{const a=h(s);e.innerHTML+=a}),r+=n.length,r<l.length?t.style.display="block":t.style.display="none"}function h(e){const t=e.author.toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,""),n=e.quote.split(" ").slice(0,10).join(" ").toLowerCase().replace(/\s+/g,"-").replace(/[^\w\-]+/g,"").substring(0,60),s=`/quote/${t}/${n}`,a=c(e.quote,o);return`
        <article class="result-card">
          <a href="${s}" style="text-decoration: none;">
            <blockquote style="color: white; font-size: 1.2em; line-height: 1.6; font-family: 'Instrument Serif', serif; font-style: italic; margin-bottom: 15px;">
              "${a}"
            </blockquote>
            
            <p style="color: #888; margin-bottom: 15px;">
              — ${c(e.author,o)}
            </p>
            
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
              ${e.topic?`<span class="quote-tag" style="font-size: 0.85em;">${e.topic}</span>`:""}
              ${e.category?`<span class="quote-tag" style="font-size: 0.85em;">${e.category}</span>`:""}
            </div>
          </a>
        </article>
      `}function c(e,t){if(!t)return e;const n=new RegExp(`(${f(t)})`,"gi");return e.replace(n,'<span class="highlight">$1</span>')}function f(e){return e.replace(/[.*+?^${}()|[\]\\]/g,"\\$&")}document.querySelectorAll(".filter-btn").forEach(e=>{e.addEventListener("click",()=>{document.querySelectorAll(".filter-btn").forEach(t=>t.classList.remove("active")),e.classList.add("active"),e.dataset.filter,d()})});document.getElementById("loadMoreBtn")?.addEventListener("click",()=>{u()});document.getElementById("searchInput").addEventListener("keypress",e=>{if(e.key==="Enter"){const t=e.target.value.trim();t&&(window.location.href=`/search?q=${encodeURIComponent(t)}`)}});p();
