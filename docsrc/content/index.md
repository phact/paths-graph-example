---
title: Mission Graph Demo
type: index
weight: 0
---

##  Main Purpose
### The main objective of this asset is to walk through the provided Studio 6.0 Notebook and tell a story on how DSE Graph can help to identify malicious actors in the financial sector.

If you are interested in contributing or learing about this asset, please reach out to Denise Gosnell.


##  Introduction
### High Level Overview
This asset visualizes the art of the possible for identifying fraudulent or malicious identities. This asset is ideally used in a workshop setting with a potential Mission Graph customer who has a qualified opportunity.

### Business Takeaways
On alert, an analyst needs to have the ability to observe the connected network of a flagged user. From the developer's perspective, DSE Graph along with DataStax Studio give an analyst the ability to observe the event which triggered the user's alert. Additionally, an analyst can query and walk deeper into the network to find connectivity to known malicious actors or events in the network. This information enables an analyst to make a decision regarding the integrity of the new user.

### Technical Takeaways
There are over 35M vertices and 50M edges generated within this example. It takes a few hours for Engine Block to fully insert all of the data into the cluster.

The data is not fully connected; therefore leaving many interesting analytic queries or processes open for exploration. The provided Studio notebook covers a few of the basics (like group counting the vertices and finding the degree distribution of the event vertices) but there is plenty of room for deeper analysis or query exploration in a workshop setting.

## Technical Details
### Architectural Explanation
This asset generates synthetic data, randomly inserts malicious users, and provides an interactive experience to showcase the art of the possible with DSE Graph.

#### Schema

**Generated Vertex Labels**

* **person**: the total number of persons determines the baseline volume for the generated graph
* **account**: will have the same total vertices as person vertices
* **application**: final count will be 5% of the total number of person vertices
* **creditCard**: final count will be 75% of the total number of person vertices
* **device**: final count will be 75% of the total number of person vertices
* **event**: final count will be 4x of the total number of person vertices

**Generated Edges**

* **familyMember**: a person is a family member to another person, and vice versa. The final count of familyMember edges will be 25% of the total number of person vertices. Persons are randomly selected to be family members.
* **submittedApp**: a person submits an application.  The final count of submittedApp edges will be the same number of application vertices. Persons are randomly selected to be connected to applications with this edge.
* **listedOnApp**: a person is also listed on an application.  The final count of listedOnApp edges will be the same number of application vertices. Persons are randomly selected to be connected to applications with this edge.
* **ownsAccount**: a person owns a financial account.  The final count of ownsAccount edges will be the same number of account vertices.
* **transferTo**: there are transfer events between financial accounts. The final count of transferTo edges will be the same number of event vertices. Accounts are randomly selected to be connected to other accounts with this edge.
* **transferFrom**: there are transfer events between financial accounts. The final count of transferFrom edges will be the same number of event vertices. Accounts are randomly selected to be connected to other accounts with this edge.

#### Data Generation
This asset uses EngineBlock (EBDSE) to generate synthetic data. The graph is generally created in the following order:

1. Create the graph schema
2. Insert all people vertices; set 5% of all people to be bad actors
3. Connect every person to an account, a device, and a credit card.
4. Insert the family member edges
5. Create applications and connect people to the applications
6. Create transfer events between the accounts

The full process and usage of EBDSE for data generation [can be found here.](https://github.com/denisekgosnell/paths-graph-example/blob/master/ebdse/runebdse.sh)


### DSE Usage
At this time, this asset showcases only two features within DSE:

* DSE Graph
* DataStax Studio 6.0

## Additional Resources

### Externally Sharable:

* Deloitte MissionGraph on Kapost| [Customer Deck](https://datastax.kapost.com/gallery/content/5abbe046751a2d00a1000143/preview)
* Deloitte MissionGraph on Kapost| [Demo Video](https://datastax.kapost.com/gallery/content/5abbdf107dae89002900016c/preview)
* [Press Release and Datasheet](https://www.datastax.com/partners/deloitte-and-datastax)

### Internal Only:

* DataStax Internal Resource: [Mission Graph Field Enablement](https://docs.google.com/presentation/d/10a-xS2Mzpht2c0V7Z1uRdeJGjT24PKV7RbeRxAeDSGk/edit?usp=sharing)
* DataStax Internal Resource: [Mission Graph Field Enablement Recording](https://bluejeans.com/s/gCMpz)
* Deloitte MissionGraph on Kapost | [Playbook - Internal Only](https://datastax.kapost.com/gallery/content/5abbe326ddae3d002900017c/preview)
* [Press Release and Datasheet](https://www.datastax.com/partners/deloitte-and-datastax)
* [Engagement Summaries](https://drive.google.com/drive/folders/0B624YoChjuWubDVVUk1oRDZfMDQ)