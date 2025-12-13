# MongoDB Sharding & Data Migration Project

## Project Overview
This repository contains the scripts and documentation required to migrate "Treasure" data from a relational database (PostgreSQL) into a sharded MongoDB cluster. The project covers the extraction of nested data into JSON format, the configuration of a MongoDB sharded architecture, and the bulk import of data into the new environment.

## File Manifest

### 1. Data Migration Scripts
* **`export_treasure.ps1`**: A PowerShell script that connects to a PostgreSQL database to extract treasure data. It executes a complex SQL query to construct a nested JSON object (containing the treasure details, the owner's profile, and a list of associated stages) and saves it as `treasures.json`.
* **`import_json.ps1`**: A PowerShell script utilizing `mongoimport` to load the generated JSON data into the MongoDB database. It is configured to handle the file as a JSON array.
* **`treasures_json_preview.txt`**: A sample snippet of the exported data, illustrating the document structure. It shows the root treasure fields (`difficulty`, `terrain`), the embedded `owner` object, and the array of embedded `stages`.

### 2. Infrastructure Documentation
* **`mongodb_sharding_handleiding.pdf`**: A comprehensive guide (Manual) for setting up the sharded cluster. It details the architecture and provides the specific commands to initialize the Config Servers, Shard Servers, and the Mongos Router.

## Architecture

The MongoDB environment described in the documentation consists of the following components:
* **Config Server (Replica Set):** Stores the cluster's metadata and configuration settings.
* **Shard Servers (Replica Sets):** Store the actual data chunks. The guide instructs on setting up multiple shards to distribute the load.
* **Mongos (Router):** The interface application that routes client queries to the appropriate shards.

**Sharding Strategy:**
* **Database:** `catchem`
* **Collection:** `treasures`
* **Shard Key:** The collection is sharded using a **Hashed Sharding** strategy on the `_id` field to ensure an even distribution of data across shards.

## Usage Guide

Follow this workflow to execute the migration and setup.

### Step 1: Export Data
Run **`export_treasure.ps1`**.
* **Prerequisites:** Ensure PostgreSQL binaries (`psql.exe`) are accessible.
* **Configuration:** Verify the database connection string and output path (`C:\tmp\json\treasures.json`) in the script.
* **Output:** Generates a file named `treasures.json` containing the document array.

### Step 2: Configure Sharded Cluster
Follow the steps in **`mongodb_sharding_handleiding.pdf`**:
1.  **Initialize Replica Sets:** Start the instances for the Config Server and Shards.
2.  **Start Mongos:** Launch the router instance connecting to the Config Server.
3.  **Add Shards:** Use the `sh.addShard()` command via the `mongos` router to register the shard replica sets.
4.  **Enable Sharding:** Enable sharding for the `catchem` database.
5.  **Shard Collection:** execute `sh.shardCollection("catchem.treasures", { _id : "hashed" } )`.

### Step 3: Import Data
Run **`import_json.ps1`**.
* **Prerequisites:** Ensure MongoDB Database Tools (`mongoimport.exe`) are installed.
* **Action:** This script reads `treasures.json` and imports it into the `catchem.treasures` collection via the `mongos` router.
* **Verification:** Once finished, the data will be automatically distributed across the configured shards based on the hashed `_id`.
