---
title: DSE Graph Offers
type: index
weight: 0
---

This is a DSE Graph Proofshop that generates realistic data for a retail offers graph using EBDSE and includes some basic queries / access patterns in Gremlin.

### Motivation

The item is the center of a retailer / grocery store's universe. The purpose of this proofshop is to demonstrate our ability to use DSE Graph to satisfy the technical requirements for a retailer's item graph. The proofshop uses a simple minimum cardinality model as an aid to representing the Edges, Vertices, and their respective volumes. We use this model to generate the declarative (yaml) description of the workload for EBDSE and generate it. The yaml can be tweaked to support other use cases with a bit of effort.

### What is included?

The Graph Offers Proofshop includes the following components

* Nomnoml Data Modeling
 * A simple declarative way to draw data models and cardinalities
 * Alternative to whiteboarding
* EBDSE Generated graph data
 * Graph creation
 * Schema
 * Inserts - Vertex - Edge - Vertex
 * Read Benchmark
* Notebook
 * Common queries
 * Intro to gremlin
 * Focus on the project step (WHERE, SELECT, FROM)

### Business Take Aways

Customer 360 is a common use case in financials and other industries. In the case of retail, the item is at the center of the universe. Using a graph to model item related data allows the business to leverage the connections accross their data to generate value for their customers.

In this asset, the graph includes item data (for products held in the stores) and it also holds thousands of recipes, each with ingredients that have been associated to items using some basic NLP / tokenization. Also connected to items are offers / coupons.

By querying the graph, we can perform interesting traversals to power a useful heuristical recommender based on offers, items, and recipes.

### Technical Take Aways

#### Data Modeling

For graph data models, the best practice is to start out by drawing your entities and edges as they are visualized by business domain experts on a whiteboard. This is often a good starting point if not the final data model that can be used in the graph. At this point, additional tradeoffs and considerations to optimize the data model can be applied. Most of these optimizations are driven off of the access patterns and their SLAs. Using something like EBDSE to test baseline performance for query access patterns against realistic graphs can help expedite this iterative process.

The main optimizations fall into the following categories:

- Indexing (both properties and vertex centric indexes)
  - property indexes are used to get a starting point for your traversal (ideally there is a strong partition key that can be used instead for a direct lookup but this is not always the case).
  - VCIs are indexes placed on edge properties to minimize fan out in your traversals, these are the only kinds of indexes that can be leveraged in DSE graph *during* your traversal (rather than at the beginning of the traversal).
  - MVs vs. Search indexes - Is fuzzy search needed? (Use Search) Are range scans needed? (Use Search) Is it a direct lookup? (Consider MVs) What is the cardinality of the field being indexed low? (Consider MVs)
- Supernodes - consider using a property on a vertex instead of a vertex with too many edges. Note: supernodes are usually only an issue if they are used by your access patterns. You can have a V with 100K - 1M edges without having problems if you aren't traversing through them.
- Grandparent edges - for common multi-hop traversals with tight SLAs, consider adding a shortcut edge from child to grandparent vertex, this way you can skip a hop.

#### Data Generation

EBDSE provides the ability to do deterministic / replayable, fast, realistic graph loads. This asset includes a YAML and a run script for ebdse. The run script is uses bash variables to allow for easy configuration of the size of the graph (number of Vs and Es, etc.).

Note, if there are more Es than the greater of the two related Vs, we may generate collisions in which case your final Edge count may be lower than the user might have thought. This is a side effect of the statistical data generation being used.

#### Gremlin

At first glance, a functional query language like Gremlin can be dauniting. The notebook included in this proofshop includes some sample queries starting simple and becoming more complex.
The more complex queries are broken down into components and built up to arrive at the final query.
