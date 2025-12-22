---
layout: page
title: "Academic Outreach Checklist"
permalink: /research/outreach-checklist/
parent: Research Materials - Volatility Hedge Discovery
published: false
---

# Academic Outreach Checklist

Use this checklist before reaching out to Tim St. Leung or other researchers.

---

## ✅ Pre-Send Checklist

### 1. Research the Professor

- [ ] Visit [Tim St. Leung's faculty page](https://amath.washington.edu/people/tim-st-leung)
- [ ] Review recent publications (Google Scholar, arXiv)
- [ ] Note 2-3 specific papers relevant to Uniteum
- [ ] Check if he's accepting new collaborations/students
- [ ] Verify preferred contact method (email, research group form, etc.)
- [ ] Check academic calendar (avoid finals week, holidays)

**Notes:**
- His research areas: Derivatives pricing, quantitative finance, optimal execution
- Relevant papers to reference: [List 2-3 titles here]
- Best contact: [Email address from faculty page]

---

### 2. Customize the Email

**File:** `/research/email-template-collaboration.md`

- [ ] Replace "Professor" with "Professor St. Leung" or "Dr. St. Leung"
- [ ] Add 1-2 sentences connecting to his specific research
  - Example: "Your work on [Paper Title] particularly resonates with this finding..."
- [ ] Confirm your email address is correct: `paul@reinholdtsen.com`
- [ ] Add GitHub repo link if test suite is public
- [ ] Decide: Attach files or provide web links?

**Personalization suggestions:**
```
After "Why This Might Interest You" section, add:

"Your recent work on [specific paper] on [topic] is particularly relevant
because [connection to Uniteum]. I believe the geometric mean structure
creates a novel [concept from his research] that could benefit from the
analytical frameworks you've developed."
```

---

### 3. Prepare Attachments

**Option A: Attach PDFs**
- [ ] Convert markdown files to PDF with proper formatting
- [ ] Test that formulas render correctly
- [ ] Check file sizes (keep under 5MB total)
- [ ] Name files clearly: `Uniteum_Research_Summary.pdf`, etc.

**Option B: Host on Website**
- [ ] Ensure all research pages are live on uniteum.one
- [ ] Test links from external browser (incognito mode)
- [ ] Add PDF download buttons on each page
- [ ] Create a landing page: `uniteum.one/research`

**Recommended:** Option B (links) for initial email, offer PDFs if interested

---

### 4. Verify Technical Materials

- [ ] Test that all Etherscan links work
- [ ] Verify contract address is current: [0x5bA9...dAD7](https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code)
- [ ] Check that `testVolatilityHedge()` test exists in public repo
- [ ] Ensure documentation site is accessible (uniteum.one)
- [ ] Run through one example yourself to confirm accuracy

---

### 5. Supporting Materials (Optional but Helpful)

- [ ] Create visual diagram of triad structure
- [ ] Create graph showing profit curve: PnL vs price ratio
- [ ] Record 2-minute video walkthrough of one example
- [ ] Set up Jupyter notebook with interactive calculations
- [ ] Prepare Sepolia testnet instructions if he wants to experiment

**Priority:** Visual diagram (highest impact for email)

---

## 📧 Email Sending Strategy

### Timing
**Best times to send:**
- Tuesday-Thursday, 9am-11am Pacific (his timezone)
- Avoid Monday mornings, Friday afternoons
- Avoid academic breaks: Dec 15-Jan 15, late May-early June
- Best: Early January (new year, grant season) or September (new academic year)

**Current date check:** December 20, 2024
- ⚠️ **Holiday season** - consider waiting until January 6-10, 2025
- Professors are often off Dec 20-Jan 5
- Early January = fresh start, grant planning, new projects

### Subject Line Options

**As written:**
"Novel volatility derivative primitive in geometric mean AMM - research collaboration?"

**Alternatives:**
- "Power perpetuals discovery in geometric mean AMM - seeking mathematical validation"
- "Inverting AMM impermanent loss: novel derivative mechanism deployed on Ethereum"
- "Native volatility hedging in constant-product AMMs - research collaboration opportunity"
- "UW Applied Math connection: novel derivatives mechanism in DeFi protocol"

**Recommendation:** Keep original or use "Inverting AMM impermanent loss" (more concrete)

---

## 🎯 Follow-Up Strategy

### Scenario 1: No Response After 2 Weeks

Send brief follow-up:

```
Subject: Re: [Original subject]

Hi Professor St. Leung,

Following up on my email from [date] about the volatility hedging mechanism
in geometric mean AMMs. I understand you're busy, but wanted to check if:

1. This topic is of interest to you or your research group
2. You could suggest other researchers who might find this relevant
3. There's a better way to share this work with the UW Applied Math community

No pressure—even a brief "not interested" helps me direct my outreach
appropriately.

Thanks,
Paul Reinholdtsen
```

### Scenario 2: He's Interested - Prepare These

- [ ] More detailed mathematical derivations
- [ ] Proof sketches for key theorems
- [ ] Numerical simulation results
- [ ] List of specific questions you need help with
- [ ] Testnet access instructions
- [ ] Potential student project scope

### Scenario 3: He's Not Interested - Ask For

- [ ] Referrals to other researchers (at UW or elsewhere)
- [ ] Relevant literature you might have missed
- [ ] Assessment of whether this is genuinely novel
- [ ] General feedback on approach

---

## 🔍 Alternative Researchers (Backup List)

If Tim St. Leung isn't available or interested:

**DeFi/AMM Specialists:**
- [ ] Guillermo Angeris (Stanford) - AMM theory, constant product invariants
- [ ] Tarun Chitra (Gauntlet) - DeFi mechanism design
- [ ] Dan Robinson (Paradigm) - Power perps, derivatives

**Derivatives Pricing:**
- [ ] [Other UW Applied Math faculty who work on derivatives]
- [ ] [Finance faculty at UW Foster School]

**Stochastic Calculus / Applied Math:**
- [ ] [Other UW Applied Math faculty]

**Action:** Research 3-5 backup contacts before sending initial email

---

## 📝 Before You Hit Send - Final Check

- [ ] Read email out loud (catches awkward phrasing)
- [ ] Check for typos and grammatical errors
- [ ] Verify all links work
- [ ] Test attachments if using them
- [ ] Confirm recipient email is correct
- [ ] Subject line is compelling but professional
- [ ] Signature has all contact info
- [ ] Email length is reasonable (not too long)

**Email length target:** 300-500 words in body (current draft is good)

---

## ✨ Enhancement Ideas (Future)

### Create Interactive Demo
- [ ] Web calculator: Input prices, see hedge profit
- [ ] Visual graph: Drag price slider, watch payoff curve
- [ ] Comparison tool: Hedge vs LP vs Hold

### Academic Paper Draft
- [ ] Write introduction section
- [ ] Literature review
- [ ] Mathematical formulation (formal notation)
- [ ] Numerical results section
- [ ] Discussion and open questions

### Video Content
- [ ] 5-minute explainer video
- [ ] Whiteboard walkthrough of math
- [ ] Screen recording of test execution

**Priority for initial outreach:** Not required, but diagram would help significantly

---

## 🎓 If You Get a Meeting

### Prepare to Discuss

**Technical depth:**
- Full mathematical derivation (bring written notes)
- Edge cases and failure modes
- Numerical simulation results
- Comparison to existing derivatives

**Business/practical:**
- Why build this? (Your motivation)
- Target users (who would use this?)
- Sustainability model (how does ecosystem survive?)
- Security considerations (audit status, risks)

**Collaboration specifics:**
- What you need from him (math validation, student project, co-author paper?)
- What you can offer (data access, testnet, acknowledgment, etc.)
- Timeline expectations
- Funding availability (if any)

---

## 📊 Success Metrics

**Minimum success:**
- [ ] Email delivered and read
- [ ] Some response (even "not interested")

**Good success:**
- [ ] Meaningful feedback on whether it's novel
- [ ] Pointer to relevant literature
- [ ] Referral to other researchers

**Great success:**
- [ ] Agreement to review materials in detail
- [ ] Student project interest
- [ ] Ongoing collaboration discussions

**Best case:**
- [ ] Co-authored academic paper
- [ ] Formal mathematical validation
- [ ] Introduction to broader research community

---

## 🚀 Ready to Send?

**Final verification:**
```
✅ Researched the professor
✅ Customized email with specific connections
✅ All links tested and working
✅ Timing is appropriate (not holidays)
✅ Attachments prepared (if using)
✅ Follow-up strategy planned
✅ Backup researchers identified
✅ Read email out loud
```

**When all checked:** Hit send with confidence!

**Remember:**
- No response ≠ rejection (professors are busy)
- One "no" ≠ failure (keep trying others)
- This is genuinely novel and worth pursuing
- Worst case: You've documented something interesting

---

Good luck! This is exciting research.

**Created:** December 2024
**Last updated:** [Update when you customize]
