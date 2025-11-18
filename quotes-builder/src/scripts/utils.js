// Utility functions for quote processing

/**
 * Generate a URL-friendly slug from text
 */
export function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')           // Replace spaces with -
    .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
    .replace(/\-\-+/g, '-')         // Replace multiple - with single -
    .replace(/^-+/, '')             // Trim - from start
    .replace(/-+$/, '');            // Trim - from end
}

/**
 * Generate a unique quote slug from quote text and author
 */
export function generateQuoteSlug(quote, author) {
  // Take first 8-10 words of the quote
  const words = quote.split(' ').slice(0, 10).join(' ');
  const slug = slugify(words);
  return slug.substring(0, 60); // Limit length for URLs
}

/**
 * Generate author slug
 */
export function generateAuthorSlug(author) {
  return slugify(author);
}

/**
 * Generate topic slug
 */
export function generateTopicSlug(topic) {
  return slugify(topic);
}

/**
 * Generate category slug
 */
export function generateCategorySlug(category) {
  return slugify(category);
}

/**
 * Group quotes by field (author, topic, category)
 */
export function groupQuotesBy(quotes, field) {
  return quotes.reduce((acc, quote) => {
    const key = quote[field];
    if (!acc[key]) {
      acc[key] = [];
    }
    acc[key].push(quote);
    return acc;
  }, {});
}

/**
 * Get unique values from quotes for a field
 */
export function getUniqueValues(quotes, field) {
  return [...new Set(quotes.map(q => q[field]))].filter(Boolean).sort();
}

/**
 * Truncate text to specific length
 */
export function truncate(text, length = 160) {
  if (text.length <= length) return text;
  return text.substring(0, length).trim() + '...';
}

/**
 * Format date for display
 */
export function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
}

/**
 * Get quote of the day based on date
 */
export function getQuoteOfTheDay(quotes, date = new Date()) {
  // Find quote with matching date
  const dateString = date.toISOString().split('T')[0]; // YYYY-MM-DD
  const quote = quotes.find(q => q.date === dateString);
  
  if (quote) return quote;
  
  // Fallback: use day of year to deterministically pick a quote
  const start = new Date(date.getFullYear(), 0, 0);
  const diff = date - start;
  const oneDay = 1000 * 60 * 60 * 24;
  const dayOfYear = Math.floor(diff / oneDay);
  
  return quotes[dayOfYear % quotes.length];
}

/**
 * Generate meta description from quote
 */
export function generateMetaDescription(quote, author, topic) {
  return `"${truncate(quote, 140)}" - ${author}. ${topic ? `Inspirational quote about ${topic.toLowerCase()}.` : 'Motivational success quote.'}`;
}

/**
 * Generate page title
 */
export function generatePageTitle(quote, author) {
  return `${truncate(quote, 60)} - ${author} | Success Quotes`;
}


