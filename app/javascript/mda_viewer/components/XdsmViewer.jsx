import * as d3 from 'd3';
import React from 'react';
let Graph = require('XDSMjs/src/graph');
let Xdsm = require('XDSMjs/src/xdsm');
let Selectable = require('XDSMjs/src/selectable');

class XdsmViewer extends React.Component {
  constructor(props) {
    super(props);
    this.graph = new Graph(props.mda);
  }

  componentDidMount() {
    let config = {
        labelizer: {
          ellipsis: 5,
          subSupScript: false,
          showLinkNbOnly: true,
        },
        layout: { 
          origin: {x: 50, y: 20},
          cellsize: {w: 150, h: 50},
          padding: 10,
        },
        titleTooltip: true,
      };
    this.xdsm = new Xdsm(this.graph, 'root', config);
    this.xdsm.draw();
    this.selectable = new Selectable(this.xdsm, this._onSelectionChange.bind(this));
    this.setSelection();
    this._setTooltips();
  }

  render() {
    return ( <div className="xdsm"></div> );
  }

  shouldComponentUpdate() {
    return false;
  }

  addDiscipline(discattrs) {
    this.xdsm.graph.addNode(discattrs);
    this.xdsm.draw();
  }

  updateDiscipline(index, discattrs) {
    var newNode = Object.assign({}, this.xdsm.graph.nodes[index], discattrs);
    console.log(JSON.stringify(discattrs));
    this.xdsm.graph.nodes.splice(index, 1, newNode);
    this._refresh();
  }
  
  removeDiscipline(index) {
    this.xdsm.graph.removeNode(index);
    this.xdsm.draw();
  }
  
  addConnection(connattrs) {
    this.xdsm.graph.addEdgeVar(connattrs.from, connattrs.to, connattrs.name);
    this._refresh();
  }
  
  setSelection() {
    this.selectable.setFilter(this.props.filter); 
  }
  
  _onSelectionChange(filter) {
    this.props.onFilterChange(filter);    
  }
  
  _refresh() {
    // remove and redraw xdsm 
    this.xdsm.refresh();
    // reattzach selection
    this.selectable.enable();
    // select current
    this.setSelection();
    // reattach tooltips
    this._setTooltips();
  }
  
  _setTooltips() {
    // bootstrap tooltip for connections
    $(".ellipsized").attr("data-toggle", "tooltip")
    $(() => { $('.ellipsized').tooltip({placement: 'right'}); });  
  }
}

export default XdsmViewer;