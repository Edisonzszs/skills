---
name: gov-ai-agent-prd-zh
description: Draft Product Briefs, PRDs, and AI or agent specifications for Chinese government and enterprise AI projects after discovery is already complete. Use when the user explicitly wants the document-writing phase and already has discovery outputs, fit assessment, pilot scope, deployment boundaries, and governance constraints.
---

# Gov AI Agent PRD ZH

## Overview

Use this skill after discovery has clarified the scenario, the AI fit, the agent fit, the pilot boundary, and the deployment constraints. This skill turns that discovery pack into formal planning documents.

State that you are using `$gov-ai-agent-prd-zh`. If the discovery pack is missing or weak, recommend using `$gov-ai-discovery-zh` first instead of guessing.

## Required Inputs

Prefer to start from a discovery pack that already answers:

- what scenario class this is
- whether AI is needed
- whether an agent is needed
- what deployment boundary applies
- what pilot scope applies
- what read-only versus write actions are allowed
- what human approval points are required
- what major risks remain open

Use [references/discovery-handoff-zh.md](references/discovery-handoff-zh.md) as the minimum handoff checklist.

## Write In Three Layers

Default outputs for medium and large projects:

1. `Product Brief`
2. `PRD`
3. `AI/Agent Spec`

Keep these layers distinct.

- Product Brief: business value, sponsor, pilot, scope, and success criteria
- PRD: user roles, workflows, FR, NFR, business rules, and acceptance criteria
- AI or Agent Spec: models, knowledge boundaries, tools, permissions, human approval, audit, and fallback logic

## Draft In Four Passes

### Pass 1: Normalize Discovery Inputs

Convert the discovery pack into stable terms:

- business objective
- target users and departments
- scenario classification
- pilot scope
- deployment boundary
- risk summary

### Pass 2: Write Product Brief

Write the brief first. Keep it concise and suitable for business or steering review.

### Pass 3: Write PRD

Write:

- numbered `FR-*` requirements
- numbered `NFR-*` requirements
- workflow states
- role and permission model
- explicit in-scope and out-of-scope sections
- business acceptance criteria

Use [references/prd-template-zh.md](references/prd-template-zh.md).

### Pass 4: Write AI Or Agent Spec

Write:

- AI necessity summary
- agent necessity summary
- model and deployment constraints
- knowledge boundaries
- tool list and tool boundaries
- read-only actions
- write actions
- mandatory human approval points
- high-risk failure modes
- fallback and escalation paths
- AI evaluation metrics

Use [references/agent-prd-template-zh.md](references/agent-prd-template-zh.md), [references/ai-evaluation-metrics-zh.md](references/ai-evaluation-metrics-zh.md), and [references/deployment-and-compliance-zh.md](references/deployment-and-compliance-zh.md).

## Non-Negotiable Sections

Do not omit these sections for government and enterprise AI projects:

- pilot scope and non-pilot scope
- deployment boundary
- compliance and audit requirements
- read-only versus write action boundary
- human approval points
- business acceptance metrics
- AI acceptance metrics
- pending issues and risks

## Output Rules

When generating the final documents:

- use Chinese for the deliverables
- keep assumptions separate from confirmed facts
- keep business acceptance separate from AI acceptance
- do not hide governance or compliance items inside generic NFR prose
- if discovery is incomplete, stop and say what is missing

## Reference Files

Load only what is needed:

- [references/discovery-handoff-zh.md](references/discovery-handoff-zh.md): minimum inputs expected from discovery
- [references/prd-template-zh.md](references/prd-template-zh.md): PRD structure
- [references/agent-prd-template-zh.md](references/agent-prd-template-zh.md): AI or agent spec structure
- [references/ai-evaluation-metrics-zh.md](references/ai-evaluation-metrics-zh.md): metric options
- [references/deployment-and-compliance-zh.md](references/deployment-and-compliance-zh.md): deployment and compliance checklist

## Example Triggers

This skill should trigger on requests like:

- turn this discovery output into a Chinese Product Brief and PRD
- write the PRD after the AI fit has been confirmed
- convert this government AI pilot scope into formal planning documents
- draft the Product Brief, PRD, and Agent Spec for this enterprise AI project