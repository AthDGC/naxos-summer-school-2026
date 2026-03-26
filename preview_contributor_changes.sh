#!/bin/bash

# Preview Contributor Changes - NO MODIFICATIONS MADE
# Shows exactly what would change without touching anything
# Author: Nikos Lavidas

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 CONTRIBUTOR PREVIEW - NO CHANGES MADE${NC}"
echo "=============================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Not in a git repository!${NC}"
    exit 1
fi

echo -e "${BLUE}📊 Current contributors:${NC}"
git log --format='%an <%ae>' | sort | uniq -c | sort -rn

echo ""
echo -e "${YELLOW}🤖 AI tools found (will be changed):${NC}"
PROBLEMATIC=$(git log --format='%an <%ae>' | sort | uniq | grep -iE "(^claude|windsurf|aider|continue|copilot|assistant|ai.*assistant|user@example|unknown@|@localhost)" | grep -vE "(michalareas|chionidi|plakoutsi)" || echo "")

if [ -z "$PROBLEMATIC" ]; then
    echo "   ✅ No AI tool attributions found - repository is clean!"
    
    echo ""
    echo -e "${GREEN}👥 Human collaborators found (will be preserved):${NC}"
    git log --format='%an <%ae>' | sort | uniq | grep -E "(michalareas|chionidi|plakoutsi)" | while read line; do
        if [ -n "$line" ]; then
            COUNT=$(git log --format='%an <%ae>' | grep -F "$line" | wc -l)
            echo -e "   ✅ $COUNT commits: $line (PRESERVED)"
        fi
    done
    
    exit 0
else
    echo "$PROBLEMATIC" | while read line; do
        if [ -n "$line" ]; then
            COUNT=$(git log --format='%an <%ae>' | grep -F "$line" | wc -l)
            echo -e "   🤖 $COUNT commits: $line (will change to you)"
        fi
    done
fi

echo ""
echo -e "${GREEN}👥 Human collaborators (will be preserved):${NC}"
git log --format='%an <%ae>' | sort | uniq | grep -E "(michalareas|chionidi|plakoutsi)" | while read line; do
    if [ -n "$line" ]; then
        COUNT=$(git log --format='%an <%ae>' | grep -F "$line" | wc -l)
        echo -e "   ✅ $COUNT commits: $line (PRESERVED)"
    fi
done || echo "   (No human collaborators detected in this pattern)"

echo ""
echo -e "${BLUE}📝 PREVIEW OF CHANGES:${NC}"
echo "===================="

# Get correct information
read -p "Your correct name (e.g., 'Nikos Lavidas'): " CORRECT_NAME
read -p "Your correct email (e.g., 'nlavidas@uoa.gr'): " CORRECT_EMAIL

if [ -z "$CORRECT_NAME" ] || [ -z "$CORRECT_EMAIL" ]; then
    echo -e "${RED}❌ Name and email are required for preview!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🔄 CHANGES THAT WOULD BE MADE:${NC}"
echo "=============================="

# Show what would be mapped (AI tools only)
git log --format='%an <%ae>' | sort | uniq | grep -iE "(^claude|windsurf|aider|continue|copilot|assistant|ai.*assistant|user@example|unknown@|@localhost)" | grep -vE "(michalareas|chionidi|plakoutsi)" | while read line; do
    if [ -n "$line" ]; then
        COUNT=$(git log --format='%an <%ae>' | grep -F "$line" | wc -l)
        echo -e "${RED}BEFORE:${NC} $line ($COUNT commits)"
        echo -e "${GREEN}AFTER:${NC}  $CORRECT_NAME <$CORRECT_EMAIL> ($COUNT commits)"
        echo ""
    fi
done

echo -e "${GREEN}✅ WHAT STAYS EXACTLY THE SAME:${NC}"
echo "============================="
echo "   ✓ All code and files"
echo "   ✓ All commit messages"  
echo "   ✓ All commit dates"
echo "   ✓ All branches and tags"
echo "   ✓ Repository structure"

echo ""
echo -e "${BLUE}📋 SAMPLE COMMIT EXAMPLE:${NC}"
echo "======================="

# Find a commit with AI tool author (not human collaborators)
SAMPLE_COMMIT=$(git log --format='%H|%an|%ae|%s|%cd' | grep -iE "(^[^|]*claude|windsurf|aider|continue|copilot|assistant|ai.*assistant|user@example|unknown@|@localhost)" | grep -vE "(michalareas|chionidi|plakoutsi)" | head -1)

if [ -n "$SAMPLE_COMMIT" ]; then
    IFS='|' read -r HASH AUTHOR EMAIL SUBJECT DATE <<< "$SAMPLE_COMMIT"
    
    echo "BEFORE (current state):"
    echo "  Commit: ${HASH:0:8}"
    echo "  Author: $AUTHOR <$EMAIL>"
    echo "  Date:   $DATE"  
    echo "  Message: $SUBJECT"
    echo ""
    echo "AFTER (would become):"
    echo "  Commit: ${HASH:0:8}  ← SAME"
    echo "  Author: $CORRECT_NAME <$CORRECT_EMAIL>  ← CHANGED"
    echo "  Date:   $DATE  ← SAME"
    echo "  Message: $SUBJECT  ← SAME"
fi

echo ""
echo -e "${BLUE}🛡️  SAFETY GUARANTEES:${NC}"
echo "==================="
echo "   • Only git author/committer info changes"
echo "   • Code files remain untouched"
echo "   • Commit messages stay the same"
echo "   • Dates and timeline preserved"
echo "   • Automatic backup created"
echo "   • Full rollback possible"

echo ""
echo -e "${YELLOW}📌 TO MAKE THESE CHANGES:${NC}"
echo "========================"
echo "1. Run: ./quick_fix_contributors.sh"
echo "2. Or:  python git_contributor_fixer.py"
echo ""
echo -e "${GREEN}✅ This was PREVIEW ONLY - no changes made${NC}"
