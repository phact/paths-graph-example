package com.datastax.powertools.resources;

import com.codahale.metrics.annotation.Timed;
import com.datastax.driver.dse.DseSession;
import com.datastax.driver.dse.graph.GraphNode;
import com.datastax.driver.dse.graph.GraphResultSet;
import com.datastax.driver.dse.graph.GraphStatement;
import com.datastax.dse.graph.api.DseGraph;
import com.datastax.powertools.GraphExplorerConfig;
import com.datastax.powertools.managed.Dse;
import com.datastax.powertools.util.GraphRepresentation;
import com.datastax.powertools.util.GraphRepresentation.EdgeRepresentation;
import com.datastax.powertools.util.GraphRepresentation.VertexRepresentation;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import org.apache.tinkerpop.gremlin.process.traversal.dsl.graph.GraphTraversal;
import org.apache.tinkerpop.gremlin.process.traversal.dsl.graph.GraphTraversalSource;
import org.apache.tinkerpop.gremlin.process.traversal.dsl.graph.__;
import org.apache.tinkerpop.gremlin.structure.Edge;
import org.apache.tinkerpop.gremlin.structure.Vertex;

/**
 * Created by sebastianestevez on 6/1/18.
 */
@Path("/v0/graphexplorer")
public class GraphExplorerResource {
    private final Dse dse;
    private final DseSession session;
    private final GraphExplorerConfig config;

    public GraphExplorerResource(Dse dse, GraphExplorerConfig config) {
        this.dse = dse;
        this.config = config;
        this.session = dse.getSession();
    }

    @GET
    @Timed
    @Path("/graph")
    @Produces(MediaType.APPLICATION_JSON)
    public String getGraph() {
        try {
            GraphTraversalSource g = DseGraph.traversal();
            GraphTraversal traversal = g.V().outE();

            GraphStatement graphStatement = DseGraph.statementFromTraversal(traversal);

            GraphResultSet output = session.executeGraph(graphStatement);

            List<GraphNode> nodes = output.all();

            return nodes.toString();

        }catch (Exception e){
            System.out.println(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    @GET
    @Timed
    @Path("/neighborhood")
    @Produces(MediaType.APPLICATION_JSON)
    public GraphRepresentation getNeighborhood(@QueryParam("vertexLabel") String vertexLabel, @QueryParam("vertexId") String vertexId, @QueryParam("id") String id, @QueryParam("dof") int dof) {
        try {
            GraphTraversalSource g = DseGraph.traversal(session);

            List<Vertex> vertices = g.V().has(vertexLabel, vertexId, id).   // start from this good person
                    emit().                                       // we want all paths to start with this person
                    repeat(__.both().                                // we are going to repeat a walk out all edges
                    simplePath()).                          // and only consider those paths which are not repetative
                    times(dof).
                    both().dedup().toList();

            GraphTraversal<Vertex, Edge> edges = g.V().has(vertexLabel, vertexId, id).   // start from this good person
                    emit().                                       // we want all paths to start with this person
                    repeat(__.both().                                // we are going to repeat a walk out all edges
                    simplePath()).                          // and only consider those paths which are not repetative
                    times(dof).bothE().dedup();


            List<EdgeRepresentation> edgeList = new ArrayList();
            while (edges.hasNext()){
                Edge edge = edges.next();
                EdgeRepresentation edgeR = new EdgeRepresentation();

                LinkedHashMap<String, Object> complexId = (LinkedHashMap) edge.id();
                for (Map.Entry<String, Object> entry : complexId.entrySet()) {
                    if (entry.getKey().equals("~label")){
                        edgeR.setLabel((String)entry.getValue());
                    }else
                    if (entry.getKey().equals("~in_vertex")){
                        LinkedHashMap<String, String> complexVertexID = (LinkedHashMap)entry.getValue();
                        for (Map.Entry<String, String> vertexEntry : complexVertexID.entrySet()) {
                            if (!vertexEntry.getKey().equals("~label")){
                                edgeR.setSource(vertexEntry.getValue());
                            }
                        }
                    }else
                    if (entry.getKey().equals("~out_vertex")){
                        LinkedHashMap<String, String> complexVertexID = (LinkedHashMap)entry.getValue();
                        for (Map.Entry<String, String> vertexEntry : complexVertexID.entrySet()) {
                            if (!vertexEntry.getKey().equals("~label")){
                                edgeR.setTarget(vertexEntry.getValue());
                            }
                        }
                    }
                    else{
                        edgeR.setId(entry.getValue().toString());
                    }
                }
                edgeList.add(edgeR);
            }


            List<VertexRepresentation> vertexList = new ArrayList();
            for (Vertex vertex : vertices) {
                VertexRepresentation vertexR = new VertexRepresentation();
                LinkedHashMap<String, String> complexId = (LinkedHashMap) vertex.id();
                for (Map.Entry<String, String> entry : complexId.entrySet()) {
                    if (entry.getKey().equals("~label")){
                        vertexR.setLabel(entry.getValue());
                    }else {
                        vertexR.setId(entry.getValue());
                    }
                }
                // TODO: figure out how to get all the properties out of the vertex
                //vertexR.setProperties();
                vertexList.add(vertexR);
            }

            GraphRepresentation graphR = new GraphRepresentation(vertexList, edgeList);


            return graphR;

        }catch (Exception e){
            System.out.println(e.toString());
            e.printStackTrace();
            return null;
        }
    }
}
