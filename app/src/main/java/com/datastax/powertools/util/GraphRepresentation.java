package com.datastax.powertools.util;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Created by sebastianestevez on 7/12/18.
 */
public class GraphRepresentation {
    public GraphRepresentation(List<VertexRepresentation> vertexList, List<EdgeRepresentation> edgeList) {
        this.vertexList  = vertexList;
        this.edgeList= edgeList;
    }

    public static class VertexRepresentation {
        @JsonProperty
        private String id;
        @JsonProperty
        private String label;
        @JsonProperty
        private List<String> properties;

        public void setId(String id) {
            this.id = id;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public void setProperties(List<String> properties) {
            this.properties = properties;
        }
    }

    public static class EdgeRepresentation {
        @JsonProperty
        private String id;
        @JsonProperty
        private String label;
        @JsonProperty
        private String source;
        @JsonProperty
        private String target;

        public void setId(String id) {
            this.id = id;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public void setSource(String source) {
            this.source = source;
        }

        public void setTarget(String target) {
            this.target = target;
        }
    }

    @JsonProperty
    private List<VertexRepresentation> vertexList;
    @JsonProperty
    private List<EdgeRepresentation> edgeList;
}
