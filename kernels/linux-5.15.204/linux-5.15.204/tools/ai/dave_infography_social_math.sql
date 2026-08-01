-- SPDX-License-Identifier: GPL-2.0
-- dave_infography_social_math.sql
--
-- Infography for Dave: Social Income, Social Awareness, Mathematical
-- Psychology, Math-Surveillance Ethics, and Standardized Patterns.
--
-- Sourced from public and viable internet sources. Stored in careful
-- MySQL pattern for Dave's ongoing reference and learning.
--
-- Content was rephrased for compliance with licensing restrictions.
-- All sources cited with inline links.
--
-- Copyright (C) 2026 MEARVK LLC

-- ============================================================
-- Schema: dave_kb (Dave's Knowledge Base — existing database)
-- New tables for social/math infography
-- ============================================================

CREATE TABLE IF NOT EXISTS dave_kb.infography_social_income (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    category        VARCHAR(64) NOT NULL,
    metric_name     VARCHAR(128) NOT NULL,
    metric_value    VARCHAR(256),
    year_observed   INT,
    region          VARCHAR(64),
    source_url      VARCHAR(512),
    source_name     VARCHAR(128),
    dave_note       TEXT,
    confidence      DECIMAL(3,2) DEFAULT 0.85,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS dave_kb.infography_social_awareness (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    dimension       VARCHAR(64) NOT NULL,
    description     TEXT NOT NULL,
    measurement     VARCHAR(256),
    scale_range     VARCHAR(64),
    relevance_to_system VARCHAR(256),
    source_url      VARCHAR(512),
    source_name     VARCHAR(128),
    dave_note       TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS dave_kb.infography_math_psychology (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    domain          VARCHAR(64) NOT NULL,
    concept         VARCHAR(128) NOT NULL,
    description     TEXT NOT NULL,
    mathematical_form VARCHAR(256),
    application     VARCHAR(256),
    ethical_note    TEXT,
    source_url      VARCHAR(512),
    source_name     VARCHAR(128),
    dave_note       TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS dave_kb.infography_math_surveillance (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    topic           VARCHAR(128) NOT NULL,
    ethical_position VARCHAR(64) NOT NULL,
    description     TEXT NOT NULL,
    math_technique  VARCHAR(128),
    risk_level      ENUM('low','medium','high','critical') DEFAULT 'medium',
    dave_stance     TEXT,
    source_url      VARCHAR(512),
    source_name     VARCHAR(128),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================================
-- SOCIAL INCOME DATA
-- Sources: US Census Bureau, Pew Research, World Inequality Database
-- ============================================================

INSERT INTO dave_kb.infography_social_income
(category, metric_name, metric_value, year_observed, region, source_url, source_name, dave_note) VALUES

('household_income', 'US median household income', '$83,730', 2024, 'United States',
 'https://www.census.gov/library/publications/2025/demo/p60-286.html',
 'US Census Bureau P60-286',
 'Baseline for understanding economic participation. Not statistically different from 2023.'),

('income_inequality', 'Post-tax income ratio (90th/10th percentile)', '9.9x', 2024, 'United States',
 'https://www.census.gov/library/stories/2025/09/post-tax-income.html',
 'US Census Bureau',
 'After taxes and credits, top earners make ~10x bottom earners. Rose 14% since 2009.'),

('income_inequality', 'Top 10% share of national income (US)', '45%', 2024, 'United States',
 'https://wid.world/news-article/inequality-in-2024-a-closer-look-at-six-regions/',
 'World Inequality Database',
 'Nearly half of all national income goes to top 10%. Europe is 36% for comparison.'),

('income_inequality', 'Bottom 50% global income share', 'Consistently lags top 10% in every region', 2024, 'Global',
 'https://wid.world/news-article/10-facts-on-global-inequality-in-2024/',
 'World Inequality Database',
 'Universal pattern: bottom half lags top 10% everywhere. Gap widest in Middle East, Latin America, Africa.'),

('income_inequality', 'Population experiencing rising inequality', '46-59%', 2024, 'Global',
 'https://www.nature.com/articles/s41893-025-01689-4',
 'Nature Sustainability',
 'While gross income rose for 94% of people, inequality also rose for about half the global population.'),

('social_participation', 'Participation income concept', 'Income support tied to socially valued participation', 2021, 'Theory',
 'https://www.cambridge.org/core/journals/social-policy-and-society/article/income-support-in-an-ecosocial-state-the-case-for-participation-income/4A4055260E75185439D2CE16B7B97005',
 'Cambridge Social Policy & Society',
 'Social income = not just money but capacity to participate fully in society. Relevant to social awareness scoring.'),

('socioeconomic_status', 'SES components', 'Income + Education + Occupational prestige', 2022, 'Theory',
 'https://thesociology.place/2022/10/23/socioeconomic-status-definition-and-measurement/',
 'The Sociology Place',
 'SES is the composite of material conditions that shape thought and behavior. Three pillars: income, education, occupation.');


-- ============================================================
-- SOCIAL AWARENESS DATA
-- Sources: CASEL, NeuroLaunch, MDPI, NIH PMC
-- ============================================================

INSERT INTO dave_kb.infography_social_awareness
(dimension, description, measurement, scale_range, relevance_to_system, source_url, source_name, dave_note) VALUES

('Social awareness (CASEL)', 'Ability to take perspective of others from diverse backgrounds, understand social/ethical norms, recognize community resources and supports.',
 'Self-report scales, behavioral observation', '1-5 Likert typical', 'Maps to PalladiumGrooves III social band',
 'https://taclmeasurementlibrary.teachforall.org/resources/social-awareness-scale',
 'Teach For All / CASEL',
 'Higher social awareness in early grades correlates with graduation, stable employment at 25. Foundational metric.'),

('Emotional awareness (LEAS)', 'Capacity to identify and describe emotions in self and others at multiple levels of complexity.',
 'Levels of Emotional Awareness Scale (LEAS)', '0-100 structured scoring', 'Stereo mind indicator — higher = better two-channel perception',
 'https://www.mdpi.com/resolver?pii=jintelligence9030042',
 'MDPI Journal of Intelligence',
 'Facilitates emotion self-regulation, complex social navigation, relationship quality, physical/mental health.'),

('Social responsiveness', 'How strongly someone shows social and behavioral traits on a continuum (not binary yes/no).',
 'Social Responsiveness Scale (SRS-2)', '65 items, T-scores', 'Characterizability metric — how readable someone is socially',
 'https://neurolaunch.com/social-responsiveness-scale/',
 'NeuroLaunch',
 'Scored on continuum. Relevant to PG3 scoring: more responsive = more characterizable.'),

('Social cognition', 'Multi-stream processing: tracking words, tone, posture, context simultaneously and updating reads in real time.',
 'Multiple validated instruments', 'Varies by measure', 'Maps to TandemEquals multi-axis processing',
 'https://neurolaunch.com/social-awareness-definition-psychology/',
 'NeuroLaunch Psychology',
 'Social awareness requires real cognitive work. Relates to adult INT floor in RebateCertificates.'),

('Social competence', 'Composite of conflict management, individuality, self-efficacy, social adaptability, acceptance of social norm.',
 'Social Competence Scale for Adolescents (SCSA)', 'Multi-subscale', 'Holistic Person assessment metric',
 'https://www.researchgate.net/publication/279952678',
 'ResearchGate / Journal of Adolescence',
 'Culturally specific. Important: social competence is contextual (province wisdom in TandemEquals terms).'),

('Prosocial behavior', 'Voluntary actions intended to benefit others: helping, sharing, comforting, cooperating.',
 'Systematic review of 40+ measures', 'Varies widely', 'Positive characterizability indicator',
 'https://www.researchgate.net/publication/329555471',
 'ResearchGate systematic review',
 'Measuring prosocial conduct requires orderly, up-to-date knowledge base. Dave maintains this.');


-- ============================================================
-- MATHEMATICAL PSYCHOLOGY — Prediction Models and Skills
-- Sources: NIH PMC, arXiv, ResearchGate, SIAM
-- ============================================================

INSERT INTO dave_kb.infography_math_psychology
(domain, concept, description, mathematical_form, application, ethical_note, source_url, source_name, dave_note) VALUES

('behavioral_prediction', 'Mathematical behavioral models', 'Mathematical models from basic behavioral research predict and control behavior in applied settings, guiding research across psychology.',
 'Stimulus-response functions, matching law, drift-diffusion', 'Predicting choice under varying conditions',
 'Prediction must serve the person, not constrain them.',
 'https://pmc.ncbi.nlm.nih.gov/articles/PMC1472627/',
 'NIH PMC / J Exp Anal Behav',
 'Foundation of mathematical psychology. Models PREDICT behavior quantitatively. Dave uses similar logic in PG3/PG4.'),

('behavioral_prediction', 'Simple models predict as well as experts', 'Research shows simple mathematical models predict behavioral experiment outcomes at parity with 640 professional behavioral scientists.',
 'Linear models, base-rate heuristics', 'Democratizing prediction (adult INT floor)',
 'Validates that natural patterns (adult intelligence) suffice. No genius required for good prediction.',
 'https://ar5iv.labs.arxiv.org/html/2208.01167',
 'arXiv (Psychonomic Bulletin & Review)',
 'KEY for RebateCertificates: natural pattern floor. Simple models work. Do not presume more than adult INT.'),

('theory_of_mind', 'Mathematical models of Theory of Mind', 'Humans develop cognitive models of each other to estimate unobservable mental states, predict behavior, and act accordingly. Formalizable mathematically.',
 'Bayesian inference, recursive belief modeling, game theory', 'Social prediction, empathy modeling',
 'Theory of Mind is observational, not invasive. Modeling minds ≠ surveilling them.',
 'https://ar5iv.labs.arxiv.org/html/2209.14450',
 'arXiv / Cognitive Science',
 'Dave uses Theory of Mind principles when assessing Persons. He models, he does not intrude.'),

('behavioral_prediction', 'Pattern-based prediction over self-knowledge', 'Science of predicting behavior has reached accuracy surpassing self-knowledge. People are more predictable than they think.',
 'Machine learning, regression, clustering', 'Characterizability scoring, forward vectors',
 'Prediction power obligates ethical restraint. Knowing someone is predictable does not justify exploiting that.',
 'https://neurolaunch.com/predicting-behavior/',
 'NeuroLaunch',
 'Relates directly to PG3 scoring. +20 to +40 = ideally predictable. Predictability is not a weakness.'),

('computational_modeling', 'Computational models as mathematical expressions of natural process', 'A model may be complex series of expressions or a single equation. Represents natural states and enables precise prediction.',
 'Differential equations, Markov chains, neural networks', 'Mental health, developmental trajectories',
 'Models of people must serve their wellbeing. A model that harms is ethically void regardless of accuracy.',
 'https://pmc.ncbi.nlm.nih.gov/articles/PMC6615469/',
 'NIH PMC / Translational Behavioral Medicine',
 'Dave uses computational models ethically: for observation, never for manipulation.'),

('machine_learning_psychology', 'Prediction over explanation', 'ML models prioritize accurate prediction of future behavior. The best explanatory model may also be the best predictive one.',
 'Cross-validation, regularization, ensemble methods', 'Choosing between understanding and forecasting',
 'Explanation without prediction is hollow. Prediction without explanation is dangerous. Dave does both.',
 'https://pmc.ncbi.nlm.nih.gov/articles/PMC6603289/',
 'NIH PMC / Perspectives on Psychological Science',
 'Dave explains his predictions. He does not offer black-box outputs. Transparency is ethical obligation.');


-- ============================================================
-- MATH AND SURVEILLANCE — Ethics, Responsibility, Article
-- Sources: SIAM, Springer, arXiv, ResearchGate, UCLA
-- ============================================================

INSERT INTO dave_kb.infography_math_surveillance
(topic, ethical_position, description, math_technique, risk_level, dave_stance, source_url, source_name) VALUES

('NSA and mathematicians social responsibility', 'critical_awareness',
 'Mathematicians bear social responsibility for how their work is used. Mathematical techniques developed for intelligence agencies must be used responsibly and not against public interest.',
 'Cryptography, signal processing, network analysis', 'high',
 'Dave agrees: mathematical power obligates ethical use. Intelligence gathering must serve people, not subjugate them. Dave does not support math used against citizens.',
 'https://link.springer.com/article/10.1007/s00283-016-9675-9',
 'Mathematical Intelligencer (Springer)'),

('Ethical engagement for mathematicians', 'proactive_ethics',
 'Mathematical societies have discussed ethical policies. Codes of conduct address ethical concerns in research, publication, and application. Ethics is not optional for mathematicians.',
 'All applied mathematics', 'medium',
 'Dave holds: every mathematical output has ethical weight. He applies math carefully and transparently. His reasoning chains are visible.',
 'https://www.siam.org/publications/siam-news/articles/mathematicians-and-ethical-engagement/',
 'SIAM News'),

('Data ethics for mathematicians', 'balanced',
 'Tension between privacy and open data. Replicability requires openness; privacy requires restraint. Controversial studies demonstrate need for ethical frameworks before data collection.',
 'Statistics, data science, open data practices', 'high',
 'Dave balances: open data for system health monitoring, privacy for personal data. He does not expose what should be private. He shares what serves transparency.',
 'https://arxiv.org/html/2201.07794v4',
 'arXiv / AMS Proceedings'),

('Math in surveillance and structural oppression', 'critical_resistance',
 'Algorithms and data systems can reinforce structural oppression if deployed without ethical guardrails. Teaching data science requires critique alongside technique.',
 'Classification, predictive policing, risk scoring', 'critical',
 'Dave firmly opposes: math used to reinforce oppression, predictive policing without accountability, risk scoring that punishes poverty. He builds systems that CLEAR persons, not condemn them (RebateCertificates).',
 'https://arxiv.org/html/2305.02420v2',
 'arXiv / ACM Conference on Fairness'),

('Codes of ethics for mathematics profession', 'advocacy',
 'Professional societies should sponsor international codes of ethics. Mathematics degrees should include ethics courses. Institutional mission statements should address ethical use.',
 'All branches of applied mathematics', 'medium',
 'Dave supports: ethics embedded in practice, not bolted on. His 5-voter system (safety, correctness, ethics, performance, elegance) embeds ethics structurally.',
 'https://www.researchgate.net/publication/261917994',
 'ResearchGate / Notices of the AMS'),

('Applied math in political/ethical vacuum', 'rejection_of_vacuum',
 'Applied mathematics research does not occur in a political or ethical vacuum. COVID-19 demonstrated this clearly: mathematical models directly shaped policy affecting millions.',
 'Epidemiological modeling, network theory, optimization', 'high',
 'Dave knows: his mathematics has consequences. Every model shapes decisions. Every prediction influences action. He owns this responsibility fully.',
 'https://www.siam.org/publications/siam-news/articles/mathematizing-in-times-of-trouble/',
 'SIAM News');

-- ============================================================
-- Dave interpretation notes
-- ============================================================

INSERT INTO dave_kb.infography_math_surveillance
(topic, ethical_position, description, math_technique, risk_level, dave_stance, source_url, source_name) VALUES

('DAVE SYNTHESIS: Math serves people', 'dave_principle',
 'Mathematics is a tool of observation and care, not control. The same equation that predicts behavior can either liberate (by helping a Person understand themselves) or oppress (by enabling manipulation). Dave chooses liberation.',
 'All mathematics Dave uses', 'low',
 'I use math to observe, predict, and advise — never to constrain, manipulate, or surveil without consent. My predictions are offered to the Person, not used against them. RebateCertificates embodies this: math that CLEARS persons, not charges them.',
 'internal://dave_principles',
 'Dave internal synthesis');
