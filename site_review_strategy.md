# Comprehensive GitHub Site Review Strategy

## Overview
This strategy provides a systematic approach to review the Naxos Summer School 2026 website for typos, errors, broken logos, images, and other issues.

## Automated Review Tools

### 1. HTML Validation
```bash
# Install HTML validator
npm install -g html-validator

# Validate all HTML files
for file in *.html; do
    echo "Validating $file..."
    html-validator "$file" > "validation_$file.txt"
done
```

### 2. Link Checking
```bash
# Install link checker
npm install -g broken-link-checker

# Check all links in the site
blc https://athdgc.github.io/naxos-summer-school-2026/ -r --exclude=https://forms.gle
```

### 3. Image Validation
```bash
# Check for broken images
find . -name "*.html" -exec grep -l "img src" {} \; | while read file; do
    echo "Checking images in $file..."
    grep -o 'src="[^"]*"' "$file" | sed 's/src="//;s/"//' | while read img; do
        if [ ! -f "$img" ]; then
            echo "Missing image: $img in $file"
        fi
    done
done
```

### 4. Spell Check
```bash
# Install spell checker
npm install -g spellchecker

# Check spelling in all HTML files
for file in *.html; do
    echo "Checking spelling in $file..."
    spellcheck "$file" --language en-US --ignore-acronyms > "spellcheck_$file.txt"
done
```

## Manual Review Checklist

### Content Review
- [ ] All dates are consistent (July 19-24, 2026)
- [ ] Organizers' names and affiliations are correct
- [ ] Teaching assistants' names are correct
- [ ] Registration fees and deadlines are accurate
- [ ] Contact information is current
- [ ] All links open in correct tabs (external links = new tab)
- [ ] Email addresses are formatted correctly

### Design Consistency
- [ ] Fonts are consistent across all pages
- [ ] Background colors are consistent
- [ ] Navigation is identical on all pages
- [ ] Footer is standardized across all pages
- [ ] Logo placement and sizing is consistent

### Technical Review
- [ ] All HTML files have proper DOCTYPE
- [ ] All pages have favicon reference
- [ ] Meta descriptions are present and accurate
- [ ] Alt text is present for all images
- [ ] CSS classes are used consistently
- [ ] No inline styles (or minimal necessary ones)

### Image Review
- [ ] All logo files exist in assets/logos/
- [ ] All images have appropriate file formats
- [ ] Image sizes are optimized for web
- [ ] Alt text describes image content
- [ ] No broken image references

### Navigation Review
- [ ] All navigation links work
- [ ] Active page highlighting works
- [ ] Logo links to homepage
- [ ] External links open in new tabs

## Specific Files to Check

### Required Logo Files
Verify these files exist in `assets/logos/`:
- `university_of_athens.jpg`
- `civis.png`
- `nkua.jpg` (AthDGC logo)
- `riemsdijk.png` (to be added)
- `naxos.png` (to be added)
- `cambridge.png` (to be added)
- `blue_star.png` (to be added)
- `eu_flag.png` (to be added)

### Required Favicon
- `assets/favicon.ico` (AthDGC favicon)

## Batch Processing Script

```bash
#!/bin/bash
# comprehensive_site_review.sh

echo "Starting comprehensive site review..."

# 1. HTML Validation
echo "1. Running HTML validation..."
for file in *.html; do
    if [ -f "$file" ]; then
        echo "  Validating $file..."
        html-validator "$file" 2>/dev/null | grep -E "(error|warning)" > "validation_$(basename $file .txt)"
    fi
done

# 2. Link Checking
echo "2. Checking external links..."
blc https://athdgc.github.io/naxos-summer-school-2026/ -r --exclude=https://forms.gle > link_check_results.txt

# 3. Image Verification
echo "3. Verifying images..."
find . -name "*.html" -exec grep -l "img src" {} \; | while read file; do
    grep -o 'src="[^"]*"' "$file" | sed 's/src="//;s/"//' | while read img; do
        if [ ! -f "$img" ] && [[ $img == http* ]]; then
            echo "External image: $img in $file"
        elif [ ! -f "$img" ] && [[ $img != http* ]]; then
            echo "Missing local image: $img in $file"
        fi
    done
done > image_check_results.txt

# 4. Date Consistency Check
echo "4. Checking date consistency..."
grep -r "July.*2026" *.html | grep -v "July 19–24" > date_inconsistencies.txt

# 5. Email Format Check
echo "5. Checking email formats..."
grep -r "href=\"mailto:" *.html > email_links.txt

# 6. External Link Check
echo "6. Checking external link targets..."
grep -r "target=\"_blank\"" *.html | grep -v "forms.gle" > external_links_check.txt

echo "Review complete. Check the generated files for results."
```

## Regular Maintenance Schedule

### Weekly Checks
- [ ] Run link checker on live site
- [ ] Verify contact form functionality
- [ ] Check for 404 errors in server logs

### Monthly Checks
- [ ] Full content review
- [ ] Image optimization review
- [ ] Performance testing
- [ ] Mobile responsiveness testing

### Pre-Event Checks (1 month before)
- [ ] Complete content accuracy review
- [ ] All external link verification
- [ ] Registration form testing
- [ ] Contact information verification

## Issue Tracking

Create a GitHub Issues template for site bugs:

```markdown
## Site Issue Report

### Issue Type
- [ ] Typo/Spelling
- [ ] Broken Link
- [ ] Missing Image
- [ ] Design Inconsistency
- [ ] Technical Error
- [ ] Other

### Location
Page: 
URL: 
Browser: 

### Description
[Detailed description of the issue]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Screenshots
[Attach screenshots if applicable]
```

## Quality Assurance Checklist

### Before Publishing Changes
- [ ] All HTML validates
- [ ] All links work
- [ ] All images load
- [ ] Spelling checked
- [ ] Consistent formatting
- [ ] Mobile responsive
- [ ] Accessibility compliant
- [ ] Performance tested

This comprehensive strategy ensures thorough review of the website for maintaining high quality and user experience.
