---
layout: page
title: "Email Template - Collaboration"
permalink: /research/email-template-collaboration/
published: false
---

# Email Draft: Introduction to Professor

---

**Subject:** Novel volatility derivative primitive in geometric mean AMM - research collaboration?

---

Dear Professor,

My name is Paul Reinholdtsen, and I'm an independent protocol developer working on algebraic liquidity mechanisms. I'm reaching out because I've discovered what appears to be a novel derivative structure that I believe would benefit from rigorous mathematical finance analysis, and your work on derivatives pricing and quantitative finance makes you an ideal person to consult.

## The Core Finding

I've built a decentralized protocol called Uniteum that uses geometric mean invariants (√(A*B) = W) to create composable liquidity units. While developing this, I discovered an unexpected property: **the protocol natively creates a volatility hedging instrument that inverts the typical AMM impermanent loss payoff.**

Specifically:
- Traditional AMM liquidity providers suffer impermanent loss when prices diverge (~5.7% loss when an asset doubles/halves)
- In Uniteum, holding equal amounts of √(A*B) and 1/√(A*B) produces a ~6% **profit** when prices move in either direction
- This position has no directional bias, no expiration, no theta decay, and requires no fees or counterparty

The mathematics appear sound (detailed calculations attached), but the economic implications are puzzling:
- Where does the profit come from?
- Who holds the offsetting loss?
- Can everyone hedge simultaneously, or is there a conservation constraint?
- What's the equilibrium between liquidity providers and volatility traders?

## Why This Might Interest You

This seems to combine elements of:
1. **Power perpetuals** (generalizes Uniswap's 0.5 power perp to arbitrary exponents)
2. **Variance swaps** (profit from volatility, not direction)
3. **Long gamma positions** (positive convexity)
4. **Multi-dimensional arbitrage** (prices enforced through geometric constraints, not oracles)

The protocol is already deployed on Ethereum mainnet (unaudited, experimental) with working smart contracts that implement these mechanics.

## What I'm Seeking

I've prepared a research summary document that includes:
- Mathematical formulation of the mechanism
- Worked numerical examples
- List of open questions requiring rigorous analysis
- Connection to existing derivatives literature

I would greatly appreciate:
1. Your assessment of whether this is genuinely novel or a rediscovery of known results
2. Guidance on the key mathematical questions to investigate
3. Potential collaboration or student project opportunities if this warrants deeper study

## Materials

- Research summary: [attached/linked]
- Live protocol: https://uniteum.one
- Smart contracts: https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code
- Documentation: https://uniteum.one/concepts/

I understand you're busy, so even brief feedback or a pointer to relevant literature would be valuable. If this interests you, I'm happy to:
- Provide additional technical details
- Share testnet access for experimentation
- Discuss potential research directions
- Connect with graduate students who might find this interesting

Thank you for considering this. I believe there's genuine mathematical novelty here, but it needs proper academic rigor to validate.

Best regards,
Paul Reinholdtsen

---

**Contact Information:**
- GitHub: github.com/uniteum
- Web: uniteum.one
- Email: paul@reinholdtsen.com

---

## Attachments:
1. Research Summary: volatility-hedge-mechanism.md
2. Quick Reference: one-page-summary.md (optional, create below)

---

# Notes for Customization:

**Before sending:**
- [ ] Add your actual email address
- [ ] Decide whether to attach files or provide links
- [ ] Consider creating a one-page visual summary (diagrams help)
- [ ] Check if he has preferred contact method (email vs research group site)
- [ ] Verify his current research interests (visit his faculty page)
- [ ] Consider timing (academic calendar - avoid finals/breaks)

**Tone adjustments:**
- As written: Professional but direct, emphasizes the puzzle
- More formal: Add more academic citations and deference
- More technical: Lead with the math, less context
- More casual: If you have a warm introduction through someone

**Alternative opening if you have a connection:**
"Professor [Name] suggested I reach out to you regarding [context]..."

**Follow-up strategy:**
- If no response in 2 weeks: Brief follow-up email
- If interested: Prepare more detailed technical write-up
- If not interested: Ask for referrals to other researchers
