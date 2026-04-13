# EA-v2 – Advanced Multi-Strategy Forex Expert Advisor

**Version:** v91  
**Platform:** MetaTrader 4 (MQL4)  
**Focus:** Smart trend harvesting with physics-inspired consensus engine

---

## Overview

**EA-v2** is a sophisticated automated trading system for Forex that combines multiple signal layers with a unique **Sage Consensus Engine**.

It blends:
- Classical technical indicators (IMA, ATR, ADX, RSI, etc.)
- Advanced slope dynamics and volatility filters
- Bayesian + Neuron-inspired hold scores
- Hyperbolic (Physics) and Cobb-Douglas (balanced) consensus models

The EA supports **pyramiding**, adaptive risk, squeeze detection, and multiple execution strategies.

## Key Features

- **3 Built-in Strategies**:
  - Strategy 1: Trinity Sniper (Phase-blended entries)
  - Strategy 2: Trend Pyramiding Harvester
  - Strategy 3: Pure Volatility Harvester + Smart Pruner (Recommended for most users)

- **Sage Consensus Engine** – Combines:
  - Hyperbolic Physics Score
  - Cobb-Douglas Combined Score
  - Market Cloud / Structure Score

- **Squeeze Detection & Conviction Sizing** – Reduces lot size during compression, increases on reversal

- **Adaptive Risk Management**:
  - ATR-scaled hold time shield
  - Dynamic spread limits
  - Volatility-adjusted trailing profit protector
  - Pyramid limit (default 15)

- **Live Data Logging** – JSON output for external analysis (compatible with Kafka/Python pipelines)

- **Circular Buffer CB Mode** – Efficient real-time data handling (v91+)

## Inputs (Key Parameters)

| Parameter              | Default   | Description |
|------------------------|-----------|-----------|
| `activeStrategy`       | 3         | 1 = Trinity Sniper, 2/3 = Harvester modes |
| `maxPyramidTrades`     | 15        | Maximum simultaneous trades |
| `microLots`            | 1         | Base lot size multiplier (0.01 = 1 microlot) |
| `TAKE_PROFIT`          | 1.4       | Base TP in account currency units |
| `STOP_LOSS`            | 0.3       | Base SL |
| `physicsWeight`        | 0.48      | Weight for Hyperbolic Physics model |
| `cobbWeight`           | 0.32      | Weight for Cobb-Douglas model |
| `cloudWeight`          | 0.20      | Market structure weight |
| `consensusThreshold`   | 0.42      | Minimum agreement to enter |
| `SQUEEZE_LIMIT`        | 0.4       | fMSR threshold for squeeze detection |
| `recordData`           | false     | Enable JSON logging |

## File Structure

