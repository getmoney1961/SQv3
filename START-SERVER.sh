#!/bin/bash

echo "========================================"
echo "Starting Success Quotes Website Server"
echo "========================================"
echo ""
echo "Server will start at: http://localhost:8080"
echo ""
echo "To test:"
echo "  - Random Quote: http://localhost:8080/random.html"
echo "  - Search:       http://localhost:8080/search.html?q=success"
echo ""
echo "Press Ctrl+C to stop the server"
echo "========================================"
echo ""

cd dist
python3 -m http.server 8080


