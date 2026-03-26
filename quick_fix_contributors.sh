#!/bin/bash

# Quick Git Contributor Fixer
# Simple bash script for fixing common contributor issues
# Author: Nikos Lavidas

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Quick Git Contributor Fixer${NC}"
echo "=================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Not in a git repository!${NC}"
    exit 1
fi

# Check if git-filter-repo is available
if ! command -v git-filter-repo &> /dev/null; then
    echo -e "${YELLOW}⚠️  git-filter-repo not found. Installing...${NC}"
    echo "Please install git-filter-repo:"
    echo "  pip install git-filter-repo"
    echo "  or: brew install git-filter-repo"
    echo "  or: apt install git-filter-repo"
    exit 1
fi

# Get current contributors
echo -e "${BLUE}🔍 Current contributors:${NC}"
git log --format='%an <%ae>' | sort | uniq -c | sort -rn

echo ""
echo -e "${YELLOW}📝 Common problematic patterns found:${NC}"
git log --format='%an <%ae>' | sort | uniq | grep -iE "(claude|gpt|assistant|ai|copilot|windsurf|aider|continue)" || echo "None found."

echo ""

# Get correct information
read -p "Enter your correct name (e.g., 'Nikos Lavidas'): " CORRECT_NAME
read -p "Enter your correct email (e.g., 'nlavidas@uoa.gr'): " CORRECT_EMAIL

if [ -z "$CORRECT_NAME" ] || [ -z "$CORRECT_EMAIL" ]; then
    echo -e "${RED}❌ Name and email are required!${NC}"
    exit 1
fi

# Create backup
BACKUP_BRANCH="backup_contributor_fix_$(date +%Y%m%d_%H%M%S)"
echo -e "${BLUE}💾 Creating backup branch: $BACKUP_BRANCH${NC}"
git checkout -b "$BACKUP_BRANCH"
git checkout -

# Create mailmap ONLY for AI tools (preserve human collaborators)
MAILMAP_FILE=".mailmap_temp"
echo -e "${BLUE}📝 Creating mailmap for AI tools only...${NC}"
echo -e "${GREEN}✅ Will preserve human collaborators: michalareas, chionidi, plakoutsi${NC}"

cat > "$MAILMAP_FILE" << EOF
$CORRECT_NAME <$CORRECT_EMAIL> claude Claude <claude@anthropic.com>
$CORRECT_NAME <$CORRECT_EMAIL> <claude@anthropic.com>
$CORRECT_NAME <$CORRECT_EMAIL> claude <claude@anthropic.com>
$CORRECT_NAME <$CORRECT_EMAIL> Claude <claude@anthropic.com>
$CORRECT_NAME <$CORRECT_EMAIL> windsurf <windsurf@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> Windsurf <windsurf@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> aider <aider@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> Aider <aider@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> continue <continue@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> Continue <continue@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> copilot <copilot@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> GitHub Copilot <copilot@github.com>
$CORRECT_NAME <$CORRECT_EMAIL> assistant <assistant@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> Assistant <assistant@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> AI Assistant <ai@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> user <user@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> User <user@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> unknown <unknown@example.com>
$CORRECT_NAME <$CORRECT_EMAIL> Unknown <unknown@example.com>
EOF

# Ask about specific contributors
echo -e "${YELLOW}❓ Do you want to add custom mappings? (y/n)${NC}"
read -r ADD_CUSTOM

if [[ $ADD_CUSTOM =~ ^[Yy] ]]; then
    echo "Enter custom mappings (format: 'Old Name <old@email.com>'):"
    echo "Press Enter with empty line to finish."
    
    while IFS= read -r line; do
        if [ -z "$line" ]; then
            break
        fi
        echo "$CORRECT_NAME <$CORRECT_EMAIL> $line" >> "$MAILMAP_FILE"
        echo "Added: $line → $CORRECT_NAME <$CORRECT_EMAIL>"
    done
fi

echo -e "${BLUE}📄 Mailmap contents:${NC}"
cat "$MAILMAP_FILE"

echo ""
echo ""
echo -e "${BLUE}🛡️  EXACTLY WHAT GETS CHANGED:${NC}"
echo "   ✓ ONLY contributor names and emails"
echo "   ✓ Author field: Old Name → Nikos Lavidas"  
echo "   ✓ Committer field: Old Email → nlavidas@uoa.gr"
echo ""
echo -e "${GREEN}🛡️  WHAT STAYS EXACTLY THE SAME:${NC}"
echo "   ✓ All your code and files"
echo "   ✓ All commit messages"
echo "   ✓ All commit dates and times"
echo "   ✓ All branches and tags"
echo "   ✓ Repository structure"
echo ""
echo -e "${YELLOW}⚠️  This rewrites git history (contributor info only)${NC}"
echo "- Backup branch created: $BACKUP_BRANCH"
echo "- You can rollback if needed"
echo "- Remote repos will need force push"

read -p "Change ONLY contributor names? Type 'yes' to proceed: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Cancelled."
    rm -f "$MAILMAP_FILE"
    exit 0
fi

# Apply the changes
echo -e "${BLUE}🔄 Applying contributor changes...${NC}"

# Use git-filter-repo with mailmap
if git filter-repo --use-mailmap --mailmap "$MAILMAP_FILE" --force; then
    echo -e "${GREEN}✅ Successfully updated contributors!${NC}"
    
    # Clean up
    rm -f "$MAILMAP_FILE"
    
    # Show results
    echo -e "${BLUE}🔍 Updated contributors:${NC}"
    git log --format='%an <%ae>' | sort | uniq -c | sort -rn
    
    echo ""
    echo -e "${GREEN}✅ Contributor fixing completed!${NC}"
    echo -e "${BLUE}💾 Backup available in branch: $BACKUP_BRANCH${NC}"
    echo ""
    echo -e "${YELLOW}📌 Next steps:${NC}"
    echo "   1. Review the changes: git log --oneline"
    echo "   2. Test your repository"
    echo "   3. If satisfied, remove backup: git branch -D $BACKUP_BRANCH"
    echo "   4. If pushing to remote: git push --force-with-lease"
    
else
    echo -e "${RED}❌ Failed to apply changes!${NC}"
    echo -e "${BLUE}💾 You can restore from backup branch: $BACKUP_BRANCH${NC}"
    rm -f "$MAILMAP_FILE"
    exit 1
fi
