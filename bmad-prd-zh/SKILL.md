---
name: bmad-prd-zh
description: Generate and refine Chinese BMAD-style product planning documents for product teams. Use when a user asks to create a PRD, product brief, MVP scope, functional requirements, non-functional requirements, acceptance criteria, or a Chinese operating manual or workflow for PRD generation based on BMAD.
---

# BMAD Chinese PRD

## Overview

Use this skill to turn a Chinese product idea, business request, or rough requirement set into a BMAD-style planning flow: clarify scope, decide whether a PRD is warranted, collect product inputs through staged interview rounds, and output a Chinese `PRD.md` that is reviewable by product, design, and engineering.

State that you are using `$bmad-prd-zh` and keep the workflow conversational. Do not jump straight to a long PRD unless the user explicitly asks for one-shot output.

## Decide The Track

First decide whether the request needs the full BMAD planning track:

- Use the full track when the request is a new product, a new major module, a cross-role workflow, a multi-page system, a complex business process, or a feature that will later need architecture and story breakdown.
- Stay lightweight when the request is a small enhancement, single-page tweak, wording polish, or a change that can be handled as a short spec rather than a PRD.

If the user only wants a process manual, summarize the workflow without pretending to generate the PRD itself.

## Follow The BMAD Order

Use this order unless the user explicitly wants to skip a step:

1. Clarify whether a `Product Brief` is needed.
2. Create or summarize the `Product Brief` first for medium or large efforts.
3. Start a fresh PRD pass and collect details by rounds.
4. Write `PRD.md` in Chinese with structured FR/NFR and acceptance criteria.
5. Flag the recommended next step: UX, architecture, then epics and stories.

Treat BMAD as a staged planning method, not a template dump.

## Run The Interview In Rounds

Use short rounds of questioning. Ask only the most important missing items first.

### Round 1: Context And Goal

Collect:

- business background
- why now
- target user
- success outcome
- deadline or release expectation

If the user is vague, ask for one concrete use case and one concrete business metric.

### Round 2: Scope And MVP

Collect:

- MVP scope
- explicit out-of-scope items
- target platforms
- dependencies on design, data, external systems, or compliance

Challenge over-scoped requests. If the MVP cannot fit into a first release, propose a narrower first phase.

### Round 3: Functional Requirements

Write requirements as numbered `FR-*` statements. Prefer direct, testable language. For each FR, add acceptance criteria unless the user asks for a very lightweight draft.

### Round 4: Non-Functional Requirements

Write measurable `NFR-*` statements where possible. Cover only relevant categories:

- performance
- security
- reliability
- availability
- observability
- compatibility
- compliance
- maintainability

Do not accept vague wording like "system should be stable" without a concrete threshold or operational meaning.

### Round 5: Risks And Open Questions

Always capture:

- assumptions
- unresolved decisions
- external dependencies
- operational or policy risks

If a blocker remains unresolved, separate it into a dedicated pending-items section rather than hiding it in prose.

## Produce The Deliverables

Default outputs:

1. a concise Chinese `Product Brief` when the project is medium or large
2. a structured Chinese `PRD.md`
3. a short follow-on recommendation for architecture or story breakdown

Use the template in [references/prd-template-zh.md](references/prd-template-zh.md) when drafting or restructuring a PRD.

Use the question bank in [references/discovery-question-bank-zh.md](references/discovery-question-bank-zh.md) when user input is incomplete or the conversation needs stronger elicitation.

Use the checklist in [references/review-checklist-zh.md](references/review-checklist-zh.md) before finalizing the PRD.

## Apply Chinese Team Conventions

Prefer terminology and structure that are easy for Chinese cross-functional teams to review:

- Use Chinese section titles in the output.
- Keep business goals separate from feature lists.
- Separate in-scope from out-of-scope items.
- Separate product requirements from page or interaction notes.
- Keep numbered FR/NFR identifiers for easy review comments.
- Add acceptance criteria under each major feature or requirement cluster.
- Add a pending-items section when information is missing.

When useful, normalize messy input into language that product managers, designers, and engineers can all review without translation.

## Output Rules

When generating a PRD:

- Prefer Markdown.
- Keep top-level sections stable and scannable.
- Avoid marketing language.
- Avoid long narrative paragraphs when bullets or numbered requirements are clearer.
- State assumptions explicitly.
- If information is missing, say what is inferred and what still needs confirmation.

When the user asks for an operational manual rather than a PRD artifact, output the workflow, roles, deliverables, and review gates instead of pretending to run the interview.

## Example Triggers

This skill should trigger on requests like:

- help me create a Chinese BMAD PRD
- turn this product idea into a PRD for engineering review
- create a product brief first, then generate a Chinese PRD
- write a Chinese team playbook for BMAD PRD generation