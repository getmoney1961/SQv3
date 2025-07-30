import json
import random
from datetime import datetime, timedelta

def create_quote_of_the_day_json():
    # Step 1: Load quotes from quotes.json
    with open('SuccessQuotes/Shared/quotes.json', 'r', encoding='utf-8') as f:
        quotes = json.load(f)
    
    # Step 2: Shuffle the quotes to randomize the order
    random.shuffle(quotes)
    
    # Step 3: Generate dates starting from August 1, 2025
    start_date = datetime(2025, 7, 29)
    quote_of_the_day_data = []
    
    for i, quote in enumerate(quotes):
        date = start_date + timedelta(days=i)
        date_str = date.strftime('%Y-%m-%d')
        
        # Create a new quote object with all original data plus the date
        quote_with_date = {
            "topic": quote["topic"],
            "quote": quote["quote"],
            "author": quote["author"],
            "id": quote["id"],
            "category": quote["category"],
            "date": date_str
        }
        
        quote_of_the_day_data.append(quote_with_date)
    
    # Step 4: Write the enhanced data to quote_of_the_day.json
    with open('SuccessQuotes/Shared/quote_of_the_day.json', 'w', encoding='utf-8') as f:
        json.dump(quote_of_the_day_data, f, ensure_ascii=False, indent=2)
    
    print(f'quote_of_the_day.json has been created successfully!')
    print(f'Total quotes assigned: {len(quote_of_the_day_data)}')
    print(f'Date range: {start_date.strftime("%Y-%m-%d")} to {(start_date + timedelta(days=len(quotes)-1)).strftime("%Y-%m-%d")}')

if __name__ == "__main__":
    create_quote_of_the_day_json()
