// Data loader for quotes
import quotesData from '../data/quotes.json';
import { 
  generateQuoteSlug, 
  generateAuthorSlug, 
  generateTopicSlug,
  generateCategorySlug,
  groupQuotesBy,
  getUniqueValues 
} from './utils.js';

// Process quotes and add slugs
export const quotes = quotesData.map(quote => ({
  ...quote,
  slug: generateQuoteSlug(quote.quote, quote.author),
  authorSlug: generateAuthorSlug(quote.author),
  topicSlug: quote.topic ? generateTopicSlug(quote.topic) : null,
  categorySlug: quote.category ? generateCategorySlug(quote.category) : null,
}));

// Group quotes
export const quotesByAuthor = groupQuotesBy(quotes, 'author');
export const quotesByTopic = groupQuotesBy(quotes, 'topic');
export const quotesByCategory = groupQuotesBy(quotes, 'category');

// Get unique values
export const authors = getUniqueValues(quotes, 'author');
export const topics = getUniqueValues(quotes, 'topic');
export const categories = getUniqueValues(quotes, 'category');

// Helper to get quote by id
export function getQuoteById(id) {
  return quotes.find(q => q.id === id);
}

// Helper to get quotes by author
export function getQuotesByAuthor(author) {
  return quotes.filter(q => q.author === author);
}

// Helper to get quotes by topic
export function getQuotesByTopic(topic) {
  return quotes.filter(q => q.topic === topic);
}

// Helper to get quotes by category
export function getQuotesByCategory(category) {
  return quotes.filter(q => q.category === category);
}

// Search quotes
export function searchQuotes(query) {
  const lowerQuery = query.toLowerCase();
  return quotes.filter(q => 
    q.quote.toLowerCase().includes(lowerQuery) ||
    q.author.toLowerCase().includes(lowerQuery) ||
    (q.topic && q.topic.toLowerCase().includes(lowerQuery)) ||
    (q.category && q.category.toLowerCase().includes(lowerQuery))
  );
}

export default quotes;


