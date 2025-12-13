

# Databanken-2

This repository documents the full workflow of designing a relational database, refactoring it into a data warehouse, and extending the system with MongoDB for NoSQL data storage and analysis.

---

## Repository Structure

```
Databanken-2/
│
├── Conceptual_model/
│   Conceptual and logical models, ERD, domain documentation
│
├── Relational-Database_Queries/
│   SQL scripts for querying the operational PostgreSQL system
│   Analytical datasets generated from the relational model
│
├── Data-Warehouse/
│   Star schema diagrams and documentation
│   Attribute mappings
│   Table creation scripts
│   ETL scripts for dimensions and fact tables
│   Data warehouse analytical queries
│
├── MongoDB/
│   JSON export scripts from PostgreSQL
│   Import scripts for MongoDB
│   Query files
│   Sharded cluster configuration and explanation
│
└── Setup/
    Environment setup instructions
    Database initialization and configuration scripts
```

---

## Project Overview

### 1. Conceptual Model

Contains the analysis of the Catchem domain: core entities, relationships, constraints, and the conceptual schema forming the basis of the relational system.

### 2. Relational Database

Implements the operational PostgreSQL system.
Includes SQL queries that generate analytical datasets focused on seasonality, user experience, terrain difficulty, and treasure size patterns.

### 3. Data Warehouse

Provides a complete star schema for analytics.
Includes creation scripts, ETL steps, SCD handling, and analytical queries executed on the warehouse instead of the operational DB.

### 4. MongoDB

Contains a document-based representation of treasure hunts, including stages.
Includes JSON export/import scripts, MongoDB queries, and a demonstration of a sharded cluster configuration.

---

## Purpose of the Repository

This project demonstrates the full lifecycle of a data system: conceptual modeling, relational implementation, data warehouse design, ETL development, and NoSQL integration. It highlights how analytical performance and data organization evolve across architectures.

