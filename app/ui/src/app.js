import {connect} from 'react-redux';
import React, { Component } from 'react'

// data
import sampleGraph from './data/sample-graph';
import {updateGraph, getNeighborhood, setupEngine} from './actions';

// utils
import Graph from './common/graph';
import LayoutEngine from './common/layout-engine';

// components
import GraphRender from './graph-render';


class App extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.processData();
  }

  componentWillUnmount() {
    this.props.app.engine.unregisterCallbacks();
  }

  processData = () => {
    this.props.dispatch(getNeighborhood("/api/v0/graphexplorer/neighborhood?vertexLabel=person&vertexId=personId&id=person-206731&dof=6"));

    if (this.props.app.graph.isEmpty() ) {
      return null;
    }
    if (Object.keys(this.props.app.engine).length === 0){
      this.props.dispatch(setupEngine());
    }
    /*
    const newGraph = new Graph();
    sampleGraph.nodes.forEach(node =>
      newGraph.addNode({
        id: node.id,
        isHighlighted: false
      })
    );
    sampleGraph.edges.forEach(edge =>
      newGraph.addEdge({
        ...edge,
        isHighlighted: false
      })
    );
    this.setState({graph: newGraph});
    // update engine
    this.props.app.engine.update(this.props.app.graph);
    this.props.app.engine.start();
    */
  }

  reRender = () => this.forceUpdate()

  // node accessors
  getNodeColor = node => (node.isHighlighted ? [255, 0, 0] : [94, 94, 94])

  getNodeSize = node => 10


  onHoverNode = pickedObj => {
    // 1. check if is hovering on a node
    const hoveredNodeID = pickedObj.object && pickedObj.object.id;
    const graph = new Graph(this.props.app.graph);
    if (hoveredNodeID) {
      // 2. highlight the selected node, neighbor nodes, and connected edges
      const connectedEdges = this.props.app.graph.findConnectedEdges(hoveredNodeID);
      const connectedEdgeIDs = connectedEdges.map(e => e.id);
      const hightlightNodes = connectedEdges.reduce((res, e) => {
        if (!res.includes(e.source)) {
          res.push(e.source);
        }
        if (!res.includes(e.target)) {
          res.push(e.target);
        }
        return res;
      }, []);
      graph.nodes.forEach(n => n.isHighlighted = hightlightNodes.includes(n.id));
      graph.edges.forEach(e => e.isHighlighted = connectedEdgeIDs.includes(e.id));
    } else {
      // 3. unset all nodes and edges
      graph.nodes.forEach(n => n.isHighlighted = false);
      graph.edges.forEach(e => e.isHighlighted = false);      
    }
    // 4. update component state
    //TODO: update via redux
    //graph.hoveredNodeID = hoveredNodeID
    this.props.dispatch(updateGraph(graph, hoveredNodeID))
  }

  // edge accessors
  getEdgeColor = edge => (edge.isHighlighted ? [255, 0, 0] : [64, 64, 64])

  getEdgeWidth = () => 2

  render() {
    if (this.props.app.graph.isEmpty() ) {
      return null;
    }
    if (Object.keys(this.props.app.engine).length === 0){
      return null;
    }
    this.props.app.engine.registerCallbacks(this.reRender);
    return (
      <GraphRender
        /* viewport related */
        width={this.props.app.viewport.width}
        height={this.props.app.viewport.height}
        /* update triggers */
        colorUpdateTrigger={this.props.app.hoveredNodeID}
        positionUpdateTrigger={this.props.app.engine.alpha()}
        /* nodes related */
        nodes={this.props.app.graph.nodes}
        getNodeColor={this.getNodeColor}
        getNodeSize={this.getNodeSize}
        getNodePosition={this.props.app.engine.getNodePosition}
        onHoverNode={this.onHoverNode}
        /* edges related */
        edges={this.props.app.graph.edges}
        getEdgeColor={this.getEdgeColor}
        getEdgeWidth={this.getEdgeWidth}
        getEdgePosition={this.props.app.engine.getEdgePosition}
      />
    );
  }
}


const mapStateToProps = state => state;
const dispatchToProps = dispatch => ({dispatch});

export default connect(mapStateToProps, dispatchToProps)(App);
//export default connect(mapStateToProps, mapDispatchToProps)(App);
