import '@astrojs/internal-helpers/path';
import 'cookie';
import 'kleur/colors';
import 'es-module-lexer';
import { N as NOOP_MIDDLEWARE_HEADER, g as decodeKey } from './chunks/astro/server_BeBUPZLl.mjs';
import 'clsx';
import 'html-escaper';

const NOOP_MIDDLEWARE_FN = async (_ctx, next) => {
  const response = await next();
  response.headers.set(NOOP_MIDDLEWARE_HEADER, "true");
  return response;
};

const codeToStatusMap = {
  // Implemented from tRPC error code table
  // https://trpc.io/docs/server/error-handling#error-codes
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  TIMEOUT: 405,
  CONFLICT: 409,
  PRECONDITION_FAILED: 412,
  PAYLOAD_TOO_LARGE: 413,
  UNSUPPORTED_MEDIA_TYPE: 415,
  UNPROCESSABLE_CONTENT: 422,
  TOO_MANY_REQUESTS: 429,
  CLIENT_CLOSED_REQUEST: 499,
  INTERNAL_SERVER_ERROR: 500
};
Object.entries(codeToStatusMap).reduce(
  // reverse the key-value pairs
  (acc, [key, value]) => ({ ...acc, [value]: key }),
  {}
);

function sanitizeParams(params) {
  return Object.fromEntries(
    Object.entries(params).map(([key, value]) => {
      if (typeof value === "string") {
        return [key, value.normalize().replace(/#/g, "%23").replace(/\?/g, "%3F")];
      }
      return [key, value];
    })
  );
}
function getParameter(part, params) {
  if (part.spread) {
    return params[part.content.slice(3)] || "";
  }
  if (part.dynamic) {
    if (!params[part.content]) {
      throw new TypeError(`Missing parameter: ${part.content}`);
    }
    return params[part.content];
  }
  return part.content.normalize().replace(/\?/g, "%3F").replace(/#/g, "%23").replace(/%5B/g, "[").replace(/%5D/g, "]");
}
function getSegment(segment, params) {
  const segmentPath = segment.map((part) => getParameter(part, params)).join("");
  return segmentPath ? "/" + segmentPath : "";
}
function getRouteGenerator(segments, addTrailingSlash) {
  return (params) => {
    const sanitizedParams = sanitizeParams(params);
    let trailing = "";
    if (addTrailingSlash === "always" && segments.length) {
      trailing = "/";
    }
    const path = segments.map((segment) => getSegment(segment, sanitizedParams)).join("") + trailing;
    return path || "/";
  };
}

function deserializeRouteData(rawRouteData) {
  return {
    route: rawRouteData.route,
    type: rawRouteData.type,
    pattern: new RegExp(rawRouteData.pattern),
    params: rawRouteData.params,
    component: rawRouteData.component,
    generate: getRouteGenerator(rawRouteData.segments, rawRouteData._meta.trailingSlash),
    pathname: rawRouteData.pathname || void 0,
    segments: rawRouteData.segments,
    prerender: rawRouteData.prerender,
    redirect: rawRouteData.redirect,
    redirectRoute: rawRouteData.redirectRoute ? deserializeRouteData(rawRouteData.redirectRoute) : void 0,
    fallbackRoutes: rawRouteData.fallbackRoutes.map((fallback) => {
      return deserializeRouteData(fallback);
    }),
    isIndex: rawRouteData.isIndex
  };
}

function deserializeManifest(serializedManifest) {
  const routes = [];
  for (const serializedRoute of serializedManifest.routes) {
    routes.push({
      ...serializedRoute,
      routeData: deserializeRouteData(serializedRoute.routeData)
    });
    const route = serializedRoute;
    route.routeData = deserializeRouteData(serializedRoute.routeData);
  }
  const assets = new Set(serializedManifest.assets);
  const componentMetadata = new Map(serializedManifest.componentMetadata);
  const inlinedScripts = new Map(serializedManifest.inlinedScripts);
  const clientDirectives = new Map(serializedManifest.clientDirectives);
  const serverIslandNameMap = new Map(serializedManifest.serverIslandNameMap);
  const key = decodeKey(serializedManifest.key);
  return {
    // in case user middleware exists, this no-op middleware will be reassigned (see plugin-ssr.ts)
    middleware() {
      return { onRequest: NOOP_MIDDLEWARE_FN };
    },
    ...serializedManifest,
    assets,
    componentMetadata,
    inlinedScripts,
    clientDirectives,
    routes,
    serverIslandNameMap,
    key
  };
}

const manifest = deserializeManifest({"hrefRoot":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/","adapterName":"","routes":[{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/app/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/app","isIndex":false,"type":"page","pattern":"^\\/app\\/?$","segments":[[{"content":"app","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/app.astro","pathname":"/app","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/book/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/book","isIndex":false,"type":"page","pattern":"^\\/book\\/?$","segments":[[{"content":"book","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/book.astro","pathname":"/book","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/daily/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/daily","isIndex":false,"type":"page","pattern":"^\\/daily\\/?$","segments":[[{"content":"daily","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/daily.astro","pathname":"/daily","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/quotes/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/quotes","isIndex":false,"type":"page","pattern":"^\\/quotes\\/?$","segments":[[{"content":"quotes","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/quotes.astro","pathname":"/quotes","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/random/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/random","isIndex":false,"type":"page","pattern":"^\\/random\\/?$","segments":[[{"content":"random","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/random.astro","pathname":"/random","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/search/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/search","isIndex":false,"type":"page","pattern":"^\\/search\\/?$","segments":[[{"content":"search","dynamic":false,"spread":false}]],"params":[],"component":"src/pages/search.astro","pathname":"/search","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}},{"file":"file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/index.html","links":[],"scripts":[],"styles":[],"routeData":{"route":"/","isIndex":true,"type":"page","pattern":"^\\/$","segments":[],"params":[],"component":"src/pages/index.astro","pathname":"/","prerender":true,"fallbackRoutes":[],"_meta":{"trailingSlash":"ignore"}}}],"site":"https://www.successquotes.co","base":"/","trailingSlash":"ignore","compressHTML":true,"componentMetadata":[["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/app.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/index.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/author/[author].astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/book.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/category/[category].astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/daily.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/quote/[author]/[slug].astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/quotes.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/random.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/search.astro",{"propagation":"none","containsHead":true}],["/Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder/src/pages/topic/[topic].astro",{"propagation":"none","containsHead":true}]],"renderers":[],"clientDirectives":[["idle","(()=>{var l=(o,t)=>{let i=async()=>{await(await o())()},e=typeof t.value==\"object\"?t.value:void 0,s={timeout:e==null?void 0:e.timeout};\"requestIdleCallback\"in window?window.requestIdleCallback(i,s):setTimeout(i,s.timeout||200)};(self.Astro||(self.Astro={})).idle=l;window.dispatchEvent(new Event(\"astro:idle\"));})();"],["load","(()=>{var e=async t=>{await(await t())()};(self.Astro||(self.Astro={})).load=e;window.dispatchEvent(new Event(\"astro:load\"));})();"],["media","(()=>{var s=(i,t)=>{let a=async()=>{await(await i())()};if(t.value){let e=matchMedia(t.value);e.matches?a():e.addEventListener(\"change\",a,{once:!0})}};(self.Astro||(self.Astro={})).media=s;window.dispatchEvent(new Event(\"astro:media\"));})();"],["only","(()=>{var e=async t=>{await(await t())()};(self.Astro||(self.Astro={})).only=e;window.dispatchEvent(new Event(\"astro:only\"));})();"],["visible","(()=>{var l=(s,i,o)=>{let r=async()=>{await(await s())()},t=typeof i.value==\"object\"?i.value:void 0,c={rootMargin:t==null?void 0:t.rootMargin},n=new IntersectionObserver(e=>{for(let a of e)if(a.isIntersecting){n.disconnect(),r();break}},c);for(let e of o.children)n.observe(e)};(self.Astro||(self.Astro={})).visible=l;window.dispatchEvent(new Event(\"astro:visible\"));})();"]],"entryModules":{"\u0000noop-middleware":"_noop-middleware.mjs","\u0000@astro-page:src/pages/app@_@astro":"pages/app.astro.mjs","\u0000@astro-page:src/pages/author/[author]@_@astro":"pages/author/_author_.astro.mjs","\u0000@astro-page:src/pages/book@_@astro":"pages/book.astro.mjs","\u0000@astro-page:src/pages/category/[category]@_@astro":"pages/category/_category_.astro.mjs","\u0000@astro-page:src/pages/daily@_@astro":"pages/daily.astro.mjs","\u0000@astro-page:src/pages/quote/[author]/[slug]@_@astro":"pages/quote/_author_/_slug_.astro.mjs","\u0000@astro-page:src/pages/quotes@_@astro":"pages/quotes.astro.mjs","\u0000@astro-page:src/pages/random@_@astro":"pages/random.astro.mjs","\u0000@astro-page:src/pages/search@_@astro":"pages/search.astro.mjs","\u0000@astro-page:src/pages/topic/[topic]@_@astro":"pages/topic/_topic_.astro.mjs","\u0000@astro-page:src/pages/index@_@astro":"pages/index.astro.mjs","\u0000@astro-renderers":"renderers.mjs","\u0000@astrojs-manifest":"manifest_CjXId928.mjs","/astro/hoisted.js?q=0":"_astro/hoisted.BaodTBRM.js","/astro/hoisted.js?q=1":"_astro/hoisted.CeUu_NZp.js","/astro/hoisted.js?q=2":"_astro/hoisted.B5WOO3GU.js","/astro/hoisted.js?q=4":"_astro/hoisted.BXLRl9Lf.js","/astro/hoisted.js?q=5":"_astro/hoisted.BhjDKJvu.js","/astro/hoisted.js?q=6":"_astro/hoisted.Bhsa22xr.js","/astro/hoisted.js?q=3":"_astro/hoisted.BI9sxElo.js","/astro/hoisted.js?q=7":"_astro/hoisted.BAWyitoc.js","astro:scripts/before-hydration.js":""},"inlinedScripts":[],"assets":["/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/app/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/book/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/daily/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/quotes/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/random/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/search/index.html","/file:///Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/docs/index.html"],"buildFormat":"directory","checkOrigin":false,"serverIslandNameMap":[],"key":"36a43TM0Z2wWicWwUTk7Jjujsn1EYj2GRDBQGnfOEaU=","experimentalEnvGetSecretEnabled":false});

export { manifest };
